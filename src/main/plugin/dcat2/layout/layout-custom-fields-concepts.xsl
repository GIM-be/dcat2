<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dcat="http://www.w3.org/ns/dcat#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:mdcat="http://data.vlaanderen.be/ns/metadata-dcat#"
                xmlns:gn-fn-dcat2="http://geonetwork-opensource.org/xsl/functions/profiles/dcat2"
                xmlns:java="java:org.fao.geonet.util.XslUtil"
                version="2.0"
                exclude-result-prefixes="#all">


  <xsl:variable name="dcatKeywordConfig">
    <xsl:for-each select="$editorConfig/editor/fields/for[@use='thesaurus-list-picker']">
      <element>
        <xsl:attribute name="name" select="./@name"/>
        <xsl:if test="./@xpath">
          <xsl:attribute name="parent" select="./@xpath"/>
        </xsl:if>
        <thesaurus>
          <xsl:value-of select="./directiveAttributes/@thesaurus"/>
        </thesaurus>
        <xpath>
          <xsl:value-of select="./directiveAttributes/@xpath"/>
        </xpath>
        <max>
          <xsl:value-of select="./directiveAttributes/@max"/>
        </max>
        <labelKey>
          <xsl:value-of select="./directiveAttributes/@labelKey"/>
        </labelKey>
        <useReference>
          <xsl:value-of select="./directiveAttributes/@useReference"/>
        </useReference>
      </element>
    </xsl:for-each>
  </xsl:variable>

  <!-- Theme can only be set by thesaurus eu.europa.data-theme.

  Catch all elements first.
  On gn:child, build the keyword picker directive using XPath mode.
  TODO: How to deal with value not in the thesaurus ?
  -->
  <xsl:template mode="mode-dcat2" priority="4000" match="*[gn-fn-dcat2:getThesaurusConfig(name(), name(..))]">
    <xsl:variable name="name" select="name()"/>
    <xsl:variable name="hasGnChild" select="count(../gn:child[concat(@prefix, ':', @name) = $name]) > 0"/>
    <xsl:if test="not($hasGnChild)">
      <xsl:variable name="isFirst" select="count(preceding-sibling::*[name() = $name]) &lt; 1"/>
      <xsl:if test="$isFirst">
        <xsl:variable name="xpath" select="concat('/', name(../..), '/', name(..), '/', name())"/>
        <xsl:variable name="config" select="gn-fn-dcat2:getThesaurusConfig(name(), name(..), $xpath)"/>
        <xsl:call-template name="thesaurus-picker-list">
          <xsl:with-param name="config" select="$config"/>
          <xsl:with-param name="ref" select="../gn:element/@ref"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="mode-dcat2" priority="4000" match="gn:child[gn-fn-dcat2:getThesaurusConfig(concat(@prefix, ':', @name), name(..))]">
    <xsl:variable name="xpath" select="concat('/', name(../..), '/', name(..), '/', concat(@prefix, ':', @name))"/>
    <xsl:variable name="config" select="gn-fn-dcat2:getThesaurusConfig(concat(@prefix, ':', @name), name(..), $xpath)"/>
    <xsl:call-template name="thesaurus-picker-list">
      <xsl:with-param name="config" select="$config"/>
      <xsl:with-param name="ref" select="../gn:element/@ref"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="thesaurus-picker-list">
    <xsl:param name="config" as="node()"/>
    <xsl:param name="ref" as="xs:string"/>
    <xsl:if test="gn-fn-dcat2:shouldShow($config/@name, $config/@parent)">
      <xsl:variable name="values">
        <xsl:choose>
          <xsl:when test="$config/useReference = 'true' and ../*[name() = $config/@name]/@rdf:resource">
            <xsl:for-each select="../*[name() = $config/@name]">
              <xsl:variable name="v" select="replace(java:getKeywordValueByUri(@rdf:resource, $config/thesaurus, $lang), ',', ',,')"/>
              <xsl:if test="string($v)">
                <xsl:value-of select="$v"/>
                <xsl:if test="position() != last()">,</xsl:if>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <!-- Show preflabel in current metadata language first -->
          <!--<xsl:when test="$metadataLanguage and ../*[name() = $config/@name]//skos:prefLabel[@xml:lang = java:twoCharLangCode($metadataLanguage)]">-->
          <!--  <xsl:value-of select="string-join(../*[name() = $config/@name]//skos:prefLabel[@xml:lang = java:twoCharLangCode($metadataLanguage)]/replace(text(), ',', ',,'), ',')"/>-->
          <!--</xsl:when>-->
          <!-- Fallback on nl language -->
          <xsl:when test="../*[name() = $config/@name]//skos:prefLabel[@xml:lang = 'nl']">
            <xsl:value-of select="string-join(../*[name() = $config/@name]//skos:prefLabel[@xml:lang = 'nl']/replace(text(), ',', ',,'), ',')"/>
          </xsl:when>
          <!-- Fallback on preflabel without any language -->
          <xsl:when test="../*[name() = $config/@name]//skos:prefLabel[not(@xml:lang)]">
            <xsl:value-of select="string-join(../*[name() = $config/@name]//skos:prefLabel[not(@xml:lang)]/replace(text(), ',', ',,'), ',')"/>
          </xsl:when>
          <!-- Fallback on first preflabel -->
          <xsl:when test="../*[name() = $config/@name]//skos:prefLabel[not(@xml:lang)]">
            <xsl:value-of select="string-join(../*[name() = $config/@name]//skos:prefLabel[not(@xml:lang)]/replace(text(), ',', ',,'), ',')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="transformation" select="if ($config/useReference = 'true')
                                                then 'to-dcat2-concept-reference'
                                                else 'to-dcat2-concept'"/>

      <xsl:variable name="elemXpath">
        <xsl:variable name="resourcePath" select="concat('./dcat:Catalog', if ($isDcatService) then '/dcat:service/dcat:DataService' else '/dcat:dataset/dcat:Dataset')"/>
        <xsl:choose>
          <xsl:when test="starts-with($config/xpath, '/dcat:Distribution')">
            <xsl:variable name="index" select="count(../../preceding-sibling::dcat:distribution) + 1"/>
            <xsl:value-of select="concat('(', $resourcePath, '/dcat:distribution', ')', '[', $index, ']', $config/xpath)"/>
          </xsl:when>
          <xsl:when test="starts-with($config/xpath, '/dct:LicenseDocument') and not($isDcatService)">
            <xsl:variable name="index" select="count(../../../../preceding-sibling::dcat:distribution) + 1"/>
            <xsl:value-of select="concat('(', $resourcePath, '/dcat:distribution', ')', '[', $index, ']', '/dcat:Distribution/dct:license', $config/xpath)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($resourcePath, $config/xpath)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <div
        data-gn-keyword-selector="tagsinput"
        data-metadata-id=""
        data-element-ref="{concat('_P', $ref, '_', replace($config/@name, ':', 'COLON'))}"
        data-element-xpath="{$elemXpath}"
        data-wrapper="{$config/@name}"
        data-thesaurus-title="{$strings/*[name() = $config/labelKey]}"
        data-thesaurus-key="{$config/thesaurus}"
        data-keywords="{$values}"
        data-transformations="{$transformation}"
        data-current-transformation="{$transformation}"
        data-max-tags="{$config/max}"
        data-lang="{$metadataOtherLanguagesAsJson}"
        data-textgroup-only="false"
        class="">
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:function name="gn-fn-dcat2:getThesaurusConfig">
    <xsl:param name="name" as="xs:string"/>
    <xsl:param name="parent" as="xs:string"/>
    <xsl:copy-of select="gn-fn-dcat2:getThesaurusConfig($name, $parent, '')"/>
  </xsl:function>

  <xsl:function name="gn-fn-dcat2:getThesaurusConfig">
    <xsl:param name="name" as="xs:string"/>
    <xsl:param name="parent" as="xs:string"/>
    <xsl:param name="xpath" as="xs:string"/>
    <xsl:variable name="config" select="if ($dcatKeywordConfig/*[@name = $name and @parent = $parent])
                         then $dcatKeywordConfig/*[@name = $name and @parent = $parent]
                         else $dcatKeywordConfig/*[@name = $name and not(@parent)]"/>
    <xsl:choose>
      <xsl:when test="count($config) = 1">
        <xsl:copy-of select="$config"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$config[xpath = $xpath]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="gn-fn-dcat2:shouldShow" as="xs:boolean">
    <xsl:param name="name"/>
    <xsl:param name="parent"/>
    <xsl:value-of select="not($isFlatMode) or not(
      ($name = 'dct:accessRights' and $parent = 'dcat:Distribution') or
      ($name = 'dcat:compressFormat') or
      ($name = 'dcat:packageFormat')
    )"/>
  </xsl:function>

</xsl:stylesheet>
