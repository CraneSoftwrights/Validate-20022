<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="utilities/xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                exclude-result-prefixes="xs svrl"
                version="2.0">

<xs:doc filename="testSVRL4ISO20022errors.xsl" vocabulary="DocBook"
        info="20221004-1000z">
  <xs:title>Testing SVRL for any errors</xs:title>
  <para>
    Test the output of Schematron transformation for any errors while at
    the same time translating the location contexts for ISO 20022 namespaces.
  </para>
  <para>
    This returns a non-zero exit code when the input SVRL xml file contains
    a signalled error for an assertion or a report.
    (ref: Part 3: Rule-based validation - Schematron (ISO/IEC 19757-3:2006)
          <ulink url="http://standards.iso.org/ittf/PubliclyAvailableStandards">http://standards.iso.org/ittf/PubliclyAvailableStandards</ulink> 19757-3)
  </para>
  <para>
    The location contexts are massaged when ISO 20022 namespaces are recognized
    so that the message is made more clear. Other namespaces are kept in clear
    text.
  </para>
  <para>
    Standard output can be ignored as all messages are sent to standard error.
  </para>
  <para>
    Any given error reports the ordinal number, followed by the message,
    followed by the XPath context, followed by " / ", followed by the
    XPath test. The XPath context can be found in the input document. The
    XPath test location may or may not be found in the input document. 
  </para>
</xs:doc>

<!--========================================================================-->
<xs:doc>
  <xs:title>Invocation parameters and input file</xs:title>
  <para>
    The input file is the output SVRL from Schematron checking.
  </para>
</xs:doc>

<xs:output>
  <para>The output is a text file</para>
</xs:output>
<xsl:output method="text"/>

<!--========================================================================-->
<xs:doc>
  <xs:title>Main logic</xs:title>
</xs:doc>

<xs:template>
  <para>
    Return an error and report all failed assertions or successful reports.
  </para>
</xs:template>
<xsl:template match="/">
  <!--gather up all of the errors-->
  <xsl:variable name="failures"
                select="//(svrl:failed-assert,//svrl:successful-report)"/>
  
  <xsl:if test="$failures">
    <!--report all of the errors-->
    <xsl:for-each select="$failures">
      <!--massage the location based on knowledge of ISO 20022 namespaces-->
      <xsl:variable name="location" select="
replace(@location,'@Q\{.*?\}','@')"/>
      <xsl:variable name="location" select="
replace($location,'Q\{urn:iso:std:iso:20022:tech:xsd:.*?\}','$1')"/>
      <!--massage location to remove the predicate on the document element-->
      <xsl:variable name="location" select="
replace($location,'^(/.+?)\[1\]','$1')"/>
      <!--compose message-->
      <xsl:variable name="message">
        <xsl:value-of select="position()"/>
        <xsl:text>. </xsl:text>
        <!--ensure only a single space follows the string-->
        <xsl:value-of select="replace( svrl:text, '(.)\s*$', '$1 ' )"/>
        <xsl:value-of select="$location"/>
        <xsl:text> / </xsl:text>
        <xsl:value-of select="replace( @test, 'i:', '')"/>
      </xsl:variable>
      <!--log message-->
      <xsl:message select="$message"/>
    </xsl:for-each>
    <xsl:message select="'Count of data errors:',count($failures)"/>
    <xsl:message/>
  </xsl:if>
  
  <xsl:variable name="internals"
                select="distinct-values(//svrl:suppressed-rule/@context)"/>
  <xsl:if test="exists($internals)">
    <!--report all of the internal errors, but only once for each-->
    <xsl:for-each-group group-by="@context"
                        select="//svrl:suppressed-rule">
      <xsl:variable name="message">
        <xsl:value-of select="'INTERNAL ERROR',position()"/>
        <xsl:text>. Suppressed rule: "</xsl:text>
        <xsl:value-of select="@context"/>
        <xsl:text>" shadowed by rule: "</xsl:text>
        <xsl:value-of select="preceding-sibling::svrl:fired-rule[1]/@context"/>
        <xsl:text>"</xsl:text>
      </xsl:variable>
      <!--log message-->
      <xsl:message select="$message"/>
    </xsl:for-each-group>
    <xsl:message select="'Count of internal errors to be reported:',
                         count($internals)"/>
    <xsl:message/>
  </xsl:if>

  <xsl:if test="$failures or $internals">
    <!--terminate with an error since there was at least one problem-->
    <xsl:message/>
    <xsl:message terminate="yes">
      <xsl:text>The following error report is simply the exit </xsl:text>
      <xsl:text>mechanism and can be ignored:</xsl:text>
    </xsl:message>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>