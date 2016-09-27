% illustrations to accompany the program "skew-ternary-calc.w"

let drawdot = draw;
def .... = .. tension 1.5 .. enddef;
def ..... = .. tension 2.0 .. enddef;

% Arrowhead Modifications for TAOCP
ahangle := 65;
ahlength := 6;
vardef arrowhead expr p =
  save q, e, f, g; path q; pair e; pair f; pair g;
  e = point length p of p;
  q = gobble(p shifted -e cutafter makepath(pencircle scaled 2ahlength))
    cuttings;
  f = point 0 of (q rotated 0.5ahangle) shifted e;
  g = point length q of (reverse q rotated -0.5ahangle) shifted e;
  f .. {dir (angle direction length q of (q rotated 0.5ahangle) - 0.3ahangle)}e
    & e{dir (angle direction 0 of ((reverse q) rotated -0.5ahangle)+0.3ahangle)} .. g
enddef;

def _finarr text t =
  draw _apth t;
  draw arrowhead _apth t        % do not fill
enddef;

def _findarr text t =
  draw _apth t;
  draw arrowhead _apth withpen currentpen t;
  draw arrowhead reverse _apth withpen currentpen t
enddef;

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
  box(xpart(urcorner pic@#-llcorner pic@#)+6pt,
      ypart(urcorner pic@#-llcorner pic@#)+5pt)(@#)
enddef;

vardef rect@# = z@#ne--z@#nw--z@#sw--z@#se--cycle enddef;
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

def cbud (expr lbl)(suffix $) =
  z$e-z$w=(budwd,0);
  z$s=.5[z$w,z$e];
  z$n-z$s=(0,budht);
  z$=.5[z$n,z$s];
  erase fill z$n--z$w--z$e--cycle;
  draw z$n--z$w--z$e--cycle;
  draw thelabel.bot(lbl,z$s) withcolor blue;
enddef;

def lbud (expr lbl)(suffix $) =
  z$e-z$w=(budwd,0) rotated -brangle;
  z$s=.5[z$w,z$e];
  z$n-z$s=(0,budht) rotated -brangle;
  z$=.5[z$n,z$s];
  erase fill z$n--z$w--z$e--cycle;
  draw z$n--z$w--z$e--cycle;
  draw thelabel.llft(lbl,z$s) withcolor blue;
enddef;

def rbud (expr lbl)(suffix $) =
  z$e-z$w=(budwd,0) rotated brangle;
  z$s=.5[z$w,z$e];
  z$n-z$s=(0,budht) rotated brangle;
  z$=.5[z$n,z$s];
  erase fill z$n--z$w--z$e--cycle;
  draw z$n--z$w--z$e--cycle;
  draw thelabel.lrt(lbl,z$s) withcolor blue;
enddef;

def tbud (expr lbl)(suffix $) =
  z$e-z$w=(budwd,0) rotated 180;
  z$s=.5[z$w,z$e];
  z$n-z$s=(0,budht) rotated 180;
  z$=.5[z$n,z$s];
  erase fill z$n--z$w--z$e--cycle;
  draw z$n--z$w--z$e--cycle;
  draw thelabel.top(lbl,z$s) withcolor blue;
enddef;

numeric h,v; h=30pt; v=30pt;
numeric budht,budwd,brangle;
budht=10pt; budwd=6.18pt; brangle=30;

verbatimtex
  \def\matname#1{\hbox{$\overline{#1}_{}$}}
  \def\budname#1{\hbox{$\vphantom{\matname#1}#1$}}
etex;

beginfig(1) % example of a skew ternary tree
z0=origin;
z0-z100=(0,v);
z100-z1=(0,v) rotated -brangle;
z100-z101=(0,v);
z101-z2=(0,v) rotated -brangle;
z101-z3=(0,v);
z102-z3=(h,0);
z102-z4=(0,v) rotated -brangle;
z102-z5=(0,v);
z102-z6=(0,v) rotated brangle;
z104-z7=(0,v) rotated -brangle;
z104-z8=(0,v);
z104-z9=(0,v) rotated brangle;
z103-z10=(0,v);
z105-z11=(0,v) rotated -brangle;
z105-z12=(0,v);
z105-z13=(0,v) rotated brangle;
y103=y101; x103=.5[x104,x105];
z11-z9=z7-z6=(h,0);

draw z0--z100--z101--z3;
draw z1--z100--z103--z10;
draw z2--z101--z102--z5;
draw z4--z102--z6;
draw z7--z104--z9;
draw z8--z104--z103--z105--z12;
draw z11--z105--z13;

draw z102--z101--z100--z103--z104 withpen pencircle scaled 2;
draw z103--z105 withpen pencircle scaled 2;

tbud(btex\budname0 etex,0);
lbud(btex\budname1 etex,1);
lbud(btex\budname2 etex,2);
cbud(btex\matname0 etex,3);
lbud(btex\budname3 etex,4);
cbud(btex\matname2 etex,5);
rbud(btex\matname3 etex,6);
lbud(btex\budname4 etex,7);
cbud(btex\budname5 etex,8);
rbud(btex\matname4 etex,9);
cbud(btex\matname1 etex,10);
lbud(btex\budname6 etex,11);
cbud(btex\matname5 etex,12);
rbud(btex\matname6 etex,13);

pic100=btex \tt A etex;
pic101=btex \tt B etex;
pic102=btex \tt C etex;
pic103=btex \tt D etex;
pic104=btex \tt E etex;
pic105=btex \tt F etex;
pic106=btex \tt G etex;
pic107=btex \tt H etex;
pic108=btex \tt I etex;
pic109=btex \tt J etex;
pic110=btex \tt K etex;
pic111=btex \tt L etex;
pic112=btex \tt M etex;
pic113=btex \tt N etex;
pic119=btex \tt T etex;

for j=100 upto 105:
 picbox[j]; drawobox(pic[j],[j]);
endfor

drawoptions(withcolor red);
pic[-1]=btex $\scriptscriptstyle-1$ etex;
pic0=btex $\scriptscriptstyle0$ etex;
pic1=btex $\scriptscriptstyle1$ etex;
pic2=btex $\scriptscriptstyle2$ etex;
pic3=btex $\scriptscriptstyle3$ etex;
for j=1,2,7:
  label.ulft(pic[-1],z[j]-(1pt,0));
endfor
for j=3,8:
  label.urt(pic0,z[j]+(1pt,0));
endfor
for j=0,4:
  label.urt(pic0,z[j]+(3pt,0));
endfor
for j=5,9,10:
  label.urt(pic1,z[j]+(1pt,0));
endfor
for j=11:
  label.urt(pic1,z[j]+(3pt,0));
endfor
for j=6,12:
  label.urt(pic2,z[j]+(1pt,0));
endfor
for j=13:
  label.urt(pic3,z[j]+(1pt,0));
endfor

for j=100,101:
  label.rt(pic0,z[j]ne-(2pt,0));
endfor
for j=104:
  label.lft(pic0,z[j]nw+(2pt,0));
endfor
for j=102,103:
  label.rt(pic1,z[j]ne-(2pt,0));
endfor
for j=105:
  label.rt(pic2,z[j]ne-(2pt,0));
endfor

endfig;

brangle:=45;
beginfig(41) % generic tree in the Jacquet-Schaeffer bijection
z0=origin;
z0-z200=z200-z201=z201-z202=z202-z203=(0,v);
z200-z1=(0,v) rotated -brangle;
z201-z2=(0,v) rotated -brangle;
z202-z3=(0,v) rotated -brangle;
z203-z4=(0,v) rotated -brangle;
z203-z5=(0,v);
z200-z300=(0,v) rotated brangle;
z201-z301=(0,v) rotated brangle;
z202-z302=(0,v) rotated brangle;
z203-z303=(0,v) rotated brangle;

draw z200--z203 withpen pencircle scaled 2;
pic200=btex \vrule height 10pt depth 3pt width 0pt $\,a^1$ etex;
pic201=btex \vrule height 10pt depth 3pt width 0pt $\,b^1$ etex;
pic202=btex \vrule height 10pt depth 3pt width 0pt $\,c^1$ etex;
pic203=btex \vrule height 10pt depth 3pt width 0pt $\,d^1$ etex;

draw z0--z5;
draw z1--z200--z300;
draw z2--z201--z301;
draw z3--z202--z302;
draw z4--z203--z303;

tbud(btex\budname0 etex,0);
lbud(btex\budname1 etex,1);
lbud(btex\budname2 etex,2);
lbud(btex\budname3 etex,3);
lbud(btex\budname4 etex,4);
cbud(btex\matname0 etex,5);

for j=200 upto 203:
 picbox[j]; drawobox(pic[j],[j]);
endfor

label.rt(btex $A'$ etex,z300);
label.rt(btex $B'$ etex,z301);
label.rt(btex $C'$ etex,z302);
label.rt(btex $D'$ etex,z303);

endfig;

beginfig(2) % buds arranged in a circle
numeric r; r=.9in;
for j=0 upto 13:
  z[j]=(0,r) rotated (360/14 j);
  z[j+200]=(0,r+budht+8pt) rotated (360/14 j);
  z[j+300]=(0,r+budht+18pt) rotated (360/14 j);
  z[j+400]=(0,r+budht+25pt) rotated (360/14 j);
  draw ((0,0)--(.5budwd,budht)--(-.5budwd,budht)--cycle) shifted (0,r)
          rotated (360/14 j);
endfor

z100=(0,.618r);
z101=(0,.618r) rotated (2.5*360/14);
z102=(0,.618r) rotated (5*360/14);
z103=origin;
z104=(0,.618r) rotated (8*360/14);
z105=(0,.618r) rotated (12*360/14);

draw z0--z100--z101--z3;
draw z1--z100--z103--z10;
draw z2--z101--z102--z5;
draw z4--z102--z6;
draw z7--z104--z9;
draw z8--z104--z103--z105--z12;
draw z11--z105--z13;

draw z102--z101--z100--z103--z104 withpen pencircle scaled 2;
draw z103--z105 withpen pencircle scaled 2;

for j=100 upto 105:
 picbox[j]; drawobox(pic[j],[j]);
endfor

drawoptions(withcolor blue);
label(btex\budname0 etex,z200);
label(btex\budname1 etex,z201);
label(btex\budname2 etex,z202);
label(btex\matname0 etex,z203);
label(btex\budname3 etex,z204);
label(btex\matname2 etex,z205);
label(btex\matname3 etex,z206);
label(btex\budname4 etex,z207);
label(btex\budname5 etex,z208);
label(btex\matname4 etex,z209);
label(btex\matname1 etex,z210);
label(btex\budname6 etex,z211);
label(btex\matname5 etex,z212);
label(btex\matname6 etex,z213);

drawoptions(withcolor red);
for j=1,2,7:
  label(pic[-1],z[j+300]);
endfor
for j=0,3,4,8:
  label(pic0,z[j+300]);
endfor
for j=5,9,10,11:
  label(pic1,z[j+300]);
endfor
for j=6,12:
  label(pic2,z[j+300]);
endfor
for j=13:
  label(pic3,z[j+300]);
endfor

picture saveit; saveit=currentpicture;

label.ulft(pic0,z100n);
label.urt(pic0,z101n);
label.ulft(pic1,z102n-(1pt,0));
label.urt(pic1,z103n);
label.lft(pic0,z104w);
label.ulft(pic2,z105n);

z50=1/2[z1,z2];
z51=1/2[z3,z4];
z52=1/5[z6,z7];
z53=2/5[z6,z7];
z54=3/5[z6,z7];
z55=4/5[z6,z7];
z56=1/2[z9,z10];
z57=1/2[z10,z11];
z58=1/3[z13,z0];
z59=2/3[z13,z0];

drawoptions(dashed evenly withcolor 2/3green);

draw z401{z401-z301}...z50{-z50}...1/3[z100,z101]{(z100-z101) rotated -90};
draw z403{z403-z303}...z51{-z51}...1/3[z101,z102]{(z101-z102) rotated -90};
draw z406{z406-z306}...(z52-(2pt,20pt))...z52{up}...(z52+(0,20pt))...1/3[z102,z101]{(z102-z101) rotated -90};
draw z405{z405-z305}....(z53-(25pt,45pt))...z53{up}...1/3[z101,z100]{(z101-z100) rotated -90};
draw z404{z404-z304}....1.9z5...(z54-(10pt,40pt))...z54{up}...1/3[z100,z103]{(z100-z103) rotated -90};
draw z402{z402-z302}...2.3z3...2.3z4...2.3z5... (z55-(12pt,45pt))...z55...(z55+(0,20pt))...1/3[z103,z104]{(z103-z104) rotated -90};
draw z409{z409-z309}...z56{-z56}...1/3[z104,z103]{(z104-z103) rotated -90};
draw z410{z410-z310}...z57{-z57}...1/3[z103,z105]{(z103-z105) rotated -90};
draw z413{z412-z312}...(z58+(2pt,20pt))..z58{down}...1/3[z105,z103]{(z105-z103) rotated -90};
draw z412{z413-z313}...(z59+(0,20pt))...z59...(z59-(0,10pt))...1/3[z103,z100]{(z103-z100) rotated -90};

endfig;

beginfig(3) % the first part of the previous
currentpicture:=saveit;
endfig;

numeric h,v; h=13pt; v=10pt;
newinternal m,n;

def setup(expr fourn) =
  m:=0; n:=-2;
  draw (0,-2v)--(fourn*h,-2v);
  label.lft(btex $\scriptstyle-2$ etex,(-2pt,-2v));
  label.rt (btex $\scriptstyle-2$ etex,(fourn*h+2pt,-2v));
  draw (0,-1v)--(fourn*h,-1v);
  label.lft(btex $\scriptstyle-1$ etex,(-2pt,-1v));
  label.rt (btex $\scriptstyle-1$ etex,(fourn*h+2pt,-1v));
  draw (0,0v)--(fourn*h,0v);
  label.lft(btex $\scriptstyle0$ etex,(-4pt,0v));
  label.rt (btex $\scriptstyle0$ etex,(fourn*h+4pt,0v));
  draw (0,+1v)--(fourn*h,+1v);
  label.lft(btex $\scriptstyle+1$ etex,(-2pt,+1v));
  label.rt (btex $\scriptstyle+1$ etex,(fourn*h+2pt,+1v));
  draw (0,+2v)--(fourn*h,+2v);
  label.lft(btex $\scriptstyle+2$ etex,(-2pt,+2v));
  label.rt (btex $\scriptstyle+2$ etex,(fourn*h+2pt,+2v));
  drawdot (0,-2v) withpen pencircle scaled 2;
  draw (0,-2v)--(0,+2v);
enddef;

def upstep(expr lbl) =
  draw (m*h,n*v) -- hide(m:=m+1;n:=n+1)(m*h,n*v);
  drawdot (m*h,n*v) withpen pencircle scaled 2;
  label(lbl,((m-.5)*h,-3.5v));
  draw (m*h,-2v)--(m*h,+2v);
enddef;

def downstep(suffix p,q) =
  draw (m*h,n*v) -- hide(m:=m+1;n:=n-1)(m*h,n*v);
  drawdot (m*h,n*v) withpen pencircle scaled 2;
  label(pic[p],((m-.5)*h,-3.5v+4.5pt));
  label(pic[q],((m-.5)*h,-3.5v-4.5pt));
  draw (m*h,-2v)--(m*h,+2v);
enddef;  
    
def dnstep(expr lbl) =
  draw (m*h,n*v) -- hide(m:=m+1;n:=n-1)(m*h,n*v);
  drawdot (m*h,n*v) withpen pencircle scaled 2;
  label(lbl,((m-.5)*h,-3.5v));
  draw (m*h,-2v)--(m*h,+2v);
enddef;  
    
def matchup(expr p,q,t) =
  draw ((p+.5)*h,(t+.5)*v)--((q+.5)*h,(t+.5)*v) dashed evenly
                  withcolor 2/3green;
enddef;  

beginfig(4) % Alice's path from bud 0
setup(24);
upstep(btex\budname0 etex);
upstep(btex\budname1 etex);
downstep(100,101);
upstep(btex\budname2 etex);
upstep(btex\matname0 etex);
downstep(101,102);
upstep(btex\budname3 etex);
upstep(btex\matname2 etex);
upstep(btex\matname3 etex);
downstep(102,101);
downstep(101,100);
downstep(100,103);
downstep(103,104);
upstep(btex\budname4 etex);
upstep(btex\budname5 etex);
upstep(btex\matname4 etex);
downstep(104,103);
upstep(btex\matname1 etex);
downstep(103,105);
upstep(btex\budname6 etex);
upstep(btex\matname5 etex);
upstep(btex\matname6 etex);
downstep(105,103);
downstep(103,100);

saveit:=currentpicture;

matchup(1,2,-1);
matchup(3,12,-1);
matchup(4,5,0);
matchup(6,11,0);
matchup(7,10,1);
matchup(8,9,2)
matchup(15,16,1);
matchup(17,18,1);
matchup(20,23,2);
matchup(21,22,3);
endfig;

beginfig(5) % same, without the matchups
currentpicture:=saveit;
endfig;

beginfig(81) % same, but modified to $T_1^*$
setup(25);
n:=1;
downstep(119,100); % first bud is changed to a downstep
downstep(100,101);
upstep(btex\budname2 etex);
upstep(btex\matname0 etex);
downstep(101,102);
upstep(btex\budname3 etex);
upstep(btex\matname2 etex);
upstep(btex\matname3 etex);
downstep(102,101);
downstep(101,100);
downstep(100,103);
downstep(103,104);
upstep(btex\budname4 etex);
upstep(btex\budname5 etex);
upstep(btex\matname4 etex);
downstep(104,103);
upstep(btex\matname1 etex);
downstep(103,105);
upstep(btex\budname6 etex);
upstep(btex\matname5 etex);
upstep(btex\matname6 etex);
downstep(105,103);
downstep(103,100);
upstep(btex\budname0 etex);
downstep(100,119); % appended to match the new downstep
endfig;

beginfig(82) % same, but modified to $T_2^*$
setup(25);
n:=1;
downstep(119,101); % first bud is changed to a downstep
upstep(btex\matname0 etex);
downstep(101,102);
upstep(btex\budname3 etex);
upstep(btex\matname2 etex);
upstep(btex\matname3 etex);
downstep(102,101);
downstep(101,100);
downstep(100,103);
downstep(103,104);
upstep(btex\budname4 etex);
upstep(btex\budname5 etex);
upstep(btex\matname4 etex);
downstep(104,103);
upstep(btex\matname1 etex);
downstep(103,105);
upstep(btex\budname6 etex);
upstep(btex\matname5 etex);
upstep(btex\matname6 etex);
downstep(105,103);
downstep(103,100);
upstep(btex\budname0 etex);
upstep(btex\budname1 etex);
downstep(100,101);
downstep(101,119); % appended to match the new downstep
endfig;

beginfig(6) % same, but starting at bud 4
setup(24);
upstep(btex\budname4 etex);
upstep(btex\budname5 etex);
upstep(btex\matname4 etex);
downstep(104,103);
upstep(btex\matname1 etex);
downstep(103,105);
upstep(btex\budname6 etex);
upstep(btex\matname5 etex);
upstep(btex\matname6 etex);
downstep(105,103);
downstep(103,100);
upstep(btex\budname0 etex);
upstep(btex\budname1 etex);
downstep(100,101);
upstep(btex\budname2 etex);
upstep(btex\matname0 etex);
downstep(101,102);
upstep(btex\budname3 etex);
upstep(btex\matname2 etex);
upstep(btex\matname3 etex);
downstep(102,101);
downstep(101,100);
downstep(100,103);
downstep(103,104);
endfig;

beginfig(84) % same, but modified to $T_4^*$
setup(25);
n:=1;
downstep(119,104); % first bud is changed to a downstep
upstep(btex\budname5 etex);
upstep(btex\matname4 etex);
downstep(104,103);
upstep(btex\matname1 etex);
downstep(103,105);
upstep(btex\budname6 etex);
upstep(btex\matname5 etex);
upstep(btex\matname6 etex);
downstep(105,103);
downstep(103,100);
upstep(btex\budname0 etex);
upstep(btex\budname1 etex);
downstep(100,101);
upstep(btex\budname2 etex);
upstep(btex\matname0 etex);
downstep(101,102);
upstep(btex\budname3 etex);
upstep(btex\matname2 etex);
upstep(btex\matname3 etex);
downstep(102,101);
downstep(101,100);
downstep(100,103);
downstep(103,104);
downstep(104,119); % appended to match the new downstep
endfig;

beginfig(7) % same, but starting at bud 5
setup(24);
upstep(btex\budname5 etex);
upstep(btex\matname4 etex);
downstep(104,103);
upstep(btex\matname1 etex);
downstep(103,105);
upstep(btex\budname6 etex);
upstep(btex\matname5 etex);
upstep(btex\matname6 etex);
downstep(105,103);
downstep(103,100);
upstep(btex\budname0 etex);
upstep(btex\budname1 etex);
downstep(100,101);
upstep(btex\budname2 etex);
upstep(btex\matname0 etex);
downstep(101,102);
upstep(btex\budname3 etex);
upstep(btex\matname2 etex);
upstep(btex\matname3 etex);
downstep(102,101);
downstep(101,100);
downstep(100,103);
downstep(103,104);
upstep(btex\budname4 etex);
endfig;

beginfig(8) % same, but starting at bud 6
setup(24);
upstep(btex\budname6 etex);
upstep(btex\matname5 etex);
upstep(btex\matname6 etex);
downstep(105,103);
downstep(103,100);
upstep(btex\budname0 etex);
upstep(btex\budname1 etex);
downstep(100,101);
upstep(btex\budname2 etex);
upstep(btex\matname0 etex);
downstep(101,102);
upstep(btex\budname3 etex);
upstep(btex\matname2 etex);
upstep(btex\matname3 etex);
downstep(102,101);
downstep(101,100);
downstep(100,103);
downstep(103,104);
upstep(btex\budname4 etex);
upstep(btex\budname5 etex);
upstep(btex\matname4 etex);
downstep(104,103);
upstep(btex\matname1 etex);
downstep(103,105);
endfig;

def starstep(expr lbl) =
  fill (m*h,-1.5v)--((m+3)*h,-1.5v)--((m+3)*h,2v)
            ...((m+1.5)*h,2.5v)...(m*h,2v)--cycle
                  withcolor .8[green,white];
  draw (m*h,-1.5v)--((m+3)*h,-1.5v)--((m+3)*h,2v)
            ...((m+1.5)*h,2.5v)...(m*h,2v)--cycle;
  unfill bbox thelabel(lbl,(.5[m,m+3]*h,0));
  label(lbl,(.5[m,m+3]*h,0));
  n:=n+1; m:=m+3;
  drawdot (m*h,n*v) withpen pencircle scaled 2;
enddef;

beginfig(9) % same, with new labeling
setup(28);
upstep(btex \strut$a_2$ etex);
upstep(btex \strut$a_3$ etex);
dnstep(btex \strut$b_2$ etex);
upstep(btex \strut$b_3$ etex);
upstep(btex \strut$b_0$ etex);
dnstep(btex \strut$c_3$ etex);
upstep(btex \strut$c_0$ etex);
upstep(btex \strut$c_1$ etex);
upstep(btex \strut$c_2$ etex);
dnstep(btex \strut$b_1$ etex);
dnstep(btex \strut$a_0$ etex);
dnstep(btex \strut$d_3$ etex);
dnstep(btex \strut$e_2$ etex);
upstep(btex \strut$e_3$ etex);
upstep(btex \strut$e_0$ etex);
upstep(btex \strut$e_1$ etex);
dnstep(btex \strut$d_0$ etex);
upstep(btex \strut$d_1$ etex);
dnstep(btex \strut$f_0$ etex);
upstep(btex \strut$f_1$ etex);
upstep(btex \strut$f_2$ etex);
upstep(btex \strut$f_3$ etex);
dnstep(btex \strut$d_2$ etex);
dnstep(btex \strut$a_1$ etex);
dnstep(btex \strut$r_2$ etex);
dnstep(btex \strut$r_3$ etex);
dnstep(btex \strut$r_0$ etex);
dnstep(btex \strut$r_1$ etex);

matchup(1,2,-1);
matchup(3,12,-1);
matchup(4,5,0);
matchup(6,11,0);
matchup(7,10,1);
matchup(8,9,2)
matchup(15,16,1);
matchup(17,18,1);
matchup(20,23,2);
matchup(21,22,3);
matchup(0,27,-2);
matchup(13,26,-1);
matchup(14,25,0);
matchup(19,24,1);
endfig;


beginfig(42) % generic chart for Jacquet/Schaeffer
setup(24);
upstep(btex\budname0 etex);
upstep(btex\budname1 etex);
downstep(200,201);
upstep(btex\budname2 etex);
downstep(201,202);
upstep(btex\budname3 etex);
downstep(202,203);
upstep(btex\budname4 etex);
upstep(btex\matname0 etex);
starstep(btex $D^*$ etex);
downstep(203,202);
starstep(btex $C^*$ etex);
downstep(202,201);
starstep(btex $B^*$ etex);
downstep(201,200);
starstep(btex $A^*$ etex);

endfig;



h:=16pt; v:=18pt;
beginfig(10) % stripped down version of figure 1: the tree T
z100=origin;
z100-z101=(0,v);
z101-z102=(-h,v);
z100-z103=(-3h,v);
z103-z104=(h,v);
z103-z105=(-h,v);

draw z104--z103--z105;
draw z103--z100--z101--z102;

for j=100 upto 105:
 picbox[j]; drawobox(pic[j],[j]);
endfor
endfig;  

beginfig(11) % the tree T^+

z104=origin;
z104-z103=(-h,v);
z103-z105=(0,v);
z103-z100=(-h,v);
z100-z101=(-h,v);
z101-z102=(-h,v);

draw z104--z103--z105;
draw z103--z100--z101--z102;

for j=100 upto 105:
 picbox[j]; drawobox(pic[j],[j]);
endfor
endfig;  

beginfig(12) % the tree T^{++}
z104=origin;
z104-z103=(0,v);
z103-z105=(0,v);
z103-z100=(-h,v);
z100-z101=(-h,v);
z101-z102=(-h,v);

draw z104--z103--z105;
draw z103--z100--z101--z102;

for j=100 upto 105:
 picbox[j]; drawobox(pic[j],[j]);
endfor
endfig;  

beginfig(13) % the tree T^{+++}
z105=origin;
z105-z103=(-h,v);
z103-z100=(h,v);
z103-z104=(0,v);
z100-z101=(-h,v);
z101-z102=(-h,v);

draw z104--z103--z105;
draw z103--z100--z101--z102;

for j=100 upto 105:
 picbox[j]; drawobox(pic[j],[j]);
endfor
endfig;  

beginfig(100) % empty tree
label(btex $\emptyset$ etex scaled 1.2,origin);
endfig;

beginfig(101) % one-node tree A---
z100=origin;
picbox100; drawobox(pic100,100);
endfig;

beginfig(201) % same, with dot for A's middle child
z100=origin;
picbox100; drawobox(pic100,100);
drawdot z100.s-(0,5pt) withpen pencircle scaled 3;
endfig;

beginfig(200) % one-node tree B---
z101=origin;
picbox101; drawobox(pic101,101);
endfig;

beginfig(205) % one-node tree C---
z102=origin;
picbox102; drawobox(pic102,102);
endfig;

beginfig(102) % A-B- B---
z100=origin;
z101=z100-(0,v);
draw z100--z101;
picbox100; drawobox(pic100,100);
picbox101; drawobox(pic101,101);
endfig;

beginfig(202) % same, with dot for B's middle child
z100=origin;
z101=z100-(0,v);
draw z100--z101;
picbox100; drawobox(pic100,100);
picbox101; drawobox(pic101,101);
drawdot z101.s-(0,5pt) withpen pencircle scaled 3;
endfig;

beginfig(206) % C-B- B---
z102=origin;
z101=z102-(0,v);
draw z102--z101;
picbox102; drawobox(pic102,102);
picbox101; drawobox(pic101,101);
endfig;

beginfig(103) % A--B B---
z100=origin;
z101=z100+(h,-v);
draw z100--z101;
picbox100; drawobox(pic100,100);
picbox101; drawobox(pic101,101);
endfig;

beginfig(207) % B--C C---
z101=origin;
z102=z101+(h,-v);
draw z101--z102;
picbox101; drawobox(pic101,101);
picbox102; drawobox(pic102,102);
endfig;

beginfig(203) % same, with dot for A's middle child
z100=origin;
z101=z100+(h,-v);
draw z100--z101;
picbox100; drawobox(pic100,100);
picbox101; drawobox(pic101,101);
drawdot z100.s-(0,5pt) withpen pencircle scaled 3;
endfig;

beginfig(204) % same, but with dot for B's left child
z100=origin;
z101=z100+(h,-v);
draw z100--z101;
picbox100; drawobox(pic100,100);
picbox101; drawobox(pic101,101);
drawdot z101.sw-(5pt,5pt) withpen pencircle scaled 3;
endfig;

beginfig(104) % A-B- B-C- C---
z100=origin;
z101=z100-(0,v);
z102=z101-(0,v);
draw z100--z101--z102;
picbox100; drawobox(pic100,100);
picbox101; drawobox(pic101,101);
picbox102; drawobox(pic102,102);
endfig;

beginfig(105) % A-B- B--C C---
z100=origin;
z101=z100-(0,v);
z102=z101+(h,-v);
draw z100--z101--z102;
picbox100; drawobox(pic100,100);
picbox101; drawobox(pic101,101);
picbox102; drawobox(pic102,102);
endfig;

beginfig(106) % A--B BC-- C---
z100=origin;
z101=z100+(h,-v);
z102=z101-(h,v);
draw z100--z101--z102;
picbox100; drawobox(pic100,100);
picbox101; drawobox(pic101,101);
picbox102; drawobox(pic102,102);
endfig;

beginfig(107) % A-CB B--- C---
z100=origin;
z101=z100+(h,-v);
z102=z100-(0,v);
draw z101--z100--z102;
picbox100; drawobox(pic100,100);
picbox101; drawobox(pic101,101);
picbox102; drawobox(pic102,102);
endfig;

beginfig(108) % A--B B--C C---
z100=origin;
z101=z100+(h,-v);
z102=z101+(h,-v);
draw z100--z101--z102;
picbox100; drawobox(pic100,100);
picbox101; drawobox(pic101,101);
picbox102; drawobox(pic102,102);
endfig;

beginfig(109) % A--B B-C- C---
z100=origin;
z101=z100+(h,-v);
z102=z101-(0,v);
draw z100--z101--z102;
picbox100; drawobox(pic100,100);
picbox101; drawobox(pic101,101);
picbox102; drawobox(pic102,102);
endfig;

beginfig(14) % the crazy tree from J-S bijection
numeric h,v; h=25pt; v:=25pt;
z100=origin;
z101=z100+(h,-v);
z102=z101+(h,-v);
z103=z100-(0,v);
z104=z103-(0,v);
z111=z104-(0,v);
z107=z111+(3h,0);
z108=z107-(h,v);
z109=z108-(0,v);
z110=z109-(0,v);
z106=z107+(h,-v);
z105=z106-(0,v);
z112=z111+(h,-v);
z113=z112-(h,v);

draw z100--z103--z104--z111--z112--z113;
draw z100--z101--z102;
draw z104--z107--z106--z105;
draw z107--z108--z109--z110;

picture pic[];
pic100=btex \vrule height 10pt depth 3pt width 0pt $\,a^1$ etex;
pic101=btex \vrule height 10pt depth 3pt width 0pt $\,a^2$ etex;
pic102=btex \vrule height 10pt depth 3pt width 0pt $\,a^3$ etex;
pic103=btex \vrule height 10pt depth 3pt width 0pt $\,b^1$ etex;
pic104=btex \vrule height 10pt depth 3pt width 0pt $\,c^1$ etex;
pic105=btex \vrule height 10pt depth 3pt width 0pt $\,c^2$ etex;
pic106=btex \vrule height 10pt depth 3pt width 0pt $\,c^3$ etex;
pic107=btex \vrule height 10pt depth 3pt width 0pt $\,c^4$ etex;
pic108=btex \vrule height 10pt depth 3pt width 0pt $\,c^5$ etex;
pic109=btex \vrule height 10pt depth 3pt width 0pt $\,c^6$ etex;
pic110=btex \vrule height 10pt depth 3pt width 0pt $\,c^7$ etex;
pic111=btex \vrule height 10pt depth 3pt width 0pt $\,d^1$ etex;
pic112=btex \vrule height 10pt depth 3pt width 0pt $\,d^2$ etex;
pic113=btex \vrule height 10pt depth 3pt width 0pt $\,d^3$ etex;

for j=100 upto 113:
  picbox[j]; drawobox(pic[j],[j]);
endfor
endfig;

beginfig(20) % quadedge structure
numeric h,v,r; h=50pt; v=80pt; r=40pt;
z5=origin; % e
z3=z5+(h,0); % c
z2=z3+(h,0); % b
z1=z2+(2h,0); % a
z4=z3+(0,v); % d
z6=z3-(0,v); % f
z11=z2+(0,.5v); % 1
z12=z5+(0,.5v); % 2
z13=z5-(0,.5v); % 3
z14=z2-(0,.5v); % 4
z21=z1+(h,0); % I
z22=z3+(0,.5v); % II
z23=z3-(0,.5v); % III
z24=z2+(h,0); % IV

picture pic[];
verbatimtex \def\strut{\vrule height 9pt depth 3pt width 0pt \relax}
   \def\|#1{\hbox to13pt{\strut\hfil$#1$\hfil}}
   \def\\#1{\hbox to13pt{\strut\hss$\scriptstyle\rm#1$\hss}}
etex;
pic1=btex \|a etex;
pic2=btex \|b etex;
pic3=btex \|c etex;
pic4=btex \|d etex;
pic5=btex \|e etex;
pic6=btex \|f etex;
pic11=btex \|1 etex;
pic12=btex \|2 etex;
pic13=btex \|3 etex;
pic14=btex \|4 etex;
pic21=btex \\{I} etex;
pic22=btex \\{II} etex;
pic23=btex \\{III} etex;
pic24=btex \\{IV} etex;

z100=.5[z1,z21];
z101=z4+(0,.25v);
z102=z5-(.75h,0);
z103=z6-(0,.25v);

path crc[],arc[];
for j=11,12,13,14,21,22,23,24:
  picbox[j];
  if j=21: crc[j]=z100{up}...z101{left}..tension.8..
               z102{down}..tension.8..z103{right}...cycle;
  else: crc[j]=fullcircle scaled r shifted z[j];
  fi
  draw crc[j] withcolor if j<20: red else: 2/3green fi;
endfor

arc0=z12...z4...z11;
arc1=z13...z6...z14;
arc2=z101--z103;
arc3=z102{right}...z5...(z22-(.3r,0));
arc4=(z23+(.3r,0))...z2{right}...z100;
arc5=z12--z13;
arc6=z11--z14;
arc7=z13...z3...z11;
arc8=z11...z1...z14;
arc9=z2--z24;
arc10=z22--z23;
arc11=z103--z23;

for j=0 upto 8: draw arc[j]; endfor

for j=11 upto 14:
  erase fill crc[j];
  draw crc[j] withcolor red;
  label(pic[j],z[j]) withcolor red;
endfor

for j=21 upto 24:
  if j>21: erase fill crc[j]; fi
  draw crc[j] withcolor 1/3green;
  label(pic[j],z[j]) withcolor 1/3green;
endfor

for j=1 upto 6:
  picbox[j]; drawobox(pic[j],[j]);
endfor

numeric ds; ds=3bp; % dot size
def connect(suffix j,k) =
  pair pp; pp=arc[j] intersectionpoint crc[k];
  erase fill fullcircle scaled ds shifted pp;
  draw fullcircle scaled ds shifted pp;
enddef;

connect(4,21); % a
connect(4,24);
connect(8,11);
connect(8,14);
connect(6,11); % b
connect(6,14);
connect(4,23);
connect(9,24);
connect(7,11); % c
connect(7,13);
connect(10,22);
connect(10,23);
connect(2,21); % d
connect(2,22);
connect(0,11);
connect(0,12);
connect(5,12); % e
connect(5,13);
connect(3,21);
connect(3,22);
connect(11,21); % f
connect(11,23);
connect(1,13);
connect(1,14);

def orient(expr ang)(suffix j) =
  draw arrowhead 
         ((((.5r,0) rotated (ang-30))...((.5r,0) rotated ang)) shifted z[j]);
enddef;

drawoptions(withcolor red);
orient(-20,11);
orient(80,11);
orient(180,11);
orient(250,11);
orient(-10,12);
orient(170,12);
orient(-15,13);
orient(75,13);
orient(200,13);
orient(20,14);
orient(160,14);
orient(-75,14);

defaultfont:="cmr5";
label.urt("2",z1.n);
label.lrt("0",z1.s);
label.lrt("0",z2.s);
label.urt("2",z2.n);
label.lft("0",z3.w-(0,2pt));
label.rt("2",z3.e+(0,3pt));
label.urt("2",z4.e);
label.ulft("0",z4.w);
label.urt("2",z5.n);
label.lrt("0",z5.s);
label.llft("0",z6.w);
label.lrt("2",z6.e);

drawoptions(withcolor 1/3green);
orient(0,22);
orient(160,22);
orient(255,22);
orient(80,23);
orient(-30,23);
orient(180,23);
orient(90,24);
orient(270,24);
draw arrowhead subpath (1,.5) of crc21;
draw arrowhead subpath (2,1.3) of crc21;
draw arrowhead subpath (3,2.7) of crc21;
draw arrowhead subpath (4,3.5) of crc21;

label.urt("1",z1.e);
label.ulft("3",z1.w);
label.ulft("3",z2.w);
label.urt("1",z2.e);
label.lrt("1",z3.s);
label.urt("3",z3.n);
label.lrt("1",z4.s);
label.urt("3",z4.n);
label.rt("1",z5.e);
label.ulft("3",z5.w);
label.urt("3",z6.n);
label.lrt("1",z6.s);

endfig;

beginfig(21) % planar graph for that example: vertices 1--4 and faces I--IV
numeric h,v; h=80pt; v=50pt;

z13=origin;
z12=(0,v);
z14=(h,0);
z11=(h,v);
z22=.3[z12,z14];
z23=.7[z12,z14];
z24=1/3[.6[z14,z11],z21];
z21=(1.6h,.6v);

z20=1/2[z24,z21];

join_radius:=10;

draw z11--z12--z13--z14--cycle;
draw z11--z13;
draw (z11--(x20,y11)) softjoin ((x20,y11)--(x20,y14)) softjoin ((x20,y14)--z14);

drawoptions(withcolor red);
for j=11,12,13,14:
  picbox[j];
  drawobox(pic[j],[j]);
endfor;

drawoptions(withcolor 1/3green);
for j=21,22,23,24:
  picbox[j];
  label(pic[j],z[j]);
endfor

drawoptions();
interim labeloffset:=0;
label.top(pic4,1/2[z12,z11]);
label.lft(pic5,1/2[z12,z13]);
label.ulft(pic3,.6[z13,z11]);
label.lft(pic2,.6[z11,z14]);
label.lft(pic1,(x20,2/3[y11,y14]));
label.bot(pic6,1/2[z13,z14]-(0,1pt));

endfig;

beginfig(22) % dual planar graph for that example: vertices I--IV and faces 1--4
numeric h,v; h=80pt; v=50pt;

z13=origin;
z12=(0,v);
z14=(h,0);
z11=(h,v);
z22=.3[z12,z14];
z23=.7[z12,z14];
z24=1/3[.6[z14,z11],z21];
z21=(1.6h,.6v);

z25=(x24,y11+12pt);
z26=(x21+20pt,y25+10pt);
z27=(x24,y14-10pt);

join_radius:=10;
draw z22--z23--z24--z21;
draw (z22--(x22,y25)) softjoin ((x22,y25)--(x21,y25)) softjoin ((x21,y25)--z21);
draw (z22--(-10pt,y22)) softjoin ((-10pt,y22)--(-10pt,y26)) softjoin
       ((-10pt,y26)--z26) softjoin (z26--(x26,y21)) softjoin ((x26,y21)--z21);
draw (z23--(x23,y27)) softjoin ((x23,y27)--(x21,y27)) softjoin ((x21,y27)--z21);

drawoptions(withcolor red);
for j=11,12,13,14:
  picbox[j];
  label(pic[j],z[j]);
endfor;

drawoptions(withcolor 1/3green);
for j=21,22,23,24:
  picbox[j];
  drawobox(pic[j],[j]);
endfor

drawoptions();
label.bot(pic1,1/2[z24,z21]);
label.ulft(pic2,1/2[z23,z24]);
label.llft(pic3,1/2[z22,z23]);
label.ulft(pic4,(x22,1/2[y22,y25]));
label.bot(pic5,(0,y22));
label.llft(pic6,(x23,1/2[y23,y27]));

endfig;

beginfig(23) % another drawing of the example planar graph: Face II external
numeric h,v; h=80pt; v=50pt;

z13=origin;
z12=(0,v);
z14=(h,0);
z11=(h,v);
z22=.3[z12,z14];
z23=.7[z12,z14];
z24=1/3[.6[z14,z11],z21];
z21=(1.6h,.6v);

z20=1/2[z24,z21];

z15=z13-(.5h,.5v);
z16=(x21+(x21-x20),y15);
z17=(x16,y11+.5v);

join_radius:=10;

draw z12--z13--z14--z11;
draw z11--z13;
draw (z11--(x20,y11)) softjoin ((x20,y11)--(x20,y14)) softjoin ((x20,y14)--z14);
draw (z12--(x15,y12)) softjoin ((x15,y12)--z15) softjoin (z15--z16) softjoin
         (z16--z17) softjoin (z17--(x11,y17)) softjoin ((x11,y17)--z11);

drawoptions(withcolor red);
for j=11,12,13,14:
  picbox[j];
  drawobox(pic[j],[j]);
endfor;

drawoptions(withcolor 1/3green);
for j=21,22,23,24:
  picbox[j];
  label(pic[j],z[j]);
endfor

drawoptions();
interim labeloffset:=0;
label.top(pic4,.1[z15,z16]+(0,1pt));
label.lft(pic5,1/2[z12,z13]);
label.ulft(pic3,.6[z13,z11]);
label.lft(pic2,.6[z11,z14]);
label.lft(pic1,(x20,2/3[y11,y14]));
label.bot(pic6,1/2[z13,z14]-(0,2pt));

endfig;

beginfig(24) % another drawing of the example planar graph: Face III external
numeric h,v; h=80pt; v=50pt;

z13=origin;
z12=(0,v);
z14=(h,0);
z11=(h,v);
z22=.3[z12,z14];
z23=.7[z12,z14];
z24=1/3[.6[z14,z11],z21];
z21=(1.6h,.6v);

z20=1/2[z24,z21];

z15=z12+(-.5h,.5v);
z16=(x21+(x21-x20),y15);
z17=(x16,y14-.5v);

join_radius:=10;

draw z14--z11--z12--z13;
draw z11--z13;
draw (z11--(x20,y11)) softjoin ((x20,y11)--(x20,y14)) softjoin ((x20,y14)--z14);
draw (z13--(x15,y13)) softjoin ((x15,y13)--z15) softjoin (z15--z16) softjoin
              (z16--z17) softjoin (z17--(x14,y17)) softjoin ((x14,y17)--z14);

drawoptions(withcolor red);
for j=11,12,13,14:
  picbox[j];
  drawobox(pic[j],[j]);
endfor;

drawoptions(withcolor 1/3green);
for j=21,22,23,24:
  picbox[j];
  label(pic[j],z[j]);
endfor

drawoptions();
interim labeloffset:=0;
label.top(pic4,1/2[z12,z11]);
label.lft(pic5,1/2[z12,z13]);
label.ulft(pic3,.6[z13,z11]);
label.lft(pic2,.6[z11,z14]);
label.lft(pic1,(x20,2/3[y11,y14]));
label.top(pic6,(x20,y17)+(5pt,2pt));

endfig;

beginfig(25) % another drawing of the example planar graph: Face IV external
numeric h,v; h=80pt; v=50pt;

z13=origin;
z12=(0,v);
z14=(h,0);
z11=(h,v);
z22=.3[z12,z14];
z23=.7[z12,z14];
z24=1/3[.6[z14,z11],z21];
z21=(1.6h,.6v);

z20=1/2[z24,z21];

z15=z13-(.5h,.5v);
z16=z12+(-.5h,.5v);

join_radius:=10;

draw z11--z12--z13--z14--cycle;
draw z11--z13;
draw (z11--(x11,y15)) softjoin ((x11,y15)--z15) softjoin (z15--z16) softjoin
               (z16--(x14,y16)) softjoin ((x14,y16)--z14);

drawoptions(withcolor red);
for j=11,12,13,14:
  picbox[j];
  drawobox(pic[j],[j]);
endfor;

drawoptions(withcolor 1/3green);
for j=22,23,24:
  picbox[j];
  label(pic[j],z[j]);
endfor
picbox21; label(pic21,(.5[x15,x12],y21));

drawoptions();
interim labeloffset:=0;
label.top(pic4,1/2[z12,z11]);
label.lft(pic5,1/2[z12,z13]);
label.ulft(pic3,.6[z13,z11]);
label.lft(pic2,.6[z11,z14]);
label.lrt(pic1,(x15,y13));
label.bot(pic6,1/2[z13,z14]-(0,1pt));

endfig;

numeric ds; ds=4bp; % dot size
vardef gvert@# =
  fill (fullcircle scaled ds) shifted z@# withcolor .5[red,white];
  draw  (fullcircle scaled ds) shifted z@#;
enddef;

beginfig(40) % example decomposition of an RNBPM
numeric h,v; h=30pt; v=30pt;
z0=origin; % position of the root label
z0=.5[z10,z50]-(0,2v);
z10-z11=(1.75h,0);
z20-z21=z40-z41=z41-z42=(h,0);
z30-z31=z31-z32=z32-z33=(1.5h,0);
z13=z10; z22=z20; z37=z30; z44=z40;
z20=z11; z30=z21; z40=z33; z50=z42;
z12=.5[z10,z11]-(0,v);
z34=.75[z30,z33]-(0,3/4v);
z35=.5[z30,z33]-(0,v);
z36=.25[z30,z33]-(0,3/4v);
z43=z41-(0,.5v);

join_radius:=10;
draw (z50--(x50,0)) softjoin ((x50,0)--(x10,0)) softjoin ((x10,0)--z10);
fill z10--z11--z12--cycle withcolor .8[green,white];
draw z10--z11--z12--z13;
draw z20--z21;
fill z30--z31--z32--z33--z34--z35--z36--cycle withcolor .8[green,white];
draw z30--z31--z32--z33--z34--z35--z36--z37;
fill  z40--z41--z42...z43...cycle withcolor .8[green,white];
draw z40--z41--z42...z43...z44;

for j=10,11,12,21,31,32,33,34,35,36,41,42: gvert[j]; endfor

draw arrowhead (z0-(h,0))--(z0+(h,0));

label.bot(btex $r$ etex,z0-(0,2pt));
label.top(btex $a^1$ etex, .5[z10,z11]);
label.llft(btex $a^2$ etex, .5[z11,z12]);
label.lrt(btex $a^3$ etex, .5[z12,z13]-(3pt,0));
label.top(btex $b^1$ etex, .5[z20,z21]);
label.top(btex $c^1$ etex, .5[z30,z31]);
label.top(btex $c^2$ etex, .5[z31,z32]);
label.top(btex $c^3$ etex, .5[z32,z33]);
label.llft(btex $c^4$ etex, .5[z33,z34]);
label.llft(btex $c^5$ etex, .5[z34,z35]);
label.lrt (btex $c^6$ etex, .5[z35,z36]);
label.lrt (btex $c^7$ etex, .5[z36,z37]-(1pt,0));
label.top(btex $d^{\mskip1mu1}$ etex, .5[z40,z41]);
label.top(btex $d^{\mskip1mu2}$ etex, .5[z41,z42]);
label.bot(btex $d^{\mskip1mu3}$ etex, z43);

endfig;

beginfig(30) % smallest RNBPM
z0=origin; z1=(h,0);
draw z0--z1;
draw arrowhead z0--3/4[z0,z1];
gvert0; gvert1;
label.bot(btex $r$ etex,.4[z0,z1]);
endfig;

beginfig(31) % next-smallest RNBPM
z0=origin; z2=z0+(0,.5v);
z1=z3+(h,0); .5[z1,z3]=.5[z0,z2];
draw z3...z0...z1;
draw z1...z2...z3;
draw arrowhead subpath (0,1.618) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $a$ etex,z2);
gvert1; gvert3;
endfig;

beginfig(32) % 3-edge RNBPM m=1
z0=origin; z2=z0+(0,v);
z1=z3+(h,0); .5[z1,z3]=2/5[z0,z2];
draw z3...z0...z1;
draw z1...z2...z3;
draw z1--z3;
draw arrowhead subpath (0,1.618) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $a$ etex,z2);
label.top(btex $b$ etex,.5[z1,z3]);
gvert1; gvert3;
endfig;

beginfig(33) % 3-edge RNBPM m=2
z0=origin; z1=(h,0);
z2=z1 rotated 60;
draw z0--z1--z2--cycle;
draw arrowhead z0--3/4[z0,z1];
label.bot(btex $r$ etex,.4[z0,z1]);
label.urt(btex $a$ etex,.382[z1,z2]);
label.ulft(btex $b$ etex,.618[z2,z0]);
gvert0; gvert1; gvert2;
endfig;

beginfig(34) % 4-edge RNBPM m=1 #1
z0=origin; z2=z0+(0,1.5v);
z1=z3+(h,0); .5[z1,z3]=1/2[z0,z2];
z4=.27[z0,z2]; z5=.55[z4,z2];
draw z3...z0...z1;
draw z3...z4...z1;
draw z1...z2...z3;
draw z1...z5...z3;
draw arrowhead subpath (0,1.5) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $a$ etex,z2);
label.top(btex $b$ etex,z4);
label.top(btex $c$ etex,z5);
gvert1; gvert3;
endfig;

beginfig(35) % 4-edge RNBPM m=1 #2
z0=origin; z1=(h,0);
z2=z1 rotated 60;
draw z0--z1--z2--cycle;
z3=.5[z0,z1]-(0,2/5v);
draw z0...z3...z1;
draw arrowhead subpath (0,1.5) of (z0...z3...z1);
label.bot(btex $r$ etex,z3);
label.urt(btex $a$ etex,.5[z1,z2]);
label.ulft(btex $b$ etex,.5[z2,z0]);
label.top(btex $c$ etex,.5[z0,z1]);
gvert0; gvert1; gvert2;
endfig;

beginfig(36) % 4-edge RNBPM m=1 #3
z0=origin; z2=z0+(0,v);
z1=z3+(1.5h,0); z4= .5[z1,z3]=2/5[z0,z2];
draw z3...z0...z1;
draw z1...z2...z3;
draw z1--z3;
draw arrowhead subpath (0,1.618) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $a$ etex,z2);
label.top(btex $c$ etex,.5[z1,z4]);
label.top(btex $b$ etex,.5[z4,z3]);
gvert1; gvert3; gvert4;
endfig;

beginfig(37) % 4-edge RNBPM m=2 #1
z0=origin; z2=z0+(0,v);
z1=z3+(1.5h,0); z4= .5[z1,z3]=.5[z0,z2];
z5=(.5[x4,x1],y2);
draw z3...z0...z1;
draw z1...z5...z4;
draw z1--z3;
draw arrowhead subpath (0,1.618) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $a$ etex,z5);
label.top(btex $c$ etex,.5[z1,z4]);
label.top(btex $b$ etex,.5[z4,z3]);
gvert1; gvert3; gvert4;
endfig;

beginfig(38) % 4-edge RNBPM m=2 $2
z0=origin; z2=z0+(0,v);
z1=z3+(1.5h,0); z4= .5[z1,z3]=.5[z0,z2];
z5=(.5[x4,x3],y2);
draw z3...z0...z1;
draw z3...z5...z4;
draw z1--z3;
draw arrowhead subpath (0,1.618) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $b$ etex,z5);
label.top(btex $a$ etex,.5[z1,z4]);
label.top(btex $c$ etex,.5[z4,z3]);
gvert1; gvert3; gvert4;
endfig;

beginfig(39) % 4-edge RNBPM m=3
z0=origin; z1=(h,0); z2=(h,v); z3=(0,v);
draw z0--z1--z2--z3--cycle;
draw arrowhead z0--3/4[z0,z1];
label.bot(btex $r$ etex,.4[z0,z1]);
label.rt(btex $a$ etex,.5[z1,z2]);
label.top(btex $b$ etex,.5[z2,z3]);
label.lft(btex $c$ etex,.5[z3,z0]);
gvert0; gvert1; gvert2; gvert3;
endfig;

beginfig(90) % smallest RNBPM
z0=origin; z1=(h,0);
draw z0--z1;
draw arrowhead z0--3/4[z0,z1];
gvert0; gvert1;
label.bot(btex $r$ etex,.4[z0,z1]);
endfig;

beginfig(91) % next-smallest RNBPM
z0=origin; z2=z0+(0,.5v);
z1=z3+(h,0); .5[z1,z3]=.5[z0,z2];
draw z3...z0...z1;
draw z1...z2...z3;
draw arrowhead subpath (0,1.618) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $a$ etex,z2);
gvert1; gvert3;
endfig;

