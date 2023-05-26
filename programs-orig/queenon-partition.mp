% illustrations for the QUEENON-PARTITION program

N=4;
u=1cm;
primarydef x!y = (x*u,y*u) enddef;
beginfig(0) % example of the Aztec partition
draw 0!0--N!0--N!N--0!N--cycle; % the outer frame
for i=0 upto N-1:
  draw 0!i--(N-i)!N;
  draw i!0--N!(N-i);
  draw 0!(N-i)--(N-i)!0;
  draw i!N--N!i;
endfor

string digs;
digs="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
vardef lab(expr I,J) =
 ((substring (I,I+1) of digs)&(substring (J,J+1) of digs)) infont "cmtt10"
enddef;
vardef labloc(expr I,J) =
  save x,y;
  x=(I-J+N)/2; y=(I+J-N-1)/2;
%  if x=0: x:=x+.15; fi
%  if x=N: x:=x-.15; fi
%  if y=0: y:=y+.15; fi
%  if y=N: y:=y-.15; fi
  x!y
enddef;
for i=1 upto N:
  for j=N+1-i upto N+i: label(lab(i,j),labloc(i,j)); endfor
endfor
for i=N+1 upto 2N:
  for j=i-N upto 3N+1-i: label(lab(i,j),labloc(i,j)); endfor
endfor
endfig;

n=17;
numeric h; n*h=N*u;

string ch;
picture pic[];
pic[ASCII "W"]=nullpicture;
currentpicture:=nullpicture;
fill (0,0)--(h,0)--(h,h)--(0,h)--cycle withcolor red;
pic[ASCII "R"]=currentpicture;
fill (0,0)--(h,0)--(h,h)--(0,h)--cycle withcolor blue;
pic[ASCII "B"]=currentpicture;
fill (0,0)--(h,0)--(h,h)--(0,h)--cycle withcolor green;
pic[ASCII "G"]=currentpicture;
currentpicture:=nullpicture;

newinternal ny;
def row expr s =
  ny:=ny+1;
  for j=0 upto length s-1:
    ch:=substring(j,j+1) of s;
    draw pic[ASCII ch] shifted (j*h,ny*h);
  endfor
enddef;


beginfig(1)
ny:=-1;
row "WGGGGBRRRWGGGBRRR"
row "WWGGBBBRWWWGBBBRW"
row "WWWBBBBGWWWRBBBGW"
row "WWRRBBGGGWRRRBGGG"
row "BRRRRGGGGBRRRWGGG"
row "BBRRWWGGBBBRWWWGG"
row "BBBWWWWBBBBGWWWRB"
row "BBGGWWRRBBGGGWWRR"
row "WGGGGRRRRGGGGBRRR"
row "WWGGBBRRWWGGGBBRR"
row "WWWBBBBWWWWGBBBGW"
row "WWRRBBGGWWWRBBBGG"
row "BRRRRGGGGWRRRBGGG"
row "BBRRWWGGGBRRRWGGG"
row "BBBWWWWGBBBRWWWGB"
row "BBGGWWWRBBBGWWWRB"
row "BGGGGWRRRBGGGWRRR"
for i=0 upto n: draw (0,i*h)--(n*h,i*h); draw (i*h,0)--(i*h,n*h); endfor
for i=0 upto N-1:
  draw 0!i--(N-i)!N;
  draw i!0--N!(N-i);
  draw 0!(N-i)--(N-i)!0;
  draw i!N--N!i;
endfor
endfig;

bye.
