LameStation Doc Tools
=====================

Here is a sample incantation of doctor-builder

    sudo apt-get install python-beautifulsoup fop xsltproc libxml2-utils tidy recode

Here's how to execute this script

    ./runit.sh

Here is the syntax for the demo provided by IBM

    fop -xml everything.html -xsl xhtml-to-xslfo.xsl -pdf everything.pdf
