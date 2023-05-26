@x
The output consists of the corresponding twintrees $T_0$ and $T_1$.
(Each root is identified, followed by
the node names and left/right child links,
in symmetric order. A null link is rendered `\.{/\\}'.)
@y
The output on |stdout| is in the format acceptable to the companion
program {\mc TWINTREE-TO-BAXTER}.
@z
@x
  printf("%*s%s: %*s%s, %*s%s\n",
          rjustname(root),rjustname(l0[root]),rjustname(r0[root]));
@y
  serial[root]=++rank;
@z
@x
printf("T0 (rooted at %s)\n",
                   name[room[root0]]);
inorder0(root0);
printf("T1 (rooted at %s)\n",
                   name[room[root1]]);
inorder1(root1);
@y
rank=0;
inorder0(root0);
serial[rooms]=0;
printf("%d %d\n",
             serial[root0],serial[root1]);
for (k=0;k<rooms;k++)
  printf("%d %d %d %d %d\n",
       serial[k],serial[l0[k]],serial[r0[k]],serial[l1[k]],serial[r1[k]]);

@ @<Glob...@>=
int rank;
int serial[maxrooms+1];
@z
