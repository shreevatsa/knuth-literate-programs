# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "tqdm",
# ]
# ///
import glob
import subprocess
import tqdm
import os
import os.path

def pdf(basename):
    print(f'Running pdftex on {basename}...', end='')
    env = os.environ.copy()
    env['SOURCE_DATE_EPOCH'] = '524493240'
    env['FORCE_SOURCE_DATE'] = '1' 
    out = subprocess.run(['pdftex', basename], capture_output=True, text=True, env=env).stdout
    if "Non-PDF special ignored" in out:
        print('    --->    Running tex + dvipdfmx instead.')
        subprocess.run(['tex', r'\year=1986\month=8\day=15\time=754', '\input', basename])
        subprocess.run(['dvipdfmx', basename + '.dvi'], env=env)
    print('Done')

print('Building all files.')

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
for f in tqdm.tqdm(glob.glob('*.w')):
    print('\n\n\n\n\n', f, sep='')
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
        outfile = changefile + '-ch' if changefile == basename else changefile
        subprocess.run(['cweave', basename + '.w', changefile + '.ch', outfile])
        pdf(outfile)
        subprocess.run(['cp', outfile + '.pdf', '../../programs/'])
    os.chdir(wd)
    print('Back to', wd)
subprocess.run(['rm', '-vrf', 'tmp/'])
