# Two-phase validation of ISO 20022 files
#
# Syntax: validate xml-file

DP0=$( cd "$(dirname "$0")" ; pwd -P )

if [ "a$2" != "a" ] || [ "a$1" == "a" ]
then
echo Syntax:  sh validate.sh xml-file
exit 1
fi

echo
echo "############################################################"
echo Validating \"$1\"
echo "############################################################"

if [ -f "$1.error.txt" ]; then rm "$1.error.txt" ; fi
if [ -f "$1.svrl.xml" ];  then rm "$1.svrl.xml"  ; fi

echo ===== Phase 1: XSD schema validation =====
sh "$DP0/w3cschema.sh" "$DP0/../iso/all-iso-20022.xsd" "$1" 2>&1 >"$1.error.txt"
errorRet=$?

if [ $errorRet -eq 0 ]
then echo No schema validation errors. ; rm "$1.error.txt"
else cat "$1.error.txt"; exit $errorRet
fi

if [ -f "$DP0/../bpc/BPC-Remittance-Rules.xsl" ]
then

echo ===== Phase 2: Data integrity validation =====
sh "$DP0/xslt.sh" "$1" "$DP0/../bpc/BPC-Remittance-Rules.xsl" "$1.svrl.xml" 2>"$1.error.txt"
errorRet=$?

if [ $errorRet -eq 0 ]
then
sh "$DP0/xslt.sh" "$1.svrl.xml" "$DP0/testSVRL4ISO20022errors.xsl" /dev/null 2>"$1.error.txt"
errorRet=$?

if [ $errorRet -eq 0 ]
then echo No data integrity validation errors. ; rm "$1.svrl.xml" "$1.error.txt"
else cat "$1.error.txt"; exit $errorRet

fi #end of check of massaged SVRL

else cat "$1.error.txt"; exit $errorRet

fi #end of check of raw SVRL

else

echo ===== Phase 2 not executed \(missing XSLT created from Schematron\) =====

fi

