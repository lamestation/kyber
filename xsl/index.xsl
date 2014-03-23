<?xml version="1.0" ?>
<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">

    <xsl:output method="xml"/>


    <xsl:template match="div[@id='main-header']"></xsl:template>
    <xsl:template match="div[@id='main-content'][@class='pageSection']"></xsl:template>
    <xsl:template match="div[@class='pageSection group']"></xsl:template>
    <xsl:template match="div[@id='footer']"></xsl:template>
    <xsl:template match="div[@class='pageSectionHeader']"></xsl:template>
    <xsl:template match="meta"></xsl:template>
    <xsl:template match="META"></xsl:template>

    <xsl:template match="head">
        <head>
            <xsl:apply-templates />
        </head>
    </xsl:template>

    <xsl:template match="title">
        <title>
            <xsl:value-of select=".|text()"/>
        </title>
    </xsl:template>
    

    <xsl:template match="html">
        <html>
            <xsl:apply-templates />
        </html>
    </xsl:template>

    <xsl:template match="body">
        <body>
            <xsl:apply-templates />
        </body>
    </xsl:template>

    <xsl:template match="br"></xsl:template>

    <xsl:template match="ul">
        <book_section>
            <xsl:apply-templates select="*|text()"/>
        </book_section>
    </xsl:template>

    <xsl:template match="ul/li">
            <xsl:apply-templates select="*|text()"/>
    </xsl:template>

    <xsl:template match="ul/li/a">
        <xsl:variable name="pageLink" select="@href"/>
        <xsl:variable name="pageName" select="text()"/>
        <h1><xsl:value-of select="$pageName" /></h1>
        <xsl:copy-of select="document($pageLink)//div[@id='main-content']" />
    </xsl:template>
</xsl:transform>
