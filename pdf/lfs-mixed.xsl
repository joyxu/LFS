<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

  <!-- This stylesheet contains misc params, attribute sets and templates
       for output formating.
       This file is for that templates that don't fit in other files. -->

    <!-- What space do you want between normal paragraphs. -->
  <xsl:attribute-set name="normal.para.spacing">
    <xsl:attribute name="space-before.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
    <xsl:attribute name="orphans">3</xsl:attribute>
    <xsl:attribute name="widows">3</xsl:attribute>
  </xsl:attribute-set>

    <!-- Properties associated with verbatim text. -->
  <xsl:attribute-set name="verbatim.properties">
    <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
    <xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>
    <xsl:attribute name="space-before.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.8em</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
    <xsl:attribute name="white-space-collapse">false</xsl:attribute>
    <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
    <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>

    <!-- Should verbatim environments be shaded? 1 =yes, 0 = no -->
  <xsl:param name="shade.verbatim" select="1"/>

    <!-- Properties that specify the style of shaded verbatim listings -->
  <xsl:attribute-set name="shade.verbatim.style">
    <xsl:attribute name="background-color">#E9E9E9</xsl:attribute>
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">0.5pt</xsl:attribute>
    <xsl:attribute name="border-color">#050505</xsl:attribute>
    <xsl:attribute name="padding-start">5pt</xsl:attribute>
    <xsl:attribute name="padding-top">2pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">2pt</xsl:attribute>
  </xsl:attribute-set>

    <!-- para:
           Skip empty "Home page" in packages.xml.
           Allow forced line breaks inside paragraphs emulating literallayout.
           Removed vertical space in variablelist. -->
    <!-- The original template is in {docbook-xsl}/fo/block.xsl -->
 <xsl:template match="para">
    <xsl:choose>
      <xsl:when test="child::ulink[@url=' ']"/>
      <xsl:when test="./@remap='verbatim'">
        <fo:block xsl:use-attribute-sets="verbatim.properties">
          <xsl:call-template name="anchor"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="ancestor::variablelist">
        <fo:block>
          <xsl:attribute name="space-before.optimum">0.1em</xsl:attribute>
          <xsl:attribute name="space-before.minimum">0em</xsl:attribute>
          <xsl:attribute name="space-before.maximum">0.2em</xsl:attribute>
          <xsl:call-template name="anchor"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="normal.para.spacing">
          <xsl:call-template name="anchor"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <!-- literal:
           Be sure that literal will use allways normal font weight. -->
    <!-- The original template is in {docbook-xsl}/fo/inline.xsl -->
  <xsl:template match="literal">
    <fo:inline  font-weight="normal">
      <xsl:call-template name="inline.monoseq"/>
    </fo:inline>
  </xsl:template>

    <!-- inline.monoseq:
           Added hyphenate-url support to classname, exceptionname, interfacename,
           methodname, computeroutput, constant, envar, filename, function, code,
           literal, option, promt, systemitem, varname, sgmltag, tag, and uri -->
    <!-- The original template is in {docbook-xsl}/fo/inline.xsl -->
  <xsl:template name="inline.monoseq">
    <xsl:param name="content">
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content">
          <xsl:call-template name="hyphenate-url">
            <xsl:with-param name="url">
              <xsl:apply-templates/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:param>
    <fo:inline xsl:use-attribute-sets="monospace.properties">
      <xsl:if test="@dir">
        <xsl:attribute name="direction">
          <xsl:choose>
            <xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
            <xsl:otherwise>rtl</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$content"/>
    </fo:inline>
  </xsl:template>

    <!-- inline.italicmonoseq:
           Added hyphenate-url support to parameter, replaceable, structfield,
           function/parameter, and function/replaceable -->
    <!-- The original template is in {docbook-xsl}/fo/inline.xsl -->
  <xsl:template name="inline.italicmonoseq">
    <xsl:param name="content">
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content">
          <xsl:call-template name="hyphenate-url">
            <xsl:with-param name="url">
              <xsl:apply-templates/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:param>
    <fo:inline font-style="italic" xsl:use-attribute-sets="monospace.properties">
      <xsl:call-template name="anchor"/>
      <xsl:if test="@dir">
        <xsl:attribute name="direction">
          <xsl:choose>
            <xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
            <xsl:otherwise>rtl</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$content"/>
    </fo:inline>
  </xsl:template>

    <!-- Show external URLs in italic font -->
  <xsl:attribute-set name="xref.properties">
    <xsl:attribute name="font-style">
      <xsl:choose>
        <xsl:when test="self::ulink">italic</xsl:when>
        <xsl:otherwise>inherit</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>


  <!-- Lists -->

    <!-- What spacing do you want before and after lists? -->
  <xsl:attribute-set name="list.block.spacing">
    <xsl:attribute name="space-before.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.8em</xsl:attribute>
  </xsl:attribute-set>

    <!-- What spacing do you want between list items?
         No space in nested itemizedlist, like in the Changelog. -->
  <xsl:attribute-set name="list.item.spacing">
    <xsl:attribute name="space-before.optimum">
      <xsl:choose>
        <xsl:when test=". = //listitem/itemizedlist/listitem">0em</xsl:when>
        <xsl:otherwise>0.4em</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-before.minimum">
      <xsl:choose>
        <xsl:when test=". = //listitem/itemizedlist/listitem">0em</xsl:when>
        <xsl:otherwise>0.2em</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-before.maximum">
      <xsl:choose>
        <xsl:when test=". = //listitem/itemizedlist/listitem">0.2em</xsl:when>
        <xsl:otherwise>0.6em</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

    <!-- Properties that apply to each list-block generated by itemizedlist. -->
  <xsl:attribute-set name="itemizedlist.properties"
                     use-attribute-sets="list.block.properties">
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>

    <!-- Format variablelists lists as blocks? 1 = yes, 0 = no
           Default variablelist format. We override it when necesary
           using the list-presentation processing instruction. -->
  <xsl:param name="variablelist.as.blocks" select="1"/>

    <!-- Specifies the longest term in variablelists.
         Used when list-presentation = list -->
  <xsl:param name="variablelist.max.termlength">32</xsl:param>

    <!-- varlistentry mode block:
           Addibg a bullet, left alignament, and @kepp-*.* attributes
           for packages and paches list. -->
    <!-- The original template is in {docbook-xsl}/fo/list.xsl -->
  <xsl:template match="varlistentry" mode="vl.as.blocks">
    <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="ancestor::variablelist/@role = 'materials'">
        <fo:block id="{$id}" xsl:use-attribute-sets="list.item.spacing"
                  keep-together.within-column="always"
                  keep-with-next.within-column="always" text-align="left">
          <xsl:text>&#x2022;   </xsl:text>
          <xsl:apply-templates select="term"/>
        </fo:block>
        <fo:block margin-left="1.4pc" text-align="left"
                  keep-together.within-column="always"
                  keep-with-previous.within-column="always">
          <xsl:apply-templates select="listitem"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block id="{$id}" xsl:use-attribute-sets="list.item.spacing"
                  keep-together.within-column="always"
                  keep-with-next.within-column="always">
          <xsl:apply-templates select="term"/>
        </fo:block>
        <fo:block margin-left="0.25in">
          <xsl:apply-templates select="listitem"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <!-- segmentedlist:
           Making it an actual FO list to can indent items.
           Adjust vertical space. -->
    <!-- The original template is in {docbook-xsl}/fo/list.xsl -->
  <xsl:template match="segmentedlist">
    <fo:list-block provisional-distance-between-starts="12em"
                   provisional-label-separation="1em"
                   keep-together.within-column="always">
      <xsl:choose>
        <xsl:when test="ancestor::appendix[@id='appendixc']">
          <xsl:attribute name="space-before.optimum">0.2em</xsl:attribute>
          <xsl:attribute name="space-before.minimum">0em</xsl:attribute>
          <xsl:attribute name="space-before.maximum">0.4em</xsl:attribute>
          <xsl:attribute name="space-after.optimum">0.2em</xsl:attribute>
          <xsl:attribute name="space-after.minimum">0em</xsl:attribute>
          <xsl:attribute name="space-after.maximum">0.4em</xsl:attribute>
          <xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="space-before.optimum">0.4em</xsl:attribute>
          <xsl:attribute name="space-before.minimum">0.2em</xsl:attribute>
          <xsl:attribute name="space-before.maximum">0.6em</xsl:attribute>
          <xsl:attribute name="space-after.optimum">0.4em</xsl:attribute>
          <xsl:attribute name="space-after.minimum">0.2em</xsl:attribute>
          <xsl:attribute name="space-after.maximum">0.6em</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="seglistitem/seg"/>
    </fo:list-block>
  </xsl:template>

    <!-- seg:
           Self-made template based on the original seg template
           found in {docbook-xsl}/fo/list.xsl
           Making segmentedlist an actual FO list to can indent items. -->
  <xsl:template match="seglistitem/seg">
    <xsl:variable name="segnum" select="count(preceding-sibling::seg)+1"/>
    <xsl:variable name="seglist" select="ancestor::segmentedlist"/>
    <xsl:variable name="segtitles" select="$seglist/segtitle"/>
    <fo:list-item xsl:use-attribute-sets="compact.list.item.spacing">
      <fo:list-item-label end-indent="label-end()" text-align="start">
        <fo:block>
          <fo:inline font-weight="bold">
            <xsl:apply-templates select="$segtitles[$segnum=position()]"
                                 mode="segtitle-in-seg"/>
            <xsl:text>:</xsl:text>
          </fo:inline>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

</xsl:stylesheet>
