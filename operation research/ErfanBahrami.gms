*  ------------------------------------------------------------------------
* | Program    : gams-programmer
* | version    : gams 25.1.2
* | By         : Erfan Bahrami
*--------------------------------------------------------------------------
sets
i index of Knight /1*4/
j index of home /1*9/
t index of move /1*20/
;
alias(j,jp);
table ini(i,j)
         1       2       3       4       5       6       7       8       9
1        1       0       0       0       0       0       0       0       0
2        0       0       1       0       0       0       0       0       0
3        0       0       0       0       0       0       1       0       0
4        0       0       0       0       0       0       0       0       1
;
table f(i,j)
         1       2       3       4       5       6       7       8       9
1        0       0       0       0       0       0       1       0       1
2        0       0       0       0       0       0       1       0       1
3        1       0       1       0       0       0       0       0       0
4        1       0       1       0       0       0       0       0       1
;
table a(j,jp) transportation distance
         1       2       3       4       5       6       7       8       9
1        0       0       0       0       0       1       0       1       0
2        0       0       0       0       0       0       1       0       1
3        0       0       0       1       0       0       0       1       0
4        0       0       1       0       0       0       0       0       1
5        0       0       0       0       0       0       0       0       0
6        1       0       0       0       0       0       1       0       0
7        0       1       0       0       0       1       0       0       0
8        1       0       1       0       0       0       0       0       0
9        0       1       0       1       0       0       0       0       0
;
*------------------------------------------------------------------------------
variable Objective;
binary variable
X(t,i,j) , Z(t,i);

equations
ObjectiveFunction
Co1(i,j,t)
Co2(i,j,t)
Co3(t)
Co4(i,t)
Co5(j,t)
Co6(t)
Co7(i,j,t)
initial(i,t)
final(i,t);

ObjectiveFunction  .. Objective =e= sum((i,t),Z(t,i));
Co1(i,j,t)$(ord(t)<>Card(t))     .. X(t+1,i,j)=g=X(t,i,j)-Z(t,i);
Co2(i,j,t)$(ord(t)<>Card(t))     .. X(t+1,i,j)=l=X(t,i,j)+Z(t,i);
Co3(t)$(ord(t)<=Card(t)-2)       .. sum(i,Z(t,i))=g=Sum(i,Z(t+1,i));
Co4(i,t)                         .. Sum(j,X(t,i,j))=e=1;
Co5(j,t)                         .. Sum(i,X(t,i,j))=l=1;
Co6(t)$(ord(t)<>Card(t))         .. Sum(i,Z(t,i))=l=1;
Co7(i,j,t)$(ord(t)<>Card(t))     .. Sum(jp$(ord(j)<>ord(jp)),a(j,jp)*X(t+1,i,jp))=g=Z(t,i)-(1-X(t,i,j));
initial(i,t)$(ord(t)=1)          .. Sum(j,ini(i,j)*X(t,i,j))=e=1;
final(i,t)$(ord(t)=Card(t))      .. Sum(j,f(i,j)*X(t,i,j))=e=1;
*------------------------------------------------------------------------------
model template /all/
option  limrow=100
option limcol=100;
option MIP=Cplex;
option optca=0;
option optcr=0;
option reslim=10000000;
solve template using MIP minimizing objective;
display Z.l , X.l;
