

(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=3;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*4;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
//s.boot;
);
(
s.waitForBoot{
	Tdef(\drone, {
	Buffer.freeAll;
(
(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~a=(0-(pi/496)); ~ph=992.collect{~a=~a+(pi/496);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);
(
~w1= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
	signal=Signal.sineFill(~signalSize,~array,~ph);

wt = signal.asWavetable;
~w1.loadCollection(wt);
//signal.plot;
		}.value;
);
);
/////mallet
		/*(
{
    var inforce, outforce, freq, k, d;
    inforce = K2A.ar(MouseButton.kr(0, 1, 0)) > 0;
    k = MouseY.kr(0.01, 100, 1);///low long decay, high short decay
    d = MouseX.kr(0.00001, 0.1, 1);//harmonics in decay
    outforce = Spring.ar(inforce, k, d);
    freq = outforce * 440; // modulate frequency with the force
	LeakDC.ar(SinOsc.ar(freq, 0, 0.5))
}.play;
)*/

		////hit delay physical
		/*(
{
    var t, sf;
    sf = K2A.ar(MouseX.kr > 0.5) > 0;
    t = TBall.ar(sf, MouseY.kr(0.01, 1.0, 1), 0.01);
    Pan2.ar(Ringz.ar(t * 10, 1200, 0.1), MouseX.kr(-1, 1));
}.play;
)*/

//////kick
		///////////////set midi sequencer steps as gate on/of for synthdefs, some pots are for synth arguments,
		///others for change of rhytmic pattern and re evaluation of patterns.
	(
 (
SynthDef(\kick, {
	arg amp=1/8,n=12,pan=1,low=0,noise=0.001,decay=1/2,attack=0.001,az=0,el=0,m=1,az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,
					temp_mag1=56,temp_mag2=56,temp_mag3=56,azx=0,azy=0,elx=0,ely=0;
    var env,freq,anglex,angley,anglez,mod_anglex,mod_angley,mod_anglez,mx,my,mz,magx,magz,magy;
	var sph,phase,threshold,ton,phase1,phase2,phase3,sph1,loc1,loc2,loc3,mag,fund;
	var sig1,sig2,sig3,phasex,phasey,phasez,control1,control2,control3,axis1,axis2,axis3;
		var amb_w,amb_x,amb_y,amb_z,out,amb_sig1,amb_sig2,amb_sig3;

			ton=2.pow(n/992);
					fund=32*(9/8);
	freq = fund*ton;
	env= EnvGen.kr(Env.perc(attack, decay, curve: -4),doneAction:2,levelScale:amp*ton.reciprocal);

			threshold=(((343/0.3)/freq).reciprocal.ampdb/2.sqrt).dbamp;

					axis1=Spherical(temp_mag1,az1.lag(0.01), el1.lag(0.01));
				axis2=Spherical(temp_mag2,az2.lag(0.01), el2.lag(0.01));
				axis3=Spherical(temp_mag3,az3.lag(0.01), el3.lag(0.01));

				sph=Cartesian(axis1.x,axis2.y,axis3.z);


anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;

phase1=Complex(0,anglex).theta;
phase2=Complex(0,angley).theta;
phase3=Complex(0,anglez).theta;

mod_anglex=SinOsc.ar(pan,phase1).range(pi.neg,pi);
mod_angley=SinOsc.ar(pan,phase2).range(pi.neg,pi);
mod_anglez=SinOsc.ar(pan,phase3).range((pi/2).neg,(pi/2));

magx=((Complex(cos(((sph.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((sph.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
	(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magy=((Complex(sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
		(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magz=((Complex(cos(((sph.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((sph.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

mx=(Cartesian(magx.value,0,0).rho);my=(Cartesian(0,magy.value,0).rho);mz=(Cartesian(0,0,magz.value).rho);

phasex=Complex(1,mx.value).theta;
phasey=Complex(1,my.value).theta;
phasez=Complex(1,mz.value).theta;
									mag=(Cartesian(magx.value,magy.value,magz.value).rho);
									sph1=Spherical(mag,sph.theta,sph.phi);
			loc1=sph1.x;
			loc2=sph1.y;
			loc3=sph1.z;

sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasex,mul:1000).abs*SinOsc.ar(freq,phase:phasex)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasey,mul:1000).abs*SinOsc.ar(freq,phase:phasey)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasez,mul:1000).abs*SinOsc.ar(freq,phase:phasez)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));

control1=SinOsc.ar(freq,phasex,ton.reciprocal);
control2=SinOsc.ar(freq,phasey,ton.reciprocal);
control3=SinOsc.ar(freq,phasez,ton.reciprocal);

sig1 = sig1 + (sig1 * BrownNoise.ar(noise*loc1)); sig2 = sig2 + (sig2 * BrownNoise.ar(noise*loc2)); sig3 = sig3 + (sig3 * BrownNoise.ar(noise*loc3));


		sig1=HPF.ar(sig1,50); sig2=HPF.ar(sig2, 50);sig3=HPF.ar(sig3, 50);
		sig1=Compander.ar(sig1,control1,threshold,1.2,1/3,0.03,0.15);
		sig2=Compander.ar(sig2,control2,threshold,1.2,1/3,0.03,0.15);
		sig3=Compander.ar(sig3,control3,threshold,1.2,1/3,0.03,0.15);
		sig1=tanh(sig1*1.5);sig2=tanh(sig2*1.5);sig3=tanh(sig2*1.5);


	amb_sig1= (sig1*env*loc1.abs);
	amb_sig2= (sig2*env*loc2.abs);
	amb_sig3= (sig3*env*loc3.abs);

							amb_w=(amb_sig1+amb_sig2+amb_sig3)/2.sqrt;
					amb_x=amb_sig1;
					amb_y=amb_sig2;
					amb_z=amb_sig3;

					out= Out.ar(0,BFDecode1.ar1(amb_w, amb_x, amb_y, amb_z, [azx, azy], [elx,ely],4 ));
			// Out.kr(~controlBus_1.index,A2K.kr(sig1*env*loc1.abs*1000));
			//	Out.kr(~controlBus_2.index,A2K.kr(sig2*env*loc1.abs*1000));
			//	Out.kr(~controlBus_3.index,A2K.kr(sig3*env*loc1.abs*1000));

			//Out.kr(0,PanAz.ar(4,Limiter.ar(LeakDC.ar(sig1),0.9,0.01),panx,width:spread));
			//Out.kr(0,PanAz.ar(4,Limiter.ar(LeakDC.ar(sig2),0.9,0.01),pany,width:spread));
			//Out.kr(0,PanAz.ar(4,Limiter.ar(LeakDC.ar(sig3),0.9,0.01),panz,width:spread));


}).add;);

//Synth(\kick);

);
	10.wait;
	/////solid
(
(
~az=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
);

///quaterion rhtyhm solid rotation
/*(var i=Quaternion(0, axis_xyz.[0], 0, 0),j=Quaternion(0, 0, axis_xyz.[1], 0),k=Quaternion(0, 0, 0, axis_xyz.[2]);

axis=i+j+k;
~x1=tetrahedron.collect{
	plx1=plx1+1;
	qx1=Quaternion(0,Spherical(1,~az1[plx1],~el1[plx1]).x.round(0.00001),Spherical(1,~az1[plx1],~el1[plx1]).y.round(0.00001),Spherical(1,~az1[plx1],~el1[plx1]).z.round(0.00001));
	rotor_a=((axis*exp(Complex(0,1)*angle_a.degrad).imag)+exp(Complex(0,1)*angle_a.degrad).real); ax=rotor_a*qx1*rotor_a.conjugate;
	ax.b.round(0.00001);
};
)*/

	////durs
	({var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=6,time=32.reciprocal,beat=1,r=0;

~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[];

					3.do{
~x=bank.collect{
m1=m1+1;
					b=Spherical(beat,~az.[m1],~el.[m1]).rotate(r).tilt(r).tumble(r).x.round(0.00001);
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~az.[m2],~el.[m2]).rotate(r).tilt(r).tumble(r).y.round(0.00001);
	2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~az.[m3],~el.[m3]).rotate(r).tilt(r).tumble(r).z.round(0.00001);
	2.pow(d).round(time);
}; m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };

				18.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
		18.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
		18.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
	//	bank.do{~durs=~durs++~x.[n]++~y.[n]++~z.[n];n=n+1;}
//	~dur = ~duri.collect { |x|
  //  if (x == 0) { Rest(2) } { x }
//	}
}.value;
);




/////sequence
	(
		~a=Pdef(\1, Pbind(\instrument, \kick,
			\dur,Pseq(~dur1,inf),
				\amp,1/2.sqrt,
				\n,496,
				\pan,5,
					\m,3,
			\low,0,
				\noise,0.001,
					\az1,pi.rand2,
					\el1,pi.rand2,
					\az2,pi.rand2,
					\el2,pi.rand2,
					\az3,pi.rand2,
					\el3,pi.rand2,
			\temp_mag1,pi.rand2,
					\temp_mag2,pi.rand2,
					\temp_mag3,pi.rand2,
				\decay,1,
				\attack,0.01,
					\azx,0,
					\azy,pi/2,
					\elx,pi/4,
					\ely,pi/4;
		))
);


);



TempoClock.default.tempo_(3);

(
~a.play;
);

2.wait;
});
	Tdef(\drone).play;
}
)
)


/*
(
var n=1.neg;
r = Routine {
	loop{ 6.do{n=n+1; Synth(\kick,[	\amp,10,\n,24,\pan,1,\low,0,\noise,0.001,\decay,1,\attack,0.01;]);
		~dur1.[n].wait;};n=1.neg;
		//2.wait;
};

}
);

r.play

	///tetrahedron
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
//////cube
(
~az=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////octahedron

(
~az=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
)

//////icosahedron
(
~az=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~el=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)

/////dodecahedron

(
~az=[45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,
	90.neg.degrad,69.09.degrad,110.91.degrad,110.91.neg.degrad,69.09.neg.degrad,0.degrad,180.degrad];

~el=[35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,69.09.neg.degrad,69.09.neg.degrad,20.91.neg.degrad,20.91.neg.degrad,
	35.26.degrad,35.26.degrad,35.26.degrad,35.26.degrad,69.09.degrad,69.09.degrad,0.degrad,0.degrad,0.degrad,0.degrad,20.91.degrad,20.91.degrad]
)

/////Rhombic dodecahedron//// hull

(
~az=[0.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,0.degrad,180.degrad,90.degrad,90.neg.degrad,0.degrad,
	45.degrad,135.neg.degrad,135.degrad,45.neg.degrad];
~el=[90.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,0.degrad
	,0.degrad,0.degrad,0.degrad,90.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////cuboctahedron//// core

(
~az=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~el=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)


///////////////Rhombic Triacontahedron//// hull
(
~az=[0.degrad,0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,0.degrad];

~el=[90.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,90.degrad];

)

///////icosidodecahedron//// core
(
~az=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~el=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];

)*/