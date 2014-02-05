Kyber
=====

Kyber is a free, open-source documentation workflow for
Confluence that allows unlimited customization of the final output.

Named for the infamous mountain pass of ancient lore, Kyber provides
the link that allows data to move seamlessly between your project
and wiki environment.

Designed initially to address the needs of the LameStation
project, Kyber has grown into a full-fledged documentation solution.

Features supported:

* Doxygen-style source code markup rendered as Confluence pages
* Fully customizable PDF generation from Confluence pages

## Installation

On Ubuntu, the prerequisites needed are as follows:

    sudo apt-get install python-beautifulsoup fop xsltproc libxml2-utils tidy

## Usage

The top-level bash script should get you started. To run, pass a Cofluence
HTML export as a parameter.

    ./runit.sh PATH/TO/ZIPFILE.html.zip

Watch as your space is rendered in glorious PDF.
