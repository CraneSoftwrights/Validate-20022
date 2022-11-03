<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
  
  <ns prefix="remt1" uri="urn:iso:std:iso:20022:tech:xsd:remt.001.001.05"/>
  <ns prefix="remt2" uri="urn:iso:std:iso:20022:tech:xsd:remt.002.001.02"/>
  
  <!-- remember that all XPath element steps must be prefixed with remt1:
       pr remt2: -->
  
  <title>Constraints for remt.001.001.05 and remt.002.001.02 instances</title>

  <pattern>
    <rule context="/remt1:future-stuff-here | /remt2:future-stuff-here">
      <report test="true()">The Schematron script needs to be changed.</report>
    </rule>
  </pattern>

</schema>