beginfig(92) % 3-edge RNBPM m=1
z0=origin; z2=z0+(0,v);
z1=z3+(h,0); .5[z1,z3]=2/5[z0,z2];
draw z3...z0...z1;
draw z1...z2...z3;
draw z1--z3;
draw arrowhead subpath (0,1.618) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $b$ etex,z2);
label.top(btex $a$ etex,.5[z1,z3]);
gvert1; gvert3;
endfig;

beginfig(93) % 3-edge RNBPM m=2
z0=origin; z1=(h,0);
z2=z1 rotated 60;
draw z0--z1--z2--cycle;
draw arrowhead z0--3/4[z0,z1];
label.bot(btex $r$ etex,.4[z0,z1]);
label.urt(btex $a$ etex,.382[z1,z2]);
label.ulft(btex $b$ etex,.618[z2,z0]);
gvert0; gvert1; gvert2;
endfig;

beginfig(94) % 4-edge RNBPM m=1 #1
z0=origin; z2=z0+(0,1.5v);
z1=z3+(h,0); .5[z1,z3]=1/2[z0,z2];
z4=.27[z0,z2]; z5=.55[z4,z2];
draw z3...z0...z1;
draw z3...z4...z1;
draw z1...z2...z3;
draw z1...z5...z3;
draw arrowhead subpath (0,1.5) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $c$ etex,z2);
label.top(btex $a$ etex,z4);
label.top(btex $b$ etex,z5);
gvert1; gvert3;
endfig;

