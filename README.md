# Kyber
*A free and open-source documentation workflow for Confluence.*

Anyone who has ever used Confluence was probably super excited about all the output formats it supported... until you actually tried it. Well, Kyber is here to help.

Kyber is the publishing toolchain for LameStation's printed books and manuals. It facilitates authoring print-quality documents within Confluence. With Kyber, you can make documents that look like they came from O'Reilly, not your apartment.

### Features

* Doxygen-style source code markup rendered to Confluence pages
* LaTeX-driven PDF generation from Confluence pages
* Tables, images, and figures that look good and don't spill off the page
* Intelligent image placement based on image and paper size and dimensions
* Add captions, indexes, footnotes, no problem

### Goals

* Control the look and feel of your book without leaving your Confluence space
* More output formats: text files, man pages, docbook, etc.

While Kyber works with Confluence, it is **NOT** an add-on. We would like Kyber to work with other things in the future, not just Confluence, so we're keeping it separate.

### Installation

#### On Ubuntu

    # XHTML
    sudo apt-get install xsltproc libxml2-utils tidy libsaxonb-java

    # LaTeX
    sudo apt-get install texlive-latex-base texlive-latex-extra
    sudo apt-get install texlive-latex-recommended lacheck

## Usage

First, open up your Confluence installation and [export your space in HTML format](https://confluence.atlassian.com/display/DOC/Exporting+Confluence+Pages+and+Spaces+to+HTML).
If you don't have a Confluence installation, [get one, it's awesome!](https://www.atlassian.com/software/confluence)

Once you've downloaded your space export, download the project and browse to the project root. Run the kyber script to get you started. Simply
pass the export as a parameter.

    ./kyber path/to/confluence-space.html.zip

**BE CAREFUL**: Kyber currently does **zero** error checking on its input; make sure the zipfile is valid before running.

Watch as your space is rendered in glorious PDF.

### Troubleshooting

The conversion is done in three separate stages: document assembly, XSL conversion to LaTeX, LaTeX compilation to PDF.

Make sure you have make, Python, Saxon, and LaTeX installed.

### Bug Reporting

Please report all Kyber bugs to the [issue tracker](https://github.com/lamestation/kyber/issues).
