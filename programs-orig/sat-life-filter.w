@*Intro. After a {\mc SAT} solver has solved a problem set up with the
{\mc SAT-LIFE} programs, we want to see the answer in a convenient form.
This program accepts the results (one line per solution) and converts
the literals of the form \.{$d$a$d$} into the rectangular ``\.{dots}''
format of periods and asterisks.

Input and output go from |stdin| to |stdout|.

@c
#include <stdio.h>
#include <stdlib.h>
char pix[101][101];
@<Subroutine@>;
main() {
  register int c,i,j,bit,maxi=0,maxj=0;
  while (1) {
    if (feof(stdin)) break;
    @<Process the next line of input@>;
  }
}

@ @<Subroutine@>=
int nextchar(void) {
  register int c=fgetc(stdin);
  if (c!=EOF) return c;
  exit(-1);
}
  
@ @<Process the next line of input@>=
for (c=nextchar();c==' ';) {
  @<Process a literal@>;
}
@<Output the pixels found@>;

@ @<Process a literal@>=
c=nextchar();
if (c!='~') bit=1;
else {
  bit=0;
  c=nextchar();
}
for (i=0;c>='0' && c<='9';c=nextchar()) i=10*i+c-'0';
if (i>=100) {
  fprintf(stderr,"Eh? I found a number of more than two digits!\n");
  exit(-2);
}
if (c!='a') goto litdone;
c=nextchar();
for (j=0;c>='0' && c<='9';c=nextchar()) j=10*j+c-'0';
if (j>=100) {
  fprintf(stderr,"Eh? I found a number of more than two digits!\n");
  exit(-2);
}
if (c!=' ' && c!='\n') goto litdone;
@<Record the pixel value $(i,j)$@>;
litdone:@+while (c!=' ' && c!='\n') c=nextchar();

@ @<Record the pixel value $(i,j)$@>=
if (i>maxi) maxi=i;
if (j>maxj) maxj=j;
pix[i][j]=bit;

@ @<Output the pixels found@>=
for (i=0;i<=maxi+1;i++) {
  for (j=0;j<=maxj+1;j++) putchar(pix[i][j]?'*':'.');
  putchar('\n');
}
putchar('\n');

@*Index.
