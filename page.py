#!/usr/bin/env python

# Fix stupid problems with confluence output

import sys, re

f = open(sys.argv[1]).read()

def add_closing_tag(tag,string):
    return re.sub("(<"+tag+"[^>]*?[^//])>","\g<1>/>",string,flags=re.S)

g = add_closing_tag('img',f)
g = add_closing_tag('input',g)
f = open(sys.argv[1],'w')
f.write(g)
f.close()
