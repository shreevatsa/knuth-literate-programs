@x
@d infty max_nodes /* the ``score'' of a completely unconstrained item */
@y
@d infty 0x7fffffff /* the ``score'' of a completely unconstrained item */
@z
@x in search for best_itm, give pref to items whose name begins with #
  if (t<=score) {
@y
  if (t<=score && t>1 && (o,cl[k].name[0]!='#')) t+=last_node;
  if (t<=score) {
@z
@x
if ((vbose&show_details) &&
@y
if (score>last_node && score<infty) score-=last_node; /* remove the bias */
if ((vbose&show_details) &&
@z
