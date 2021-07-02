<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:spdx="http://spdx.org/rdf/terms#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:adms="http://www.w3.org/ns/adms#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:dcat="http://www.w3.org/ns/dcat#"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:schema="http://schema.org/"
                xmlns:locn="http://www.w3.org/ns/locn#"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
                xmlns:mdcat="http://data.vlaanderen.be/ns/metadata-dcat#"
                xmlns:gn-fn-dcat2="http://geonetwork-opensource.org/xsl/functions/profiles/dcat2"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:java="java:org.fao.geonet.util.XslUtil"
                xmlns:uuid="java:java.util.UUID"
                extension-element-prefixes="saxon"
                version="2.0"
                exclude-result-prefixes="#all">

  <!-- Tell the XSL processor to output XML. -->
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:output name="default-serialize-mode" indent="no"
              omit-xml-declaration="yes"/>

  <!-- =================================================================   -->

  <xsl:include href="layout/utility-fn.xsl"/>
  <xsl:variable name="serviceUrl" select="/root/env/siteURL"/>
  <xsl:variable name="env" select="/root/env"/>
  <xsl:variable name="iso2letterLanguageCode" select="lower-case(java:twoCharLangCode(/root/gui/language))"/>
  <xsl:variable name="resourcePrefix" select="$env/metadata/resourceIdentifierPrefix"/>

  <xsl:variable name="resourceType">
    <xsl:choose>
      <xsl:when test="/root/rdf:RDF/dcat:Catalog/dcat:dataset/dcat:Dataset">
        <xsl:value-of select="'dataset'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'service'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="profile">
    <xsl:variable name="std"
                  select="string(/root/rdf:RDF/dcat:Catalog/dcat:record/dcat:CatalogRecord/dct:conformsTo/dct:Standard/@rdf:about)"/>
    <xsl:choose>
      <xsl:when test="starts-with($std, 'https://data.vlaanderen.be/doc/applicatieprofiel/metadata-dcat')">
        <xsl:value-of select="'metadata-dcat'"/>
      </xsl:when>
      <xsl:when test="starts-with($std, 'https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL')">
        <xsl:value-of select="'dcat-ap-vl'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="uuidRegex" select="'([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}){1}'"/>
  <xsl:variable name="record" select="/root/rdf:RDF/dcat:Catalog/dcat:record/dcat:CatalogRecord"/>
  <xsl:variable name="resource" select="/root/rdf:RDF/dcat:Catalog/dcat:dataset/dcat:Dataset|
                                        /root/rdf:RDF/dcat:Catalog/dcat:service/dcat:DataService"/>

  <xsl:variable name="recordUUID" select="/root/env/uuid"/>
  <xsl:variable name="recordAbout">
    <xsl:choose>
      <xsl:when test="matches($record/@rdf:about, $uuidRegex)">
        <xsl:value-of select="replace($record/@rdf:about, $uuidRegex, $recordUUID)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(/root/env/nodeURL, 'api/records/', $recordUUID)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="resourceUUID">
    <xsl:choose>
      <xsl:when test="count($resource/dct:identifier[matches(., concat('^', $uuidRegex, '$'))]) > 0">
        <xsl:value-of select="$resource/dct:identifier[matches(., concat('^', $uuidRegex, '$'))][1]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="uuid:toString(uuid:randomUUID())"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="resourceAbout">
    <xsl:choose>
      <xsl:when test="matches($resource/@rdf:about, $uuidRegex)">
        <xsl:value-of select="replace($resource/@rdf:about, $uuidRegex, $resourceUUID)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(/root/env/nodeURL, 'doc/', $resourceType, '/', $resourceUUID)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- =================================================================  -->

  <xsl:template match="/root">
    <xsl:apply-templates select="//rdf:RDF"/>
  </xsl:template>

  <xsl:template match="@*|*[name(.)!= 'root']">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="rdf:RDF" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:call-template name="add-namespaces"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- ================================================================= -->

  <xsl:template match="dcat:Catalog" priority="10">
    <dcat:Catalog>
      <xsl:attribute name="rdf:about">
        <xsl:value-of select="concat($resourcePrefix,'/catalogs/',$env/system/site/siteId)"/>
      </xsl:attribute>
      <dct:title xml:lang="nl">
        <xsl:value-of select="concat('Open Data Catalogus van ', $env/system/site/organization)"/>
      </dct:title>
      <dct:description xml:lang="nl">
        <xsl:value-of select="concat('Deze catalogus bevat datasets ontsloten door ', $env/system/site/organization)"/>
      </dct:description>
      <dct:publisher>
        <foaf:Agent
          rdf:about="{$resourcePrefix}/organizations/{encode-for-uri($env/system/site/organization)}">
          <foaf:name xml:lang="nl">
            <xsl:value-of select="$env/system/site/organization"></xsl:value-of>
          </foaf:name>
          <dct:type>
            <skos:Concept rdf:about="http://purl.org/adms/publishertype/LocalAuthority">
              <skos:prefLabel xml:lang="nl">Local Authority</skos:prefLabel>
              <skos:prefLabel xml:lang="en">Local Authority</skos:prefLabel>
              <skos:prefLabel xml:lang="fr">Local Authority</skos:prefLabel>
              <skos:prefLabel xml:lang="de">Local Authority</skos:prefLabel>
              <skos:inScheme rdf:resource="http://purl.org/adms/publishertype/1.0"/>
            </skos:Concept>
          </dct:type>
        </foaf:Agent>
      </dct:publisher>
      <!--<xsl:copy-of select="foaf:homepage"/>-->
      <dct:license>
        <dct:LicenseDocument rdf:about="https://data.vlaanderen.be/id/licentie/creative-commons-zero-verklaring/v1.0"
                             xmlns:dct="http://purl.org/dc/terms/"
                             xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                             xmlns:skos="http://www.w3.org/2004/02/skos/core#">
          <dct:type>
            <skos:Concept rdf:about="http://purl.org/adms/licencetype/PublicDomain">
              <skos:prefLabel xml:lang="nl">Public domain</skos:prefLabel>
              <skos:prefLabel xml:lang="en">Public domain</skos:prefLabel>
              <skos:prefLabel xml:lang="fr">Public domain</skos:prefLabel>
              <skos:prefLabel xml:lang="de">Public domain</skos:prefLabel>
              <skos:inScheme rdf:resource="http://purl.org/adms/licencetype/1.0"/>
            </skos:Concept>
          </dct:type>
          <dct:title xml:lang="nl">Creative Commons Zero verklaring</dct:title>
          <dct:description xml:lang="nl">De instantie doet afstand van haar intellectuele eigendomsrechten voor zover dit wettelijk mogelijk is. Hierdoor kan de gebruiker de data hergebruiken voor eender welk doel, zonder een verplichting op naamsvermelding. Deze is de welbekende CC0 licentie.</dct:description>
          <dct:identifier>https://data.vlaanderen.be/id/licentie/creative-commons-zero-verklaring/v1.0</dct:identifier>
        </dct:LicenseDocument>
      </dct:license>
      <dct:language>
        <skos:Concept rdf:about="http://publications.europa.eu/resource/authority/language/NLD">
          <rdf:type rdf:resource="http://purl.org/dc/terms/LinguisticSystem"/>
          <skos:prefLabel xml:lang="nl">Nederlands</skos:prefLabel>
          <skos:prefLabel xml:lang="en">Dutch</skos:prefLabel>
          <skos:prefLabel xml:lang="fr">néerlandais</skos:prefLabel>
          <skos:prefLabel xml:lang="de">Niederländisch</skos:prefLabel>
          <skos:inScheme rdf:resource="http://publications.europa.eu/resource/authority/language"/>
        </skos:Concept>
      </dct:language>
      <dct:issued>
        <xsl:value-of select="'2019-09-01'"/>
      </dct:issued>
      <dct:modified>
        <xsl:value-of select="'2019-09-01'"/>
      </dct:modified>
      <xsl:for-each select="/root/gui/thesaurus/thesauri/thesaurus">
        <dcat:themeTaxonomy>
          <skos:ConceptScheme rdf:about="{$resourcePrefix}/registries/vocabularies/{key}">
            <dct:title xml:lang="{$iso2letterLanguageCode}">
              <xsl:value-of select="title"/>
            </dct:title>
            <foaf:isPrimaryTopicOf><xsl:value-of select="$serviceUrl"/>thesaurus.download?ref=<xsl:value-of
              select="key"/>
            </foaf:isPrimaryTopicOf>
          </skos:ConceptScheme>
        </dcat:themeTaxonomy>
      </xsl:for-each>
      <xsl:choose>
        <xsl:when test="dcat:record/dcat:CatalogRecord">
          <xsl:apply-templates select="dcat:record"/>
        </xsl:when>
        <xsl:otherwise>
          <dcat:record>
            <dcat:CatalogRecord>
              <xsl:call-template name="handle-record-id"/>
              <dct:modified>
                <xsl:value-of select="format-dateTime(/root/env/changeDate, '[Y0001]-[M01]-[D01]')"/>
              </dct:modified>
            </dcat:CatalogRecord>
          </dcat:record>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="dcat:dataset|dcat:service"/>
    </dcat:Catalog>
  </xsl:template>

  <xsl:template match="dcat:CatalogRecord" priority="10">
    <xsl:copy>
      <xsl:call-template name="handle-record-id"/>

      <xsl:choose>
        <xsl:when test="/root/env/changeDate">
          <dct:modified>
            <xsl:value-of select="format-dateTime(/root/env/changeDate,'[Y0001]-[M01]-[D01]')"/>
          </dct:modified>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="dct:modified"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="dct:conformsTo"/>
      <xsl:apply-templates select="adms:status"/>
      <xsl:apply-templates select="dct:issued"/>
      <xsl:apply-templates select="dct:title"/>
      <xsl:apply-templates select="dct:description"/>
      <xsl:apply-templates select="dct:language"/>
      <xsl:apply-templates select="dct:source"/>
      <xsl:apply-templates select="adms:identifier"/>
      <xsl:apply-templates select="dct:rights"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="dcat:Dataset" priority="10">
    <dcat:Dataset>
      <xsl:call-template name="handle-resource-id"/>
      <xsl:apply-templates select="dct:title"/>
      <xsl:apply-templates select="dct:description"/>
      <xsl:apply-templates select="dcat:contactPoint"/>
      <xsl:apply-templates select="dct:issued"/>
      <xsl:apply-templates select="dct:modified"/>
      <xsl:apply-templates select="dct:publisher"/>
      <xsl:apply-templates select="dcat:keyword"/>
      <xsl:call-template name="apply-subjects"/>
      <xsl:apply-templates select="dcat:theme"/>
      <xsl:apply-templates select="dct:accessRights"/>
      <xsl:apply-templates select="dct:conformsTo"/>
      <xsl:apply-templates select="foaf:page"/>
      <xsl:apply-templates select="dct:accrualPeriodicity"/>
      <xsl:apply-templates select="dct:hasVersion"/>
      <xsl:apply-templates select="dct:isVersionOf"/>
      <xsl:apply-templates select="dcat:landingPage"/>
      <xsl:apply-templates select="dct:language"/>
      <xsl:apply-templates select="adms:identifier"/>
      <xsl:apply-templates select="dct:provenance"/>
      <xsl:apply-templates select="dct:relation"/>
      <xsl:apply-templates select="dct:source"/>
      <xsl:apply-templates select="dct:spatial"/>
      <xsl:apply-templates select="dct:temporal"/>
      <xsl:apply-templates select="dct:type"/>
      <xsl:apply-templates select="owl:versionInfo"/>
      <xsl:apply-templates select="adms:versionNotes"/>
      <xsl:apply-templates select="dcat:extension"/>
      <xsl:apply-templates select="dcat:distribution"/>
      <xsl:apply-templates select="adms:sample"/>
      <xsl:apply-templates select="dcat:qualifiedRelation"/>
      <xsl:apply-templates select="dct:creator"/>
      <xsl:apply-templates select="dct:isReferencedBy"/>
      <xsl:apply-templates select="dct:rights"/>
    </dcat:Dataset>
  </xsl:template>

  <xsl:template match="dcat:DataService" priority="10">
    <dcat:DataService>
      <xsl:call-template name="handle-resource-id"/>
      <xsl:apply-templates select="dct:title"/>
      <xsl:apply-templates select="dct:description"/>
      <xsl:apply-templates select="dct:publisher"/>
      <xsl:apply-templates select="dcat:endpointUrl"/>
      <xsl:apply-templates select="dcat:endpointDescription"/>
      <xsl:apply-templates select="dcat:servesDataset"/>
      <xsl:apply-templates select="dcat:landingPage"/>
      <xsl:apply-templates select="dcat:contactPoint"/>
      <xsl:apply-templates select="dcat:keyword"/>
      <xsl:apply-templates select="dct:language"/>
      <xsl:apply-templates select="owl:versionInfo"/>
      <xsl:apply-templates select="adms:identifier"/>
      <xsl:apply-templates select="mdcat:landingspaginaVoorAuthenticatie"/>
      <xsl:apply-templates select="mdcat:landingspaginaVoorStatusinformatie"/>
      <xsl:apply-templates select="mdcat:landingspaginaVoorGebruiksinformatie"/>
      <xsl:apply-templates select="mdcat:levensfase"/>
      <xsl:apply-templates select="mdcat:ontwikkelingstoestand"/>
      <xsl:apply-templates select="dcat:qualifiedRelation"/>
      <xsl:call-template name="apply-subjects"/>
      <xsl:apply-templates select="dcat:theme"/>
      <xsl:apply-templates select="dct:accessRights"/>
      <xsl:apply-templates select="dct:conformsTo"/>
      <xsl:apply-templates select="dct:creator"/>
      <xsl:apply-templates select="dct:isReferencedBy"/>
      <xsl:apply-templates select="dct:license"/>
      <xsl:apply-templates select="dct:issued"/>
      <xsl:apply-templates select="dct:modified"/>
      <xsl:apply-templates select="dct:relation"/>
      <xsl:apply-templates select="dct:rights"/>
      <xsl:apply-templates select="dct:type"/>
    </dcat:DataService>
  </xsl:template>

  <!-- =================================================================  -->

  <!-- Set default xml:lang value when missing -->
  <xsl:template match="dcat:Dataset/dct:title|dcat:DataService/dct:title|dcat:Dataset/dct:description|
                       dcat:DataService/dct:description|dcat:Distribution/dct:title|
                       dcat:Distribution/dct:description|foaf:Agent/foaf:name" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:if test="not(@xml:lang)">
        <xsl:attribute name="xml:lang">nl</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>

  <!-- Fill empty element and update existing with resourceType -->
  <xsl:template match="foaf:Agent/dct:type|dct:subject|dcat:theme|dct:accrualPeriodicity|dct:language|dcat:Dataset/dct:type|
                       dcat:DataService/dct:type|dct:format|dcat:mediaType|adms:status|dct:LicenseDocument/dct:type|
                       dct:accessRights|mdcat:levensfase|mdcat:ontwikkelingstoestand|dcat:compressFormat|
                       dcat:packageFormat" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="inScheme" select="gn-fn-dcat2:getInSchemeURIByElementName(name(.),name(..))"/>
      <xsl:variable name="rdfType" select="gn-fn-dcat2:getRdfTypeByElementName(name(.),name(..))"/>
      <xsl:choose>
        <xsl:when test="count(*)=0 or count(skos:Concept/*[name(.)='skos:prefLabel'])=0">
          <skos:Concept>
            <xsl:if test="$rdfType!=''">
              <rdf:type rdf:resource="{$rdfType}"/>
            </xsl:if>
            <skos:prefLabel xml:lang="nl"/>
            <skos:prefLabel xml:lang="en"/>
            <skos:prefLabel xml:lang="fr"/>
            <skos:prefLabel xml:lang="de"/>
            <skos:inScheme rdf:resource="{$inScheme}"/>
          </skos:Concept>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="normalize-space(skos:Concept/@rdf:about) = ''">
              <skos:Concept>
                <xsl:if test="$rdfType!=''">
                  <rdf:type rdf:resource="{$rdfType}"/>
                </xsl:if>
                <xsl:for-each select="skos:Concept/*[name(.)='skos:prefLabel']">
                  <xsl:copy-of select="."/>
                </xsl:for-each>
                <skos:inScheme rdf:resource="{$inScheme}"/>
              </skos:Concept>
            </xsl:when>
            <xsl:otherwise>
              <skos:Concept rdf:about="{skos:Concept/@rdf:about}">
                <xsl:if test="$rdfType!=''">
                  <rdf:type rdf:resource="{$rdfType}"/>
                </xsl:if>
                <xsl:for-each select="skos:Concept/*[name(.)='skos:prefLabel']">
                  <xsl:copy-of select="."/>
                </xsl:for-each>
                <skos:inScheme rdf:resource="{$inScheme}"/>
              </skos:Concept>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- Fix value for attribute -->
  <xsl:template match="rdf:Statement/rdf:object" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[name() != 'rdf:datatype']"/>
      <xsl:attribute name="rdf:datatype">xs:dateTime</xsl:attribute>
    </xsl:copy>
  </xsl:template>

  <!-- Fix value for attribute -->
  <xsl:template match="dct:issued|dct:modified|schema:startDate|schema:endDate" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[name() != 'rdf:datatype']"/>
      <xsl:attribute name="rdf:datatype">
        <xsl:if test="not(contains(lower-case(.),'t'))">http://www.w3.org/2001/XMLSchema#date</xsl:if>
        <xsl:if test="contains(lower-case(.),'t')">http://www.w3.org/2001/XMLSchema#dateTime</xsl:if>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>

  <!-- Normalize bbox -->
  <xsl:template match="dct:Location" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="coverage">
        <xsl:choose>
          <xsl:when test="count(locn:geometry[ends-with(@rdf:datatype, '#wktLiteral')])>0">
            <xsl:value-of select="locn:geometry[ends-with(@rdf:datatype, '#wktLiteral')][1]"/>
          </xsl:when>
          <xsl:when test="count(locn:geometry[ends-with(@rdf:datatype, '#gmlLiteral')])>0">
            <xsl:value-of select="locn:geometry[ends-with(@rdf:datatype, '#gmlLiteral')][1]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="locn:geometry[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="n" select="substring-after($coverage, 'North ')"/>
      <xsl:if test="string-length($n)=0">
        <xsl:copy-of select="node()"/>
      </xsl:if>
      <xsl:if test="string-length($n)>0">
        <xsl:variable name="north" select="substring-before($n, ',')"/>
        <xsl:variable name="s" select="substring-after($coverage, 'South ')"/>
        <xsl:variable name="south" select="substring-before($s, ',')"/>
        <xsl:variable name="e" select="substring-after($coverage, 'East ')"/>
        <xsl:variable name="east" select="substring-before($e, ',')"/>
        <xsl:variable name="w" select="substring-after($coverage, 'West ')"/>
        <xsl:variable name="west" select="if (contains($w, '. ')) then substring-before($w, '. ') else $w"/>
        <xsl:variable name="isValid" select="number($west) and number($east) and number($south) and number($north)"/>
        <xsl:if test="$isValid">
          <xsl:variable name="wktLiteral" select="concat('POLYGON ((',$west,' ',$south,',',$west,' ',$north,',',$east,' ',$north,',', $east,' ', $south,',', $west,' ',$south,'))')"/>
          <xsl:variable name="gmlLiteral" select="concat('&lt;gml:Polygon&gt;&lt;gml:exterior&gt;&lt;gml:LinearRing&gt;&lt;gml:posList&gt;',$south,' ',$west,' ',$north,' ', $west, ' ', $north, ' ', $east, ' ', $south, ' ', $east,' ', $south, ' ', $west, '&lt;/gml:posList&gt;&lt;/gml:LinearRing&gt;&lt;/gml:exterior&gt;&lt;/gml:Polygon&gt;')"/>
          <xsl:element name="locn:geometry">
            <xsl:attribute name="rdf:datatype">http://www.opengis.net/ont/geosparql#wktLiteral</xsl:attribute>
            <xsl:value-of select="$wktLiteral"/>
          </xsl:element>
          <xsl:element name="locn:geometry">
            <xsl:attribute name="rdf:datatype">http://www.opengis.net/ont/geosparql#gmlLiteral</xsl:attribute>
            <xsl:value-of select="$gmlLiteral"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="not($isValid)">
          <xsl:element name="locn:geometry">
            <xsl:attribute name="rdf:datatype">http://www.opengis.net/ont/geosparql#wktLiteral</xsl:attribute>
          </xsl:element>
          <xsl:element name="locn:geometry">
            <xsl:attribute name="rdf:datatype">http://www.opengis.net/ont/geosparql#gmlLiteral</xsl:attribute>
          </xsl:element>
        </xsl:if>
        <xsl:apply-templates select="node()[name(.) != 'locn:geometry']"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- Ignore all empty rdf:about -->
  <xsl:template match="@rdf:about[normalize-space() = '' and name(..) != 'dct:LicenseDocument']|@rdf:datatype[normalize-space() = '']"
                priority="10"/>

  <!-- Fix value for attribute -->
  <xsl:template match="spdx:checksumValue" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[name() != 'rdf:datatype']"/>
      <xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#hexBinary</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>

  <!-- Fix value for attribute -->
  <xsl:template match="spdx:algorithm" priority="10">
    <spdx:algorithm rdf:resource="http://spdx.org/rdf/terms#checksumAlgorithm_sha1"/>
  </xsl:template>

  <!-- Add "mailto:" prefix on mail adresses -->
  <xsl:template match="vcard:hasEmail[not(starts-with(@rdf:resource, 'mailto:')) and normalize-space(@rdf:resource) != '']" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="rdf:resource" select="concat('mailto:', @rdf:resource)"/>
    </xsl:copy>
  </xsl:template>

  <!-- =================================================================  -->

  <xsl:template name="handle-record-id">
    <xsl:apply-templates select="@*[name() != 'rdf:about']"/>
    <xsl:attribute name="rdf:about" select="$recordAbout"/>
    <xsl:element name="dct:identifier">
      <xsl:value-of select="$recordUUID"/>
    </xsl:element>
    <xsl:element name="foaf:primaryTopic">
      <xsl:attribute name="rdf:resource" select="$resourceAbout"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="handle-resource-id">
    <xsl:apply-templates select="@*[name() != 'rdf:about']"/>
    <xsl:attribute name="rdf:about" select="$resourceAbout"/>
    <xsl:element name="dct:identifier">
      <xsl:value-of select="$resourceUUID"/>
    </xsl:element>
    <xsl:apply-templates select="dct:identifier[string() != $resourceUUID]"/>
  </xsl:template>

  <xsl:template name="apply-subjects">
    <xsl:choose>
      <xsl:when test="$profile != 'dcat-ap-vl'">
        <xsl:apply-templates select="dct:subject"/>
      </xsl:when>
      <xsl:otherwise>
        <dct:subject>
          <skos:Concept rdf:about="https://metadata.vlaanderen.be/id/GDI-Vlaanderen-Trefwoorden/VLOPENDATA">
            <skos:prefLabel xml:lang="nl">Vlaamse Open data</skos:prefLabel>
            <skos:prefLabel xml:lang="en">Vlaamse Open data</skos:prefLabel>
            <skos:inScheme rdf:resource="https://metadata.vlaanderen.be/id/GDI-Vlaanderen-Trefwoorden"/>
          </skos:Concept>
        </dct:subject>
        <xsl:apply-templates select="dct:subject[skos:Concept/@rdf:about != 'https://metadata.vlaanderen.be/id/GDI-Vlaanderen-Trefwoorden/VLOPENDATA']"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="add-namespaces">
    <xsl:namespace name="rdf" select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'"/>
    <xsl:namespace name="skos" select="'http://www.w3.org/2004/02/skos/core#'"/>
    <xsl:namespace name="spdx" select="'http://spdx.org/rdf/terms#'"/>
    <xsl:namespace name="owl" select="'http://www.w3.org/2002/07/owl#'"/>
    <xsl:namespace name="adms" select="'http://www.w3.org/ns/adms#'"/>
    <xsl:namespace name="locn" select="'http://www.w3.org/ns/locn#'"/>
    <xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
    <xsl:namespace name="foaf" select="'http://xmlns.com/foaf/0.1/'"/>
    <xsl:namespace name="dct" select="'http://purl.org/dc/terms/'"/>
    <xsl:namespace name="vcard" select="'http://www.w3.org/2006/vcard/ns#'"/>
    <xsl:namespace name="dcat" select="'http://www.w3.org/ns/dcat#'"/>
    <xsl:namespace name="schema" select="'http://schema.org/'"/>
    <xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'"/>
    <xsl:if test="$resourceType = 'service' and $profile = 'metadata-dcat'">
      <xsl:namespace name="mdcat" select="'http://data.vlaanderen.be/ns/metadata-dcat#'"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
