<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
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
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--

Schematron validation for DCAT-AP

This script was written by GIM.

Source:
- DCAT-AP v1.1: https://joinup.ec.europa.eu/release/metadata-dcat-v11
- VODAP Validator: https://github.com/tenforce/vodap-dcatap-validation

-->
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema">{$loc/strings/schematron.title}</sch:title>
  <sch:ns prefix="spdx" uri="http://spdx.org/rdf/terms#"/>
  <sch:ns prefix="owl" uri="http://www.w3.org/2002/07/owl#"/>
  <sch:ns prefix="adms" uri="http://www.w3.org/ns/adms#"/>
  <sch:ns prefix="locn" uri="http://www.w3.org/ns/locn#"/>
  <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
  <sch:ns prefix="foaf" uri="http://xmlns.com/foaf/0.1/"/>
  <sch:ns prefix="dct" uri="http://purl.org/dc/terms/"/>
  <sch:ns prefix="vcard" uri="http://www.w3.org/2006/vcard/ns#"/>
  <sch:ns prefix="dcat" uri="http://www.w3.org/ns/dcat#"/>
  <sch:ns prefix="schema" uri="http://schema.org/"/>
  <sch:ns prefix="rdf" uri="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
  <sch:ns prefix="skos" uri="http://www.w3.org/2004/02/skos/core#"/>
  <sch:ns prefix="xml" uri="http://www.w3.org/XML/1998/namespace"/>
  <sch:ns prefix="gco" uri="undefined"/>
  <sch:ns prefix="dc" uri="http://purl.org/dc/elements/1.1/"/>
  <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
  <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <sch:pattern>
    <sch:title>2. dct:type is a recommended property for Agent.</sch:title>
    <sch:rule context="//foaf:Agent[not(name(../..) = ('dcat:Catalog', 'dcat:DataService'))]">
      <sch:let name="id" value="@rdf:about/string()"/>
      <sch:let name="missingProperty" value="not(dct:type)"/>
      <sch:assert test="$missingProperty = false()">WARNING: The foaf:Agent "<sch:value-of select="$id"/>" does not have a dct:type property.
      </sch:assert>
      <sch:report test="$missingProperty = false()">The foaf:Agent "<sch:value-of select="$id"/>" has a dct:type property.
      </sch:report>
    </sch:rule>
  </sch:pattern>
  <!-- <sch:pattern> -->
    <!-- <sch:title>8. dct:publisher is a recommended property for Catalog.</sch:title> -->
    <!-- <sch:rule context="//dcat:Catalog"> -->
      <!-- <sch:let name="id" value="@rdf:about/string()"/> -->
      <!-- <sch:let name="noPublisher" value="not(dct:publisher)"/> -->
      <!-- <sch:assert test="$noPublisher = false()">WHARNING: The dcat:Catalog "<sch:value-of select="$id"/>" does not have a dct:publisher. -->
      <!-- </sch:assert> -->
      <!-- <sch:report test="$noPublisher = false()">The dcat:Catalog "<sch:value-of select="$id"/>" has a dct:publisher with id "<sch:value-of select="dct:publisher/*/@rdf:about/string()"/>". -->
      <!-- </sch:report> -->
    <!-- </sch:rule> -->
  <!-- </sch:pattern> -->
  <!-- <sch:pattern> -->
    <!-- <sch:title>14. foaf:homepage is a recommended property for Catalog.</sch:title> -->
    <!-- <sch:rule context="//dcat:Catalog"> -->
      <!-- <sch:let name="id" value="@rdf:about/string()"/> -->
      <!-- <sch:let name="noHomepage" value="not(foaf:homepage)"/> -->
      <!-- <sch:assert test="$noHomepage = false()">WARNING: The dcat:Catalog "<sch:value-of select="$id"/>" does not have a foaf:homepage. -->
      <!-- </sch:assert> -->
      <!-- <sch:report test="$noHomepage = false()">The dcat:Catalog "<sch:value-of select="$id"/>" has a foaf:homepage. -->
      <!-- </sch:report> -->
    <!-- </sch:rule> -->
  <!-- </sch:pattern> -->
<!--  <sch:pattern>-->
<!--    <sch:title>18. dct:language is a recommended property for Catalog.</sch:title>-->
<!--    <sch:rule context="//dcat:Catalog">-->
<!--      <sch:let name="id" value="@rdf:about/string()"/>-->
<!--      <sch:let name="noLanguage" value="not(dct:language)"/>-->
<!--      <sch:assert test="$noLanguage = false()">WARNING: The dcat:Catalog "<sch:value-of select="$id"/>" does not have a dct:language.-->
<!--      </sch:assert>-->
<!--      <sch:report test="$noLanguage = false()">The dcat:Catalog "<sch:value-of select="$id"/>" has a dct:language.-->
<!--      </sch:report>-->
<!--    </sch:rule>-->
<!--  </sch:pattern>-->
<!--  <sch:pattern>-->
<!--    <sch:title>21. dct:license is a recommended property for Catalog.</sch:title>-->
<!--    <sch:rule context="//dcat:Catalog">-->
<!--      <sch:let name="id" value="@rdf:about/string()"/>-->
<!--      <sch:let name="noLicense" value="not(dct:license)"/>-->
<!--      <sch:assert test="$noLicense = false()">WARNING: The dcat:Catalog "<sch:value-of select="$id"/>" does not have a dct:license.-->
<!--      </sch:assert>-->
<!--      <sch:report test="$noLicense = false()">The dcat:Catalog "<sch:value-of select="$id"/>" has a dct:license.-->
<!--      </sch:report>-->
<!--    </sch:rule>-->
<!--  </sch:pattern>-->
<!--  <sch:pattern>-->
<!--    <sch:title>24. dct:issued is a recommended property for Catalog.</sch:title>-->
<!--    <sch:rule context="//dcat:Catalog">-->
<!--      <sch:let name="id" value="@rdf:about/string()"/>-->
<!--      <sch:let name="noIssued" value="not(dct:issued )"/>-->
<!--      <sch:assert test="$noIssued = false()">WARNING: The dcat:Catalog "<sch:value-of select="$id"/>" does not have a dct:issued.-->
<!--      </sch:assert>-->
<!--      <sch:report test="$noIssued = false()">The dcat:Catalog "<sch:value-of select="$id"/>" has a dct:issued.-->
<!--      </sch:report>-->
<!--    </sch:rule>-->
<!--  </sch:pattern>-->
<!--  <sch:pattern>-->
<!--    <sch:title>24. dcat:themeTaxonomy is a recommended property for Catalog.</sch:title>-->
<!--    <sch:rule context="//dcat:Catalog">-->
<!--      <sch:let name="id" value="@rdf:about/string()"/>-->
<!--      <sch:let name="noIssued" value="not(dcat:themeTaxonomy )"/>-->
<!--      <sch:assert test="$noIssued = false()">WARNING: The dcat:Catalog "<sch:value-of select="$id"/>" does not have a dcat:themeTaxonomy.-->
<!--      </sch:assert>-->
<!--      <sch:report test="$noIssued = false()">The dcat:Catalog "<sch:value-of select="$id"/>" has a dcat:themeTaxonomy.-->
<!--      </sch:report>-->
<!--    </sch:rule>-->
<!--  </sch:pattern>-->
<!--  <sch:pattern>-->
<!--    <sch:title>31. dct:modified is a recommended property for Catalog.</sch:title>-->
<!--    <sch:rule context="//dcat:Catalog">-->
<!--      <sch:let name="id" value="@rdf:about/string()"/>-->
<!--      <sch:let name="noModified" value="not(dct:modified)"/>-->
<!--      <sch:assert test="$noModified = false()">WARNING: The dcat:Catalog "<sch:value-of select="$id"/>" does not have a dct:modified.-->
<!--      </sch:assert>-->
<!--      <sch:report test="$noModified = false()">The dcat:Catalog "<sch:value-of select="$id"/>" has a dct:modified property "<sch:value-of select="dct:modified"/>".-->
<!--      </sch:report>-->
<!--    </sch:rule>-->
<!--  </sch:pattern>-->
  <sch:pattern>
    <sch:title>41. dcat:contactPoint is a recommended property for Dataset.</sch:title>
    <sch:rule context="//dcat:Dataset">
      <sch:let name="id" value="@rdf:about/string()"/>
      <sch:let name="noContactPoint" value="not(dcat:contactPoint)"/>
      <sch:assert test="$noContactPoint = false()">WARNING: The dcat:Dataset "<sch:value-of select="$id"/>" does not have a dcat:contactPoint.
      </sch:assert>
      <sch:report test="$noContactPoint = false()">The dcat:Dataset "<sch:value-of select="$id"/>" has a dcat:contactPoint "<sch:value-of select="dcat:contactPoint/*/@rdf:about/string()"/>".
      </sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>44. dcat:distribution is a recommended property for Dataset.</sch:title>
    <sch:rule context="//dcat:Dataset">
      <sch:let name="id" value="@rdf:about/string()"/>
      <sch:let name="missingProperty" value="not(dcat:distribution )"/>
      <sch:assert test="$missingProperty = false()">WARNING: The dcat:Dataset "<sch:value-of select="$id"/>" does not have a dcat:distribution.
      </sch:assert>
      <sch:report test="$missingProperty = false()">The dcat:Dataset "<sch:value-of select="$id"/>" has a dcat:distribution with id  "<sch:value-of select="dcat:distribution/*/@rdf:about/string()"/>".      </sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>47. dcat:keyword is a recommended property for Dataset.</sch:title>
    <sch:rule context="//dcat:Dataset">
      <sch:let name="id" value="@rdf:about/string()"/>
      <sch:let name="missingProperty" value="not(dcat:distribution)"/>
      <sch:assert test="$missingProperty = false()">WARNING: The dcat:Dataset "<sch:value-of select="$id"/>" does not have a dcat:keyword.
      </sch:assert>
      <sch:report test="$missingProperty = false()">The dcat:Dataset "<sch:value-of select="$id"/>" has a dcat:keyword.</sch:report>
    </sch:rule>
  </sch:pattern>
  <!-- ISSUE: VODAP Validator is wrong... it is not a mandatory but a recommended property for a dataset (but according to DCAT-AP v1.1 and VODAP bijlage 3)
    https://github.com/tenforce/vodap-dcatap-validation/blob/master/webservice/rules/dcat/rule-49.rq-->
  <sch:pattern>
    <sch:title>49. dct:publisher is a recommended property for Dataset.</sch:title>
    <sch:rule context="//dcat:Dataset">
      <sch:let name="id" value="@rdf:about/string()"/>
      <sch:let name="noPublisher" value="not(dct:publisher)"/>
      <sch:assert test="$noPublisher = false()">WARNING: The dcat:Dataset "<sch:value-of select="$id"/>" does not have a dct:publisher.
      </sch:assert>
      <sch:assert test="$noPublisher = false()">The dcat:Dataset "<sch:value-of select="$id"/>" has a dct:publisher.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>53. dcat:theme is a recommended property for Dataset.</sch:title>
    <sch:rule context="//dcat:Dataset">
      <sch:let name="id" value="@rdf:about/string()"/>
      <sch:let name="missingProperty" value="not(dcat:theme)"/>
      <sch:assert test="$missingProperty = false()">WARNING: The dcat:Dataset "<sch:value-of select="$id"/>" does not have a dcat:theme.
      </sch:assert>
      <sch:report test="$missingProperty = false()">The dcat:Dataset "<sch:value-of select="$id"/>" has a dcat:theme².</sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>81. dct:description is a recommended property for Distribution.</sch:title>
    <sch:rule context="//dcat:Distribution">
      <sch:let name="id" value="@rdf:about/string()"/>
      <sch:let name="noDescription" value="not(dct:description)"/>
      <sch:assert test="$noDescription = false()">WARNING: The dcat:Distribution "<sch:value-of select="$id"/>" does not have a dct:description.
      </sch:assert>
      <sch:report test="$noDescription = false()">The dcat:Distribution "<sch:value-of select="$id"/>" has a dct:description "<sch:value-of select="dct:description"/>"
      </sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>83. dct:format is a recommended property for Distribution.</sch:title>
    <sch:rule context="//dcat:Distribution">
      <sch:let name="id" value="@rdf:about/string()"/>
      <sch:let name="missingProperty" value="not(dct:format)"/>
      <sch:assert test="$missingProperty = false()">WARNING: The dcat:Distribution "<sch:value-of select="$id"/>" does not have a dct:format.
      </sch:assert>
      <sch:report test="$missingProperty = false()">The dcat:Distribution "<sch:value-of select="$id"/>" has a dct:format "<sch:value-of select="dct:format"/>"
      </sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>86. dct:license is a recommended property for Distribution.</sch:title>
    <sch:rule context="//dcat:Distribution">
      <sch:let name="id" value="@rdf:about/string()"/>
      <sch:let name="noLicense" value="not(dct:license)"/>
      <sch:assert test="$noLicense = false()">WARNING: The dcat:Distribution "<sch:value-of select="$id"/>" does not have a dct:license.
      </sch:assert>
      <sch:report test="$noLicense = false()">The dcat:Distribution "<sch:value-of select="$id"/>" has a dct:license.
      </sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>166. The recommended class dct:LicenseDocument does not exist.</sch:title>
    <sch:rule context="/">
      <sch:let name="noLicenseDocument" value="not(//dct:LicenseDocument)"/>
      <sch:assert test="$noLicenseDocument = false()">WARNING: The recommended class dct:LicenseDocument does not exist.
      </sch:assert>
      <sch:report test="$noLicenseDocument = false()">The recommended class dct:LicenseDocument exists.
      </sch:report>
    </sch:rule>
  </sch:pattern>
  <!-- 144.  dct:conformsTo is a recommended property for Catalog Record-->
  <!-- 145.  adms:status is a recommended property for Catalog Record-->
  <!-- 146.  dct:issued is a recommended property for Catalog Record-->
  <sch:pattern>
    <sch:title>167. The recommended class skos:Concept does not exist.</sch:title>
    <sch:rule context="/">
      <sch:let name="missingClass" value="not(//skos:Concept)"/>
      <sch:assert test="$missingClass = false()">ERROR: The recommended class skos:Concept does not exist.</sch:assert>
      <sch:report test="$missingClass = false()">The recommended class skos:Concept does exist.</sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>168. The recommended class skos:ConceptScheme does not exist.</sch:title>
    <sch:rule context="/">
      <sch:let name="missingClass" value="not(//skos:Concept)"/>
      <sch:assert test="$missingClass = false()">ERROR: The recommended class skos:ConceptScheme does not exist.</sch:assert>
      <sch:report test="$missingClass = false()">The recommended class skos:ConceptScheme does exist.</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--<sch:pattern>-->
  <!--  <sch:title>169. skos:prefLabel is a required property for skos:Concept.</sch:title>-->
  <!--  <sch:rule context="//skos:Concept[name(..) = ('dct:type','dcat:theme','dct:format')]">-->
  <!--    <sch:let name="id" value="@rdf:about/string()"/>-->
  <!--    <sch:let name="value" value="skos:prefLabel[@xml:lang='nl']"/>-->
  <!--    <sch:let name="missingProperty" value="not($value!='')"/>-->
  <!--    <sch:assert test="$missingProperty = false()">ERROR: The <sch:value-of select="name(../..)"/>/<sch:value-of select="name(..)"/> does not have a skos:prefLabel value.-->
  <!--    </sch:assert>-->
  <!--    <sch:report test="$missingProperty = false()">The <sch:value-of select="name(../..)"/>/<sch:value-of select="name(..)"/> does have a skos:prefLabel with value <sch:value-of select="$value"/>.-->
  <!--    </sch:report>-->
  <!--  </sch:rule>-->
  <!--</sch:pattern>-->
  <sch:pattern>
    <sch:title>170. dct:type is a recommended property for Licence Document.</sch:title>
    <sch:rule context="//dcat:Distribution/*/dct:LicenseDocument">
      <sch:let name="id" value="@rdf:about/string()"/>
      <sch:let name="noLicenseType" value="not(dct:type)"/>
      <sch:assert test="$noLicenseType = false()">WARNING: The licence "<sch:value-of select="$id"/>" has no dct:type property.
      </sch:assert>
      <sch:report test="$noLicenseType = false()">The licence "<sch:value-of select="$id"/>" has a dct:type property.
      </sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>235. dct:description should be a non-empty string for dcat:Distribution.</sch:title>
    <sch:rule context="//dcat:Distribution/dct:description">
      <sch:let name="id" value="parent::node()/@rdf:about/string()"/>
      <sch:let name="emptyString" value="normalize-space(.)=''"/>
      <sch:assert test="$emptyString = false()">ERROR: The dcat:Distribution "<sch:value-of select="$id"/>" has a dct:description that is an empty string.
      </sch:assert>
      <sch:report test="$emptyString = false()">The dcat:Distribution '<sch:value-of select="$id"/>' has a dct:description '<sch:value-of select="./string()"/>' which is a non-empty string.
      </sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>301. dcat:contactPoint is a recommended property for DataService.</sch:title>
    <sch:rule context="//dcat:DataService">
      <sch:let name="id" value="@rdf:about/string()"/>
      <sch:let name="noContactPoint" value="not(dcat:contactPoint)"/>
      <sch:assert test="$noContactPoint = false()">WARNING: The dcat:DataService "<sch:value-of select="$id"/>" does not have a dcat:contactPoint.
      </sch:assert>
      <sch:report test="$noContactPoint = false()">The dcat:DataService "<sch:value-of select="$id"/>" has a dcat:contactPoint "<sch:value-of select="dcat:contactPoint/*/@rdf:about/string()"/>".
      </sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>510. dcat:Catalog property should be an absolute URI.</sch:title>
    <sch:rule context="//dcat:Catalog/*[name()=('foaf:homepage', 'dct:language', 'dct:rights', 'dct:license', 'dcat:themeTaxonomy', 'dct:hasPart', 'dct:isPartOf')]">
      <sch:let name="id" value="parent::node()/@rdf:about/string()"/>
      <sch:let name="elementName" value="name()"/>
      <sch:let name="resource" value="(* and not(*/@rdf:about)) or ((starts-with(@rdf:resource,'http') or starts-with(@rdf:resource,'ftp') or starts-with(@rdf:resource,'urn')) and @rdf:resource castable as xs:anyURI) or ((starts-with(*/@rdf:about,'http') or starts-with(*/@rdf:about,'ftp') or starts-with(*/@rdf:about,'urn')) and */@rdf:about castable as xs:anyURI)"/>
      <sch:let name="messageStart" value="concat('The property ', $elementName, ' of dcat:Catalog ',$id)"/>
      <sch:assert test="$resource = true()"><sch:value-of select="$messageStart"/> should be an absolute URI.</sch:assert>
      <sch:report test="$resource = true()"><sch:value-of select="$messageStart"/> is an absolute URI.</sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>511. dcat:Dataset property should be an absolute URI.</sch:title>
    <sch:rule context="//dcat:Dataset/*[name()=('dcat:landingPage', 'dct:language', 'dct:type', 'dcat:theme', 'dct:accessRights', 'foaf:page', 'dct:hasVersion', 'dct:isVersionOf', 'dct:source', 'dct:relation')]">
      <sch:let name="id" value="parent::node()/@rdf:about/string()"/>
      <sch:let name="elementName" value="name()"/>
      <sch:let name="resource" value="(* and not(*/@rdf:about)) or ((starts-with(@rdf:resource,'http') or starts-with(@rdf:resource,'ftp') or starts-with(@rdf:resource,'urn')) and @rdf:resource castable as xs:anyURI) or ((starts-with(*/@rdf:about,'http') or starts-with(*/@rdf:about,'ftp') or starts-with(*/@rdf:about,'urn')) and */@rdf:about castable as xs:anyURI)"/>
      <sch:let name="messageStart" value="concat('The property ', $elementName, ' of dcat:Dataset ',$id)"/>
      <sch:assert test="$resource = true()"><sch:value-of select="$messageStart"/> should be an absolute URI.</sch:assert>
      <sch:report test="$resource = true()"><sch:value-of select="$messageStart"/> is an absolute URI.</sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>512. dcat:Distribution property should be an absolute URI.</sch:title>
    <sch:rule context="//dcat:Distribution/*[name()=('dct:format', 'dct:license', 'dcat:mediaType', 'dct:rights', 'adms:status', 'foaf:page', 'dct:language', 'dct:conformsTo')]">
      <sch:let name="id" value="parent::node()/@rdf:about/string()"/>
      <sch:let name="elementName" value="name()"/>
      <sch:let name="resource" value="(* and not(*/@rdf:about)) or ((starts-with(@rdf:resource,'http') or starts-with(@rdf:resource,'ftp') or starts-with(@rdf:resource,'urn')) and @rdf:resource castable as xs:anyURI) or ((starts-with(*/@rdf:about,'http') or starts-with(*/@rdf:about,'ftp') or starts-with(*/@rdf:about,'urn')) and */@rdf:about castable as xs:anyURI)"/>
      <sch:let name="messageStart" value="concat('The property ', $elementName, ' of dcat:Distribution ',$id)"/>
      <sch:assert test="$resource = true()"><sch:value-of select="$messageStart"/> should be an absolute URI.</sch:assert>
      <sch:report test="$resource = true()"><sch:value-of select="$messageStart"/> is an absolute URI.</sch:report>
    </sch:rule>
  </sch:pattern>
</sch:schema>
