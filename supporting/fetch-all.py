"""Download all CWEB programs from Knuth's webpage."""

import requests
import subprocess
from bs4 import BeautifulSoup

def fetch():
    prefix = 'https://cs.stanford.edu/~knuth/'

    print('Getting the programs.html page, to parse links.')
    response = requests.get(prefix + 'programs.html')
    links = BeautifulSoup(response.content, 'html.parser').find_all('a')

    for link in links:
        href = link.get('href')
        if not href:
            # Something that happens to be true for this page: non-links are names.
            assert list(link.attrs.keys()) == ['name']
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
            assert href.startswith('programs/')
            filename = href[len('programs/'):]

        url = prefix + href
        print(f'Downloading from {url} if updated.')
        subprocess.run(['wget', '-N', url])
        if filename.endswith('.gz'):
            subprocess.run(['gunzip', '-k', '-f', filename])
        if filename in ['sat-life.tgz', 'tictactoe.tgz']:
            subprocess.run(['tar', 'xvfz', filename])

    additional = ['programs/cvm-estimates.w']
    for f in additional:
        subprocess.run(['wget', '-N', prefix + f])


fetch()
print('Done downloading all files.')
