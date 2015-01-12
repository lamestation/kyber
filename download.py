#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, re

import argparse
import getpass

import xmlrpclib
import requests
import glob

import zipfile

from HTMLParser import HTMLParser

import pypandoc

home = os.path.dirname(os.path.abspath(__file__))

parser = argparse.ArgumentParser(description='Export a Confluence Space')

parser.add_argument('-u','--url', nargs=1, metavar='URL', help='Download space first from server URL')
parser.add_argument('-s','--space', nargs=1, metavar='SPACE', required=True, help='Space key')

args = parser.parse_args()

def create_dir(path):
    if not os.path.exists(path):
            os.makedirs(path)


def download_file(url, auth):
    local_filename = url.split('/')[-1]

    with open(local_filename, 'wb') as f:
        print "Downloading from: %s" % (url)
        r = requests.get(url, auth=auth, stream=True)
        total_length = r.headers.get('content-length')

        if total_length is None:
            f.write(r.content)
        else:
            dl = 0
            total_length = int(total_length)
            for data in r.iter_content(chunk_size=4096):
                dl += len(data)
                f.write(data)
                done = int(50 * dl / total_length)
                sys.stdout.write("\r[%s%s]" % ('=' * done, ' ' * (50 - done)) )
                sys.stdout.flush()

    sys.stdout.write(" -> %s\n" % (local_filename) )
    return local_filename


def export_space(url, key):
    proxy = xmlrpclib.ServerProxy(url+"/rpc/xmlrpc")
    
    user = raw_input("Enter Confluence username: ")
    passwd = getpass.getpass("Enter Confluence password: ")
    auth = (user, passwd)

    token = proxy.confluence2.login(user,passwd)
    
    space = proxy.confluence2.getSpace(token, key) 
    print "Exporting space: %s Key: %s" % (space['name'], space['key'])
    spaceurl = proxy.confluence2.exportSpace(token,key,"TYPE_HTML")

    proxy.confluence2.logout(token)

    return download_file(spaceurl, auth)

def unzip_space(filename):

    print "Verifying %s" % (filename)
    z = zipfile.ZipFile(filename,'r')
    z.testzip()
    z.extractall()
    z.close()

def write_last(text):
    f = open('last','w')
    f.write(text)
    f.close()

def read_last():
    f = open('last','r')
    text = f.read()
    f.close()
    return text

create_dir("build")
os.chdir("build")
create_dir(args.space[0])
os.chdir(args.space[0])

if args.url:
    r = export_space(args.url[0], args.space[0])
    write_last(r)
    unzip_space(r)

last = read_last()
create_dir(args.space[0])
os.chdir(args.space[0])

import lxml.etree as ET
from bs4 import BeautifulSoup


def remove_tag(root, tag, class_=None, id=None):
    if class_ == None and not id == None:
        res = root.find_all(tag, id=id)
    if not class_ == None and id == None:
        res = root.find_all(tag, class_=class_)
    if not class_ == None and not id == None:
        res = root.find_all(tag, class_=class_, id=id)
    if class_ == None and id == None:
        res = root.find_all(tag)

    for h in res:
        h.decompose()


def build_toc(node):
    remove_tag(node,'div',id='footer')
    remove_tag(node,'div','pageSection','main-content')
    remove_tag(node,'div','pageSectionHeader')
    remove_tag(node,'div',id='main-header')
    remove_tag(node,'img')
    return node.find('div','pageSection').ul

def header(tag, level):
    tag.attrs = {}
    #return '\n#'*(level)+' '+tag.text+'\n'


def link(tag):
    output = ""
    output += '['+tag.text+']'
    output += '('+tag['href']+')'
    return output

def title_index(node):
    output = node.find('title').text
    output = re.sub('.*\((.*)\)','\g<1>', output)
    return output.lstrip()

def title_page(node):
    output = node.find('title').text.split(':')[1:]
    output = ':'.join(output).lstrip()
    return output


def makelist(item, depth, char='*'):
    output = ""
    if depth > 0: 
        output += "<ul>"
        output += "<li>"
#        output += ' '*(depth-1)*2 + ' '+char+' '
#        output += link(item.a)
        output += item.a.prettify()
        output += '\n'

    for x in item.li.find_all('ul',recursive=False):
        output += makelist(x, depth+1, char)

    if depth > 0:
        output += "</li>"
        output += "</ul>"

    return output

def image(tag):
    src = tag.attrs['src']
    if 'width' in tag.attrs:
        tag.attrs = {'width':tag.attrs['width']}
    else:
        tag.attrs = {}

    tag.attrs['src'] = src

def gliffy_diagram(tag):
    pass

def build_index():
    f = open('index.html').read()
    s = BeautifulSoup(f)
    toc = build_toc(s)
    output = ""
    output += "<h1>"+title_index(s)+"</h1>"
    
    for l in s.find_all('a'):
        l['href'] = os.path.splitext(l['href'])[0]+'.md'

    output += makelist(toc,0)

    return output

def build_page(node):
    remove_tag(node,'div',id='footer')
    remove_tag(node,'head')
    node = node.find('div','wiki-content group',id='main-content')

    [x.unwrap() for x in node.find_all('span','confluence-embedded-file-wrapper')]

    [image(x) for x in node.find_all('img')]

    #[header(x,1) for x in node.find_all('h1')]
    #[header(x,2) for x in node.find_all('h2')]
    #[header(x,3) for x in node.find_all('h3')]
    #[header(x,4) for x in node.find_all('h4')]
    #[header(x,5) for x in node.find_all('h5')]
    #[header(x,6) for x in node.find_all('h6')]
    return node


g = open('index.md','w')
g.write(build_index())
g.close()

for filename in glob.glob('*.html'):
    if not filename == 'index.html':
        f = open(filename).read()
        s = BeautifulSoup(f)

        title = '<h1>'+title_page(s)+'</h1>\n'
        output = build_page(s).prettify()
#        output = pypandoc.convert(output,'markdown', format='html')
        output = title + output

        newname = os.path.splitext(filename)[0]

        f = open(newname+'.md','w')
        f.write(output.encode('utf-8'))
        f.close()
        #print output.encode('utf-8')

