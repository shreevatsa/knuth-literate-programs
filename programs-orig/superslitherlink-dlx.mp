% definitions for boxes
def box(expr wd,ht)(suffix $) =
  z$ne-z$nw=z$se-z$sw=(wd,0);
  z$ne-z$se=z$nw-z$sw=(0,ht);
  z$n=.5[z$nw,z$ne];
  z$e=.5[z$se,z$ne];
  z$s=.5[z$se,z$sw];
  z$w=.5[z$nw,z$sw];
  z$=.5[z$nw,z$se];
enddef;

picture pic[];
vardef picbox@# =
  box(xpart(urcorner pic@#-llcorner pic@#)+3pt,
      ypart(urcorner pic@#-llcorner pic@#)+3pt)(@#)
enddef;

vardef rect@# = z@#ne--z@#nw--z@#sw--z@#se--cycle enddef;
vardef diamond@# = (z@#n+(0,3pt))--(z@#w-(3pt,0))--
                   (z@#s-(0,3pt))--(z@#e+(3pt,0))--cycle enddef;
vardef oval@# = z@#se-(.5ypart(z@#n-z@#s),0){right}..
  z@#e{up}..{left}z@#ne-(.5ypart(z@#n-z@#s),0)--
  z@#nw+(.5ypart(z@#n-z@#s),0){left}..
  z@#w{down}..{right}z@#sw+(.5ypart(z@#n-z@#s),0)--cycle enddef;

def drawbox (expr lbl)(suffix $) =
  erase fill rect$;
  draw rect$;
  label(lbl,z$);
enddef;
def drawobox (expr lbl)(suffix $) =
  erase fill oval$;
  draw oval$;
  label(lbl,z$);
enddef;
def drawdbox (expr lbl)(suffix $) =
  erase fill diamond$;
  draw diamond$;
  label(lbl,z$);
enddef;

numeric u; u=12bp;
primarydef a!b = (b*u,-a*u) enddef;

vardef hexst(expr n) =
  if n<10: decimal n
  else: char (ASCII "a"+n-10)
  fi
enddef;
vardef lbl(expr p) =
  (hexst(-ypart p) & hexst(xpart p)) infont "cmtt8"
enddef;

beginfig(1) % example loop
path p;
p=2!4--2!6--2!8--4!8--4!10--6!10--6!8--8!8--10!8--10!6--
  10!4--8!4--8!6--6!6--6!4--6!2--4!2--4!4--cycle;
draw p;
for j=0 upto 17:
 z[j]=point j of p;
 pic[j]=lbl(z[j]/u);
 picbox[j];
 drawobox(pic[j],[j]);
endfor
for t=1!5,1!7,3!3,3!5,3!7,3!9,5!1,5!3,5!5,5!9,5!11,7!3,7!5,7!7,7!9,
              9!3,9!5,9!7,9!9,11!5,11!7:
  label(lbl(t/u),t) withcolor red;
endfor
endfig;
bye.




 
