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

Like the mountain pass that connected much of the ancient world, Kyber is
the link between your project and your wiki, keeping them connected and
mutually up-to-date.

## Installation

On Ubuntu, installation is easy. Install any needed dependencies first, probably:

    sudo apt-get install xsltproc libxml2-utils tidy texlive-latex-base texlive-latex-extra texlive-latex-recommended lacheck

## Usage

The top-level bash script should get you started. To run, pass a Cofluence
HTML export as a parameter.

    ./runit.sh PATH/TO/ZIPFILE.html.zip

Watch as your space is rendered in glorious PDF.

## To Do

 * Figure out how figures, need to strip out extra file garbage like before.
 * Need to format the info boxes properly.
 * Need to ensure images always fit within page
 * Need to change verbatim output of pandoc to listing
 * Need to create user macros to allow formatting of cool things.
 * Fix table output
 * Fix graphics inclusion (wtf does confluence do)
 * Properly escape ampersand then convert it back to real character before running to latex
 * Need to make sure no divs or brs get through
 * Need to find away to clean up all the white space being created
 * Need to properly concatenate subsubsection so that newlines are not added.
 * Need to migrate to makefile so that there is strict error checking on build
