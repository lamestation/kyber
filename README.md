# Welcome To Kyber

Anyone who has ever used Confluence was probably super excited about all the output formats it supported... until you actually tried it. Well, Kyber is here to help.

Kyber is the publishing toolchain for LameStation's printed books and manuals. It facilitates authoring print-quality documents within Confluence. With Kyber, you can make documents that look like they came from O'Reilly, not your apartment.

"But Confluence already does HTML and PDF export!" you may say. Well, not like this; not with this level of granularity and control over the output.

## Features

* Doxygen-style source code markup rendered to Confluence pages
* LaTeX-driven PDF generation from Confluence pages
* Tables, images, and figures that look good and don't spill off the page
* Intelligent image placement based on image and paper size and dimensions
* Add captions, indexes, footnotes, no problem

## Installation

### On Ubuntu

    sudo apt-get install xsltproc libxml2-utils tidy libsaxonb-java
    sudo apt-get install texlive-latex-base texlive-latex-extra texlive-fonts-extra
    sudo apt-get install texlive-latex-recommended

## Usage

First, open up your Confluence installation and [export your space in HTML format](https://confluence.atlassian.com/display/DOC/Exporting+Confluence+Pages+and+Spaces+to+HTML).
If you don't have a Confluence installation, [get one, it's awesome!](https://www.atlassian.com/software/confluence)

Once you've downloaded your space export, download the project and browse to the project root. Run the kyber script to get you started. Simply
pass the export as a parameter.

Kyber currently supports PDF and HTML outputs.

Generate a PDF output of your space. Watch as your space is rendered in glorious PDF:

    make pdf SPACE=yourspace.zip

Generate a fancy HTML manual from your space:

    make website SPACE=manual.zip

### Bug Reporting

Please report all Kyber bugs to the [issue tracker](https://github.com/lamestation/kyber/issues).

## Author

This tool was originally developed for in-house use at [LameStation](htp://www.lamestation.com)  by Brett Weir.
