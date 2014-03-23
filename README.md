Kyber
=====

Kyber is a free and open-source documentation workflow for
Confluence.

But what does it do?

* Doxygen-style source code markup rendered to Confluence pages
* LaTeX-driven PDF generation from Confluence pages; no expensive enterprise solution
* Propeller Spin and PASM language definitions (finally!)
* Customizable with the full power of LaTeX
* Full UTF-8 and internationization support throughout
* Intelligent image scaling built into the environment
* Uses the Saxon parser for full XSLT 2.0 support
* Use make for strict error checking on build

Like the mountain pass that connected much of the ancient world, Kyber is
the link between your project and your wiki, keeping them connected and
mutually up-to-date.

*Note: There is some support for XSL-FO but this is being deprecated in favor of LaTeX.*

## Installation

On Ubuntu, installation is easy. Install any needed dependencies first, probably:

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

**BE CAREFUL**: Kyber currently does **zero** error checking on its input; be mindful of what you're doing.
Watch as your space is rendered in glorious PDF.

## Troubleshooting

The conversion is done in three separate stages: document assembly, XSL conversion to LaTeX, LaTeX compilation to PDF.

Make sure you have Python, xsltproc, Saxon, and LaTeX installed.

## To Do

 * Fix graphics inclusion (wtf does confluence do)
 * Add support for intelligent image handling to XSL stylesheet
 * Add subfigure support (multiple images with top-level caption)
 * Add table support
 * Add link support
 * Make latex prefer to line break at white space
 * Make boxes prefer to not line break at all
