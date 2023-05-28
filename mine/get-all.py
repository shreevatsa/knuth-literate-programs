"""Download all CWEB programs from Knuth's webpage."""

import os
import os.path
import glob
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

    additional = ['cvm-estimates.w']
    for f in additional:
        subprocess.run(['wget', '-N', prefix + f])


def pdf(basename):
    print(f'\n\n\n\nRunning pdftex on {basename}')
    out = subprocess.run(['pdftex', basename], capture_output=True, text=True).stdout
    if "Non-PDF special ignored" in out:
        print('    --->    Running tex + dvipdfmx instead.')
        subprocess.run(['tex', basename])
        subprocess.run(['dvipdfmx', basename + '.dvi'])


fetch()
print('Done downloading all files. Now building them.')

subprocess.run(['mkdir', '-p', 'tmp/'])
subprocess.run(['cp', 
                    '../supporting/gb_types.w', 
                    '../supporting/cwebmac.tex', 
                    '../supporting/cwebmac-real.tex', 
                    'matula.S',
                    'matula.T',
                    'matula.ST',
                    'queenon-partition.0',
                    'queenon-partition.1',
                    'deco.5',
                    *glob.glob('*.mp'),
                'tmp/'])
wd = os.getcwd()
os.chdir('tmp/')
for mp in glob.glob('*.mp'):
    subprocess.run(['mpost', mp])
os.chdir(wd)
for f in glob.glob('*.w'):
    print('\n\n\n\n\n')
    basename = os.path.basename(f)
    assert basename.endswith('.w')
    basename = basename[:-2]
    subprocess.run(['cp', *glob.glob(basename + '*'), 'tmp/'])
    wd = os.getcwd()
    os.chdir('tmp/')
    subprocess.run(['cweave', basename])
    # Some things don't work currently
    if basename in [
        'back-graceful-kmp3', # \Xmod and \MOD
        'dlx1',               # same
        'dlx2',               # same
        'dlx3',               # same
        'dlx5',               # same
        'dlx6',               # same
        'xccdc1',             # same
        'xccdc2',             # same
        'ssxcc1',             # same
        'ssxcc2',             # same
        'sat13',              # same
        'ulam-gibbs',         # same
        'reflect',            # something about \normaloutput -> \grouptitle -> \lheader
        'celtic-paths',        # missing font
        'tchoukaillon-arrays', # missing font lhwnr8
       ]:
        os.chdir(wd)
        continue
    pdf(basename)
    subprocess.run(['cp', basename + '.pdf', '../../programs/'])

    for changefile in glob.glob(basename + '*.ch'):
        assert changefile.endswith('.ch')
        changefile = changefile[:-3]
        subprocess.run(['cweave', basename + '.w', changefile + '.ch', changefile])
        pdf(changefile)
        subprocess.run(['cp', changefile + '.pdf', '../../programs/'])
    os.chdir(wd)
    print('Back to', wd)
subprocess.run(['rm', '-vrf', 'tmp/'])
