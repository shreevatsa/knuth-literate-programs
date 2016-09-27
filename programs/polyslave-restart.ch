@x change file for restarting POLYSLAVE after a checkpoint
math_file=fopen(filename,"w");
@y
math_file=fopen(filename,"a"); /* append to previous outputs */
@z
Note: Bad definitions may have gotten into the outfile file, but
we append good definitions that will override them.
@x
FILE *out_file;
@y
FILE *out_file;
FILE *dump_file;
char dfilename[100];

@ This is the data reconstituter just mentioned.
If the dumped data had a different value of |slave_size|,
we don't complain;
{\mc POLYNUM} will have made sure that there is no problem.
(At the time of a checkpoint, all the valid data appears
at the beginning of the |count| table.)

@<Init...@>=
sprintf(dfilename,"%.90s-%u.dump",base_name,m);
dump_file=fopen(dfilename,"rb");
if (!dump_file) panic("I can't open the dump file");
if (fread(dump_data,sizeof(unsigned int),5,dump_file)!=5)
  panic("Bad read at beginning of dump");
if (n!=dump_data[0] || w!=dump_data[1] || m!=dump_data[2]) 
  panic("Dump data doesn't match");
if (dump_data[3]>slave_size) dump_data[3]=slave_size;
if (fread(scount,sizeof(counter),n+1,dump_file)!=n+1)
  panic("Can't read the dumped subtotals");
if (fread(count,sizeof(counter),dump_data[3],dump_file)!=dump_data[3])
  panic("Can't read the dumped counters");
prev_row=dump_data[4];
@z