beginfig(95) % 4-edge RNBPM m=1 #2
z0=origin; z1=(h,0);
z2=z1 rotated 60;
draw z0--z1--z2--cycle;
z3=.5[z0,z1]-(0,2/5v);
draw z0...z3...z1;
draw arrowhead subpath (0,1.5) of (z0...z3...z1);
label.bot(btex $r$ etex,z3);
label.urt(btex $b$ etex,.5[z1,z2]);
label.ulft(btex $c$ etex,.5[z2,z0]);
label.top(btex $a$ etex,.5[z0,z1]);
gvert0; gvert1; gvert2;
endfig;

beginfig(96) % 4-edge RNBPM m=1 #3
z0=origin; z2=z0+(0,v);
z1=z3+(1.5h,0); z4= .5[z1,z3]=2/5[z0,z2];
draw z3...z0...z1;
draw z1...z2...z3;
draw z1--z3;
draw arrowhead subpath (0,1.618) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $c$ etex,z2);
label.top(btex $a$ etex,.5[z1,z4]);
label.top(btex $b$ etex,.5[z4,z3]);
gvert1; gvert3; gvert4;
endfig;

beginfig(97) % 4-edge RNBPM m=2 #1
z0=origin; z2=z0+(0,v);
z1=z3+(1.5h,0); z4= .5[z1,z3]=.5[z0,z2];
z5=(.5[x4,x1],y2);
draw z3...z0...z1;
draw z1...z5...z4;
draw z1--z3;
draw arrowhead subpath (0,1.618) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $c$ etex,z5);
label.top(btex $a$ etex,.5[z1,z4]);
label.top(btex $b$ etex,.5[z4,z3]);
gvert1; gvert3; gvert4;
endfig;

