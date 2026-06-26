({
		var angle=0;
		~angle=(720).collect{
		angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
		}
		}.value;
	)

///////////////////////////////////////////routine sending to control bus


~controlBus.free
(
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);
)

(
 // Initialize angle
var angle = 0, value1, value2,tone1,tone2,mult=12;
~angleRoutine = Routine({
    loop {
        // Calculate the next angle
      angle = (angle + (360 - (360 / 1.6180339887499))).wrap(0, 360);
	//angle = (angle + 1).wrap(0, 360);
        angle.postln; // Yield the value to the routine
		value1=exp(Complex(0,1)*angle.degrad).imag*mult;
		value2=exp(Complex(0,1)*angle.degrad).real*mult;
		tone1=2.pow(value1/12);
		tone2=2.pow(value2/12);
		"tone1".postln;
		tone1.postln;
		"tone2".postln;
		tone2.postln;
		~controlBus1.set(tone1);
		~controlBus2.set(tone2);
		0.1.wait;
    }
});
)

//) Start the routine and get values
~angleRoutine.play; // Get the first 10 values

(
{
		Out.ar(0,SinOsc.ar(220*In.kr(~controlBus1),mul:In.kr(~controlBus1).reciprocal));
	    Out.ar(1,SinOsc.ar(220*In.kr(~controlBus2),mul:In.kr(~controlBus2).reciprocal));
}
.play
)


({
var n=10;
1000.do{
	Out.ar(0,SinOsc.ar((110+n),mul:In.kr(~controlBus1).reciprocal));
	Out.ar(1,SinOsc.ar((110+n),phase:90.degrad,mul:In.kr(~controlBus2).reciprocal));
	n=n+10;
}}
.play
)
2.6758392461683*17

 (360*2.pow(1/12))-360

/////////////////////////////////////////////
exp(Complex(0,1)*45.degrad).real

(
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);
)
180*2.pow(1/12)
(

 // Initialize angle
var angle = 0, value1, value2,tone1,tone2,mult=2,n=0;
~tempo=0.5;
~angleRoutine = Routine({
    loop {
        // Calculate the next angle
		//angle = (angle + (45*(2.pow(1/12)-1))).wrap(0, 360);
		//angle=(angle+45);
	//	angle=(angle+3).wrap(0,360);

		//angle = (angle + 9);  // Increment azimuth
       // if (angle > 360) { angle = angle - 360 };
		angle = (pi/2)*2.pow(n/12);  // Increment azimuth
		n=(n+1).mod(24);


		//angle= (2.pow(n/12)).wrap(0,360);
		//n=(n+1).postln;
		//"angle".postln;
		angle.postln;
	//angle = (angle + 1).wrap(0, 360);
       // angle.yield; // Yield the value to the routine
		value1=exp(Complex(0,1)*angle).imag.abs.linlin(0,1,1,2);
		value2=exp(Complex(0,1)*angle).real.abs.linlin(0,1,1,2);
		"tone1".postln;
		value1.postln;
		"tone2".postln;
	   value2.postln;
		~controlBus1.set(value1);
		~controlBus2.set(value2);
		~tempo.wait;
    }
});
)

(
~angleRoutine.play;
{
		Out.ar(0,SinOsc.ar(220*In.kr(~controlBus1),mul:In.kr(~controlBus1).reciprocal));
	    Out.ar(1,SinOsc.ar(220*In.kr(~controlBus2),mul:In.kr(~controlBus2).reciprocal));
}
.play
)

720.mod(360)
(

 // Initialize angle
var angle = 0, value1, value2,tone1,tone2,mult=2,n=0;
~tempo=1;
~angleRoutine = Routine({
    loop {
        // Calculate the next angle
		//angle = (angle + (45*(2.pow(1/12)-1))).wrap(0, 360);
		//angle=(angle+45);
	//	angle=(angle+3).wrap(0,360);

		//angle = (angle + 9);  // Increment azimuth
       // if (angle > 360) { angle = angle - 360 };
		angle =((2pi)*2.pow(n/12)); // Increment azimuth
	n=(n+1).mod(13);

	value1=exp(Complex(0,1)*angle).imag.abs.linlin(0,1,1,2);
		value2=exp(Complex(0,1)*angle).real.abs.linlin(0,1,1,2);
"tone".postln;
		//(value1/value2).postln;
		(value2).postln;
		//~controlBus1.set(value1);
		//~controlBus2.set(value2);
		//angle.postln;

		~tempo.wait;
    }
}
);
)
~angleRoutine.play;
////////////////quaternion

