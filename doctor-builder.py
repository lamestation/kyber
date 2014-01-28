#!/usr/bin/env python

import os, sys, subprocess
import argparse
import getpass
import xmlrpclib

import BeautifulSoup

# I can totally automate this all the way to Confluence
parser = argparse.ArgumentParser(description='Generate glorious PDF output from Confluence HTML export.')

parser.add_argument('-o','--output', nargs=1, metavar='OUTPUT', help='Output PDF file')
parser.add_argument('-s','--stylesheet', nargs=1, metavar='STYLESHEET', default="xhtml-to-xslfo.xsl",help='Custom XSL-FO stylesheet (optional)')
parser.add_argument('filename', nargs=1, metavar='FILE', help='Input HTML file') # This will need to be confluence zip file eventually

args = parser.parse_args()

filename = args.filename[0]
stylesheet = args.stylesheet
output = args.output[0]

def strip_tags(soup, invalid_tags):
    for match in soup.findAll(invalid_tags):
        match.replaceWithChildren()


    return soup


def remove_tag(soup,tag,attr,idee):
    for div in soup.findAll(tag,attr,id=idee):
        div.extract()

    return soup


def sanitize_html(value):

    soup = BeautifulSoup.BeautifulSoup(value)

    soup = remove_tag(soup,'div','page-metadata',None)
    soup = remove_tag(soup,'div',None,'footer-logo')
    soup = remove_tag(soup,'footer',None,'footer-logo')
    soup = remove_tag(soup,'div','pageSection',None)


    soup = strip_tags(soup, invalid_tags)


    # Delete any invalid tags
    for tag in soup.findAll(True):
        for attribute in ["class", "id", "name", "style"]:
            del tag[attribute]


    for tag in soup.findAll(True):
        if tag.name not in VALID_TAGS:
            tag.replaceWith('')
            tag.hidden = True

    empty_tags = soup.findAll(lambda tag: tag.name == True and not tag.contents and (tag.string is None or not tag.string.strip()))
    [empty_tag.extract() for empty_tag in empty_tags]


#    soup = remove_tag(soup,'div',None,None)
    

#    return soup.renderContents()
    return soup.prettify()

html = open(filename).read()

#print html

invalid_tags = ['div']
VALID_TAGS = ['p','a','img','ul','li','ol','br','h1','h2','h3','h4','h5',
                'strong','em','hr','body','head','html','title','pre','code','div']

#sanitize_html(html)
newhtml = sanitize_html(html)



#print newhtml
anotherfilename = filename+".tmp"
anotherfile = open(anotherfilename,'w')
anotherfile.write(newhtml)
anotherfile.close()

processargs = ["fop","-xml",anotherfilename,"-xsl",stylesheet,"-pdf",output]
subprocess.Popen(processargs)



#print strip_tags(html, invalid_tags)
