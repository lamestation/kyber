<?xml version="1.0"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="no" omit-xml-declaration="yes" />

    <!-- Normalize white space through document -->
    <!-- More info: http://stackoverflow.com/questions/5737862/xslt-output-formatting-removing-line-breaks-and-blank-output-lines-from-remove -->

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
    <xsl:template match="div[@class='pageSectionHeader']"></xsl:template>

    <xsl:template match="div[@id='footer']"></xsl:template>


    <xsl:template match="ul|li">
        <xsl:choose>
            <xsl:when test="name() = 'ul' and count(ancestor::ul) = 0">
                <xsl:apply-templates />
            </xsl:when>
            <xsl:when test="name() = 'li' and count(ancestor::ul) = 1">
                <xsl:apply-templates />
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="a">
        <xsl:choose>
            <xsl:when test="count(ancestor::ul) = 1"></xsl:when>
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
