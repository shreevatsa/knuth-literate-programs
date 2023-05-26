@x
@ ``9. The sum of all question numbers whose answers are correct and the same as
this one is:
(A)~$\in[59\dts62]$ (B)~$\in[52\dts55]$ (C)~$\in[44\dts49]$
(D)~$\in[59\dts67]$ (E)~$\in[44\dts53]$''

@<Cases for the big...@>=
case pack(0,9,A): case pack(0,9,B): case pack(0,9,C): case pack(0,9,D):
 case pack(0,9,E):
case pack(1,9,A): case pack(1,9,B): case pack(1,9,C): case pack(1,9,D):
 case pack(1,9,E):@+goto defer;

@ @<Cases for the def...@>=
case pack(0,9,A): case pack(0,9,B): case pack(0,9,C): case pack(0,9,D):
 case pack(0,9,E):
case pack(1,9,A): case pack(1,9,B): case pack(1,9,C): case pack(1,9,D):
 case pack(1,9,E): for (j=0,i=1;i<=20;i++)
      if ((o,falsity[i]==0)&&(o,mem[i]==(1<<x))) j+=i;
   switch (x) {
case A: i=(j>=59 && j<=62);@+break;
case B: i=(j>=52 && j<=55);@+break;
case C: i=(j>=44 && j<=49);@+break;
case D: i=(j>=59 && j<=67);@+break;
case E: i=(j>=44 && j<=53);@+break;
  }
  if (!u && !i) goto b5;
  if (u && i) goto b5;@+break;
@y
@ ``9. The sum of all question numbers whose answers are correct and the same as
this one is:
(A)~$\in[59\dts62]$ (B)~$\in[52\dts55]$ (C)~$\in[44\dts49]$
(D)~$\in[59\dts67]$ (E)~$\in[39\dts43]$''

@<Cases for the big...@>=
case pack(0,9,A): case pack(0,9,B): case pack(0,9,C): case pack(0,9,D):
 case pack(0,9,E):
case pack(1,9,A): case pack(1,9,B): case pack(1,9,C): case pack(1,9,D):
 case pack(1,9,E):@+goto defer;

@ @<Cases for the def...@>=
case pack(0,9,A): case pack(0,9,B): case pack(0,9,C): case pack(0,9,D):
 case pack(0,9,E):
case pack(1,9,A): case pack(1,9,B): case pack(1,9,C): case pack(1,9,D):
 case pack(1,9,E): for (j=0,i=1;i<=20;i++)
      if ((o,falsity[i]==0)&&(o,mem[i]==(1<<x))) j+=i;
   switch (x) {
case A: i=(j>=59 && j<=62);@+break;
case B: i=(j>=52 && j<=55);@+break;
case C: i=(j>=44 && j<=49);@+break;
case D: i=(j>=59 && j<=67);@+break;
case E: i=(j>=39 && j<=43);@+break;
  }
  if (!u && !i) goto b5;
  if (u && i) goto b5;@+break;
@z
@x
@ ``15. The set of odd-numbered questions with answer A is:
(A)~$\{7\}$ (B)~$\{9\}$ (C)~not $\{11\}$ (D)~$\{13\}$ (E)~$\{15\}$''

In the falsifying case,
I note that question~3 has been treated earlier in the ordering.

@<Cases for the big...@>=
case pack(0,15,A): case pack(0,15,E): goto bad;
case pack(0,15,B): force(9,A);@+deny(11,A);@+deny(13,A);@+goto odd_denials;
case pack(0,15,D): deny(9,A);@+deny(11,A);@+force(13,A);@+goto odd_denials;
odd_denials: deny(1,A);@+deny(3,A);@+deny(5,A);@+deny(7,A);
  deny(17,A);@+deny(19,A);@+goto okay;
case pack(1,15,A): case pack(1,15,E): goto okay;
case pack(0,15,C): case pack(1,15,B): case pack(1,15,D):
  if (o,mem[3]==AA) goto okay;@+goto defer;
