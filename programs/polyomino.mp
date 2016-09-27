% for the polyomino enumeration programs
numeric u; u=.2in;
picture pix;
fill unitsquare scaled u withcolor .9white;
draw unitsquare scaled u;
pix=currentpicture; currentpicture:=nullpicture;

beginfig(1)

def slice(expr s,x,y) =
  pair z,zz; z=zz=(x,y)*u;
  for i=1 upto length s:
    if substring (i-1,i) of s <> "0": draw pix shifted z; fi;
    z:=z+(u,u);
  endfor
  draw zz -- z dashed withdots;
enddef;

slice("1002",2,15);
slice("1002",2,14);
slice("1002",2,13);
slice("10002",2,12);
slice("10223004",0,9);
slice("112022003",0,8);
slice("1010101002",0,7);
slice("100010010023",0,6);
slice("1000100010022",0,5);
slice("10001000100202",0,4);
slice("100010000102002",0,3);
slice("10200103001405446",0,2);
slice("100022033003004",3,4);
slice("10230340000005",4,4);
slice("1220020000003",5,4);
slice("100010000002",6,4);
slice("1000002",11,8);
slice("100023",12,8);
slice("12344",13,8);
slice("1111",14,8);

endfig;

beginfig(2)

def row(expr s,y) =
  for i=1 upto length s:
    if substring (i-1,i) of s <> "0": draw pix shifted ((i-1,y)*u); fi;
  endfor
enddef;

for y=10 downto 0:
  draw ((0,y)*u) -- ((if y>0: 26 else: 15 fi, y)*u) dashed withdots;
endfor
for x=0 upto 26:
  draw ((x,if x>15: 1 else: 0 fi)*u) -- ((x,10)*u) dashed withdots;
endfor

row("00000001011111000000000000",9);
row("00000011110001000000000000",8);
row("00011111000011111100000000",7);
row("00010000000000000111000000",6);
row("00010000111111110001000000",5);
row("01110000100000010001000111",4);
row("01100111100001110001110010",3);
row("01000100111000100000010010",2);
row("01011101001000110011010110",1);
row("010010010010101",0);
endfig;

bye.

