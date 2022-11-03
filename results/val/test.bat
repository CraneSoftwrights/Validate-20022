@echo off

call validate-20022.bat iso-20022-test-bad-syntax.xml
call validate-20022.bat iso-20022-test-bad-model.xml
call validate-20022.bat iso-20022-test-good.xml

echo.
echo.
pause
