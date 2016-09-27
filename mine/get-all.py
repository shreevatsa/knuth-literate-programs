"""Download all programs and generate stats."""

import os.path
import requests
import subprocess

prefix = 'https://cs.stanford.edu/~uno/'

response = requests.get(prefix + 'programs.html')

from bs4 import BeautifulSoup
soup = BeautifulSoup(response.content, 'html.parser')
links = soup.find_all('a')

for link in links:
    href = link.get('href')
    if not href:
        # Something that happens to be true for this page: non-links are names.
        assert link.attrs.keys() == ['name']
        continue
    # Ignore links to other html pages
    if href.endswith('.html'):
        continue
    # Hack for detecting start of "Programs in languages other than CWEB"
    if href == 'news02.html#rng':
        break

    # Hack for certain files that are not under programs/
    if href in ['words.tgz', 'ulam-gibbs.ps']:
        filename = href
    else:
        (programs, filename) = href.split('/')
        assert programs == 'programs'

    url = prefix + href
    if os.path.isfile(filename):
        if open(filename).read():
            print 'Already have %s from %s' % (filename, url)
            continue
        os.remove(filename)

    # with open(filename, 'wb') as f:
    #     print 'Downloading %s into %s' % (url, filename)
    #     f.write(requests.get(url).content)
    print 'Downloading from %s' % url
    subprocess.call(['wget', url])
    if filename.endswith('.gz'):
        subprocess.call(['gunzip', '-k', filename])
