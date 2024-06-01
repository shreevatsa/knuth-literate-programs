@x an experimental change file for SSMCC, based on SSXCC-FRB
I suggest that you read {\mc SSXCC}, {\mc SSXCC-BINARY} and {\mc DLX3} first.
@y
I suggest that you read {\mc SSXCC}, {\mc SSXCC-BINARY} and {\mc DLX3} first.

The ``{\mc FRB} heuristic'' implemented here is motivated by the paper
of Li, Yin, and Li in
@^Li, Hongbo@>
@^Yin, Minghao@>
@^Li, Zhanshan@>
{\sl Leibniz International Proceedings in Informatics\/ \bf210}
(2021), 9:1--9:10
[the proceedings of the 27th International Conference on Principles and
Practice of Constraint Programming, CP~2021].
When the option chosen for branching on some primary item~$i$ causes
another primary item~$i'$ to be wiped out, we say that a failure has
occurred with respect to~$i$. We branch on an item
that has a small number of options and a relatively high failure rate.
Details are discussed below.
@z
@x
@d show_weight_bumps 32 /* |vbose| code to show new weights */
@d show_final_weights 64 /* |vbose| code to display weights at the end */
@y
@d show_final_stats 64 /* |vbose| code to display item stats at the end */
@z
@x
  if (vbose&show_final_weights) {
    fprintf(stderr,"Final weights:\n");
    print_weights();
  }
@y
  if (vbose&show_final_stats) {
    fprintf(stderr,"Final primary item stats:\n");
    print_item_stats();
  }
@z
@x
`\.w$\langle\,$float$\,\rangle$' is the initial increment |dw| added to
an item's weight (default 1.0);
\item{$\bullet$}
`\.W$\langle\,$float$\,\rangle$' is the factor by which |dw| changes
dynamically (default 1.0);
@y
@z
@x
case 'w': k|=(sscanf(argv[j]+1,""O"f",&dw)-1);@+break;
case 'W': k|=(sscanf(argv[j]+1,""O"f",&dwfactor)-1);@+break;
@y
@z
@x
       " [c<n>] [C<n>] [l<n>] [t<n>] [T<n>] [w<f>] [W<f>] [S<bar>] < foo.dlx\n",
@y
       " [c<n>] [C<n>] [l<n>] [t<n>] [T<n>] [S<bar>] < foo.dlx\n",
@z
@x
A primary item $x$ also has a |wt| field, |set[x-5]|, initially~1.
The weight is increased by |dw| whenever we backtrack because |x|
cannot be covered. (Weights aren't actually {\it used} in the present
program; that will come in extensions to be written later. But it will
be convenient to have space ready for them in our data structures,
so that those extensions will be easy to write.)
@y
A primary item $x$ also has two special fields called
|assigns| and |failrate|, used in the {\mc FRB} heuristic.
Their significance is described below.
@z
@x
@d wt(x) set[(x)-7].f /* the current floating-point ``weight'' of |x| */
@d primextra 7 /* this many extra entries of |set| for each primary item */
@d secondextra 4  /* and this many for each secondary item */
@d maxextra 7 /* maximum of |primextra| and |secondextra| */
@y
@d assigns(x) set[(x)-7].f /* number of assignments tried so far for |x| */
@d failrate(x) set[(x)-8].f /* the current ``failure rate'' of |x| */
@d primextra 8 /* this many extra entries of |set| for each primary item */
@d secondextra 4  /* and this many for each secondary item */
@d maxextra 8 /* maximum of |primextra| and |secondextra| */
@z
@x
    fprintf(stderr," ("O"d of "O"d), length "O"d, weight "O".1f:\n",
         pos(c)+1,active,size(c),wt(c));
@y
    fprintf(stderr,
     " ("O"d of "O"d), length "O"d, failrate "O".1f of "O"g:\n",
         pos(c)+1,active,size(c),failrate(c),assigns(c));
@z
@x
    o,wt(j)=w0;
@y
    oo,assigns(j)=1.0,failrate(j)=0.5;
@z
@x
  if (!include_option(cur_choice)) goto tryagain;
  @<Increase |stage|@>;@+@<Increase |level|@>;
  goto forward;
@y
  if (!include_option(cur_choice)) goto abort;
  @<Take account of a nonfailure for |best_itm|@>;
  @<Increase |stage|@>;@+@<Increase |level|@>;
  goto forward;
abort:@+@<Take account of a failure for |best_itm|@>;
@z
@x
@ If a weight becomes dangerously large, we rescale all the weights.

(That will happen only when |dwfactor| isn't 1.0. Adding a constant
eventually ``converges'': For example, if the constant is 1, we have convergence
to $2^{17}$ after $2^{17}-1=16777215$ steps.
If the constant~|dw| is .250001, convergence
to \.{8.38861e+06} occurs after 25165819 steps!)