beginfig(98) % 4-edge RNBPM m=2 $2
z0=origin; z2=z0+(0,v);
z1=z3+(1.5h,0); z4= .5[z1,z3]=.5[z0,z2];
z5=(.5[x4,x3],y2);
draw z3...z0...z1;
draw z3...z5...z4;
draw z1--z3;
draw arrowhead subpath (0,1.618) of (z3...z0...z1);
label.bot(btex $r$ etex,z0);
label.top(btex $b$ etex,z5);
label.top(btex $a$ etex,.5[z1,z4]);
label.top(btex $c$ etex,.5[z4,z3]);
gvert1; gvert3; gvert4;
endfig;

beginfig(99) % 4-edge RNBPM m=3
z0=origin; z1=(h,0); z2=(h,v); z3=(0,v);
draw z0--z1--z2--z3--cycle;
draw arrowhead z0--3/4[z0,z1];
label.bot(btex $r$ etex,.4[z0,z1]);
label.rt(btex $a$ etex,.5[z1,z2]);
label.top(btex $b$ etex,.5[z2,z3]);
label.lft(btex $c$ etex,.5[z3,z0]);
gvert0; gvert1; gvert2; gvert3;
endfig;

beginfig(110) % RNBPM from DDP in main example, A-BD B--C C--- DE-F E--- F---
numeric h,v; h=40pt; v=30pt;
z0=origin; z1=(h,0); z2=(h,v); z3=(0,v);
z4=.5[z0,z3]-(.4h,0);
z5=.5[z0,z3];
z6=.5[z2,z3]+(0,2/3v);
z7=.5[z0,z3]-(h,0);
z8=.5[z1,z2]+(1/2h,0);
draw z0--z1--z2--z3...z4...z0;
draw z1--z3;
draw z3...z5...z0;
draw (z1--(x8,y1)) softjoin ((x8,y1)--(x8,y6)) softjoin
       ((x8,y6)--(x7,y6)) softjoin ((x7,y6)--(x7,y0)) softjoin ((x7,y0)--z0);
