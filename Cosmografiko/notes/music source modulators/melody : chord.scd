
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=2;
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
)

//array experiments

////silver star
(
{
	var az=0,el1=0,sph,n=90,iter=90,rep=360,el,silver=(1+2.sqrt),w=((1+5.sqrt)/2);
	~az=[];~el=[];

rep.do{
el=iter.collect{
		el1 = 90/n;
			n=n-1;
sph=Spherical(1,az.degrad,el1.degrad).phi.round(0.000000000001);
	};
~az=~az++az.degrad;~el=~el++el;
//az = (az+1).wrap(0,360);
		az=(az+(360-(360/silver))).wrap(0,360);
el1=0;n=90;
	};
}.value;
);

/////sphere
		(
{
var  sph1,sph2,sph3,az1=0,el1=0,az2=0,el2=0,gold_r=((1+5.sqrt)/2),silver_r=(1+2.sqrt);
var azimuth,elevation,angle=0,n=12,ellipsis=[1,1,1];
var mag1=1,mag2=1,mag3=1,mag4=1,mag5=1,mag6=1,mag7=1;
	~az=[];~el=[];

	360.do{
azimuth=90.collect{
			az1 = (az1+((180*2.pow(n/12))-((180*2.pow(n/12))/silver_r))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
		   el1 = (el1+((90*2.pow(n/12))-((90*2.pow(n/12))/silver_r))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));
sph1=(Spherical(mag1,(az1.degrad+angle.degrad).wrap(pi.neg,pi),(el1.degrad+angle.degrad).wrap((pi/2).neg,(pi/2)))).theta.round(0.000000000001);
	};

elevation=90.collect{
				az2 = (az2+((180*2.pow(n/12))-((180*2.pow(n/12))/silver_r))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
			el2 = (el2+((90*2.pow(n/12))-((90*2.pow(n/12))/silver_r))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));
sph2=(Spherical(mag2,(az2.degrad+angle.degrad).wrap(pi.neg,pi),(el2.degrad+angle.degrad).wrap((pi/2).neg,(pi/2)))).phi.round(0.000000000001);
	};


angle=(angle+((180*2.pow(n/12))-((180*2.pow(n/12))/1.6180339887499))).wrap(0,(180*2.pow(n/12)));
~az=~az++azimuth;~el=~el++elevation;
		az1=0;el1=0;az2=0;el2=0;
	}
}.value;
);


///tetrahedron
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
)
//////test array
(
~az=[90.degrad,0.degrad];
~el=[0.degrad,0.degrad];
)

////tester
(var m,b,c,d,interval=56,octave=1; {

	//m=MouseX.kr(0,3).round(1).asInteger;
		//m=MouseX.kr(0,1).round(1).asInteger;
	m=MouseX.kr(0,(360*90)).round(1).asInteger;
	b=Spherical(interval*octave,Select.kr(m.lag(0.1),~az),Select.kr(m.lag(0.1),~el)).x.round(1);
	c=Spherical(interval*octave,Select.kr(m.lag(0.1),~az),Select.kr(m.lag(0.1),~el)).y.round(1);
	d=Spherical(interval*octave,Select.kr(m.lag(0.1),~az),Select.kr(m.lag(0.1),~el)).z.round(1);
	(2.pow(b/interval)).round(0.0001).poll;
	(2.pow(c/interval)).round(0.0001).poll;
	(2.pow(d/interval)).round(0.0001).poll;
		}.play
		)

/////////////sound example
(
SynthDef(\chord, {
	var freq1,freq2,freq3,n1,n2,n3,fund=440,env,bank=(1*11);
	var m,b,c,d,interval=12,octave=1,osc1,osc2,osc3,osc1a,osc2a,osc3a;

	//env= EnvGen.kr(Env.perc(0.1, 10),doneAction:2,levelScale:1/10);
env=0.05;
	m=SinOsc.ar(fund/1000/11).range(0,bank);
	b=Spherical(interval*octave,Select.kr(m.lag(0.1),~az),Select.kr(m.lag(0.1),~el)).x.round(1);
	c=Spherical(interval*octave,Select.kr(m.lag(0.1),~az),Select.kr(m.lag(0.1),~el)).y.round(1);
	d=Spherical(interval*octave,Select.kr(m.lag(0.1),~az),Select.kr(m.lag(0.1),~el)).z.round(1);
	n1=(2.pow(b/interval)).round(0.0001).poll;
	n2=(2.pow(c/interval)).round(0.0001).poll;
	n3=(2.pow(d/interval)).round(0.0001).poll;

	freq1=fund*n1;
	freq2=fund*n2;
	freq3=fund*n3;

	osc1=SinOsc.ar(freq1,mul:n1.reciprocal,phase:0.degrad);
	osc2=SinOsc.ar(freq2,mul:n2.reciprocal,phase:0.degrad);
	osc3=SinOsc.ar(freq3,mul:n3.reciprocal,phase:0.degrad);
	///xy view
	osc1a=SinOsc.ar(freq1,mul:n1.reciprocal,phase:90.degrad);
	osc2a=SinOsc.ar(freq2,mul:n2.reciprocal,phase:90.degrad);
	osc3a=SinOsc.ar(freq3,mul:n3.reciprocal,phase:90.degrad);

		Out.ar(0, Pan2.ar(osc1*env,1));
		Out.ar(0, Pan2.ar(osc2*env,1));
	    Out.ar(0, Pan2.ar(osc3*env,1));
		Out.ar(0, Pan2.ar(osc1a*env,1.neg));
		Out.ar(0, Pan2.ar(osc2a*env,1.neg));
	    Out.ar(0, Pan2.ar(osc3a*env,1.neg));


	};
).add;
)

Synth.new(\chord)


	(
		~chord=Pdef(\1, Pbind(\instrument, \chord,
			//\dur,Pseq(~dur1,inf);
		\dur,1;
		))
)





TempoClock.default.tempo_(1/1);


~chord.play;
~chord.pause;

////other arrays
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
/////////////sun
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

////planet
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
~az.[32].raddeg
~el.[32].raddeg

///////icosidodecahedron//// core
(
~az=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~el=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];

)