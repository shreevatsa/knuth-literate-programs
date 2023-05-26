@x
    @<Output the options for edge |k|@>;
@y
    @<Output the options for edge |k|@>;
  for (v=g->vertices;v<g->vertices+n;v++)
    @<Output the options for vertex |v|@>;
@z
@x
There's a secondary item \.{.$v$} for each vertex; its color will be its label.
@y
This version also introduces a primary item \.{\#$v$} for each vertex.

There's a secondary item \.{.$v$} for each vertex; its color will be its label.
@z
@x
printf("|");
@y
for (v=g->vertices;v<g->vertices+n;v++) printf("#%s ",
                      v->name);
printf("|");
@z
@x
@*Index.
@y
@ @<Output the options for vertex |v|@>=
{
  for (k=0;k<=m;k++)
    printf("#%s .%s:%c +%c:%c\n",
       v->name,v->name,encode(k),encode(k),encode((int)(v-g->vertices)));
}

@*Index.
@z
