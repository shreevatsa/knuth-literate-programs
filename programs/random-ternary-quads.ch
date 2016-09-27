@x
  for (k=0;k<=3*nn;k++) printf(" %d",L[k]);
  printf("\n");
@y
  @<Print the answer in `quad' format@>;
@z
@x
@*Index.
@y
@ This version outputs the tree in the format accepted as command-line
arguments to the program {\mc SKEW-TERNARY-CALC-RAW} (which see).

@<Print the answer in `quad' format@>=
for (k=1;k<=nn;k++) {
  printf(" %c",'@@'+k);
  for (j=-2;j<=0;j++)
    i=L[3*k+j],printf("%c",(i+1)%3?'-':'@@'+(int)(i+1)/3);
}

@*Index.
@z for example, test this program with "random-ternary-quads 7 3 | xargs echo".
