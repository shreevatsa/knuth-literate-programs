beginfig(1)
numeric dotsize; dotsize=3pt;
numeric u; u=15pt;

def above(expr j,k,s) =
  z[j]=z[k]+(s*u,u);
  drawdot z[j] withpen pencircle scaled dotsize;
  draw z[j]--z[k];
enddef;

def below(expr j,k,s) =
  z[j]=z[k]+(s*u,-u);
  drawdot z[j] withpen pencircle scaled dotsize;
  draw z[j]--z[k];
enddef;

z[0]=origin;
drawdot z[0] withpen pencircle scaled dotsize;
above(1,0,-1);
above(2,1,-1);
below(3,2,-1);
above(4,1,+1);
above(5,0,+1);
below(6,5,+1);
below(7,0,-1);
above(8,7,-1);

for t=3,8: label.lft(decimal t,z[t]); endfor
for t=4,6: label.rt(decimal t,z[t]); endfor
for t=1: label.lft(decimal t,z[t]-(2pt,0)); endfor
for t=0,2,5,7: label.rt(decimal t,z[t]+(2pt,0)); endfor

endfig;
bye.