case pack(1,15,C): goto defer;

@ @<Cases for the def...@>=
case pack(1,15,B):@+if ((o,mem[9]==AA)&&(o,mem[11]!=AA)&&(o,mem[13]!=AA))
  goto test_odd; break;
case pack(0,15,C): case pack(1,15,C):@+if ((o,mem[1]!=AA)&&(o,mem[3]!=AA)&&@|
  (o,mem[5]!=AA)&&(o,mem[7]!=AA)&&(o,mem[9]!=AA)&&(o,mem[11]==AA)&&@|
  (o,mem[13]!=AA)&&(o,mem[17]!=AA)&&(o,mem[19]!=AA))@+goto b5;@+break;
case pack(1,15,D):@+if ((o,mem[9]!=AA)&&(o,mem[11]!=AA)&&(o,mem[13]==AA))
  goto test_odd; break;
test_odd:@+if ((o,mem[1]!=AA)&&(o,mem[5]!=AA)&&(o,mem[7]!=AA)&&@|
  (o,mem[17]!=AA)&&(o,mem[19]!=AA)) goto b5;
  break;
@y
@ ``15. The set of odd-numbered questions with answer A is:
(A)~$\{7\}$ (B)~$\{9\}$ (C)~$\{11\}$ (D)~$\{13\}$ (E)~$\{15\}$''

In the falsifying case,
I note that question~3 has been treated earlier in the ordering.

@<Cases for the big...@>=
case pack(0,15,A): case pack(0,15,E): goto bad;
case pack(0,15,B): force(9,A);@+deny(11,A);@+deny(13,A);@+goto odd_denials;
case pack(0,15,C): deny(9,A);@+force(11,A);@+deny(13,A);@+goto odd_denials;
case pack(0,15,D): deny(9,A);@+deny(11,A);@+force(13,A);
odd_denials: deny(1,A);@+deny(3,A);@+deny(5,A);@+deny(7,A);
  deny(17,A);@+deny(19,A);@+goto okay;
case pack(1,15,A): case pack(1,15,E): goto okay;
case pack(1,15,B): case pack(1,15,C): case pack(1,15,D):
  if (o,mem[3]==AA) goto okay;@+goto defer;

@ @<Cases for the def...@>=
case pack(1,15,B):@+if ((o,mem[9]==AA)&&(o,mem[11]!=AA)&&(o,mem[13]!=AA))
  goto test15; break;
case pack(1,15,C):@+if ((o,mem[9]!=AA)&&(o,mem[11]==AA)&&(o,mem[13]!=AA))
  goto test15; break;
case pack(1,15,D):@+if ((o,mem[9]!=AA)&&(o,mem[11]!=AA)&&(o,mem[13]==AA))
  goto test15; break;
test15:@+if ((o,mem[1]!=AA)&&(o,mem[5]!=AA)&&(o,mem[7]!=AA)&&@|
  (o,mem[17]!=AA)&&(o,mem[19]!=AA)) goto b5;
  break;
@z
@x
difficulties,'' obviously needs some special consideration. Discussion in
my book shows that option (D) is always false. I assume here that (E) is also
@y
difficulties,'' obviously needs some special consideration. I assume here for
variety that option (D) is always true. And I assume here that (E) is
@z
@x
case pack(0,20,D): case pack(0,20,E): goto bad;
case pack(1,20,A): case pack(1,20,B): case pack(1,20,C):
  if (score!=18+x) goto okay;@+goto bad;
case pack(1,20,D): case pack(1,20,E): goto okay;
@y
case pack(1,20,D): case pack(0,20,E): goto bad;
case pack(1,20,A): case pack(1,20,B): case pack(1,20,C):
  if (score!=18+x) goto okay;@+goto bad;
case pack(0,20,D): case pack(1,20,E): goto okay;
@z
