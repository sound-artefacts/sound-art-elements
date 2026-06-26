					mk=(mk+(1-(1/1.6180339887499))).wrap(0,1);


(
var angle=0;
89.do{	angle=(angle+(360-(360/(89/55)))).wrap(0,360); angle.postln;}
)


360-(360/(8/5))

120*3


/(3/2)=/3
/(5/3)=/5
/(8/5)=/8
.
.
.
55*5
.

0	1	1	2	3	5	8	13	21	34	55	89	144	233	377	610	987	1597	2584	418


for cycle division of 89 degrees
360-(360/(89/55))
////////////////////////////////////////////////////////////////////weight tensor


(
var angle=0;
2.do{	angle=(angle+(360-(360/(2/1)))).wrap(0,360); angle.postln;}
)




//////////proximity

(Spherical(1,0.degrad,90.degrad).asCartesian.round(0.0001)+Spherical(10,45.degrad,0.degrad).asCartesian.round(0.0001)).asSpherical

////transfer center
(
var center, vektor, new_vektor;

vektor=Spherical(100,0,0.degrad).asCartesian;
center=Spherical(100,0.degrad,0.degrad).asCartesian;
new_vektor= vektor+center;
new_vektor.asSpherical.postln;

)