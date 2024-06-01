@x an experimental change file for SSXCC-BINARY (the new version of 25 Aug!)
those heuristics were designed with binary branching in mind.
@y
those heuristics were designed with binary branching in mind.

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
  t=inf_size,tmems=mems;
@y
@d inf_size 0x7fffffff
@d infty 2e32f /* twice |dangerous| */

@<Set |best_itm| to the best item for branching...@>=
{
  register float score,tscore,w;
  t=inf_size,tmems=mems,score=infty;
@z
@x
  for (k=0;k<active;k++) if (o,item[k]<second) {
    o,s=size(item[k]);
    if ((vbose&show_details) &&
        level<show_choices_max && level>=maxl-show_choices_gap) {
      print_item_name(item[k],stderr);
      fprintf(stderr,"("O"d)",s);
    }
    if (s<=1) {
      if (s==0)
        fprintf(stderr,"I'm confused.\n"); /* |include_option| missed this */
      else o,force[forced++]=item[k];
    }@+else if (s<=t) {
      if (s<t) best_itm=item[k],t=s;
      else if (item[k]<best_itm) best_itm=item[k]; /* suggested by P. Weigel */
    }
  }
@y
  for (k=0;k<active;k++) if (o,item[k]<second) {
    o,s=size(item[k]);
    if (s<=1) {
      if (s==0)
        fprintf(stderr,"I'm confused.\n"); /* |include_option| missed this */
      else o,force[forced++]=item[k];
    }@+else {
      o,w=wt(item[k]);
      tscore=s/w;
      if (tscore>=infty) tscore=dangerous;
      if (tscore<=score) {
        if (tscore<score) best_itm=item[k],score=tscore,t=s;
        else if (item[k]<best_itm) best_itm=item[k];
      }
    }
    if ((vbose&show_details) &&
        level<show_choices_max && level>=maxl-show_choices_gap) {
      print_item_name(item[k],stderr);@+
      if (s==1) fprintf(stderr,"(1)");
      else fprintf(stderr,"("O"d,"O"g)",s,w);
    }
  }
@z
@x
      fprintf(stderr,"("O"d)\n",t);
@y
      fprintf(stderr,"("O"d), score "O".4f\n",t,score);
@z
