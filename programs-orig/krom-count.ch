@x a change file for horn-count
@*Intro. Counting closure operators on six elements that are nonisomorphic
@y
@*Intro. Counting Krom functions on six elements that are nonisomorphic
@z
@x
@d final_level (nn-1) /* the first element that is never in a solution */
@y
@d final_level nn /* the first element that is never in a solution */
@z
@x
@<Record a solution@>;
l++;
@y
@<Record a solution@>;
nogood: l++;
@z
@x
@ @<Reject |l| if it violates closure@>=
for (j=0;j<l;j++) if (f[j] && !(f[j&l])) {
  if (verbose) printf(" rejecting %x for closure\n",l);
  goto reject;
}
@y
@ @<Reject |l| if it violates closure@>=
for (j=1;j<l;j++) if (f[j]) 
  for (d=0;d<j;d++) if (f[d]) {
    t=(d&j)|(d&l)|(j&l);
    if (t<l && !f[t]) {
      if (verbose) printf(" rejecting %x for median\n",l);
      goto reject;
    }
  } /* maybe the median was bigger than |l|; then I can't reject yet */
@z
@x
  sols++;
@y 
  for (k=2;k<=l;k++) if (f[k])
    for (j=1;j<k;j++) if (f[j])
      for (d=0;d<j;d++)
        if (f[d]&&!f[(d&j)|(d&k)|(j&k)]) goto nogood;
  sols++;
@z
