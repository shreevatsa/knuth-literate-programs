@x a change file for ssxcc2.w
Items are chosen for branching based on the size of their set divided by their
current weight.
@y

The program {\mc SSXCC2} chooses items for branching
based on the size of their set divided by their current weight.
But this one, {\mc SSXCC3}, minimizes the size of the set,
then breaks ties by maximizing the weight.
@z
@x
    oo,s=size(item[k]),w=wt(item[k]);
    if ((vbose&show_details) &&
        level<show_choices_max && level>=maxl-show_choices_gap) {
      print_item_name(item[k],stderr);@+
      fprintf(stderr,"("O"d,"O".1f)",s,w);
    }
    if (s<=1) {
      if (s<t) force=1,t=s,best_itm=item[k];
    }@+else if (!force) {
      tscore=s/w;
      if (tscore>=infty) tscore=dangerous;
      if (tscore<score) best_itm=item[k],score=tscore;
    }
  }
  if (!force) t=(score==infty? max_nodes: size(best_itm));
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap) {
    if (t==max_nodes) fprintf(stderr," solution\n");
    else {
      fprintf(stderr," branching on");
      print_item_name(best_itm,stderr);@+
      if (t<=1) fprintf(stderr,"(forced)\n");
      else fprintf(stderr,"("O"d), score "O".4f\n",t,score);
    }
  }
@y
    oo,s=size(item[k]),w=wt(item[k]);
    if ((vbose&show_details) &&
        level<show_choices_max && level>=maxl-show_choices_gap) {
      print_item_name(item[k],stderr);@+
      fprintf(stderr,"("O"d,"O".1f)",s,w);
    }
    if (s<=t) {
      if (s<t) t=s,score=w,best_itm=item[k];
      else if (w>score) score=w,best_itm=item[k];
    }
  }
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap) {
    if (t==max_nodes) fprintf(stderr," solution\n");
    else {
      fprintf(stderr," branching on");
      print_item_name(best_itm,stderr);@+
      fprintf(stderr,"("O"d), weight "O".1f\n",t,score);
    }
  }
@z
