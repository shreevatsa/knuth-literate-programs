@x
@ One of the first goals of this program will be to compute the
``conjugates'' $T^+$, $T^{++}$, and $T^{+++}=T^-$, given a
skew ternary tree~$T$. That tree is specified on the command line,
@y
@ The goal of this variant of {\mc SKEW-TERNARY-CALC} is simply
to compute the four skew ternary trees
$T$, $T^+$, $T^{++}$, and $T^{+++}=T^-$ that are cyclically equivalent
to a given a ternary tree~$T$. That tree is specified on the command line,
@z
@x
checks to make sure that they actually do define a skew ternary tree.
@y
checks to make sure that they actually do define a ternary tree.
@z
@x
  @<Find and print the three conjugates of |T|@>;
  @<Find and print the corresponding planar maps@>;
@y
  @<Find and print the four skew conjugates of |T|@>;
@z
@x
  if (r<0) {
    fprintf(stderr,"Not properly skewed: rank(%c)=-1!\n",p);
    exit(-30);
  }
@y
  if (r<minrank) minrank=r;
@z
@x
int stack[256]; /* buds currently unmatched */
@y
int stack[512]; /* buds currently unmatched */
int minrank; /* smallest rank of a node so far */
@z
@x
@ @<Find and print the three conjugates of |T|@>=
@y
@ @<Find and print the four skew conjugates of |T|@>=
@z
@x
@ @d offset 2 /* difference between |stacked| and the current rank */
@y
@ @d offset 258 /* difference between |stacked| and the current rank */
@z
@x
fun of deciphering it.
@y
fun of deciphering it.

If |minrank<-1|, the topmost |-minrank-1| buds on the stack were actually
matched (in the previous cycle), although the chart's |match| fields don't
show this. I could patch this up, but the |match| fields aren't really used.
We do have to shift the stack entries so that the four truly unmatched
buds appear at the top.
@z
@x
for (j=1;j<4;j++) {
@y
if (minrank<-1)
  for (i=1;i>=-2;i--)
    stack[i+offset]=stack[i+offset+minrank+1];
for (j=0;j<4;j++) {
@z
