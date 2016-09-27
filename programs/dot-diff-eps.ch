@x
#include <stdio.h>
@y
#include <stdio.h>
#include <time.h>
time_t cur_clock;
@z
@x
@<Spew out the answers@>=
@y
@<Forget this@>=
@z
@x
@* Index.
@y
@ Here I'm writing an encapsulated PostScript file instead of a
kludgy \MF\ file.

@<Spew out the answers@>=
  @<Output the header of the EPS file@>;
  @<Output the image@>;
  @<Output the trailer of the EPS file@>;

@ @<Output the header of the EPS file@>=
printf("%%!PS\n");
printf("%%%%BoundingBox: 0 0 %d %d\n",
    (int)(.5+n*72.0/300.0),(int)(.5+m*72.0/300.0));
printf("%%%%Creator: dot_diff-eps\n");
cur_clock=time(0);
printf("%%%%CreationDate: %s",ctime(&cur_clock));
printf("%%%%Pages: 1\n");
printf("%%%%EndProlog\n");
printf("%%%%Page: 1 1\n");
printf("/picstr %d string def\n",n>>3);
printf("72 300 div dup scale %d %d scale\n", n, m);
printf("%d %d true [%d 0 0 -%d 0 %d]\n",n,m,n,m,m);
printf(" {currentfile picstr readhexstring pop} imagemask\n");

@ @<Output the image@>=
for (i=1;i<=m;i++) for (j=1;j<=n;j+=4) {
  for (k=0,w=0;k<4;k++) w=w+w+(aa[i][j+k]==black? 1: 0);
  printf("%x",w);
}

@ @<Output the trailer of the EPS file@>=
printf("%%%%EOF\n");  

@* Index.
@z
