#!/bin/bash

if [ ! -d $targetdir ]; then mkdir $targetdir ; fi
if [ ! -d $targetdir/Validate-20022-tools-$dateTime ]; then 
mkdir     $targetdir/Validate-20022-tools-$dateTime
fi
if [ ! -d $targetdir/Validate-20022-tools-$dateTime/archive-only-not-in-final-distribution/ ]; then 
mkdir     $targetdir/Validate-20022-tools-$dateTime/archive-only-not-in-final-distribution/
fi

echo Building package...
java -Dant.home=utilities/ant -classpath utilities/saxon/saxon.jar:utilities/ant/lib/ant-launcher.jar:utilities/saxon9he/saxon9he.jar:. org.apache.tools.ant.launch.Launcher -buildfile prepareValidationArtefacts.xml "-Ddir=$targetdir" "-DssGoogle=$ssGoogle" "-DdateTime=$dateTime" "-Dnumber-of-processes=$numberOfProcesses" | tee $targetdir/Validate-20022-tools.console.$3.txt
serverReturn=${PIPESTATUS[0]}

mv $targetdir/Validate-20022-tools.console.$3.txt $targetdir/Validate-20022-tools-$dateTime/archive-only-not-in-final-distribution/
echo $serverReturn >$targetdir/Validate-20022-tools-$dateTime/archive-only-not-in-final-distribution/Validate-20022-tools.exitcode.$3.txt

# reduce GitHub storage costs by zipping results and deleting intermediate files
pushd $targetdir

if [ -f Validate-20022-tools-$dateTime.zip ]; then rm Validate-20022-tools-$dateTime.zip ; fi
7z a Validate-20022-tools-$dateTime.zip Validate-20022-tools-$dateTime
rm -r -f Validate-20022-tools-$dateTime

popd

if [ "$targetdir" = "target" ]
then
if [ "$2" = "github" ]
then
if [ "$4" = "DELETE-REPOSITORY-FILES-AS-WELL" ] #secret undocumented failsafe
then
# further reduce GitHub storage costs by deleting repository files

find . -not -name target -not -name .github -maxdepth 1 -exec rm -r -f {} \;
mv $targetdir/Validate-20022-tools-$dateTime.zip .
rm -r -f $targetdir

fi
fi
fi

exit 0 # always be successful so that github returns ZIP of results