draw arrowhead z0--3/4[z0,z1];
gvert0; gvert1; gvert2; gvert3;
label.bot(btex $r$ etex,.4[z0,z1]);
label.rt(btex $e$ etex,z8);
label.rt(btex $b$ etex,.5[z1,z2]);
label.top(btex $c$ etex,.5[z2,z3]);
label.lft(btex $d$ etex,z4);
label.rt(btex $f$ etex,z5-(0,2pt));
label.urt(btex $a$ etex,.5[z1,z3]);
endfig;



beginfig(50) % the join operation
numeric u; u=25pt;
verbatimtex \def\join#1{\buildrel #1 \over\bowtie} etex;
def setup =
  z0=origin; 
  z1=z0+(u,0);
  z2=z1+(0,u);
  z3=z2-(u,0);
  z100=z1+(3u,0);
  z101=z100+(u,0);
  z102=z101+((u,0) rotated 72);
  z103=z102+((u,0) rotated 144);
  z104=z103+((u,0) rotated 216);

  transform t;
  t=((identity shifted -z100) rotated 60) shifted z503;

  for j=0 upto 3: z[j+500]=z[j]+(10u,0); endfor
  for j=100 upto 104: z[j+500]=z[j] transformed t; endfor
  z550=z502+(u,0);

  fill z500--z501--z502--z503--cycle withcolor .8[green,white];
  draw z500--z501--z502--z503--cycle;
  draw arrowhead z500--.6[z500,z501];
  fill z600--z601--z602--z603--z604--cycle withcolor .8[green,white];
  draw z601--z602--z603--z604--z600;

  label.rt(btex $a^1$ etex, .5[z501,z502]);
  label.top(btex $a^2$ etex, .5[z502,z503]+(3pt,0));
  label.lft(btex $a^3$ etex, .5[z503,z500]);
  label.urt(btex $b^1$ etex, .5[z601,z602]);
  label.ulft(btex $b^2$ etex, .5[z602,z603]+(2pt,0));
  label.lft(btex $b^3$ etex, .5[z603,z604]);
  label.llft(btex $b^4$ etex, .5[z604,z600]+(2pt,0));

