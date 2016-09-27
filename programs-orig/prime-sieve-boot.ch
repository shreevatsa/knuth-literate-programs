@x
The output file is a short text file that reports large gaps.
Whenever the program discovers consecutive primes for which the gap
$p_{k+1}-p_k$ is greater than or equal to all previously seen gaps,
this gap is output (unless it is smaller than 256).
The smallest and largest
primes between $s_0$ and $s_t$ are also output, so that we can keep
track of gaps between primes that are
found by different instances of this program.
@y
The output file in this ``bootstrap'' version is a list of all
primes $\le s_t$, in a format suitable for use as the input file
in the regular version.
@z
@x
  @<Report the final prime@>;
@y
@z
@x
outfile=fopen(argv[4],"w");
if (!outfile) {
  fprintf(stderr,"I can't open %s for text output!\n",argv[4]);
  exit(-3);
}
st=s0+tt*del;
@y
outfile=fopen(argv[4],"wb");
if (!outfile) {
  fprintf(stderr,"I can't open %s for binary output!\n",argv[4]);
  exit(-3);
}
st=s0+tt*del;
if (st>0xffffffff) {
  fprintf(stderr,"Sorry, s[t] = %llu exceeds 32 bits!\n",st);
  exit(-69);
}
@z
@x
@<Initialize the active primes@>;
@y
@<Output the primes that precede the first segment@>;
@<Initialize the active primes@>;
@z
@x
  @<Look for large gaps@>;
@y
  @<Output the primes in the current segment@>;
@z
@x
@*Index.
@y
@ @<Output the primes that precede the first segment@>=
for (k=0; prime[k]<s0; k++)
  fwrite(&prime[k],sizeof(int),1,outfile);

@ @<Output the primes in the current segment@>=
for (j=0;j<del/128;j++) {
  for (x=~sieve[j];x;x=x&(x-1)) {
    y=x&-x; /* extract the rightmost 1 bit */
    @<Change |y| to its binary logarithm@>;
    lastprime=s+(j<<7)+y+y+1; /* this is the first prime after the gap */
    fwrite(&lastprime,sizeof(int),1,outfile);
  }
}

@*Index.
@z
