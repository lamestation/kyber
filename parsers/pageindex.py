import os, re
from bs4 import BeautifulSoup
import functions

import markdown

class Index:
    def __init__(self):
        self.pages = []
        self.fixlinks = False

    def add(self, item):
        self.pages.append(item)

    def clear(self):
        del self.pages[:]

    def makelist(self, item, depth, char='*'):
        node = {'name': item.a.text, 'depth': depth, 'url': item.a['href']}
        self.pages.append(node)

        for x in item.li.find_all('ul',recursive=False):
            self.makelist(x, depth+1, char)

    def configure(self, fixlinks=False):
        self.fixlinks = fixlinks


    def pagelist(self):
        return self.pages
            
    def markdown(self, mindepth=0, ordered=False):
        output = ""
        if ordered:
            char = '1.'
        else:
            char = '*'

        if self.fixlinks:
            h = '#'
        else:
            h = ''

        for i in self.pages:
            if i['depth'] >= mindepth:

                output += ' '*(i['depth']-mindepth)*4 + char + ' '
                if self.fixlinks:
                    filename = i['url']
                else:
                    filename = os.path.splitext(i['url'])[0]+'.md'
                output += link(i['name'], h+filename)
                output += '\n'

        return output

    def html(self, mindepth=0, ordered=False):
        return markdown.markdown(self.markdown(ordered=ordered, mindepth=mindepth))

def link(name, url):
    output = ""
    output += '['+name+']'
    output += '('+url+')'
    return output


def title_index(node):
    output = node.find('title').text
    output = re.sub('.*\((.*)\)','\g<1>', output)
    return output.lstrip()

def table_of_contents(node):
    functions.remove_tag(node,'div',id='footer')
    functions.remove_tag(node,'div','pageSection','main-content')
    functions.remove_tag(node,'div','pageSectionHeader')
    functions.remove_tag(node,'div',id='main-header')
    functions.remove_tag(node,'img')
    return node.find('div','pageSection').ul



def index():
    f = open('index.html').read()
    s = BeautifulSoup(f)
    toc = table_of_contents(s)
    output = ""
    output += "<h1>"+title_index(s)+"</h1>"

    index = Index()
    index.makelist(toc,0)
    print index.markdown(ordered=True, mindepth=2)
    print markdown.markdown(index.markdown(ordered=True, mindepth=2))

    return index

