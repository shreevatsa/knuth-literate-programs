"""Download all programs and generate stats."""

import os.path
import requests
import subprocess
from bs4 import BeautifulSoup

prefix = 'https://cs.stanford.edu/~knuth/'

print('Getting the programs.html page to parse links.')
response = requests.get(prefix + 'programs.html')

soup = BeautifulSoup(response.content, 'html.parser')
links = soup.find_all('a')

for link in links:
    href = link.get('href')
    if not href:
        # Something that happens to be true for this page: non-links are names.
        assert list(link.attrs.keys()) == ['name'], (link, link.attrs.keys())
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
        if open(filename, 'rb').read():
            print(f'Already have {filename} from {url}')
            continue
        os.remove(filename)

    # with open(filename, 'wb') as f:
    #     print 'Downloading %s into %s' % (url, filename)
    #     f.write(requests.get(url).content)
    print(f'Downloading from {url}')
    subprocess.call(['wget', url])
    if filename.endswith('.gz'):
        subprocess.call(['gunzip', '-k', filename])