enddef;

setup;

fill z0--z1--z2--z3--cycle withcolor .8[green,white];
fill z100--z101--z102--z103--z104--cycle withcolor .8[green,white];

draw z0--z1--z2--z3--cycle;
draw z100--z101--z102--z103--z104--cycle;
draw arrowhead z0--.6[z0,z1];
draw arrowhead z100--.6[z100,z101];
draw arrowhead z2--.7[z2,z3];

label.rt(btex $a^1$ etex, .5[z1,z2]);
label.top(btex $a^2$ etex, .5[z2,z3]+(3pt,3pt));
label.lft(btex $a^3$ etex, .5[z3,z0]);
label.lrt(btex $b^1$ etex, .5[z101,z102]);
label.urt(btex $b^2$ etex, .5[z102,z103]);
label.ulft(btex $b^3$ etex, .5[z103,z104]);
label.llft(btex $b^4$ etex, .5[z104,z100]);

draw z600--z601 dashed evenly;
draw z501...z550...z601;
label.rt(btex $c$ etex, z550);

for j=0 upto 3: gvert[j]; gvert[j+500]; endfor
for j=100 upto 104: gvert[j]; gvert[j+500]; endfor

label (btex \strut$\join c$ etex,.45[z1,z100]+(0,.75u));
label (btex \strut$=$ etex, .5[z101,z500]+(0,.75u));

endfig;

beginfig(51) % preliminary splice while joining up that figure
setup;
draw z600--z601;
for j=0 upto 3: gvert[j+500]; endfor
for j=100 upto 104: gvert[j+500]; endfor
label.rt(btex $c$ etex,.6[z600,z601]);
endfig;

beginfig(52) % the next splice, which moves the former root edge out
setup;
draw z600--z601 dashed evenly;
z504=z601+(u,0);
draw z601--z504;

for j=0 upto 4: gvert[j+500]; endfor
for j=100 upto 104: gvert[j+500]; endfor
label.rt(btex $c$ etex,z504);
endfig;


bye.



  
