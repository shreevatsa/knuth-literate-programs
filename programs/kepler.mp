% draw an example of Viennot's "Kepler towers"

beginfig(0) % first, a Dyck path
numeric u; u:=10pt; % basic unit of measure for the path grid
newinternal n; n:=0; % the step number
newinternal h; h:=0; % the partial sum
for j=0 upto 44:
 draw (j*u,0)--(j*u,14u) withcolor .7white;
endfor
for j=0 upto 14:
 draw (0,j*u)--(44u,j*u) withcolor .7white;
endfor
draw (0,0)
 for t=1,-1,1,-1,1,1,1,
      -1,1,1,-1,1,1,1,-1,1,1,
       1,-1,-1,-1,1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,1,-1,1,-1,-1,-1,-1,1,-1,-1,-1:
  --hide(n:=n+1;h:=h+t;)(n,h)*u
 endfor
 withpen pencircle scaled .75pt;
endfig;

% now the tower

numeric th; th=3pt; % thickness of the heavy pen
numeric d; d=5pt; % distance between rings
numeric eps; eps=.02; % extra width of bricks

path p;
def ring (expr r, n)(text t) =
  pickup pencircle scaled .4pt;
  p:=(r*d,0) for j=1 upto n-1: .. ((r*d,0) rotated (360j/n)) endfor .. cycle;
  draw p;
  pickup pencircle scaled th;
  for j=t: draw subpath (j-n*eps/r,j+1+n*eps/r) of p; endfor
enddef;

beginfig(1) % first version: no gaps between walls
ring(2,2,0);
ring(3,2,1);
ring(4,2,1);
ring(5,4,0,2);
ring(6,4,3);
ring(7,4,0,2);
ring(8,8,0,2,4,6);
ring(9,8,0,3,6);
ring(10,8,2,7);
ring(11,8,1,3,6);
ring(12,8,0,6);
endfig;

beginfig(2) % second version: an empty ring between walls
ring(2,2,0);
ring(3,2,1);
ring(4,2,1);
ring(6,4,0,2);
ring(7,4,3);
ring(8,4,0,2);
ring(10,8,0,2,4,6);
ring(11,8,0,3,6);
ring(12,8,2,7);
ring(13,8,1,3,6);
ring(14,8,0,6);
endfig;

bye.

   
