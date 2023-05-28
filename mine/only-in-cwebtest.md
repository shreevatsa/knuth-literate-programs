# List of files only in ../cwebtest

## Seen and understood

- .git (directory)
 
- .gitignore (*gz)

- downloadable-programs.lst

- downloadable-programs.sh (Just downloads all files in `downloadable-programs.lst`)

- gb_types.w: From SGB, included by some programs.

- For the following files: See `git log ham.ch` — can ignore for now.
    - gb_graph.hux
    - gb_save.hux
    - ham.bux
    - ham.ch
    - system.bux

- runall.sh:
  - For `*.mp` files, run `mpost` on them.
  - For `.w` files, 
    - run `cweave`, then `tex` on the basename `$bi`.
    - for every `$bi*.ch`, run `cweave $i $c $bc`, and then `pdftex $bc`
    - Special logic:
      - `cweave horn-count krom-count krom-count`
      - `cweave ssxcc2 ssxcc3 ssxcc3`
      - `cweave xccdc2 xccdc3 xccdc3`

- README.md

## Need to think
- Look into downloading these additional files: sat-life.w (is it same as the one in `sat-life.tgz`?), ssxc0.w, ssxc1.w, ssxcc0.w, ssxccdom.w
