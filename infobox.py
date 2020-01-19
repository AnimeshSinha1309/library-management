#!/usr/bin/env python3
# Anchor extraction from HTML document
from bs4 import BeautifulSoup
from urllib.request import urlopen


def get_summary(name):
    with urlopen('https://en.wikipedia.org/wiki/'+name) as response:
        print(response.code)
        # if response.code != 200:
        #     return None
        soup = BeautifulSoup(response, 'html.parser')
        # for anchor in soup.find_all('a'):
        #     print(anchor.get('href', '/'))
        # print(soup.find_all('p'))
        i = 0
        ret_str = ""
        for a in soup.find_all('p'):
            if i == 2:
                break
            ret_str += (a.getText())
            i += 1
        return ret_str


print(get_summary('The_Adventures_of_Tom_Sawyer'))