(

 // Initialize angle
var angle = 0, value1, value2,value3,tone1,tone2,mult=2,n=0,sph5,v5,rotation5,az5,el5,sph_axis,sph;
~tempo=1;
~angleRoutine = Routine({
    loop {
        // Calculate the next angle
		//angle = (angle + (45*(2.pow(1/12)-1))).wrap(0, 360);
		//angle=(angle+45);
	//	angle=(angle+3).wrap(0,360);
		sph=Cartesian(1,0,0);
	//sph_axis=Quaternion(0, 0.57735026918963, 0.57735026918963, 0.57735026918963);
		sph_axis=Quaternion(0, 1, 0, 0);
sph5=Cartesian(0,0,1);
			v5=Quaternion(0, sph5.x, sph5.y, sph5.z);
				rotation5=((sph_axis*exp(Complex(0,1)*((pi/4)*2.pow(n/12))).imag)+exp(Complex(0,1)*((pi/4)*2.pow(n/12))).real);
			//rotation5=(cos(((pi/2)*2.pow(n/12)))+(sin(((pi/2)*2.pow(n/12)))*sph_axis));


			//q3=(cos(angle.degrad)+(sin(angle.degrad)*(i3+j3+k3)));
			v5=rotation5*v5*rotation5.conjugate;
			az5 = Cartesian(v5.b,v5.c,v5.d).theta.round(0.000001);
			el5 =Cartesian(v5.b,v5.c,v5.d).phi.round(0.000001);
			sph5=Spherical(1,az5,el5);
		//angle = (angle + 9);  // Increment azimuth
       // if (angle > 360) { angle = angle - 360 };
		angle =((pi/2)*2.pow(n/12)); // Increment azimuth
	n=(n+1).mod(13);

		value1=sph5.y.round(0.000001).abs.linlin(0,1,1,2);
		value2=sph5.phi.round(0.000001).abs.linlin(0,1,1,2);
	value3=sph5.z.round(0.000001).abs.linlin(0,1,1,2);
"tone".postln;
		//(value1/value2).postln;
	//	(value2/value1).postln;
	(value1).postln;
		(value2).postln;
		(value3).postln;
		//~controlBus1.set(value1);
		//~controlBus2.set(value2);
		//angle.postln;

		~tempo.wait;
    }
}
);
)
~angleRoutine.play;
\
////////////////////


(

 // Initialize angle
var angle = 0, value1, value2,tone1,tone2,mult=2,n=0;
~tempo=0.5;
~angleRoutine = Routine({
    loop {



		angle = (90*2.pow(n/12)); // Increment azimuth
		if (angle > 180) { angle = angle - 360 };
		n=(n+1).mod(25);

/*	value1=exp(Complex(0,1)*angle.degrad).imag.abs.linlin(0,1,1,2);
		value2=exp(Complex(0,1)*angle.degrad).real.abs.linlin(0,1,1,2);
		angle.postln;
		"tone1".postln;
		value1.postln;
		"tone2".postln;
	   value2.postln;*/
		//angle= (2.pow(n/12)).wrap(0,360);
		//n=(n+1).postln;
		//"angle".postln;
		angle.postln;

		~tempo.wait;
    }
});
)
~angleRoutine.play;

(

 // Initialize angle
var angle = 0, value1, value2,tone1,tone2,mult=2,n=0;
~tempo=2;
~angleRoutine = Routine({
    loop {



		angle = (0+(180*2.pow(n/12))).wrap(90.neg,90); // Increment azimuth
		//if (angle > 90) { angle = angle - 180 };
		n=(n+1).mod(12);

/*	value1=exp(Complex(0,1)*angle.degrad).imag.abs.linlin(0,1,1,2);
		value2=exp(Complex(0,1)*angle.degrad).real.abs.linlin(0,1,1,2);
		angle.postln;
		"tone1".postln;
		value1.postln;
		"tone2".postln;
	   value2.postln;*/
		//angle= (2.pow(n/12)).wrap(0,360);
		//n=(n+1).postln;
		//"angle".postln;
		angle.postln;

		~tempo.wait;
    }
});
)
/////////////////////////////////////////lamdoma intervals

(
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);
)

