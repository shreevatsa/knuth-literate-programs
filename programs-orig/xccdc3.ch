@x a change file for xccdc2.w
program {\mc SSXCC2} extended {\mc SSXCC1} by using ``weights''; a
primary item with a large weight is more likely to be chosen for
branching than a primary item with a small weight. I've obtained the present program
{\mc XCCDC2} by extending {\mc XCCDC1} in essentially the same way.
@y
program {\mc SSXCC3} extended {\mc SSXCC1} by using ``weights''; a
primary item with a large weight is more likely to be chosen for
branching than a primary item with a small weight. I've obtained the present program
{\mc XCCDC3} by extending {\mc XCCDC1} in essentially the same way.
@z
@x
    oo,s=size(item[k]),w=wt(item[k]);
    if ((vbose&show_details) &&
        level<show_choices_max && level>=maxl-show_choices_gap) {
      print_item_name(item[k],stderr);@+
      fprintf(stderr,"("O"d,"O".1f)",s,w);
    }
    if (s<=1) {
      if (s==0) fprintf(stderr,"I'm confused.\n"); /* |hide| missed this */
      force=t=1,best_itm=item[k];
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
      if (t==1) fprintf(stderr,"(forced)\n");
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
