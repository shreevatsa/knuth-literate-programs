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

def cutat suffix$ =
 cutafter (fullcircle scaled 3pt shifted z$)
enddef;

beginfig(1)
numeric h,w; h=.4in; w=.5in;
z1-z0=z2-z1=z3-z2=(w,0);
z1=-z2; z4=-z5;
z4-z5=z6=-z7=(0,h);
path p; p= z0{up}...z6{right}...z3{down}...z7{left}...cycle;
draw p;
draw z1{up}...z4{right}...z2{down}...z5{left}...cycle;
draw z0--z1; draw z2--z3;
pickup pencircle scaled 3pt;
for j=0,1,2,3,7: drawdot z[j]; endfor
label.top(btex$a$etex,z6);
label.top(btex$b$etex,.5[z0,z1]);
label.top(btex$c$etex,z4);
label.top(btex$d$etex,z5);
label.top(btex$e$etex,.5[z2,z3]);
label.top(btex$f$etex,point 3.3 of p);
label.top(btex$g$etex,point 2.7 of p);
endfig;

beginfig(2)
verbatimtex \def\mbox#1{\hbox to1em{\hfil$#1\mathstrut$\hfil}} etex;
w:=20pt; h:=18pt;
z0=origin;
z2=z0-(5pt,h);
y1=y2=y3; x3=.5[x7,x8]; x2-x1=4/5(x3-x2);
z5=z2-(0,h);
z6-z5=z5-z4=z7-z6=z8-z7=z10-z9=(w,0);
.5[z9,z10]=z5-(0,h);
draw z0--z1; draw z0--z2; draw z0--z3;
draw z2--z4; draw z2--z5; draw z2--z6; draw z3--z7; draw z3--z8; 
draw z5--z9; draw z5--z10;
picture pic[];
pic0=btex\mbox A etex;
pic1=btex\mbox a etex;
pic2=btex\mbox B etex;
pic3=btex\mbox D etex;
pic4=btex\mbox b etex;
pic5=btex\mbox C etex;
pic6=btex\mbox e etex;
pic7=btex\mbox f etex;
pic8=btex\mbox g etex;
pic9=btex\mbox c etex;
pic10=btex\mbox d etex;
for j=0 upto 10:
  picbox[j];
  drawobox(pic[j],[j]);
endfor
endfig;

bye.
