@x all cycles; source and target are ignored, but I still check for them
for (t=2;t<=n;t++) mate[t]=t;
mate[target->num]=1, mate[1]=target->num;
@y
for (t=1;t<=n;t++) mate[t]=t;
@z
