@x an experimental change file for SSMCC, based on SSXCC-WTD
I suggest that you read {\mc SSXCC}, {\mc SSXCC-BINARY} and {\mc DLX3} first.
@y
I suggest that you read {\mc SSXCC}, {\mc SSXCC-BINARY} and {\mc DLX3} first.

The heuristic implemented in this version is motivated by the paper
of Boussemart, Hemery, Lecoutre, and Sais in {\sl Proc.\ 16th
European Conference on Artificial Intelligence} (2004), 146--150: We increase
the weight of a primary item when its current set of options becomes null.
Items are chosen for branching based on the size of their set divided by their
current weight, unless the choice is forced.
@^Boussemart, Fr\'ed\'eric@>
@^H\'emery, Fred@>
@^Lecoutre, Christophe@>
@^Sa{\"\i}s, Lakhdar@>
@z
@x
  if (!include_option(cur_choice)) goto tryagain;
  @<Increase |stage|@>;@+@<Increase |level|@>;
  goto forward;
@y
  if (!include_option(cur_choice)) goto abort;
  @<Increase |stage|@>;@+@<Increase |level|@>;
  goto forward;
abort:@+@<Increase the weight of |tough_itm|@>;
@z
@x
@d inf_size 0x7fffffff

@<Set |best_itm| to the best item for branching...@>=
{
  score=inf_size,tmems=mems;
@y
@d inf_size 0x7fffffff
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
      o,w=wt(item[k]);
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
