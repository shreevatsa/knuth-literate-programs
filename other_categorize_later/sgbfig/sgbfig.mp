extra_endfig:="special exactbb;"; % gives decimal points in the bounding box
vardef exactbb=
  "%%%ExactBoundingBox:"
  for p=llcorner currentpicture, urcorner currentpicture:
    & " " & decimal xpart p
    & " " & decimal ypart p
  endfor
enddef;

hsize=33pc; vsize=44pc;
dispindent=40pt; % cf \begindialog in gbmac.tex

verbatimtex
\font\ninerm=cmr9
\let\mc=\ninerm
\font\eightrm=cmr8
\let\sc=\eightrm
\def\_{\leavevmode \kern.06em
  {\ninerm\lower.4ex\hbox{-}\kern-.08em}}
   % PostScript needs a "hint", or it won't do the rule consistently
   % so we use a font character instead of the \_
   % (yes, it's a kludge)

\setbox\strutbox=\hbox{\vrule height8bp depth3bp width 0bp}
\def\,{\relax\ifmmode\mskip\thinmuskip\else\thinspace\fi}

\def\ASSIGNLISA/{{\sc ASSIGN\_\allowbreak\,LISA}}
\def\BOOKCOMPONENTS/{{\sc BOOK\_\allowbreak\kern.05emCOMPONENTS}}
\def\ECONORDER/{{\sc ECON\_\allowbreak\,ORDER}}
\def\FOOTBALL/{{\sc FOOTBALL}}
\def\GBBASIC/{{\sc GB\_\,BASIC}}
\def\GBBOOKS/{{\sc GB\_\,BOOKS}}
\def\GBDIJK/{{\sc GB\_\,DIJK}}
\def\GBECON/{{\sc GB\_\,ECON}}
\def\GBFLIP/{{\sc GB\_\,FLIP}}
\def\GBGAMES/{{\sc GB\_\,GAMES}}
\def\GBGATES/{{\sc GB\_\,GATES}}
\def\GBGRAPH/{{\sc GB\_\,GRAPH}}
\def\GBIO/{{\sc GB\_\,IO}}
\def\GBLISA/{{\sc GB\_\,LISA}}
\def\GBMILES/{{\sc GB\_\,MILES}}
\def\GBPLANE/{{\sc GB\_\,PLANE}}
\def\GBRAMAN/{{\sc GB\_\,RAMAN}}
\def\GBRAND/{{\sc GB\_\,RAND}}
\def\GBROGET/{{\sc GB\_\,ROGET}}
\def\GBSAVE/{{\sc GB\_\,SAVE}}
\def\GBSORT/{{\sc GB\_\,SORT}}
\def\GBWORDS/{{\sc GB\_WORDS}}
\def\GIRTH/{{\sc GIRTH}}
\def\LADDERS/{{\sc LADDERS}}
\def\MILESSPAN/{{\sc MILES\_\allowbreak\,SPAN}}
\def\MULTIPLY/{{\sc MULTIPLY}}
\def\QUEEN/{{\sc QUEEN}}
\def\QUEENWRAP/{{\sc QUEEN\_\allowbreakWRAP}}
\def\ROGETCOMPONENTS/{{\sc ROGET\_\allowbreak\,COMPONENTS}}
\def\TAKERISC/{{\sc TAKE\_\allowbreak\,RISC}}
\def\TESTSAMPLE/{{\sc TEST\_\allowbreak\,SAMPLE}}
\def\WORDCOMPONENTS/{{\sc WORD\_\allowbreak\,COMPONENTS}}
etex

def ledge = xpart llcorner enddef; % left edge of picture
def redge = xpart urcorner enddef;
def tedge = ypart ulcorner enddef;
def bedge = ypart lrcorner enddef;
vardef lpoint primary a = .5[llcorner a,ulcorner a] enddef;
vardef rpoint primary a = .5[lrcorner a,urcorner a] enddef;
vardef tpoint primary a = .5[ulcorner a,urcorner a] enddef;
vardef bpoint primary a = .5[llcorner a,lrcorner a] enddef;

numeric superness;
def superellipse(expr x,y,dx,dy) =
  (x+dx,y){up}...
  (x+superness*dx,y+superness*dy){-dx,dy}...
  (x,y+dy){left}...
  (x-superness*dx,y+superness*dy){-dx,-dy}...
  (x-dx,y){down}...
  (x-superness*dx,y-superness*dy){dx,-dy}...
  (x,y-dy){right}...
  (x+superness*dx,y-superness*dy){dx,dy}...
  cycle enddef;

beginfig(1);
numeric w,h,m,gap,hold;
w=hsize; % width of illustration
h=vsize-20; % height of illustration
m=.38197hsize; % left margin of generator names
gap=5; % distance between small features
hold=5; % distance of pure straightness in connecting lines

def connect(expr a,b) =
 draw a--(a+(hold,0)){right}..tension 0.8..{right}(b-(hold,0))--b enddef;

forsuffixes $=words,roget,anna,david,homer,huck,jean,econ,games,miles,lisa:
 picture $.dat.pic;
 $.dat.pic=(str$ & ".dat") infont "cmtt10";
 setbounds $.dat.pic to (ledge $.dat.pic,-3)--(redge $.dat.pic,-3)--
                        (redge $.dat.pic,8)--(ledge $.dat.pic,8)--cycle;
 pair $.dat.off, $.dat.r;
 $.dat.off=(0,$.dat.y);
 $.dat.r=rpoint $.dat.pic + $.dat.off + (gap,0);
endfor

forsuffixes $=gb_words,gb_roget,gb_books,gb_econ,gb_games,gb_miles,gb_plane,
   gb_lisa,gb_raman,gb_gates,gb_rand,gb_basic,
   word_components,ladders,roget_components,book_components,econ_order,
   football,miles_span,assign_lisa,girth,take_risc,multiply,queen,
   kernel,gb_dijk,gb_save:
  picture $.pic; % TeX output
  pair $.off; % shift amount
  pair $.l,$.r; % connectors
  $.off=($.x,$.y);
endfor

gb_words.pic=btex \GBWORDS/\strut etex;
gb_roget.pic=btex \GBROGET/\strut etex;
gb_books.pic=btex \GBBOOKS/\strut etex;
gb_econ.pic=btex \GBECON/\strut etex;
gb_games.pic=btex \GBGAMES/\strut etex;
gb_miles.pic=btex \GBMILES/\strut etex;
gb_plane.pic=btex \GBPLANE/\strut etex;
gb_lisa.pic=btex \GBLISA/\strut etex;
gb_raman.pic=btex \GBRAMAN/\strut etex;
gb_gates.pic=btex \GBGATES/\strut etex;
gb_rand.pic=btex \GBRAND/\strut etex;
gb_basic.pic=btex \GBBASIC/\strut etex;
word_components.pic=btex \WORDCOMPONENTS/\strut etex;
ladders.pic=btex \LADDERS/\strut etex;
roget_components.pic=btex \ROGETCOMPONENTS/\strut etex;
book_components.pic=btex \BOOKCOMPONENTS/\strut etex;
econ_order.pic=btex \ECONORDER/\strut etex;
football.pic=btex \FOOTBALL/\strut etex;
miles_span.pic=btex \MILESSPAN/\strut etex;
assign_lisa.pic=btex \ASSIGNLISA/\strut etex;
girth.pic=btex \GIRTH/\strut etex;
take_risc.pic=btex \TAKERISC/\strut etex;
multiply.pic=btex \MULTIPLY/\strut etex;
queen.pic=btex \QUEEN/\strut etex;
kernel.pic=btex \GBGRAPH/\qquad\GBIO/\qquad\GBFLIP/\qquad\GBSORT/\strut etex;
gb_dijk.pic=btex \GBDIJK/\strut etex;
gb_save.pic=btex \GBSAVE/\strut etex;

forsuffixes $=gb_words,gb_roget,gb_books,gb_econ,gb_games,gb_miles,gb_plane,
   gb_lisa,gb_raman,gb_gates,gb_rand,gb_basic:
  $.x=m;
  $.r=rpoint $.pic+$.off+(gap,0);
  $.l=lpoint $.pic+$.off-(gap,0);
endfor
forsuffixes $=word_components,ladders,roget_components,book_components,
   econ_order,football,miles_span,assign_lisa,girth,take_risc,multiply,queen:
  $.x+redge $.pic=w;
  $.l=lpoint $.pic+$.off-(gap,0);
endfor

tpoint kernel.pic + kernel.off = (.5w,h-10);
gb_save.off=(m,10);
gb_dijk.x=1/2[gb_words.x,word_components.x];
gb_dijk.r=rpoint gb_dijk.pic+gb_dijk.off+(gap,0);

words.dat.y=gb_words.y=word_components.y;
gb_dijk.y=ladders.y;
roget.dat.y=gb_roget.y=roget_components.y;
anna.dat.y=david.dat.y+11;
david.dat.y=homer.dat.y+11;
homer.dat.y=gb_books.y=book_components.y;
huck.dat.y=homer.dat.y-11;
jean.dat.y=huck.dat.y-11;
econ.dat.y=gb_econ.y=econ_order.y;
games.dat.y=gb_games.y=football.y;
miles.dat.y=1/3[gb_miles.y,gb_plane.y];
gb_miles.y=miles_span.y;
lisa.dat.y=gb_lisa.y=assign_lisa.y;
gb_raman.y=girth.y;
gb_gates.y=1/2[take_risc.y,multiply.y];
gb_basic.y=queen.y;

kernel.y-gb_words.y=word_components.y-ladders.y=ladders.y-roget.dat.y
 =roget.dat.y-anna.dat.y-2=jean.dat.y+2-econ.dat.y=econ.dat.y-gb_games.y
 =gb_games.y-gb_miles.y=gb_miles.y-gb_plane.y=gb_plane.y-gb_lisa.y
 =gb_lisa.y-gb_raman.y=girth.y-take_risc.y=take_risc.y-multiply.y
 =gb_gates.y-gb_rand.y=gb_rand.y-gb_basic.y=gb_basic.y-gb_save.y;

forsuffixes $=gb_words,gb_roget,gb_books,gb_econ,gb_games,gb_miles,gb_plane,
   gb_lisa,gb_raman,gb_gates,gb_rand,gb_basic,
   word_components,ladders,roget_components,book_components,econ_order,
   football,miles_span,assign_lisa,girth,take_risc,multiply,queen,
   kernel,gb_dijk,gb_save:
  draw $.pic shifted $.off;
endfor
forsuffixes $=words,roget,anna,david,homer,huck,jean,econ,games,miles,lisa:
  draw $.dat.pic shifted $.dat.off;
endfor

connect(words.dat.r,gb_words.l);
connect(gb_words.r,word_components.l);
connect(gb_words.r,ladders.l);
connect(gb_dijk.r,ladders.l);
connect(roget.dat.r,gb_roget.l);
connect(gb_roget.r,roget_components.l);
connect(anna.dat.r,gb_books.l);
connect(david.dat.r,gb_books.l);
connect(homer.dat.r,gb_books.l);
connect(huck.dat.r,gb_books.l);
connect(jean.dat.r,gb_books.l);
connect(gb_books.r,book_components.l);
connect(econ.dat.r,gb_econ.l);
connect(gb_econ.r,econ_order.l);
connect(games.dat.r,gb_games.l);
connect(gb_games.r,football.l);
connect(miles.dat.r,gb_miles.l);
connect(gb_miles.r,miles_span.l);
connect(miles.dat.r,gb_plane.l);
connect(lisa.dat.r,gb_lisa.l);
connect(gb_lisa.r,assign_lisa.l);
connect(gb_raman.r,girth.l);
connect(gb_gates.r,take_risc.l);
connect(gb_gates.r,multiply.l);
connect(gb_basic.r,queen.l);

superness:=.9;
draw superellipse(.5[ledge kernel.pic,redge kernel.pic],
                  .5[tedge kernel.pic,bedge kernel.pic],
                  .5(redge kernel.pic-ledge kernel.pic)+34,
                  .5(tedge kernel.pic-bedge kernel.pic)+5)
     shifted kernel.off dashed evenly;
draw (rpoint gb_save.pic + (29,0)){up}...
     (tpoint gb_save.pic+(0,5)){left}...
     (lpoint gb_save.pic - (29,0)){down}...
     (bpoint gb_save.pic-(0,5)){right}...
     cycle shifted gb_save.off dashed evenly;

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(2);
save round,c,w,h,pic;
numeric w,h;
w=hsize; % width
h=80pt; % height
round.y=sound.y=would.y=world.y=h-6pt;
hound.y=wound.y=mould.y=could.y;
pound.y=mound.y=mount.y=moult.y;
bound.y=found.y=fount.y=count.y=court.y=6pt;
world.y-could.y=could.y-moult.y=moult.y-court.y;

hound.x=pound.x=20pt;
round.x=bound.x;
sound.x=found.x;
wound.x=mound.x;
would.x=mould.x=mount.x;
world.x=could.x=moult.x;
court.x=w-20pt;
found.x-bound.x=fount.x-found.x=count.x-fount.x=court.x-count.x
 =moult.x-mount.x=mount.x-mound.x=2(mound.x-found.x)=2(bound.x-pound.x);

newinternal c;
forsuffixes $=bound,pound,hound,round,sound,found,mound,wound,
              fount,mount,count,court,moult,could,mould,would,world:
 forsuffixes $$=bound,pound,hound,round,sound,found,mound,wound,
               fount,mount,count,court,moult,could,mould,would,world:
  c:=0;
  for k=0 upto 4:
   if substring (k,k+1) of str $ = substring (k,k+1) of str $$: c:=c+1 fi;
  endfor
  if c=4: draw ($.x,$.y)--($$.x,$$.y); fi
 endfor
endfor

interim bboxmargin:=1;
forsuffixes $=bound,pound,hound,round,sound,found,mound,wound,
              fount,mount,count,court,moult,could,mould,would,world:
  picture pic;
  pic=str $ infont "cmtt10";
  setbounds pic to (ledge pic-1,-1)--(redge pic+1,-1)--
                        (redge pic+1,6)--(ledge pic-1,6)--cycle;
% unfill superellipse(.5[ledge pic,redge pic],.5[tedge pic,bedge pic],
%                     .5(redge pic-ledge pic)+1,
%                     .5(tedge pic-bedge pic)+1.5)
%                  shifted (($.x,$.y)-.5[llcorner pic,urcorner pic]);
  unfill bbox pic shifted (($.x,$.y)-.5[llcorner pic,urcorner pic]);
  draw pic shifted (($.x,$.y)-.5[llcorner pic,urcorner pic]);
endfor
setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(3);
save w,h,pic;
numeric w,h;
w=hsize; % width
h=45pt; % height

VR.y=AN.y=PS.y=h-6pt;
LE.y=KI.y=AL.y=KO.y;
ST.y=DO.y=PR.y=12pt;
VR.y-LE.y=1.61803(LE.y-ST.y);

VR.x=ST.x;
AN.x=DO.x;
PS.x=PR.x;
LE.x=ST.x-LE.x=DO.x-ST.x=KI.x-DO.x=PR.x-KI.x=AL.x-PR.x=KO.x-AL.x=w-KO.x;

def connect(suffix a,b) =
  draw (a.x,a.y)--(b.x,b.y) enddef;
connect(VR,ST);
connect(VR,AN);
connect(ST,DO);
connect(ST,AN);
connect(DO,AN);
connect(DO,KI);
connect(AN,KI);
connect(PS,KI);
connect(PR,KI);
connect(PR,PS);
draw (ST.x,ST.y) .. (DO.x,DO.y)+(3,-12){right} .. (KI.x,KI.y){curl 3};

forsuffixes $=LE,VR,ST,AN,DO,KI,PS,PR,AL,KO:
  picture pic;
  pic=str $ infont "cmtt10";
  unfill bbox pic shifted (($.x,$.y)-.5[llcorner pic,urcorner pic]);
  draw pic shifted (($.x,$.y)-.5[llcorner pic,urcorner pic]);
endfor

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(100);
save w,h,pic,LE,VR,ST,AN,DO,KI,PS,PR,AL,KO;

numeric w,h;
w=hsize; % width
h=45pt; % height

for k=15 upto 20: y[k]=h-6; endfor
forsuffixes $=LE,VR,ST,AN,DO,KI,PS,PR,AL,KO: $.y=6; endfor

LE.x=x16-LE.x=x17-x16=x18-x17=x19-x18=x20-x19=x15-x20=PR.x-x15
 =.618(AL.x-PR.x)=KO.x-AL.x=w-KO.x;
ST.x-VR.x=AN.x-ST.x=DO.x-AN.x=KI.x-DO.x=PS.x-KI.x=PR.x-PS.x;
VR.x=x17;

def connect(suffix a,b) =
  draw z.a--(b.x,b.y) enddef;
connect(16,VR);
connect(17,VR);
connect(17,ST);
connect(18,ST);
connect(18,VR);
connect(18,AN);
connect(19,AN);
connect(19,DO);
connect(20,DO);
connect(20,ST);
connect(20,AN);
connect(20,KI);
connect(15,KI);
connect(15,PS);
connect(15,PR);

for k=15 upto 20:
  picture pic;
  pic=decimal k infont "cmtt10";
  unfill bbox pic shifted (z[k] -.5[llcorner pic,urcorner pic]);
  draw pic shifted (z[k] - .5[llcorner pic,urcorner pic]);
endfor

forsuffixes $=LE,VR,ST,AN,DO,KI,PS,PR,AL,KO:
  picture pic;
  pic=str $ infont "cmtt10";
  unfill bbox pic shifted (($.x,$.y)-.5[llcorner pic,urcorner pic]);
  draw pic shifted (($.x,$.y)-.5[llcorner pic,urcorner pic]);
endfor

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(5);
save w,h,unit;
numeric w,h;
w=vsize; % width
h=hsize-20; % height
unit=.012in; % taken from cities.texmap; factor of .1 removed

z0=unit*(418.8,216.6); % Ravenna, OH
z1=unit*(471.9,204.1); % Reading, PA
z2=unit*(8.8,201.9); % Red Bluff, CA
z3=unit*(184.7,355.5); % Regina, SA
z4=unit*(33.1,192.0); % Reno, NV
z5=unit*(337.0,283.8); % Rhinelander, WI
z6=unit*(110.3,180.7); % Richfield, UT
z7=unit*(382.3,196.6); % Richmond, IN
z8=unit*(456.7,162.3); % Richmond, VA
z9=unit*(431.8,158.2); % Roanoke, VA
z10=unit*(306.6,259.5); % Rochester, MN
z11=unit*(455.1,246.6); % Rochester, NY
z12=unit*(340.2,233.2); % Rockford, IL
z13=unit*(138.9,223.0); % Rock Springs, WY
z14=unit*(453.2,138.3); % Rocky Mount, NC
z15=unit*(185.9,100.2); % Roswell, NM
z16=unit*(501.5,253.3); % Rutland, VT
z17=unit*(16.3,178.0); % Sacramento, CA
z18=unit*(391.8,250.6); % Saginaw, MI
z19=unit*(418.0,47.5); % Saint Augustine, FL
z20=unit*(289.5,282.7); % Saint Cloud, MN
z21=unit*(511.0,265.5); % Saint Johnsbury, VT
z22=unit*(366.4,230.7); % Saint Joseph, MI
z23=unit*(282.8,195.7); % Saint Joseph, MO
z24=unit*(329.3,178.5); % Saint Louis, MO
z25=unit*(300.2,273.4); % Saint Paul, MN
z26=unit*(.9,273.3); % Salem, OR
z27=unit*(171.2,177.1); % Salida, CO
z28=unit*(255.1,181.8); % Salina, KS
z29=unit*(14.7,149.2); % Salinas, CA
z30=unit*(475.2,174.7); % Salisbury, MD
z31=unit*(112.4,210.6); % Salt Lake City, UT
z32=unit*(226.8,71.1); % San Angelo, TX
z33=unit*(246.2,40.5); % San Antonio, TX
z34=unit*(58.1,110.8); % San Bernardino, CA
z35=unit*(59.7,89.8); % San Diego, CA
z36=unit*(404.1,220.9); % Sandusky, OH
z37=unit*(7.0,165.9); % San Francisco, CA
z38=unit*(12.4,159.3); % San Jos\'e, CA
z39=unit*(52.5,105.6); % Santa Ana, CA
z40=unit*(34.2,115.5); % Santa Barbara, CA
z41=unit*(171.7,134.4); % Santa Fe, NM
z42=unit*(4.0,175.8); % Santa Rosa, CA
z43=unit*(405.9,9.3); % Sarasota, FL
z44=unit*(387.7,296.5); % Sault Sainte Marie, MI
z45=unit*(420.3,80.4); % Savannah, GA
z46=unit*(491.7,241.5); % Schenectady, NY
z47=unit*(194.6,227.2); % Scottsbluff, NB
z48=unit*(474.5,220.3); % Scranton, PA
z49=unit*(7.9,313.2); % Seattle, WA
z50=unit*(298.9,179.8); % Sedalia, MO
z51=unit*(361.0,85.5); % Selma, AL
z52=unit*(264.4,127.6); % Seminole, OK
z53=unit*(161.6,271.2); % Sheridan, WY
z54=unit*(265.1,103.8); % Sherman, TX
z55=unit*(293.7,86.8); % Shreveport, LA
z56=unit*(267.3,236.5); % Sioux City, IA
z57=unit*(263.9,252.3); % Sioux Falls, SD
z58=unit*(368.7,224.4); % South Bend, IN
z59=unit*(57.1,314.2); % Spokane, WA
z60=unit*(334.7,196.2); % Springfield, IL
z61=unit*(505.3,230.7); % Springfield, MA
z62=unit*(298.3,157.5); % Springfield, MO
z63=unit*(393.1,198.0); % Springfield, OH
z64=unit*(440.5,171.4); % Staunton, VA
z65=unit*(199.0,208.5); % Sterling, CO
z66=unit*(425.0,204.6); % Steubenville, OH
z67=unit*(335.5,267.0); % Stevens Point, WI
z68=unit*(18.3,168.6); % Stockton, CA
z69=unit*(479.3,214.0); % Stroudsburg, PA
z70=unit*(427.7,108.0); % Sumter, SC
z71=unit*(407.8,88.2); % Swainsboro, GA
z72=unit*(469.7,244.9); % Syracuse, NY
z73=unit*(6.9,307.8); % Tacoma, WA
z74=unit*(388.4,55.9); % Tallahassee, FL
z75=unit*(406.7,18.4); % Tampa, FL
z76=unit*(357.1,191.2); % Terre Haute, IN
z77=unit*(290.7,100.6); % Texarkana, TX
z78=unit*(395.8,223.9); % Toledo, OH
z79=unit*(274.5,184.9); % Topeka, KS
z80=unit*(437.4,253.9); % Toronto, ON
z81=unit*(374.9,270.6); % Traverse City, MI
z82=unit*(483.5,202.6); % Trenton, NJ
z83=unit*(186.1,156.7); % Trinidad, CO
z84=unit*(121.5,82.5); % Tucson, AZ
z85=unit*(272.1,141.6); % Tulsa, OK
z86=unit*(344.1,113.1); % Tupelo, MS
z87=unit*(355.5,97.3); % Tuscaloosa, AL
z88=unit*(86.5,237.6); % Twin Falls, ID
z89=unit*(278.2,84.4); % Tyler, TX
z90=unit*(433.9,197.7); % Uniontown, PA
z91=unit*(478.9,245.8); % Utica, NY
z92=unit*(398.4,61.6); % Valdosta, GA
z93=unit*(251.1,303.0); % Valley City, ND
z94=unit*(.0,338.2); % Vancouver, BC
z95=unit*(322.4,84.4); % Vicksburg, MS
z96=unit*(261.1,31.3); % Victoria, TX
z97=unit*(355.9,179.4); % Vincennes, IN
z98=unit*(259.8,72.4); % Waco, TX
z99=unit*(47.9,290.2); % Walla Walla, WA
z100=unit*(439.8,226.9); % Warren, PA
z101=unit*(460.9,182.5); % Washington, DC
z102=unit*(500.7,222.4); % Waterbury, CT
z103=unit*(307.8,236.7); % Waterloo, IA
z104=unit*(472.0,258.9); % Watertown, NY
z105=unit*(260.1,272.7); % Watertown, SD
z106=unit*(352.9,234.6); % Waukegan, IL
z107=unit*(334.8,273.6); % Wausau, WI
z108=unit*(407.7,67.5); % Waycross, GA
z109=unit*(7.3,220.5); % Weed, CA
z110=unit*(28.0,310.5); % Wenatchee, WA
z111=unit*(430.7,.0); % West Palm Beach, FL
z112=unit*(424.0,200.2); % Wheeling, WV
z113=unit*(257.8,164.5); % Wichita, KS
z114=unit*(246.3,107.7); % Wichita Falls, TX
z115=unit*(408.4,164.4); % Williamson, WV
z116=unit*(461.2,217.9); % Williamsport, PA
z117=unit*(195.0,321.4); % Williston, ND
z118=unit*(475.7,195.4); % Wilmington, DE
z119=unit*(452.0,112.8); % Wilmington, NC
z120=unit*(449.6,187.0); % Winchester, VA
z121=unit*(259.7,347.4); % Winnipeg, MB
z122=unit*(428.7,140.7); % Winston-Salem, NC
z123=unit*(333.5,253.6); % Wisconsin Dells, WI
z124=unit*(513.2,233.2); % Worcester, MA
z125=unit*(26.1,298.2); % Yakima, WA
z126=unit*(257.3,242.4); % Yankton, SD
z127=unit*(424.7,215.7); % Youngstown, OH

% The following lines computed by a variant of miles_span.w with the changes
% @x
% @<Execute |jar_pr(g)| with binary heaps as the priority queue algorithm@>;
% @y stop after krusk
% return;
% @z
% @x
% { printf("  %ld miles between %s and %s [%ld mems]\n",
%            l,u->name,v->name,mems);
% @y
% { printf("draw z%d--z%d; %% %s and %s\n",
%            u->index_no,v->index_no,u->name,v->name);
% @z
% @x
% @d clink z.V /* pointer to another vertex in the same component */
% @y avoid memory conflict with index_no field
% @d clink w.V /* pointer to another vertex in the same component */
% @z
% and with command-line options -n128 -v

draw z112--z66; % Wheeling, WV and Steubenville, OH
draw z49--z73; % Seattle, WA and Tacoma, WA
draw z107--z67; % Wausau, WI and Stevens Point, WI
draw z0--z127; % Ravenna, OH and Youngstown, OH
draw z48--z69; % Scranton, PA and Stroudsburg, PA
draw z58--z22; % South Bend, IN and Saint Joseph, MI
draw z68--z17; % Stockton, CA and Sacramento, CA
draw z38--z37; % San Jose, CA and San Francisco, CA
draw z124--z61; % Worcester, MA and Springfield, MA
draw z91--z72; % Utica, NY and Syracuse, NY
draw z75--z43; % Tampa, FL and Sarasota, FL
draw z78--z36; % Toledo, OH and Sandusky, OH
draw z34--z39; % San Bernardino, CA and Santa Ana, CA
draw z42--z37; % Santa Rosa, CA and San Francisco, CA
draw z102--z61; % Waterbury, CT and Springfield, MA
draw z118--z1; % Wilmington, DE and Reading, PA
draw z38--z29; % San Jose, CA and Salinas, CA
draw z97--z76; % Vincennes, IN and Terre Haute, IN
draw z107--z5; % Wausau, WI and Rhinelander, WI
draw z118--z82; % Wilmington, DE and Trenton, NJ
draw z127--z66; % Youngstown, OH and Steubenville, OH
draw z108--z92; % Waycross, GA and Valdosta, GA
draw z7--z63; % Richmond, IN and Springfield, OH
draw z56--z126; % Sioux City, IA and Yankton, SD
draw z82--z69; % Trenton, NJ and Stroudsburg, PA
draw z90--z112; % Uniontown, PA and Wheeling, WV
draw z104--z72; % Watertown, NY and Syracuse, NY
draw z106--z12; % Waukegan, IL and Rockford, IL
draw z101--z120; % Washington, DC and Winchester, VA
draw z77--z55; % Texarkana, TX and Shreveport, LA
draw z25--z20; % Saint Paul, MN and Saint Cloud, MN
draw z91--z46; % Utica, NY and Schenectady, NY
draw z67--z123; % Stevens Point, WI and Wisconsin Dells, WI
draw z68--z38; % Stockton, CA and San Jose, CA
draw z10--z25; % Rochester, MN and Saint Paul, MN
draw z74--z92; % Tallahassee, FL and Valdosta, GA
draw z57--z126; % Sioux Falls, SD and Yankton, SD
draw z51--z87; % Selma, AL and Tuscaloosa, AL
draw z23--z79; % Saint Joseph, MO and Topeka, KS
draw z113--z28; % Wichita, KS and Salina, KS
draw z64--z9; % Staunton, VA and Roanoke, VA
draw z72--z11; % Syracuse, NY and Rochester, NY
draw z35--z39; % San Diego, CA and Santa Ana, CA
draw z46--z16; % Schenectady, NY and Rutland, VT
draw z64--z120; % Staunton, VA and Winchester, VA
draw z116--z48; % Williamsport, PA and Scranton, PA
draw z36--z0; % Sandusky, OH and Ravenna, OH
draw z45--z71; % Savannah, GA and Swainsboro, GA
draw z52--z85; % Seminole, OK and Tulsa, OK
draw z55--z89; % Shreveport, LA and Tyler, TX
draw z24--z60; % Saint Louis, MO and Springfield, IL
draw z21--z16; % Saint Johnsbury, VT and Rutland, VT
draw z118--z30; % Wilmington, DE and Salisbury, MD
draw z108--z71; % Waycross, GA and Swainsboro, GA
draw z109--z2; % Weed, CA and Red Bluff, CA
draw z46--z61; % Schenectady, NY and Springfield, MA
draw z101--z118; % Washington, DC and Wilmington, DE
draw z9--z122; % Roanoke, VA and Winston-Salem, NC
draw z101--z8; % Washington, DC and Richmond, VA
draw z33--z96; % San Antonio, TX and Victoria, TX
draw z108--z19; % Waycross, GA and Saint Augustine, FL
draw z10--z103; % Rochester, MN and Waterloo, IA
draw z62--z50; % Springfield, MO and Sedalia, MO
draw z114--z54; % Wichita Falls, TX and Sherman, TX
draw z125--z110; % Yakima, WA and Wenatchee, WA
draw z105--z57; % Watertown, SD and Sioux Falls, SD
draw z100--z127; % Warren, PA and Youngstown, OH
draw z8--z14; % Richmond, VA and Rocky Mount, NC
draw z12--z123; % Rockford, IL and Wisconsin Dells, WI
draw z79--z28; % Topeka, KS and Salina, KS
draw z106--z58; % Waukegan, IL and South Bend, IN
draw z47--z65; % Scottsbluff, NB and Sterling, CO
draw z86--z87; % Tupelo, MS and Tuscaloosa, AL
draw z52--z54; % Seminole, OK and Sherman, TX
draw z78--z63; % Toledo, OH and Springfield, OH
draw z119--z14; % Wilmington, NC and Rocky Mount, NC
draw z40--z39; % Santa Barbara, CA and Santa Ana, CA
draw z17--z2; % Sacramento, CA and Red Bluff, CA
draw z125--z99; % Yakima, WA and Walla Walla, WA
draw z98--z89; % Waco, TX and Tyler, TX
draw z90--z120; % Uniontown, PA and Winchester, VA
draw z54--z89; % Sherman, TX and Tyler, TX
draw z125--z73; % Yakima, WA and Tacoma, WA
draw z7--z76; % Richmond, IN and Terre Haute, IN
draw z4--z17; % Reno, NV and Sacramento, CA
draw z78--z18; % Toledo, OH and Saginaw, MI
draw z48--z72; % Scranton, PA and Syracuse, NY
draw z23--z50; % Saint Joseph, MO and Sedalia, MO
draw z76--z60; % Terre Haute, IN and Springfield, IL
draw z49--z94; % Seattle, WA and Vancouver, BC
draw z78--z58; % Toledo, OH and South Bend, IN
draw z81--z18; % Traverse City, MI and Saginaw, MI
draw z45--z70; % Savannah, GA and Sumter, SC
draw z83--z27; % Trinidad, CO and Salida, CO
draw z119--z70; % Wilmington, NC and Sumter, SC
draw z59--z99; % Spokane, WA and Walla Walla, WA
draw z80--z11; % Toronto, ON and Rochester, NY
draw z31--z6; % Salt Lake City, UT and Richfield, UT
draw z10--z123; % Rochester, MN and Wisconsin Dells, WI
draw z105--z20; % Watertown, SD and Saint Cloud, MN
draw z81--z44; % Traverse City, MI and Sault Sainte Marie, MI
draw z98--z33; % Waco, TX and San Antonio, TX
draw z75--z19; % Tampa, FL and Saint Augustine, FL
draw z55--z95; % Shreveport, LA and Vicksburg, MS
draw z3--z117; % Regina, SA and Williston, ND
draw z113--z85; % Wichita, KS and Tulsa, OK
draw z24--z50; % Saint Louis, MO and Sedalia, MO
draw z83--z41; % Trinidad, CO and Santa Fe, NM
draw z93--z105; % Valley City, ND and Watertown, SD
draw z31--z13; % Salt Lake City, UT and Rock Springs, WY
draw z41--z15; % Santa Fe, NM and Roswell, NM
draw z43--z111; % Sarasota, FL and West Palm Beach, FL
draw z26--z73; % Salem, OR and Tacoma, WA
draw z9--z115; % Roanoke, VA and Williamson, WV
draw z33--z32; % San Antonio, TX and San Angelo, TX
draw z86--z95; % Tupelo, MS and Vicksburg, MS
draw z88--z31; % Twin Falls, ID and Salt Lake City, UT
draw z40--z29; % Santa Barbara, CA and Salinas, CA
draw z27--z65; % Salida, CO and Sterling, CO
draw z121--z93; % Winnipeg, MB and Valley City, ND
draw z15--z32; % Roswell, NM and San Angelo, TX
draw z109--z26; % Weed, CA and Salem, OR
draw z47--z53; % Scottsbluff, NB and Sheridan, WY
draw z93--z117; % Valley City, ND and Williston, ND
draw z47--z13; % Scottsbluff, NB and Rock Springs, WY
draw z88--z99; % Twin Falls, ID and Walla Walla, WA
draw z35--z84; % San Diego, CA and Tucson, AZ

pickup pencircle scaled 3;
for k=0 upto 127: drawdot z[k]; endfor

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(6);
save w,h,unit,s,off;
numeric w,h,unit;
w=hsize; % width
h=380unit; % height
pair off;
off=(40,-20);
unit*520+xpart off=w;

z0=unit*(59.7,89.8)+off; % San Diego
z1=unit*(246.2,40.5)+off; % San Antonio
z2=unit*(7.0,165.9)+off; % San Francisco
z3=unit*(460.9,182.5)+off; % Washington
z4=unit*(12.4,159.3)+off; % San Jos\'e
z5=unit*(437.4,253.9)+off; % Toronto
z6=unit*(259.7,347.4)+off; % Winnipeg
z7=unit*(7.9,313.2)+off; % Seattle
z8=unit*(329.3,178.5)+off; % Saint Louis
z9=unit*(.0,338.2)+off; % Vancouver

path boundary; boundary=(0,0)--(w,0)--(w,h)--(0,h)--cycle;
def infline(suffix i,j) =
 drawarrow z.i--((z.i--10[z.i,z.j])intersectionpoint boundary) enddef;
infline(9,6);
infline(6,5);
infline(5,3);
infline(3,1);
infline(1,0);
infline(0,2);
infline(2,9);

draw z0--z4;
draw z0--z6;
draw z0--z8;
draw z1--z8;
draw z2--z7;
draw z2--z4;
draw z3--z8;
draw z4--z7;
draw z4--z6;
draw z5--z8;
draw z6--z7;
draw z6--z8;
draw z7--z9;

dotlabel.llft(btex\fiverm San Diego etex,z0);
dotlabel.lrt(btex\fiverm San Antonio etex,z1);
dotlabel.lft(btex\fiverm San Francisco etex,z2);
dotlabel.rt(btex\fiverm Washington etex,z3);
dotlabel.rt(btex\fiverm \ San Jos\'e etex,z4);
dotlabel.urt(btex\fiverm Toronto etex,z5);
dotlabel.ulft(btex\fiverm Winnipeg etex,z6);
dotlabel.lrt(btex\fiverm Seattle etex,z7);
dotlabel.lrt(btex\fiverm Saint Louis etex,z8);
dotlabel.ulft(btex\fiverm Vancouver etex,z9);

%draw boundary;
setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(10);
save w,h,theta,p,t,pic;
w=.6hsize; % width
h=2in; % height
theta=360/7;
path p[];
transform t;

z0=(.5w,.5h);
y1=y4=y0; y2=y3=1.05y0;
x1=x0+.16h; x4=x0+.46h; x2=.3[x1,x4]; x3=.7[x1,x4];
p10=z1{curl3}..z2..z3..z4{curl3};
p20=p10 reflectedabout (z1,z4);
for k=1 upto 4:
  pair zz;
  zz=z[k] rotatedaround(z0,theta);
  p[k]=z[k]{(z[k]-z0)rotated 90}..zz{(zz-z0)rotated 90};
endfor

picture pic;
pickup pencircle scaled 3;
drawdot z1; drawdot z2; drawdot z3; drawdot z4;
pickup defaultpen;
drawarrow subpath (0,.6) of p10;
drawarrow subpath (.6,1.6) of p10;
drawarrow subpath (1.6,2.6) of p10;
draw subpath (2.6,3) of p10;
drawarrow subpath (3,1.4) of p20;
draw subpath (1.4,0) of p20;
drawarrow subpath (0,.5) of p1;
drawarrow subpath (0,.48) of p2;
drawarrow subpath (0,.45) of p3;
drawarrow subpath (0,.45) of p4;
draw subpath(.5,1) of p1;
draw subpath(.48,1) of p2;
draw subpath(.45,1) of p3;
draw subpath(.45,1) of p4;
pic:=currentpicture;

for k=1 upto 6:
  draw pic rotatedaround(z0,k*theta);
endfor

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(11);
save w,h,unit,off;
w=.6hsize; % width
h=2in; % height
unit=h/8;

pickup pencircle scaled 3;
for j=0 upto 5: for k=0 upto 5:
 drawdot (j,k) scaled unit;
endfor endfor

pickup defaultpen;
for j=0 upto 4:
 for k=0 upto 3:
  draw ((j,k)--(j+1,k+2)) scaled unit;
 endfor
 for k=2 upto 5:
  draw ((j,k)--(j+1,k-2)) scaled unit;
 endfor
endfor
for j=0 upto 3:
 for k=0 upto 4:
  draw ((j,k)--(j+2,k+1)) scaled unit;
 endfor
 for k=1 upto 5:
  draw ((j,k)--(j+2,k-1)) scaled unit;
 endfor
endfor

currentpicture:=currentpicture shifted ((.5w,.5h)-unit*(2.5,2.5));

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(12);
save w,h;
w=.6hsize; % width
h=1in; % height

z0=(.5w,0); z2=(.5w,h); z1-z0=(z2-z0)rotated-60; z3-z0=(z2-z0)rotated 60;

pickup pencircle scaled 3;
for j=0 upto 4: for k=0 upto 4:
 drawdot z0+(j/4)*(z1-z0)+(k/4)*(z3-z0);
endfor endfor

pickup defaultpen;
draw z0--z2;
for j=1 upto 3:
  draw (j/4)[z0,z1]--(j/4)[z2,z1];
  draw (j/4)[z0,z3]--(j/4)[z2,z3];
endfor
for j=0 upto 4:
  draw (j/4)[z0,z3]--(j/4)[z1,z2];
  draw (j/4)[z0,z1]--(j/4)[z3,z2];
endfor

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(13);
save w,h,theta,p,t,pic;
w=.6hsize; % width
h=1.2in; % height
theta=360/5;

z0=(.5w,.5h);
z1=(.5w,h);
z2=(.5w,.75h);

pickup pencircle scaled 3;
drawdot z1; drawdot z2;

pickup defaultpen;
draw z1--z2;
draw z1--(z1 rotatedaround(z0,theta));
draw z2--(z2 rotatedaround(z0,2theta));

picture pic;
pic:=currentpicture;

for k=1 upto 4:
  draw pic rotatedaround(z0,k*theta);
endfor

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(14);
save w,h,p,t,del,z,unit;
w=.6hsize; % width
h=3in; % height
pair del[],z[][][][];

del[2]=unit*(14.5,2.5); % inversion 12
del[3]=unit*(18,14.5); % inversion 13
del[4]=unit*(0,20); % inversion 14
del[6]=unit*(3.5,12.5); % inversion 23
del[8]=unit*(-14.5,18); % inversion 24
del[12]=unit*(-18,5); % inversion 34

z 4 3 2 1 = (.5w,8);
ypart z 1 2 3 4 = h-8;

for a=1 upto 4: for b=1 upto 3: for c=1 upto 2:
  p1:=1;
  p2:=p[c]; p[c]:=2;
  p3:=p[b]; p[b]:=3;
  p4:=p[a]; p[a]:=4;
  if p1>p2: z[p2][p1][p3][p4]=z[p1][p2][p3][p4]+del[p1*p2];
  elseif p2>p3: z[p1][p3][p2][p4]=z[p1][p2][p3][p4]+del[p2*p3];
  elseif p3>p4: z[p1][p2][p4][p3]=z[p1][p2][p3][p4]+del[p3*p4];
  fi
endfor endfor endfor

for a=1 upto 4: for b=1 upto 3: for c=1 upto 2:
  p1:=1;
  p2:=p[c]; p[c]:=2;
  p3:=p[b]; p[b]:=3;
  p4:=p[a]; p[a]:=4;
  pickup pencircle scaled 3; drawdot z[p1][p2][p3][p4]; pickup defaultpen;
  if p1>p2: draw z[p2][p1][p3][p4]--z[p1][p2][p3][p4]; fi
  if p2>p3: draw z[p1][p3][p2][p4]--z[p1][p2][p3][p4]; fi
  if p3>p4: draw z[p1][p2][p4][p3]--z[p1][p2][p3][p4]; fi
endfor endfor endfor

defaultfont:="cmr8";
label.top("1234",z 1 2 3 4);
label.ulft("2134",z 2 1 3 4);
label.urt("1243",z 1 2 4 3);
label.lrt("2143",z 2 1 4 3);
label.ulft("1324",z 1 3 2 4);
label.lrt("2314",z 2 3 1 4);
label.lft("3214",z 3 2 1 4);
label.urt("2341",z 2 3 4 1);
label.rt("3241",z 3 2 4 1+right);
label.llft("3421",z 3 4 2 1);
label.ulft("3412",z 3 4 1 2);
label.bot("4321",z 4 3 2 1);
label.lrt("4312",z 4 3 1 2);
label.lrt("4231",z 4 2 3 1);
label.ulft("4132",z 4 1 3 2);
label.rt("4123",z 4 1 2 3);
label.lft("4213",z 4 2 1 3+2left);
label.llft("1432",z 1 4 3 2);
label.rt("1423",z 1 4 2 3);
label.urt("1342",z 1 3 4 2);
label.lft("2413",z 2 4 1 3+2up);
label.llft("2431",z 2 4 3 1);
label.lrt("3142",z 3 1 4 2);
label.rt("3124",z 3 1 2 4+2right);

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(15);
save w,h,bls,unit;
w=.6hsize; % width
h=1.6in; % height
bls=unit/2=h/7; % baselineskip and horizontal unit

h-y1.1.1.1.1.1=y1.1.1.1.1.1-y2.1.1.1.1=y2.1.1.1.1-y3.1.1.1
 =y3.1.1.1-y4.1.1=y4.1.1-y5.1=y5.1-y6=2y6;
y3.1.1.1=y2.2.1.1;
y4.1.1=y3.2.1=y2.2.2;
y5.1=y4.2=y3.3;
x1.1.1.1.1.1=x2.1.1.1.1;
x3.1.1.1=x4.1.1=x5.1;
x2.2.1.1=x3.2.1=x4.2=x6=.5w;
x2.2.2=x3.3;
x3.3-x4.2=x4.2-x5.1=unit;
x1.1.1.1.1.1=.5[x5.1,x4.2];

pickup pencircle scaled 3;
drawdot z1.1.1.1.1.1; drawdot z2.1.1.1.1; drawdot z3.1.1.1; drawdot z2.2.1.1;
drawdot z4.1.1; drawdot z3.2.1; drawdot z2.2.2;
drawdot z5.1; drawdot z4.2; drawdot z3.3; drawdot z6;

def adraw expr p = draw p; drawarrow (point 1 of p)--(point .1 of p) enddef;
pickup defaultpen;
adraw z1.1.1.1.1.1--z2.1.1.1.1;
adraw z2.1.1.1.1--z3.1.1.1; adraw z2.1.1.1.1--z2.2.1.1;
adraw z3.1.1.1--z4.1.1; adraw z3.1.1.1--z3.2.1;
adraw z2.2.1.1--z4.1.1; adraw z2.2.1.1--z3.2.1; adraw z2.2.1.1--z2.2.2;
adraw z4.1.1--z5.1; adraw z4.1.1--z4.2;
adraw z3.2.1--z5.1; adraw z3.2.1--z4.2; adraw z3.2.1--z3.3;
adraw z2.2.2--z4.2;
adraw z5.1--z6;
adraw z4.2--z6;
adraw z3.3--z6;

defaultfont:="cmr8";
label.top("111111",z1.1.1.1.1.1+up);
label.urt("21111",z2.1.1.1.1+right);
label.ulft("3111",z3.1.1.1);
label.urt("2211",z2.2.1.1);
label.lft("411",z4.1.1+2up);
label.rt("321",z3.2.1+2up);
label.rt("222",z2.2.2+2up);
label.llft("51",z5.1);
label.lrt("42",z4.2);
label.lrt("33",z3.3);
label.bot("6",z6+down);

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(200);
save w,h,unit;
w=hsize; % width
h=30pt; % height
unit=h-8;

y0.0=y0.1=y0.2=h-1;
y1.0=y1.1=y1.2=y0.0-unit;
x0.0=x1.0=dispindent+17pt;
x0.1=x1.1=x0.0+2unit;
x0.2=x1.2=x0.1+2unit;

defaultfont:="cmtt10";
forsuffixes $=0.0,0.1,0.2,1.0,1.1,1.2:
  dotlabel.llft(str$ if round$=$: &".0" fi,z$);
endfor

draw z0.0--z1.0; drawarrow z0.0--.8[z0.0,z1.0];
draw z0.1--z1.1; drawarrow z0.1--.8[z0.1,z1.1];
draw z0.2--z1.2; drawarrow z0.2--.8[z0.2,z1.2];
draw z0.0--z0.1; drawarrow z0.0--.6[z0.0,z0.1];
draw z1.0--z1.1; drawarrow z1.0--.6[z1.0,z1.1];
draw z1.1--z1.2; drawarrow z1.1--.6[z1.1,z1.2];
draw z0.1--z0.2; drawarrow z0.1--.6[z0.1,z0.2];

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(201);
save w,h,hunit,vunit,alpha,beta,p;
w=hsize; % width
h=115pt; % height

17+8.2vunit=h;
dispindent+58+13hunit=w;

label(btex weight etex rotated 90,(dispindent+5,.5h));
label.rt(btex $2^0$ etex,(dispindent+14,17));
label.rt(btex $2^2$ etex,(dispindent+14,17+vunit));
label.rt(btex $2^4$ etex,(dispindent+14,17+2vunit));
label.rt(btex $2^6$ etex,(dispindent+14,17+3vunit));
label.rt(btex $2^8$ etex,(dispindent+14,17+4vunit));
label.rt(btex $2^{10}$ etex,(dispindent+14,17+5vunit));
label.rt(btex $2^{12}$ etex,(dispindent+14,17+6vunit));
label.rt(btex $2^{14}$ etex,(dispindent+14,17+7vunit));
label.rt(btex $2^{16}$ etex,(dispindent+14,17+8vunit));

defaultfont:="cmr10";
for k=0 upto 12:
  x[k]=dispindent+38+k*hunit;
  label.top(decimal round (2**k),(x[k],-2));
endfor
label.top("rank",(dispindent+38+13.5*hunit,-2));

x12.25=dispindent+38+12.25hunit;
y12.25=14;

numeric alpha,beta;
alpha*mlog 0.01+beta=14;
alpha*mlog 655.36+beta=14+8vunit;

y0=alpha*mlog 767.66+beta;
y1=alpha*mlog 761.53+beta;
y2=alpha*mlog 590.44+beta;
y3=alpha*mlog 470.43+beta;
y4=alpha*mlog 212.86+beta;
y5=alpha*mlog 144.76+beta;
y6=alpha*mlog  90.81+beta;
y7=alpha*mlog  44.98+beta;
y8=alpha*mlog  22.61+beta;
y9=alpha*mlog   9.87+beta;
y10=alpha*mlog  3.64+beta;
y11=alpha*mlog  1.41+beta;
y12=alpha*mlog   .10+beta;

path p; p=z0 for k=1 upto 12: .. z[k] endfor .. z12.25;

for k=0 upto 12: draw (x[k],14)--z[k]; endfor
for k=0 upto 8: draw (x0,14+k*vunit)--(x12.25,14+k*vunit);
endfor

unfill (p shifted (.25,0))--(x12.25,y0)--cycle;
draw p;

pickup pencircle scaled 3;
for k=0 upto 12: drawdot z[k]; endfor

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(202);
save w,h,hunit,vunit,off,p,yy,yyy,n;
w=hsize; % width
h=117pt; % height

19+100vunit=h;
dispindent+38+75hunit=w;

newinternal n; % number of items
def item(expr a,b,c,d) =
 x[n]=a*hunit; % no of vertices/100
 y[n]=(40c/a)*vunit; % average degree*20
 yy[n]=(b/a)*vunit; % percent of isolated vertices
 yyy[n]=(d/a)*vunit; % percent in giant component
 n:=n+1;
enddef;

item(  .01,1,0,0); x0:=0;
item( 2,116,.64,6);
item( 4,204,1.56,7);
item( 6,275,3.11,25);
item( 8,286,5.34,81);
item(10,326,7.59,224);
item(12,338,10.81,331);
item(14,373,13.81,417);
item(16,370,17.46,757);
item(18,393,21.63,1048);
item(20,410,25.75,1186);
item(22,433,30.35,1360);
item(24,456,34.89,1530);
item(26,475,39.15,1670);
item(28,478,45.67,1874);
item(30,474,52.09,2056);
item(32,475,61.31,2269);
item(34,488,67.68,2465);
item(36,504,73.00,2636);
item(38,516,78.29,2822);
item(40,533,83.43,2986);
item(42,576,88.40,3132);
item(44,591,94.49,3310);
item(46,604,101.17,3467);
item(48,630,106.32,3646);
item(50,630,112.74,3825);
item(52,652,119.59,4009);
item(54,663,126.77,4000+179);
item(56,670,134.56,4000+350);
item(57.57,671,141.35,4000+493);

path p[];
p1=(x[0],y[0]) for k=1 upto n-1: ..(x[k],y[k]) endfor;
p2=(x[0],yy[0]){down} for k=1 upto n-1: ..(x[k],yy[k]) endfor;
p3=(x[0],yyy[0]) for k=1 upto n-1: ..(x[k],yyy[k]) endfor;

label(btex average degree etex rotated 90,(dispindent+5,.5h));
for k=0 upto 5:
 label.rt((decimal k &".0") infont "cmr10",(dispindent+14,17+20k*vunit));
 label.top(decimal(1000k) infont "cmr10",(dispindent+38+10k*hunit,0));
 label.lft((decimal(20k)&"%") infont "cmr10",
    (dispindent+67+57.57hunit,17+20k*vunit));
endfor
defaultfont:="cmr10";
label.top("5757",(dispindent+38+57.57hunit,0));
label.top("vertices",(dispindent+38+67hunit,0));

pair off; off=(dispindent+38,16);

for k=0 step 20 until 100:
  draw ((0,k*vunit)--(57.57hunit,k*vunit)) shifted off;
endfor
for k=0 step 5 until 55:
  draw ((k*hunit,0)--(k*hunit,100*vunit)) shifted off;
endfor
draw ((57.57hunit,0)--(57.57hunit,100vunit)) shifted off;

draw p1 shifted off;
draw p2 shifted off dashed evenly;
draw p3 shifted off dashed evenly;

z100=off+(22hunit,30vunit);
drawarrow z100{left}..((point 8 of p2)+off+(1,1));
z200=off+(33hunit,57vunit);
drawarrow z200{left}..((point 16.2 of p3)+off-(2,2));

picture pic;
pic:=thelabel.rt(btex percentage of isolated vertices etex,z100);
unfill bbox pic;
draw pic;
pic:=thelabel.rt(btex \vbox{\hbox{percentage of vertices}
                            \hbox{in largest component}} etex,z200);
unfill bbox pic;
draw pic;

% pickup pencircle scaled 3;
% for k=0 upto n-1: drawdot z[k] shifted off; endfor

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(16);
save w,h,unit,s,off;
numeric w,h,unit;
w=hsize; % width
h=380unit; % height
pair off;
off=(40,-20);
unit*520+xpart off=w;

z0=unit*(59.7,89.8)+off; % San Diego
z1=unit*(246.2,40.5)+off; % San Antonio
z2=unit*(7.0,165.9)+off; % San Francisco
z3=unit*(460.9,182.5)+off; % Washington
z4=unit*(12.4,159.3)+off; % San Jos\'e
z5=unit*(437.4,253.9)+off; % Toronto
z6=unit*(259.7,347.4)+off; % Winnipeg
z7=unit*(7.9,313.2)+off; % Seattle
z8=unit*(329.3,178.5)+off; % Saint Louis
z9=unit*(.0,338.2)+off; % Vancouver

vardef inter(suffix $,$$,$$$) =
  save p; pair p;
  p=.5[z$,z$$]+whatever*((z$-z$$)rotated 90);
  p=.5[z$,z$$$]+whatever*((z$-z$$$)rotated 90);
  p enddef;

def triang(suffix $,$$,$$$) =
  z$.$$.$$$=(inter($,$$,$$$)+inter($$,$$$,$)+inter($$$,$,$$))/3;
enddef; % tests show that the intersections agree to within .02

triang(6,7,9);
triang(2,7,9);
triang(2,4,7);
triang(0,2,4);
triang(0,1,8);
triang(1,3,8);
triang(3,5,8);
triang(5,6,8);
triang(4,6,7);
triang(0,4,6);
triang(0,6,8);

def midp(suffix $,$$) =
  z$.$$=.5[z$,z$$];
enddef;

midp(6,9);
midp(5,6);
midp(3,5);
midp(1,3);
midp(0,1);

path boundary; boundary=(0,0)--(w,0)--(w,h)--(0,h)--cycle;
def infline(suffix i,j) =
 drawarrow z.i--((z.i--10[z.i,z.j])intersectionpoint boundary) enddef;
infline(5 6 8,5 6);
infline(3 5 8,3 5);
infline(0 1 8,0 1);

def infline(suffix i,j) = % now we go t'other way
 drawarrow z.i--((z.i--(-10)[z.i,z.j])intersectionpoint boundary) enddef;
infline(1 3 8,1 3);
infline(6 7 9,6 9);

def infline(suffix i,j) = % now we eliminate the arrowhead
 draw z.i--((z.i--10[z.i,z.j])intersectionpoint boundary) enddef;
infline(0 4 6,0 2 4);
infline(2 4 7,0 2 4);
infline(2 4 7,2 7 9);
infline(6 7 9,2 7 9);

draw z6 7 9--z4 6 7--z0 4 6--z0 6 8--z5 6 8--z3 5 8--z1 3 8--z0 1 8--z0 6 8;
draw z4 6 7--z2 4 7;

dotlabel.llft(btex\fiverm San Diego etex,z0);
dotlabel.lrt(btex\fiverm San Antonio etex,z1);
dotlabel.lft(btex\fiverm San Francisco etex,z2);
dotlabel.rt(btex\fiverm Washington etex,z3);
dotlabel.rt(btex\fiverm \ San Jos\'e etex,z4);
dotlabel.urt(btex\fiverm Toronto etex,z5);
dotlabel.ulft(btex\fiverm Winnipeg etex,z6);
dotlabel.lrt(btex\fiverm Seattle etex,z7);
dotlabel.lrt(btex\fiverm Saint Louis etex,z8);
dotlabel.ulft(btex\fiverm Vancouver etex,z9);

%draw boundary;
setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

beginfig(300);
save w,h,p,pp,gap;
numeric w,h,gap;
w=hsize; % width
h=45pt; % height
gap=10;
picture p[];
path pp[];
verbatimtex \newbox\ttstrutbox \setbox0=\hbox{\tt foo}
  \setbox\ttstrutbox=\vbox to\ht0{}
  \def\ttstrut{\copy\ttstrutbox}
etex;

y2=y3=y4=y5=h-5;
y0=.5[y2,y12];
y1=.8[y0,y2]; y11=.8[y0,y12];
y12=y13=y14=y15=5;

x0=dispindent+15;
x1=x11; x2=x12; x3=x13; x4=x14; x5=x15=w-15;
x1-x0=30; x5-x4=75;
x2-x0=x4-x2; x3-x2=x4-x3;

defaultfont:="cmtt10";
p0=thelabel("foo.w",z0);
p1=thelabel("CTANGLE",z1);
p2=thelabel("foo.c",z2);
p3=thelabel("cc",z3);
p4=thelabel("foo",z4);
p5=thelabel.lft(btex \smash{(executable)}\ttstrut etex,z5);
p11=thelabel("CWEAVE",z11);
p12=thelabel("foo.tex",z12);
p13=thelabel(btex \TeX etex,z13);
p14=thelabel("foo.dvi",z14);
p15=thelabel.lft(btex \smash{(printable)}\ttstrut etex,z15);

pp10=(.6[lpoint p0,rpoint p0]-(0,6)){down}...{right}(lpoint p12-(gap,0));
pp12=(rpoint p12+(gap,0))--(lpoint p14-(gap,0));
pp0=pp10 reflectedabout (z0,(w,y0));
pp2=pp12 reflectedabout (z0,(w,y0));

forsuffixes $=0,2,10,12:
  drawarrow pp$ dashed dashpattern(on .5bp off 2bp);
endfor
forsuffixes $=0,1,2,3,4,5,11,12,13,14,15:
  unfill bbox p$;
  draw p$;
endfor

setbounds currentpicture to (0,0)--(w,0)--(w,h)--(0,h)--cycle;
endfig;

end.