(Note: I threw in the parameters |dw| and |dwfactor| only to do experiments.
My preliminary experiments didn't turn up any noteworthy results.
But I didn't have time to do a careful study; hence there might
be some settings that work unexpectedly well. The code for rescaling
might be flaky, since it hasn't been tested very thoroughly at all.)

@d dangerous 1e32f
@d wmin 1e-30f

@<Increase the weight of |tough_itm|@>=
cmems+=2,oo,wt(tough_itm)+=dw;
if (vbose&show_record_weights && wt(tough_itm)>maxwt) {
  maxwt=wt(tough_itm);
  fprintf(stderr,""O"8.1f ",maxwt);
  print_item_name(tough_itm,stderr);
  fprintf(stderr," "O"lld\n",nodes);
}
if (vbose&show_weight_bumps) {
  print_item_name(tough_itm,stderr);
  fprintf(stderr," wt "O".1f\n",wt(tough_itm));
}
dw*=dwfactor;
if (wt(tough_itm)>=dangerous) {
  register int k;
  register float t;
  tmems=mems;
  for (k=0;k<itemlength;k++) if (o,item[k]<second) {
    o,t=wt(item[k])*1e-20f;
    o,wt(item[k])=(t<wmin?wmin:t);
  }
  dw*=1e-20f;
  if (dw<wmin) dw=wmin;
  w0*=1e-20f;
  if (w0<wmin) w0=wmin;
  cmems+=mems-tmems;
}
@y
@z
@x
@ @<Sub...@>=
void print_weights(void) {
  register int k;
  for (k=0;k<itemlength;k++) if (item[k]<second && wt(item[k])!=w0) {
    print_item_name(item[k],stderr);
    fprintf(stderr," wt "O".1f\n",wt(item[k]));
  }
}
@y
@ The heuristics used in this program are based on the special
fields |assigns| and |failrate| of each primary item~|i|.

The |assigns| field simply counts the number of assignments made to~|i|
so far, namely the number of times we've branched on~|i| by trying
to include one of its options. It's a \&{float}, so it starts at
1.0 and increases to $2^{24}=16777216.0$, after which it remains constant.

An assignment {\it fails\/} if it wipes out the options for some
other primary variable that it doesn't cover. A global variable
|failtime| is 1 more than the total number of failed assignments so far.

The |failrate| field is the most interesting. It basically
represents the number of failed assignments to~|i| divided by
|assigns(i)|. However, |failrate(i)| is initialized to 0.5,
and |assigns(i)| is initialized to 1.0, according to the definition
introduced by Li, Yin, and Li in their paper cited above.
@^Li, Hongbo@>
@^Yin, Minghao@>
@^Li, Zhanshan@>
After the first assignment, |assigns(i)| will be~2.0, and
|failrate(i)| will be either 0.75 or 0.25, depending on whether
or not that assignment led to failure. After $k$ assignments,
the possible values of |failrate(i)| are $1/(2k+2)$,
$3/(2k+2)$, \dots,~$(2k+1)/(2k+2)$.

@<Take account of a nonfailure for |best_itm|@>=
oo,assigns(best_itm)+=1.0;
oo,failrate(best_itm)-=failrate(best_itm)/assigns(best_itm);

@ @<Take account of a failure for |best_itm|@>=
oo,assigns(best_itm)+=1.0;
oo,failrate(best_itm)+=(1.0-failrate(best_itm))/assigns(best_itm);

@ @<Sub...@>=
void print_item_stats(void) {
  register int k;
  for (k=0;k<itemlength;k++) if (item[k]<second && assigns(item[k])!=1.0) {
    print_item_name(item[k],stderr);
    fprintf(stderr," fr "O".4f of "O"g\n",
           failrate(item[k]),assigns(item[k]));
  }
}
@z
@x
@d inf_size 0x7fffffff

@<Set |best_itm| to the best item for branching...@>=
{
  score=inf_size,tmems=mems;
@y
@d inf_size 0x7fffffff
@d dangerous 1e32f
@d infty 2e32f /* twice |dangerous| */

@<Set |best_itm| to the best item for branching...@>=
{
  register float fscore,tscore,w;
  score=inf_size,tmems=mems,fscore=infty;
@z
@x
  for (k=0;k<active;k++) if (o,item[k]<second) {
    o,s=slack(item[k]);
    if (o,s>bound(item[k])) s=bound(item[k]);
    o,t=size(item[k])+s-bound(item[k])+1;
    if ((vbose&show_details) &&
        level<show_choices_max && level>=maxl-show_choices_gap) {
      print_item_name(item[k],stderr);
      if (bound(item[k])!=1 || s!=0) {
        fprintf(stderr, "("O"d:"O"d,"O"d)",
            bound(item[k])-s,bound(item[k]),t);
      }@+else fprintf(stderr,"("O"d)",t);
    }
    if (t==1)
      for (i=bound(item[k])-slack(item[k]);i>0;i--) o,force[forced++]=item[k];
    else if (t<=score && (t<score ||
               (s<=best_s && (s<best_s ||
               (size(item[k])>=best_l && (size(item[k])>best_l ||
               (item[k]<best_itm)))))))
      score=t,best_itm=item[k],best_s=s,best_l=size(item[k]);
  }
@y
  for (k=0;k<active;k++) if (o,item[k]<second) {
    o,s=slack(item[k]);
    if (o,s>bound(item[k])) s=bound(item[k]);
    o,t=size(item[k])+s-bound(item[k])+1;
    if (t==1)
      for (i=bound(item[k])-slack(item[k]);i>0;i--) o,force[forced++]=item[k];
    else {
      o,w=failrate(item[k]);
      tscore=t/w;
      if (tscore>=infty) tscore=dangerous;
      if (tscore<=fscore && (tscore<fscore || 
               (s<=best_s && (s<best_s ||
               (size(item[k])>=best_l && (size(item[k])>best_l ||
               (item[k]<best_itm)))))))
      fscore=tscore,best_itm=item[k],score=t,best_s=s,best_l=size(item[k]);
    }
    if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap) {
      print_item_name(item[k],stderr);@+
      if (t==1) fprintf(stderr,"(1)");
      else {
        if (bound(item[k])!=1 || s!=0) {
          fprintf(stderr, "*("O"d:"O"d,"O"d,"O".1f)",
            bound(item[k])-s,bound(item[k]),t,w);
        }@+else fprintf(stderr,"("O"d,"O".1f)",t,w);
      }
    }
  }
@z
@x
      fprintf(stderr,"("O"d)\n",score);
@y
      fprintf(stderr,"("O"d), score "O".4f\n",score,fscore);
@z
