<?xml version="1.0"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="no" omit-xml-declaration="yes" />

    <!-- Normalize white space through document -->
    <!-- More info: http://stackoverflow.com/questions/5737862/xslt-output-formatting-removing-line-breaks-and-blank-output-lines-from-remove -->

    <xsl:preserve-space elements="div"/>

    <xsl:template match="*/text()[normalize-space()]">
        <xsl:value-of select="normalize-space()"/>
    </xsl:template>

    <xsl:template match="*/text()[not(normalize-space())]" />



    <!-- Character escaping -->
    <!--
    <xsl:template match=
        "contains('|code|',
        concat('|', name(), '|'))
        ">
        -->
    <xsl:template match="a">
        <xsl:value-of select="replace(text(),'&amp;','\\&amp;')"/>
    </xsl:template>

    <!-- Open up document -->

    <xsl:template match="html|head|body"><xsl:apply-templates /></xsl:template>
    <xsl:template match="title"></xsl:template>


    <!-- Tables -->

    <xsl:template match="div[@class='table-wrap']">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    <!--<xsl:template match="table"><table><xsl:apply-templates /></table></xsl:template> -->

    <xsl:template match="table[@class='confluenceTable']">
        <xsl:text>\begin{longtabu} to \textwidth { | </xsl:text>

        <!-- count number of columns -->
        <xsl:for-each select="for $i in 1 to count(./tbody[1]/tr[1]/th|./tbody[1]/tr[1]/td|./thead[1]/tr[1]/th|./thead[1]/tr[1]/td) return $i">
            <xsl:text>l | </xsl:text>
         </xsl:for-each>

        <xsl:text>}&#10;</xsl:text>
        <xsl:text>\hline&#10;</xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>\end{longtabu}&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="thead"><xsl:apply-templates /></xsl:template>
    <xsl:template match="tbody"><xsl:apply-templates /></xsl:template>


    <xsl:template match="tr">
        <xsl:apply-templates select="node()" />
        <xsl:text>\hline&#10;</xsl:text>
    </xsl:template>

    <!-- get rid of table images for now -->
    <!--<xsl:template match="td//img|th//img" />-->
    <xsl:template match="td/img|th/img">
        <xsl:choose>
            <xsl:when test="@width">
                <xsl:text> \vspace{0cm}\includegraphics[width = </xsl:text>
                <xsl:value-of select="number(@width) div 2" />
                <xsl:text>px]{</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>  \includegraphics[scale=0.5]{</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

        <!-- confluence adds parameters when image effects are used; strip them -->
        <xsl:choose>
            <xsl:when test="contains(@src,'?')">
                <xsl:value-of select="substring-before(@src,'?')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@src" /><!-- confluence adds parameters when image effects are used; strip them -->
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>}&#xa;</xsl:text>
    </xsl:template>



    <!-- center align divs -->
    <xsl:template match="div/@align"><xsl:apply-templates /></xsl:template>



    <!-- Table cells -->
    <xsl:template match="td/p|th/p">
        <xsl:apply-templates />
        <xsl:text> \\ </xsl:text>
    </xsl:template>
    <xsl:template match="td|th">

        <!-- Check if multicolumn -->
        <xsl:choose>
            <xsl:when test="@colspan and @colspan &gt; 1">
                <xsl:text>\multicolumn{</xsl:text>
                <xsl:value-of select="@colspan" />
                <xsl:text>}{l}{\scell{</xsl:text>
                <xsl:apply-templates select="node()" />
                <xsl:text>}} </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>\scell{</xsl:text>
                <xsl:apply-templates select="node()" />
                <xsl:text>} </xsl:text>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Check if last element in table -->
        <xsl:choose>
            <xsl:when test="not(following-sibling::td|following-sibling::th)">
                <xsl:text> \\&#10;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes"><![CDATA[ & ]]></xsl:text>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- Remove headers from tables -->
    <xsl:template match="th//h1|th//h2|th//h3|th//h4|th//h5">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    <xsl:template match="td//h1|td//h2|td//h3|td//h4|td//h5">
        <xsl:apply-templates select="node()" />
    </xsl:template>

    <!-- Basic -->

    <xsl:template match="p">
        <xsl:apply-templates select="node()" />
        <xsl:text>&#10;&#10;</xsl:text>
    </xsl:template>
    <xsl:template match="strong|b">
        <xsl:text> \textbf{</xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>} </xsl:text>
    </xsl:template>
    <xsl:template match="em|i">
        <xsl:text> \textit{</xsl:text>
        <xsl:apply-templates />
        <xsl:text>} </xsl:text>
    </xsl:template>
    <xsl:template match="sub">
        <xsl:text> \textsubscript{</xsl:text>
        <xsl:apply-templates />
        <xsl:text>} </xsl:text>
    </xsl:template>
    <xsl:template match="sup">
        <xsl:text>\textsuperscript{</xsl:text>
        <xsl:apply-templates />
        <xsl:text>} </xsl:text>
    </xsl:template>

    <!-- code with auto-indexing -->

    <xsl:template match="code">
        <xsl:text> \texttt{</xsl:text>
        <xsl:apply-templates />
        <xsl:text>} \index{</xsl:text>
        <xsl:apply-templates />
        <xsl:text>} </xsl:text>
    </xsl:template>

    <!-- Gliffy Diagrams -->

    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/tr/td/img[@class='gliffy-macro-image']">
        <xsl:text>  \includegraphics[width = 3.5in]{</xsl:text>

        <!-- confluence adds parameters when image effects are used; strip them -->
        <xsl:choose>
            <xsl:when test="contains(@src,'?')">
                <xsl:value-of select="substring-before(@src,'?')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@src" /><!-- confluence adds parameters when image effects are used; strip them -->
            </xsl:otherwise>
        </xsl:choose>

        <xsl:text>}&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/caption"></xsl:template>

    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/tr/td"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/tr"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr/td"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']"><xsl:apply-templates /></xsl:template>


    <!-- Images -->

    <xsl:template match="p//img">
        <xsl:choose>
            <xsl:when test="@width">
                <xsl:text>  \includegraphics[width = </xsl:text>
                <xsl:value-of select="number(@width) div 2" />
                <xsl:text>px]{</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>  \includegraphics[scale = 0.5]{</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

        <!-- confluence adds parameters when image effects are used; strip them -->
        <xsl:choose>
            <xsl:when test="contains(@src,'?')">
                <xsl:value-of select="substring-before(@src,'?')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@src" /><!-- confluence adds parameters when image effects are used; strip them -->
            </xsl:otherwise>
        </xsl:choose>

        <xsl:text>}&#xa;</xsl:text>
    </xsl:template>



    <!-- Lists -->

    <xsl:template match="ol">
        <xsl:text>\begin{enumerate}</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates />
        <xsl:text>\end{enumerate}</xsl:text>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="ul">
        <xsl:text>\begin{itemize}</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates />
        <xsl:text>\end{itemize}</xsl:text>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="li">
        <xsl:text>  \item </xsl:text>
        <xsl:apply-templates />
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>



    <!-- Stupid divs and other dumb content -->

    <xsl:template match="map"></xsl:template>

    <xsl:template match="div[@id='main-content']">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    <xsl:template match="div[@class='wiki-content group']">
        <xsl:apply-templates select="node()" />
    </xsl:template>

    <xsl:template match="div[@class='columnMacro' or @class='sectionMacro' or @class='sectionMacroRow' or @class='sectionColumnWrapper']">
        <xsl:apply-templates select="node()" />
    </xsl:template>

    <xsl:template match="div[@class='contentLayout2']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[contains(@class,'columnLayout')]"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[@class='cell aside']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[@class='innerCell']"><xsl:apply-templates /></xsl:template>

    <!-- TOC -->

    <!-- Haven't figured this one out yet -->

    <xsl:template match="div[contains(@class,'toc-macro')]"></xsl:template>
    <xsl:template match="div[contains(@class,'cell')]"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[@class='plugin_pagetree']"></xsl:template>

    <!-- LaTeX Features -->
    <xsl:template match="div[@class='figure']">
        <xsl:text>&#xa;\begin{figure}[!htb]&#xa;</xsl:text>
        <xsl:text>\centering&#xa;</xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>\end{figure}&#xa;</xsl:text>
    </xsl:template>

    <!-- Block quotes -->

    <xsl:template match="blockquote">
        <xsl:text>&#xa;\begin{quote}</xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>\end{quote}</xsl:text>
        <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:template>

    <!-- Code boxes -->

    <xsl:template match="span[@class='expand-control-text']"></xsl:template>

    <xsl:template match="div[@class='code panel pdl']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[contains(@class,'codeHeader')]"><xsl:apply-templates /></xsl:template>

    <xsl:template match="div[contains(@class,'codeContent')]">
        <xsl:call-template name="codebox">
            <xsl:with-param name="style" select="plain"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="div[contains(@class,'codeContent')]/pre"><xsl:apply-templates /></xsl:template>

    <!-- Code Boxes -->

    <xsl:template name="codebox">
        <xsl:param name="style"/>
        <xsl:text>\lstset{style=</xsl:text>
        <xsl:value-of select="$style" />
        <xsl:text>}&#xa;\begin{lstlisting}</xsl:text>
        <xsl:choose>
            <xsl:when test="pre">
                <xsl:copy-of select="pre/text()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="node()" />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>\end{lstlisting}&#xa;&#xa;</xsl:text>
    </xsl:template>


    <xsl:template match="pre[@class='spin']|pre[@class='pasm']">
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="contains(@class,'spin')">spin</xsl:when>
                <xsl:when test="contains(@class,'pasm')">pasm</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="codebox">
            <xsl:with-param name="style" select="$type"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="pre/pre"><xsl:apply-templates /></xsl:template>

    <xsl:template match="pre[@class='latex']">
        <xsl:text>\[ </xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text> \]&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="pre[@class='latex']/p">
        <xsl:apply-templates select="node()" />
    </xsl:template>



    <!-- Highlight Boxes -->

    <xsl:template name="highlightbox">
        <xsl:param name="style"/>
        <xsl:text>\begin{minipage}{\textwidth}\begin{mdframed}[style=</xsl:text>
        <xsl:value-of select="$style" />
        <xsl:text>]&#xa;</xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>&#xa;\end{mdframed}\end{minipage}&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="div[contains(@class,'information-macro')]">
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="contains(@class,'problem')">problem</xsl:when>
                <xsl:when test="contains(@class,'warning')">warning</xsl:when>
                <xsl:when test="contains(@class,'hint')">hint</xsl:when>
                <xsl:when test="contains(@class,'success')">success</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:call-template name="highlightbox">
            <xsl:with-param name="style" select="$type"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="div[contains(@class,'information-macro')]/span"></xsl:template>
    <xsl:template match="div[contains(@class,'information-macro')]/div"><xsl:apply-templates /></xsl:template>


    <xsl:template match="div[@class='panel']">
        <xsl:call-template name="highlightbox">
            <xsl:with-param name="style" select="panel"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="div[@class='panelContent']"><xsl:apply-templates /></xsl:template>


    <!-- Headers -->

    <xsl:template match="booksection"><xsl:apply-templates /></xsl:template>

    <xsl:template match="h0|h1|h2|h3|h4|h5">
        <xsl:variable name="length" select="string-length(name())" />
        <xsl:variable name="headlevel" select="number(substring(name(),$length))" />
        <xsl:variable name="booklevel" select="count(ancestor::booksection)-1" />
        <xsl:variable name="level" select="$headlevel + $booklevel" />

        <xsl:if test="$booklevel > 0">
            <xsl:choose>
                <xsl:when test="$level = 0">
                    <xsl:text>&#xa;\newpage
\AddToShipoutPicture*{\ChapterBackgroundPic}
\part{</xsl:text>
                    <xsl:apply-templates select="node()" />
                    <xsl:text>}&#xa;\newpage&#xa;&#xa;</xsl:text>
                </xsl:when>

                <xsl:when test="$level = 1">
                    <xsl:text>&#xa;\newpage
\AddToShipoutPicture*{\ChapterBackgroundPic}
\chapter{</xsl:text>
                    <xsl:apply-templates select="node()" />
                    <xsl:text>}&#xa;\newpage&#xa;&#xa;</xsl:text>
                </xsl:when>

                <xsl:when test="$level = 2">
                    <xsl:text>&#xa;\section{</xsl:text>
                    <xsl:apply-templates select="node()" />
                    <xsl:text>}&#xa;&#xa;</xsl:text>
                </xsl:when>

                <xsl:when test="$level = 3">
                    <xsl:text>&#xa;\subsection{</xsl:text>
                    <xsl:apply-templates select="node()" />
                    <xsl:text>}&#xa;&#xa;</xsl:text>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:text>&#xa;\subsubsection{</xsl:text>
                    <xsl:apply-templates select="node()" />
                    <xsl:text>}&#xa;&#xa;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- Miscellaneous stuff -->

    <xsl:template match="span">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    <xsl:template match="div[not(@*)]">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    <xsl:template match="div[not(@*)]">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    <xsl:template match="br"></xsl:template>
    <xsl:template match="style"></xsl:template>

    <!-- If nothing else, just copy it -->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>
