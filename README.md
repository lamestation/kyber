LameStation Doc Tools
=====================

Here is a sample incantation of doctor-builder

<pre>
sudo apt-get install python-beautifulsoup fop xsltproc libxml2-utils tidy recode
</pre>



<pre>
./doctor-builder.py -o blah.pdf Drawing-Text_9011324.html 
</pre>

Here is the syntax for the demo provided by IBM

<pre>
fop -xml everything.html -xsl xhtml-to-xslfo.xsl -pdf everything.pdf
</pre>
