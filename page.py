#!/usr/bin/env python

# Fix stupid problems with confluence output

import sys, re

f = open(sys.argv[1]).read()
g = re.sub("(<img[^>]*?[^//])>","\g<1>/>",f,flags=re.S)
f = open(sys.argv[1],'w')
f.write(g)
f.close()
