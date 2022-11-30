@echo off
rem Default BPC 2 two-phase validation
rem
rem Syntax: validate customization-id document-type ubl-xml-file

if not "a%~2" == "a" goto :args
if     "a%~1" == "a" goto :args

if not exist "%~1" goto :badxml

echo.
echo ############################################################
echo Validating "%~1"
echo ############################################################

if exist "%~1.error.txt" del "%~1.error.txt"
if exist "%~1.svrl.xml" del "%~1.svrl.xml"

echo ===== Phase 1: XSD schema validation =====
call "%~dp0w3cschema.bat" "%~dp0../iso/remt.001.001.05.xsd" "%~1" > "%~1.error.txt"
set errorRet=%errorlevel%
if %errorRet% neq 0 goto :error
echo No schema validation errors.
del "%~1.error.txt"

if not exist "%~dp0../bpc/BPC-Remittance-Rules.xsl" goto :noxslt

echo ===== Phase 2: Data integrity validation =====
call "%~dp0xslt.bat" "%~1" "%~dp0../bpc/BPC-Remittance-Rules.xsl" "%~1.svrl.xml" 2> "%~1.error.txt"
set errorRet=%errorlevel%
if %errorRet% neq 0 goto :error
del "%~1.error.txt"

call "%~dp0xslt.bat" "%~1.svrl.xml" "%~dp0testSVRL4ISO20022errors.xsl" nul 2>"%~1.error.txt"
set errorRet=%errorlevel%
if %errorRet% neq 0 goto :error

echo No data integrity validation errors.
del "%~1.svrl.xml"
del "%~1.error.txt"
goto :done

:args
echo Syntax:  validate.bat xml-file
goto :done

:noxslt
echo ===== Phase 2 not executed (missing XSLT created from Schematron) =====
goto :done

:badxml
echo Input XML file not found: "%~1"
goto :done

:error
type "%~1.error.txt"

:done
exit /B %errorRet%