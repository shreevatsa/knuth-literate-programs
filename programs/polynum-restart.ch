@x change file for restarting POLYNUM after a checkpoint
We start with an all-|zero| configuration, at the very top of the
width-$w$ array of cells that we will conceptually traverse; this configuration
serves as the great-$\,\ldots\,$-great grandparent of all other
configurations that will arise later. The slave module will begin
by giving this configuration the trivial generating function `1' (namely
$z^0$) in its counter cell number~0, meaning that there's just one way to
reach the initial configuration, and that no cells are occupied so far.

There is no need to initialize |conf[0].lim| or |conf[0].link|, because
those fields are used only when a configuration is a target.
The other fields---namely |conf[0].s|, |conf[0].addr|, |conf[0].lo|,
|conf[0].hi|, and |conf[0].state|--- are initially zero by the
conventions of \CEE/, and luckily those zeros happen to be just what we want.

@<Init...@>=
r=0, row_end=w;
trg=conf+1; /* pretend that the previous pass produced a single result */
strg=1;
@y
We start by restoring the situation at the end of the previous checkpoint.

Important: We have already clobbered file \.{foo.0}, because we are assuming
that the user has either renamed the former output files or already
processed them with {\mc POLYSLAVE}. In the latter case, {\mc POLYSLAVE}
will have written its own dump files \.{foo-256.dump}, etc., for various
moduli; it should be restarted with the variation prepared from change file
\.{polyslave-restart.ch}.

@<Init...@>=
sprintf(dfilename,"%.90s.dump",base_name);
in_file=fopen(dfilename,"rb");
if (!in_file) panic("I can't open the dump file");
if (fread(dump_data,sizeof(int),5,in_file)!=5)
  panic("Bad read at beginning of dump");
if (n!=dump_data[0] || w!=dump_data[1])
  panic("Dump data doesn't match");
r=dump_data[2], trg=conf+dump_data[3], strg=dump_data[4];
if (trg>=conf_end)
  panic("Must increase confsize"); /* it's waaaaaaaayy too small */
if (strg>=slave_size)
  panic("Must increase slavesize"); /* likewise */
if (fread(conf,sizeof(config),trg-conf,in_file)!=trg-conf)
  panic("Can't read the dumped configurations");
row_end=w;
@z
@x
  if (r) {
@y
  if (r!=dump_data[2]) {
@z
@x
printf("Checkpoint stop: Please process that data with polyslave,\n");
@y
printf("Checkpoint stop: Please process that data with polyslave-restart,\n");
@z
@x
int dump_data[5]; /* parameters needed to restart */
@y
int dump_data[5]; /* parameters needed to restart */
char dfilename[100];
FILE *in_file;
@z
