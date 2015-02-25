Kyber - a free publishing tool for Confluence
=============================================

Kyber is a publishing tool that allows you to get the most out of your
Confluence installation. The export tools built into Confluence can only
minimally be customized.

Kyber is written in Python 2.7.

Installation
------------

Kyber depends on Beautiful Soup 4, Python Markdown, and WeasyPrint. You
can get the first two from **apt**, but WeasyPrint will require ``pip``.
Then again, you can just get them all from ``pip``.

::

    sudo apt-get install python-bs4 python-markdown
    sudo pip install weasyprint

A Confluence toolchain will also require Confluence, so you should
probably get one if you don't already have one.

Usage
-----

Kyber uses Confluence's XML-RPC API, so exporting the space manually is
not necessary.

You will need export permission on the space which you plan to extract.
Pass the space key with ``-s`` and the URL of the Confluence wiki with
``-u``; Kyber will export and download the target space for you.

::

    kyber -s LTM -u https://lamestation.atlassian.net/wiki/

Output will be generated in the ``build/`` directory.

If the space key is given without a URL, the last download of that space
will be re-run.

::

    kyber -s LTM

The space key *must* be passed for Kyber to run.

Output Formats
--------------

Kyber can be used to generate PDF and HTML output. Since Confluence
already generates HTML output, Kyber's role in this is more about style
and presentation, as the output can be customized a great deal more
using Kyber than the built-in space exporter.

Multi-page HTML
~~~~~~~~~~~~~~~

By default, Kyber produces a multi-page HTML document, largely a
repackaged version of Confluence's built-in export.

This HTML output will appear in:

::

    build/<SPACE>/<SPACE>/

Single-page hTML
~~~~~~~~~~~~~~~~

The ``--single-page`` parameter to generate a single file document at:

::

    build/<SPACE>/<SPACE>/_output_.md

PDF
~~~

The ``--pdf`` parameter will generate a styled PDF using WeasyPrint at:

::

    build/<SPACE>/<SPACE>/_output_.pdf

**Kyber is in development and some things aren't working right or don't
work at all. Please help improve Kyber!**

Bug Reporting
~~~~~~~~~~~~~

Report any Kyber bugs to the `issue
tracker <https://github.com/lamestation/kyber/issues>`__.

License
-------

Copyright (c) 2015 LameStation LLC. This software is released under a
GPLv3 license.
