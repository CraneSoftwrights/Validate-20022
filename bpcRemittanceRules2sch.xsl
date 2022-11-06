<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="utilities/xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:bpc="urn:X-BPC"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                xmlns:xslo="dummy"
                exclude-result-prefixes="xs xsd bpc xslo xsl"
                version="2.0">

<xs:doc filename="bpcCustomization2sch.xsl" vocabulary="DocBook"
        info="$Id$">
  <xs:title>
    Convert a BPC skeleton Schematron script into one tailored for a 
    customization.
  </xs:title>
  <para>
    The tailoring is simple in the attributes, text, and comments.
  </para>
</xs:doc>

<!--========================================================================-->

<xs:doc>
  <xs:title>Invocation parameters and input/output files</xs:title>
  <para>
    The input file is the genericode of the spreadsheet with the rule
    definitions.
  </para>
  <para>
    The output is the Schematron summary of contexts and expressions.
  </para>
</xs:doc>

<xs:param ignore-ns='yes'>
  <para>
    The date and time stamp to distinguish releases of a particular version.
  </para>
</xs:param>
<xsl:param name="dateTime" required="yes" as="xsd:string"/>

<xs:output>
  <para>Indented results are easier to read</para>
</xs:output>
<xsl:output indent="yes"/>
  
<!--========================================================================-->
<xs:doc>
  <xs:title>Genericode access functions</xs:title>
  <para>
    Various convenience functions to access information from an
    instance of genericode
  </para>
</xs:doc>

<xs:function>
  <para>Returning a row's column value by its column name</para>
  <xs:param name="row"><para>The genericode row</para></xs:param>
  <xs:param name="column"><para>The genericode column</para></xs:param>
</xs:function>
<xsl:function name="bpc:col" as="element(SimpleValue)*">
  <xsl:param name="row" as="element(Row)"/>
  <xsl:param name="column" as="xsd:string"/>
  <xsl:sequence select="$row/Value[@ColumnRef=$column]/SimpleValue"/>
</xsl:function>

<!--========================================================================-->

<xs:template>
  <para>Everything is done here</para>
</xs:template>
<xsl:template match="/">
  <xsl:comment>
    This Schematron schema incorporates the BPC business rules dated
    <xsl:value-of select="$dateTime"/> for instances of ISO 20022 regarding remittances.
    
    Business Payments Coalition Remittance Group
</xsl:comment>
  <schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <title>BPC Schematron Constraints Remittance Rules</title>
    <ns prefix="xsd" uri="http://www.w3.org/2001/XMLSchema"/>
    <ns prefix="i" uri="urn:iso:std:iso:20022:tech:xsd:remt.001.001.05"/>
    <pattern>
      <title>BPC Schematron Expressions for Remittance Rules</title>

      <xsl:for-each-group select="/*/SimpleCodeList/Row[
                                  exists(bpc:col(.,'SchematronContext')) and
                                  exists(bpc:col(.,'SchematronAssertion'))]"
                          group-by="bpc:col(.,'SchematronContext')">
        <rule context="{current-grouping-key()} (:{bpc:col(.,'RuleID')}:)">
          <xsl:for-each select="current-group()">
            <assert test="{bpc:col(.,'SchematronAssertion')}">
              <xsl:value-of select="bpc:col(.,'ErrorMessage')"/>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="bpc:col(.,'RuleID')"/>
              <xsl:text>)</xsl:text>
            </assert>
          </xsl:for-each>
        </rule>
      </xsl:for-each-group>
    </pattern>
  </schema>
</xsl:template>
 
</xsl:stylesheet>