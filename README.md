Kyber
=====

Kyber is a free and open-source documentation workflow for Confluence.

Kyber is being developed by LameStation LLC as the publishing toolchain for LameStation books and manuals.
It facilitates authoring print-quality documents within Confluence.

With Kyber, your work looks like it came from O'Reilly, not your apartment. Sell that to your manager!

But what does it do?

* Doxygen-style source code markup rendered to Confluence pages
* LaTeX-driven PDF generation from Confluence pages
* Tables, images, and figures that look good and don't spill off the page
* Intelligent image placement based on image and paper size and dimensions
* Add captions, indexes, footnotes, no problem

Here's what we'd like to add:

* Control the look and feel of your book without leaving your Confluence space
* More output formats: text files, man pages, docbook, etc.

While Kyber works with Confluence, it is **NOT** an add-on. We would like Kyber to work with other things in the future, not just Confluence, so we're keeping it separate.

## Installation

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

## Troubleshooting

The conversion is done in three separate stages: document assembly, XSL conversion to LaTeX, LaTeX compilation to PDF.

Make sure you have make, Python, Saxon, and LaTeX installed.

## Things To Be Done

 * Add subfigure support (multiple images with top-level caption)
 * Make latex prefer to line break at white space
 * Make boxes prefer to not line break at all
 * Fix table support to adjust for varying column widths
 * Create image rotating algorithm and define expectations for image size
 * Figure out scheme for adding glossary
 * Add good formatting for highlight boxes
 * Verify handling of special characters in all cases
 * Create test confluence space that will thoroughly vet possible formatting
 * Scheme up decent interface for customizing look/feel
 * Add automatic header demotion
 * Need a good way to escape _, #, $, and &.
