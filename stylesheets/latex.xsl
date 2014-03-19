<?xml version="1.0"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="no" omit-xml-declaration="yes" />

    <xsl:template match="html"><xsl:apply-templates /></xsl:template>
    <xsl:template match="head"><xsl:apply-templates /></xsl:template>
    <xsl:template match="title"><xsl:apply-templates /></xsl:template>
    <xsl:template match="body"><xsl:apply-templates /></xsl:template>


    <!-- tables -->
    <xsl:template match="div[@class='table-wrap']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table"><table><xsl:apply-templates /></table></xsl:template>
    <xsl:template match="tr"><tr><xsl:apply-templates /></tr></xsl:template>
    <xsl:template match="th"><th><xsl:apply-templates /></th></xsl:template>
    <xsl:template match="td"><xsl:apply-templates /><xsl:text disable-output-escaping="yes"><![CDATA[ & ]]></xsl:text></xsl:template>


    <!-- basic -->
    <xsl:template match="p">
        <xsl:apply-templates /><xsl:text>&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="a">
        <xsl:apply-templates />
    </xsl:template>



    <xsl:template match="strong|b">
        <xsl:text>\textbf{</xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="em|i">
        <xsl:text>\textit{</xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
    </xsl:template>


    <!-- images -->
    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/tr/td/img[@class='gliffy-macro-image']">
        <xsl:text>\begin{figure}[H]
            \centering
            \includegraphics[scale=0.3]{</xsl:text>
        <xsl:value-of select="@src" /><xsl:text>}\\
            \end{figure}
        </xsl:text>
    </xsl:template>

    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/caption"></xsl:template>

    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/tr/td"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/tr"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr/td"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']"><xsl:apply-templates /></xsl:template>


    <xsl:template match="img">
        <xsl:text>\begin{figure}[H]
            \centering
            \includegraphics[width = 2.5in]{</xsl:text>
        <xsl:value-of select="@src" /><xsl:text>}\\
            \end{figure}
        </xsl:text>
    </xsl:template>



    <!-- lists -->
    <xsl:template match="ol">
        <xsl:text>\begin{enumerate}</xsl:text>
        <xsl:apply-templates />
        <xsl:text>\end{enumerate}</xsl:text>
    </xsl:template>

    <xsl:template match="ul">
        <xsl:text>\begin{itemize}</xsl:text>
        <xsl:apply-templates />
        <xsl:text>\end{itemize}</xsl:text>
    </xsl:template>

    <xsl:template match="li">\item <xsl:apply-templates /></xsl:template>



    <!-- Stupid divs and other dumb content -->
    <xsl:template match="map"></xsl:template>

    <xsl:template match="div[@id='main-content' or @class='wiki-content group']">
        <xsl:apply-templates />
    </xsl:template>


    <!-- Friendly box messages -->
    <!--    <xsl:template match="div"><xsl:apply-templates /></xsl:template> -->
    <xsl:template match="div[@class='aui-message problem shadowed information-macro']">
        <xsl:text>\begin{bclogo}[couleur=bgblue, arrondi =0, logo=\bcbombe, barre=none,noborder=true]{}</xsl:text>
        <xsl:text>\itshape </xsl:text><xsl:apply-templates />
        <xsl:text>\end{bclogo}</xsl:text>
    </xsl:template>
    <xsl:template match="div[@class='aui-message problem shadowed information-macro']/span"></xsl:template>
    <xsl:template match="div[@class='aui-message problem shadowed information-macro']/div"><xsl:apply-templates /></xsl:template>

    <xsl:template match="div[@class='aui-message warning shadowed information-macro']">
        <xsl:text>\begin{bclogo}[couleur=bgblue, arrondi =0, logo=\bcbombe, barre=none,noborder=true]{}</xsl:text>
        <xsl:text>\itshape </xsl:text><xsl:apply-templates />
        <xsl:text>\end{bclogo}</xsl:text>
    </xsl:template>
    <xsl:template match="div[@class='aui-message warning shadowed information-macro']/span"></xsl:template>
    <xsl:template match="div[@class='aui-message warning shadowed information-macro']/div"><xsl:apply-templates /></xsl:template>

    <xsl:template match="div[@class='aui-message hint shadowed information-macro']">
        <xsl:text>\begin{bclogo}[couleur=bgblue, arrondi =0, logo=\bcbombe, barre=none,noborder=true]{}</xsl:text>
        <xsl:text>\itshape</xsl:text><xsl:apply-templates />
        <xsl:text>\end{bclogo}</xsl:text>
    </xsl:template>
    <xsl:template match="div[@class='aui-message hint shadowed information-macro']/span"></xsl:template>
    <xsl:template match="div[@class='aui-message hint shadowed information-macro']/div"><xsl:apply-templates /></xsl:template>

    <xsl:template match="div[@class='aui-message success shadowed information-macro']">
        <xsl:text>\begin{bclogo}[couleur=bgblue, arrondi =0, logo=\bcbombe, barre=none,noborder=true]{}</xsl:text>
        <xsl:text>\itshape</xsl:text><xsl:apply-templates />
        <xsl:text>\end{bclogo}</xsl:text>
    </xsl:template>
    <xsl:template match="div[@class='aui-message success shadowed information-macro']/span"></xsl:template>
    <xsl:template match="div[@class='aui-message success shadowed information-macro']/div"><xsl:apply-templates /></xsl:template>



    <xsl:template match="book_section"><xsl:apply-templates /></xsl:template>

    <xsl:template match="h1">
        <xsl:choose>
            <xsl:when test="count(ancestor::book_section) = 1">
                <xsl:text>\AddToShipoutPicture*{\ChapterBackgroundPic}
                \clearpage
                \part{</xsl:text><xsl:value-of select="text()"/><xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::book_section) = 2">
                <xsl:text>\chapter{</xsl:text><xsl:value-of select="text()"/><xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::book_section) = 3">
                <xsl:text>\section{</xsl:text><xsl:value-of select="text()"/><xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::book_section) = 4">
                <xsl:text>\subsection{</xsl:text><xsl:value-of select="text()"/><xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                EVERYTHING SUCKS<xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="h2|h3|h4|h5">
        \subsubsection{<xsl:apply-templates />}
    </xsl:template>


    <xsl:template match="span"><xsl:apply-templates /></xsl:template>


    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
