
/*
						//phase=Complex(sph.theta.linlin(pi.neg,pi,1.neg,1),sph.phi.linlin((pi/2).neg,(pi/2),1.neg,1)).theta;
			per=Spherical(360.degrad,sph.theta,sph.phi);
			phase=(per.x+per.y+per.z).wrap(2pi.neg,2pi);//////////////////!!!!!!!




////


(
 var copper=0,bank=5,angle;
 bank.do{ 	copper=(copper+(360-(360/1.6180339887499))).wrap(0, 360).round(0.00000001);
	if(copper>180,{copper=180-copper},{copper=copper});
	copper.postln;
 } )*/



////phase as wavefield
// ////cube

(
var sph,phase;
(
 ~az=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
 ~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
 );
sph=Spherical(2pi,~az.[1],~el.[1]);

//phase=Complex(sph.theta.linlin(pi.neg,pi,1.neg,1),sph.phi.linlin((pi/2).neg,(pi/2),1.neg,1)).theta;

phase=Complex(exp(Complex(0,1)*sph.theta).real,exp(Complex(0,1)*sph.phi).imag).theta;

)
