@x find all hamiltonian paths from the source; IGNORE the stated target
@d maxn 255 /* maximum number of vertices; at most 255 */
@y
@d maxn 254 /* maximum number of vertices; at most 254 */
@d dummy maxn+1 /* code for a dummy vertex adjacent to all */
@z
@x
      else printf(" -> %d(%s,%d) #%d\n",u->num,u->name,a->len,m);
    }
  }
@y
      else printf(" -> %d(%s,%d) #%d\n",u->num,u->name,a->len,m);
    }
  }
  arcto[m++]=dummy;
  printf(" -> dummy,0 #%d\n",m);
@z
@x
mate[target->num]=1, mate[1]=target->num;
@y
mate[dummy]=1, mate[1]=dummy;
@z
@x
ll=(k>l? k: l);
@y
ll=(k==dummy? l: k>l? k: l);
@z
@x
@<Unpack a state, and move |tail| up@>=
for (t=j;t<=l;t++,tail++) {
  mate[t]=mem[trunc(tail)];
  if (mate[t]>l) mate[mate[t]]=t;
@y
@<Unpack a state, and move |tail| up@>=
mate[dummy]=0;
for (t=j;t<=l;t++,tail++) {
  mate[t]=mem[trunc(tail)];
  if (mate[t]==dummy) mate[dummy]=t;
@z
@x
    if (mate[t] && mate[t]!=t) break;
  }
  if (t>ll) printf("1"); /* we win: this cycle is all by itself */
@y
    if (mate[t]) break;
  }
  if (t>n) printf("1"); /* we win: this cycle is all by itself */
@z
@x
    if (mate[t] && mate[t]!=t) break;
@y
    if (mate[t]) break;
@z
