<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">


    <!-- Allow forced line breaks inside paragraphs emulating literallayout
    and to remove vertical space in pachages and patches pages. -->
 <xsl:template match="para">
    <xsl:choose>
      <xsl:when test="child::ulink[@url=' ']"/>
      <xsl:when test="./@remap='verbatim'">
        <fo:block wrap-option="no-wrap"
                    white-space-collapse="false"
                    white-space-treatment="preserve"
                    text-align="start"
                    linefeed-treatment="preserve">
          <xsl:call-template name="anchor"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="ancestor::variablelist/@role = 'materials'">
        <fo:block>
          <xsl:attribute name="space-before.optimum">0.1em</xsl:attribute>
          <xsl:attribute name="space-before.minimum">0em</xsl:attribute>
          <xsl:attribute name="space-before.maximum">0.2em</xsl:attribute>
          <xsl:call-template name="anchor"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-imports/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <!-- Show URLs in italic font -->
  <xsl:template match="ulink" name="ulink">
    <fo:inline font-style="italic">
      <fo:basic-link xsl:use-attribute-sets="xref.properties">
        <xsl:attribute name="external-destination">
          <xsl:call-template name="fo-external-image">
            <xsl:with-param name="filename" select="@url"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="count(child::node())=0">
            <xsl:call-template name="hyphenate-url">
              <xsl:with-param name="url" select="@url"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:basic-link>
    </fo:inline>
    <xsl:if test="count(child::node()) != 0
                  and string(.) != @url
                  and $ulink.show != 0">
      <!-- yes, show the URI -->
      <xsl:choose>
        <xsl:when test="$ulink.footnotes != 0 and not(ancestor::footnote)">
          <xsl:text>&#xA0;</xsl:text>
          <fo:footnote>
            <xsl:call-template name="ulink.footnote.number"/>
            <fo:footnote-body font-family="{$body.fontset}"
                              font-size="{$footnote.font.size}">
              <fo:block>
                <xsl:call-template name="ulink.footnote.number"/>
                <xsl:text> </xsl:text>
                <fo:inline>
                  <xsl:value-of select="@url"/>
                </fo:inline>
              </fo:block>
            </fo:footnote-body>
          </fo:footnote>
        </xsl:when>
        <xsl:otherwise>
          <fo:inline hyphenate="false">
            <xsl:text> [</xsl:text>
            <xsl:call-template name="hyphenate-url">
              <xsl:with-param name="url" select="@url"/>
            </xsl:call-template>
            <xsl:text>]</xsl:text>
          </fo:inline>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

    <!-- Split URLs (obsolete, keeped as reference) -->
  <!--<xsl:template name="hyphenate-url">
    <xsl:param name="url" select="''"/>
    <xsl:choose>
      <xsl:when test="ancestor::varlistentry">
        <xsl:choose>
          <xsl:when test="string-length($url) > 90">
            <xsl:value-of select="substring($url, 1, 50)"/>
            <xsl:param name="rest" select="substring($url, 51)"/>
            <xsl:value-of select="substring-before($rest, '/')"/>
            <xsl:text> /</xsl:text>
            <xsl:value-of select="substring-after($rest, '/')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$url"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$url"/>-->
      <!--  <xsl:value-of select="substring-before($url, '//')"/>
        <xsl:text>// </xsl:text>
        <xsl:call-template name="split-url">
          <xsl:with-param name="url2" select="substring-after($url, '//')"/>
        </xsl:call-template>-->
     <!-- </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

  <!--<xsl:template name="split-url">
    <xsl:choose>
      <xsl:when test="contains($url2, '/')">
      <xsl:param name="url2" select="''"/>
      <xsl:value-of select="substring-before($url2, '/')"/>
      <xsl:text> /</xsl:text>
      <xsl:call-template name="split-url">
        <xsl:with-param name="url2" select="substring-after($url2, '/')"/>
      </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$url2"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

    <!-- Shade screen -->
  <xsl:param name="shade.verbatim" select="1"/>

    <!-- How is rendered by default a variablelist -->
  <xsl:param name="variablelist.as.blocks" select="1"/>
  <xsl:param name="variablelist.max.termlength">32</xsl:param>

    <!-- Adding space before segmentedlist -->
  <xsl:template match="segmentedlist">
    <!--<xsl:variable name="presentation">
      <xsl:call-template name="pi-attribute">
        <xsl:with-param name="pis"
                        select="processing-instruction('dbfo')"/>
        <xsl:with-param name="attribute" select="'list-presentation'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$presentation = 'table'">
        <xsl:apply-templates select="." mode="seglist-table"/>
      </xsl:when>
      <xsl:when test="$presentation = 'list'">
        <fo:block space-before.minimum="0.4em" space-before.optimum="0.6em"
                space-before.maximum="0.8em">
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$segmentedlist.as.table != 0">
        <xsl:apply-templates select="." mode="seglist-table"/>
      </xsl:when>
      <xsl:otherwise>-->
        <fo:block space-before.minimum="0.4em" space-before.optimum="0.6em"
                space-before.maximum="0.8em">
          <xsl:apply-templates/>
        </fo:block>
      <!--</xsl:otherwise>
    </xsl:choose>-->
  </xsl:template>

    <!-- Presentation of literal tag -->
  <xsl:template match="literal">
    <fo:inline  font-weight="normal">
      <xsl:call-template name="inline.monoseq"/>
    </fo:inline>
  </xsl:template>

    <!-- Left alingnament for itemizedlist -->
  <xsl:template match="itemizedlist">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="label-width">
      <xsl:call-template name="dbfo-attribute">
        <xsl:with-param name="pis"
                        select="processing-instruction('dbfo')"/>
        <xsl:with-param name="attribute" select="'label-width'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="title">
      <xsl:apply-templates select="title" mode="list.title.mode"/>
    </xsl:if>
    <!-- Preserve order of PIs and comments -->
    <xsl:apply-templates
        select="*[not(self::listitem
                  or self::title
                  or self::titleabbrev)]
                |comment()[not(preceding-sibling::listitem)]
                |processing-instruction()[not(preceding-sibling::listitem)]"/>
    <fo:list-block id="{$id}" xsl:use-attribute-sets="list.block.spacing"
                  provisional-label-separation="0.2em" text-align="left">
      <xsl:attribute name="provisional-distance-between-starts">
        <xsl:choose>
          <xsl:when test="$label-width != ''">
            <xsl:value-of select="$label-width"/>
          </xsl:when>
          <xsl:otherwise>1.5em</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates
            select="listitem
                    |comment()[preceding-sibling::listitem]
                    |processing-instruction()[preceding-sibling::listitem]"/>
    </fo:list-block>
  </xsl:template>

    <!-- Addibg a bullet, and left alignament, for packages and paches list. -->

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
        <fo:block margin-left="1.4pc" text-align="left">
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

    <!-- Total packages size calculation -->
  <xsl:template match="returnvalue">
    <xsl:call-template name="calculation">
     <xsl:with-param name="scope" select="../../variablelist"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="calculation">
    <xsl:param name="scope"/>
    <xsl:param name="total">0</xsl:param>
    <xsl:param name="position">1</xsl:param>
    <xsl:variable name="tokens" select="count($scope/varlistentry)"/>
    <xsl:variable name="token" select="$scope/varlistentry[$position]/term/token"/>
    <xsl:variable name="size" select="substring-before($token,' KB')"/>
    <xsl:variable name="rawsize">
      <xsl:choose>
        <xsl:when test="contains($size,',')">
          <xsl:value-of select="concat(substring-before($size,','),substring-after($size,','))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$size"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$position &lt;= $tokens">
        <xsl:call-template name="calculation">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="position" select="$position +1"/>
          <xsl:with-param name="total" select="$total + $rawsize"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$total &lt; '1000'">
            <xsl:value-of select="$total"/>
            <xsl:text>  KB</xsl:text>
          </xsl:when>
          <xsl:when test="$total &gt; '1000' and $total &lt; '5000'">
            <xsl:value-of select="substring($total,1,1)"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="substring($total,2)"/>
            <xsl:text>  KB</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="round($total div 1024)"/>
            <xsl:text>  MB</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
