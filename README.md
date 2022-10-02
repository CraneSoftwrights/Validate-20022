# Validate-20022


## WORK INCOMPLETE! SNAPSHOT BACKUP ONLY!!

An environment with which to validate XML documents against a couple of ISO-20022 XSD schemas:

- `remt.001.001.05.xsd`
- `remt.002.001.02.xsd`

... and placebo Schematron files that are prepared here without constraints and are ready to be modified for one's own needs:

- `remt.001.001.05.rules.sch`
- `remt.002.001.02.rules.sch`

Invocation

To validate a test document of one’s own that is found in your local computer file system there is a Java-based invocation for each of the Windows and Shell environments:
- Windows drag-n-drop:
  - fully extract the nested ZIP files into your file system because drag-n-drop does not work from inside ZIP extractor virtual directories
  - open the unzipped val/windows-drag-n-drop/ directory in Windows Explorer to reveal the available invocations (pro tip: pre-click once on the batch file you intend to use so that it is highlighted when the time comes to drop a file on it; this will make it easier to locate in the list for dropping)
  - drag your XML file from Windows Explorer where it is being edited, and drop it onto the corresponding invocation batch file performing the desired validation

- image Windows Drag-n-Drop

  - a dynamic command DOS box window will open up revealing the results until a key is pressed to make the window disappear (see  for details on adjusting the length of the history)
- image Windows Drop Execution
- Windows DOS prompt:
  - `validate.bat  20022-type-string  20022-xml-file`
for example from the test.bat demonstration:
`validate.bat  remt.001.001.05 remt.001.001.05-test-good.xml`
  - Shell:
  - `sh validate.sh  20022-type-string  20022-xml-file`
for example from the test.sh demonstration:
`sh validate.sh remt.001.001.05 remt.001.001.05-test-good.xml`

When there is a schema error of any kind, the script creates a file named by adding the “.error.txt” suffix to the input file name and records the error information in that file.

When there is a Schematron data integrity error, the script also creates a file named by adding the “.svrl.xml” suffix to the input file name and records the Schematron SVRL record information in that file.
