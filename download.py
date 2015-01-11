#!/usr/bin/env python

import os, sys

import argparse
import getpass

import xmlrpclib
import requests

import zipfile

parser = argparse.ArgumentParser(description='Export a Confluence Space')

parser.add_argument('-u','--url', nargs=1, metavar='URL', required=True, help='Confluence XMLRPC server URL')
parser.add_argument('-s','--space', nargs=1, metavar='SPACE', required=True, help='Destination Confluence space')

args = parser.parse_args()

proxy = xmlrpclib.ServerProxy(args.url[0]+"/rpc/xmlrpc")

user = raw_input("Enter Confluence username: ")
passwd = getpass.getpass("Enter Confluence password: ")
token = proxy.confluence2.login(user,passwd)

space = proxy.confluence2.getSpace(token, args.space[0]) 
print "Exporting space: %s Key: %s" % (space['name'], space['key'])

spaceurl = proxy.confluence2.exportSpace(token,args.space[0],"TYPE_HTML")

def download_file(url):
    local_filename = url.split('/')[-1]

    with open(local_filename, 'wb') as f:
        print "Downloading from: %s" % (url)
        r = requests.get(url, auth=(user, passwd), stream=True)
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

r = download_file(spaceurl)
print r

z = zipfile.ZipFile(r,'r')

print "Verifying %s" % (r)
z.testzip()

proxy.confluence2.logout(token)
