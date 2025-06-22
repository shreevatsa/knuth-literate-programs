# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "bs4",
#     "ipdb",
#     "requests",
# ]
# ///
from bs4 import BeautifulSoup
import requests
import os

# Get programs.html
filename = 'programs.html'
if not os.path.exists(filename):
    with open(filename, 'wb') as f:
        f.write(requests.get('https://cs.stanford.edu/~knuth/programs.html').content)
s = open('programs.html').read()
# Fix lines incorrectly ending with `<dt>` instead of `</dt>`
lines = []
for line in s.splitlines():
    if line.endswith('<dt>') and line != '<dt>':
        line = line[:-len('<dt>')] + '</dt>'
    lines.append(line)
# Parse file and get first `<dl>` (of 5) on the page.
b = BeautifulSoup('\n'.join(lines), features='html.parser')
dl = b.find('dl')

# Build map from <dt> to <dd>
dt = None
desc = {}
for (i, s) in enumerate(dl.children):
    if i % 2 == 0:
        assert s == '\n', (i, s)
        continue
    # print(i, repr(s).replace('\n', '\\n'))
    assert repr(s).startswith('<dt>' if (i % 4 == 1) else '<dd>'), (i, s)
    if i % 4 == 1:
        dt = s
    else:
        desc[dt] = s


def work_type(dd_hrefs, dt_hrefs):
    """Returns a list of programs to build, where each is a (w, optional ch) tuple. Or raises Exception."""
    if dd_hrefs:
        raise Exception('hrefs in dd too')
    w = []
    ch = []
    for href in dt_hrefs:
        if href.endswith('.gz'):
            href = href[:-3]
        if href.endswith('.w'):
            w.append(href)
        elif href.endswith('.ch'):
            ch.append(href)
        else:
            raise Exception('Unknown files')
    if len(ch) > 0 and len(w) > 1:
        raise Exception('Too many kinds of files')
    ret = []
    for w_file in w:
        ret.append((w_file, ))
        for ch_file in ch:
            ret.append((w_file, ch_file))
    return ret


# Extract what-to-do out of each pair.
i = 0
for (dt, dd) in desc.items():
    i += 1
    assert dt.name == 'dt'
    dt_hrefs = []
    dd_hrefs = []
    for part in dt.contents:
        if part.name == 'a' and 'href' in part.attrs:
            href = part.attrs['href']
            # print(part)
            # print(part.text.replace('\n', ' '), '<--', )
            dt_hrefs.append(href)
    for part in dd.contents:
        if part.name == 'a' and 'href' in part.attrs:
            href = part.attrs['href']
            dd_hrefs.append(href)
            # print(f'dd: {part.text} -> {href}')
            pass

    # Easy cases:
    # dt_hrefs has only `.w`s, or single `.w` and a bunch of `.ch`s, and
    # dd_hrefs is empty
    try:
        build = work_type(dd_hrefs, dt_hrefs)
        print(i, 'ok', build)
    except Exception as e:
        # print(e, repr(dt).replace('\n', ' '),
        #       repr(dd).replace('\n', ' '), '\n\n')
        print(i, 'Exception: ', e)
        pass

# Currently, 120 of 156 cases work can be handled automatically.
# Might as well put the rest in a list?
