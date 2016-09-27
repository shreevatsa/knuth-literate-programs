@x
unsigned int ttt; /* truth table found in input line */
main(int argc,char *argv[])
{
  register int c,j,k,r,t,m,mm,s;
@y
unsigned int tta,ttb; /* partial truth table found in input line */
unsigned int footp[footsize];
main(int argc,char *argv[])
{
  register int a,b,c,j,k,r,t,m,mm,s,ttt;
@z
@x
  printf("Truth table (hex): ");
  fflush(stdout);
  if (!fgets(buf,100,stdin)) break;
  if (sscanf(buf,"%x",&ttt)!=1) break;
@y
  printf("Asterisks and bits (hex): ");
  fflush(stdout);
  if (!fgets(buf,100,stdin)) break;
  if (sscanf(buf,"%x %x",&tta,&ttb)!=2) break;
  a=tta,b=ttb;
  if (b&0x8000) b^=0xffff^a;
  for (j=b,k=9999;j<0x10000;) {
    if (func[j].cost<=k) {
       if (func[j].cost<k) for (r=0;r<mm;r++) footp[r]=0;
       k=func[j].cost,ttt=j;
       for (r=0;r<mm;r++) footp[r]|=func[j].footprint[r];
    }
    r=(j|(0xffff-a))+1;
    j=(r&(0x10000+a))+b;
  }
@z
@x
  for (j=0;j<mm;j++) if (func[ttt].footprint[j]) {
    s=32*j;
    for (u=func[ttt].footprint[j]; u; u>>=1, s++)
@y
  for (j=0;j<mm;j++) if (footp[j]) {
    s=32*j;
    for (u=footp[j]; u; u>>=1, s++)
@z
