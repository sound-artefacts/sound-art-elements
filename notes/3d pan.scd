
(
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
{
var g_ch1,g_ch2,g_ch3,g_ch4;
var g11,g22,g33,g44;
var spread=1,g_sum;
var polytope,mag=1;

	polytope=Spherical(1,MouseX.kr(pi.neg,pi),MouseY.kr(35.264390.degrad,35.264390.degrad.neg));


g_ch1 = (
   (Spherical(polytope.rho,polytope.theta,polytope.phi).x * Spherical(mag,~az[0],~el[0]).x) +
 (Spherical(polytope.rho,polytope.theta,polytope.phi).y * Spherical(mag,~az[0],~el[0]).y)+
  (Spherical(polytope.rho,polytope.theta,polytope.phi).z * Spherical(mag,~az[0],~el[0]).z)
);

g_ch2 = (
   (Spherical(polytope.rho,polytope.theta,polytope.phi).x * Spherical(mag,~az[1],~el[1]).x)+
(Spherical(polytope.rho,polytope.theta,polytope.phi).y * Spherical(mag,~az[1],~el[1]).y)+
  (Spherical(polytope.rho,polytope.theta,polytope.phi).z * Spherical(mag,~az[1],~el[1]).z)
);

g_ch3 = (
  (Spherical(polytope.rho,polytope.theta,polytope.phi).x * Spherical(mag,~az[2],~el[2]).x)+
   (Spherical(polytope.rho,polytope.theta,polytope.phi).y * Spherical(mag,~az[2],~el[2]).y)+
  (Spherical(polytope.rho,polytope.theta,polytope.phi).z * Spherical(mag,~az[2],~el[2]).z)
);

g_ch4 = (
(Spherical(polytope.rho,polytope.theta,polytope.phi).x * Spherical(mag,~az[3],~el[3]).x) +
 (Spherical(polytope.rho,polytope.theta,polytope.phi).y * Spherical(mag,~az[3],~el[3]).y)+
   (Spherical(polytope.rho,polytope.theta,polytope.phi).z * Spherical(mag,~az[3],~el[3]).z)
					);

g_ch1 = g_ch1.pow(spread);
g_ch2 = g_ch2.pow(spread);
g_ch3 = g_ch3.pow(spread);
g_ch4 = g_ch4 .pow(spread);

	Out.ar(0,BrownNoise.ar(g_ch1*0.01));
	Out.ar(1,BrownNoise.ar(g_ch2*0.01));
	Out.ar(2,BrownNoise.ar(g_ch3*0.01));
	Out.ar(3,BrownNoise.ar(g_ch4*0.01));

}.play)