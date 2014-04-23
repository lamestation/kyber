<?xml version="1.0"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="no" omit-xml-declaration="yes" />

    <xsl:template match="html"><xsl:apply-templates /></xsl:template>
    <xsl:template match="head"><xsl:apply-templates /></xsl:template>
    <xsl:template match="title"></xsl:template>
    <xsl:template match="link"></xsl:template>

    <xsl:template match="body"><xsl:apply-templates /></xsl:template>

    <xsl:template match="div[@id='page']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[@id='main'][@class='aui-page-panel']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[@id='main-header']"></xsl:template>
    <xsl:template match="div[@id='content']"><xsl:apply-templates /></xsl:template>

    <xsl:template match="div[@class='pageSection']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table"></xsl:template>
    <xsl:template match="br"></xsl:template>
    <xsl:template match="img"></xsl:template>
    <xsl:template match="div[@class='pageSectionHeader']"></xsl:template>

    <xsl:template match="div[@id='footer']"></xsl:template>


    <xsl:template match="ul|li">
        <xsl:choose>

            <!-- First level -->

            <xsl:when test="name() = 'ul' and count(ancestor::ul) = 0">
                <div class="accordion" id="accordion">
                    <xsl:apply-templates />
                </div>
            </xsl:when>

            <xsl:when test="name() = 'li' and count(ancestor::ul) = 1">
                <xsl:apply-templates />
            </xsl:when>

            <!-- Second level -->

            <xsl:when test="name() = 'ul' and count(ancestor::ul) = 1">
                <div class="accordion-group">
                    <xsl:apply-templates />
                </div>
            </xsl:when>

            <xsl:when test="name() = 'li' and count(ancestor::ul) = 2">
                <xsl:for-each select="a">
                    <div class="accordion-heading">
                        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion">
                            <xsl:attribute name="href">#collapse<xsl:value-of select="count(preceding::li)"/></xsl:attribute>
                            <xsl:apply-templates />
                        </a>
                    </div>
                </xsl:for-each>

                <div class="accordion-body collapse">
                    <xsl:attribute name="id">collapse<xsl:value-of select="count(preceding::li)"/></xsl:attribute>
                    <div class="accordion-inner">
                        <ul>
                            <xsl:for-each select="ul">
                                <xsl:apply-templates />
                            </xsl:for-each>
                        </ul>
                    </div>
                </div>
            </xsl:when>

            <!--            <xsl:when test="name() = 'li' and count(ancestor::ul) = 3">
                <xsl:apply-templates />
            </xsl:when>
            -->

            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="a">
        <xsl:choose>
            <xsl:when test="count(ancestor::ul) = 1"></xsl:when>
            <xsl:when test="count(ancestor::ul) = 2">
                <div class="accordion-heading">
                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                        <xsl:attribute name="href">
                            <xsl:value-of select="@href" />
                        </xsl:attribute>
                        <xsl:apply-templates />
                    </a>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