(
~angleRoutine.play;
{
		Out.ar(0,SinOsc.ar(220*In.kr(~controlBus1),mul:In.kr(~controlBus1).reciprocal));
	    Out.ar(1,SinOsc.ar(220*In.kr(~controlBus2),mul:In.kr(~controlBus2).reciprocal));
}
.play
)
(

 // Initialize angle
var angle = 0, value1, value2,tone1,tone2,mult=2,n=0,m=15;
~tempo=1/2;
~angleRoutine = Routine({
    loop {
        // Calculate the next angle
		n=(m+1)/(m-7);
		//n.postln;
		angle = (90*n).wrap(0, 360);
		//angle=(angle+45);
	//	angle=(angle+3).wrap(0,360);
		//m=(m+1).wrap(15,141);
		m=(m+1).wrap(15,23);
	//	m.postln;
		//angle = (angle + 9);  // Increment azimuth
       // if (angle > 360) { angle = angle - 360 };
	//	angle =((pi/2)*2.pow(n/12)); // Increment azimuth
//	n=(n+1).mod(13);

	value1=exp(Complex(0,1)*angle.degrad).imag.abs.linlin(0,1,1,2);
		value2=exp(Complex(0,1)*angle.degrad).real.abs.linlin(0,1,1,2);
"tone".postln;
		(value2/value1).postln;
//	value1.postln;
	//	value2.postln;
		~controlBus1.set(value1);
		~controlBus2.set(value2);
	//	angle.postln;

		~tempo.wait;
    }
}
);
)
///////////////////////////3d

2.pow(10/12)

([2.pow(12.rand2/12),2.pow(12.rand2/12),2.pow(12.rand2/12)].normalizeSum.sqrt*2).postln;
[1,1,1].normalizeSum.sqrt

Cartesian(12/9,12/8, 12/6).rho

Cartesian(2.pow(4/12),2.pow(5/12), 2.pow(11/12)).rho

~angleRoutine.play;

[2.pow(4/12),2.pow(6/12),2.pow(8/12) ].normalizeSum.sqrt

(
var xyz;

xyz=(([2.pow(12.rand/12),2.pow(12.rand/12),2.pow(12.rand/12)].normalizeSum*2.8331469310467*2).sqrt).postln;
Cartesian(xyz.[0],xyz.[1], xyz.[2]).rho.postln;
)
2.pow(66/12)
2.pow(78/12)

(

 // Initialize angle
var angle,n=0;
~tempo=1;
~angleRoutine = Routine({
    loop {
       angle=(2.pow(n/12)).postln;
		n=n+1;
(sin(angle.degrad).abs.linlin(0,1,1,2)/cos(angle.degrad).abs.linlin(0,1,1,2)).postln;

		~tempo.wait;
    }
}
);
)

~angleRoutine.play;
(

 // Initialize angle
var angle = 0, value1, value2,value3,tone1,tone2,mult=2,n=0;
var pl1=0,az1,el1,sph1,spha,mag,xyz,seed=1234;
~tempo=2;
~angleRoutine = Routine({
	thisThread.randSeed = seed;
			seed=seed+2;
    loop {


		xyz=[2.pow(12.rand2/12),2.pow(12.rand2/12),2.pow(12.rand2/12)].normalizeSum.sqrt.postln;
	//	az1 = (angle+(360*2.pow(pl1/12))).wrap(180.neg,180);  // Increment azimuth
	//		el1 = (angle+(180*2.pow(pl1/12))).wrap(90.neg,90);
	//	pl1=(pl1+1).mod(13);


		spha=Cartesian(xyz.[0]*([1.neg,1].choose),xyz.[1]*([1.neg,1].choose),xyz.[2]*([1.neg,1].choose));
		//spha=Cartesian(2.pow(12.rand2/12)*([1.neg,1].choose),2.pow(12.rand2/12)*([1.neg,1].choose),2.pow(12.rand2/12)*([1.neg,1].choose));
		mag=spha.rho;
			az1=(angle.degrad+spha.theta).wrap(pi.neg,pi);
			el1=(angle.degrad+spha.phi).wrap((pi/2).neg,(pi/2));

		sph1=Spherical(1,(az1),(el1));
		//sph1=Spherical(1,(az1.degrad),(el1.degrad));


		value1=sph1.x.abs.linlin(0,1,1,2);
		value2=sph1.y.abs.linlin(0,1,1,2);
		value3=sph1.z.abs.linlin(0,1,1,2);
	//value1=sph1.x.abs;
		//value2=sph1.y.abs;
	//	value3=sph1.z.abs;

		"tone".postln;
		value1.postln;
	   value2.postln;
		value3.postln;


		~tempo.wait;
    }
});
)
