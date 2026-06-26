(
s.options.numWireBufs = 1024*8;
s.options.numOutputBusChannels=8;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(1);
s.options.memSize = 8192*32;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 4;
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
s.boot;
)


Buffer.freeAll
(
~c1 = Buffer.readChannel(s,,channels:0 );
~c2 = Buffer.readChannel(s,,channels:1 );
)

////speaker setup

///tetrahedon
(
	~a = VBAPSpeakerArray.new(3, [[0, 45], [180, 45], [90, 45.neg], [90.neg, 45.neg]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);

///cube

(
~a = VBAPSpeakerArray.new(3,
[[45, 35.264390.neg], [135, 35.264390.neg], [45.neg, 35.264390.neg], [135.neg, 35.264390.neg],[45,35.264390],[135,35.264390],[45.neg,35.264390],[135.neg,35.264390]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
)

/////////////////array
(
{
var  sph1,sph2,sph3,sph4,sph5,sph6,sph7,m_x=0,m_y=0,m_z=0,qx,qy,mq=1;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z,mag_qx,mag_qy;
var az4=0,el4=0,az5=0,el5=0,az6=0,el6=0,az7=0,el7=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez,angle=0,n=12;
var sphx,sphy,sphz,azx,elx,azy,ely,azz,elz,plx=1,ply=1,plz=1;
var num=1.neg,silver=(1+2.sqrt),golden=((1+5.sqrt)/2);
var ellipsis=[1,1,1],spread=1;
var mag1=1,mag2=1,mag3=1,mag4=1,mag5=1,mag6=1,mag7=1;
	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];

	55.do{
azimuth=21.collect{
			az1 = (az1+((180*2.pow(n/12))-((180*2.pow(n/12))/silver))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
		   el1 = (el1+((90*2.pow(n/12))-((90*2.pow(n/12))/silver))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

sph1=(Spherical(mag1,(az1.degrad+angle.degrad).wrap(pi.neg,pi),(el1.degrad+angle.degrad).wrap((pi/2).neg,(pi/2)))).theta.round(0.000000000001);

	};

elevation=21.collect{
				az2 = (az2+((180*2.pow(n/12))-((180*2.pow(n/12))/silver))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
			el2 = (el2+((90*2.pow(n/12))-((90*2.pow(n/12))/silver))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

		sph2=(Spherical(mag2,(az2.degrad+angle.degrad).wrap(pi.neg,pi),(el2.degrad+angle.degrad).wrap((pi/2).neg,(pi/2)))).phi.round(0.000000000001);

	};

magnitudex=	21.collect{
			az3 = (az3+((180*2.pow(n/12))-((180*2.pow(n/12))/silver))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
			el3 = (el3+((90*2.pow(n/12))-((90*2.pow(n/12))/silver))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

	sph3=(Spherical(mag3,(az3.degrad+angle.degrad).wrap(pi.neg,pi),(el3.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

	 mag_x=((Complex(cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

				};

magnitudey=	21.collect{
			az4 = (az4+((180*2.pow(n/12))-((180*2.pow(n/12))/silver))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
				el4 = (el4+((90*2.pow(n/12))-((90*2.pow(n/12))/silver))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

	sph4=(Spherical(mag4,(az4.degrad+angle.degrad).wrap(pi.neg,pi),(el4.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

		 mag_y=((Complex(sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi)),sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
		 (Complex(cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
				};


qx=	21.collect{
			az5 = (az5+((180*2.pow(n/12))-((180*2.pow(n/12))/silver))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
			el5 = (el5+((90*2.pow(n/12))-((90*2.pow(n/12))/silver))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

	sph5=(Spherical(mag5,(az5.degrad+angle.degrad).wrap(pi.neg,pi),(el5.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));


mag_qx=((((Complex(cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),
cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),
cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


qy=	21.collect{
			az6 = (az6+((180*2.pow(n/12))-((180*2.pow(n/12))/silver))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
			el6 = (el6+((90*2.pow(n/12))-((90*2.pow(n/12))/silver))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

	sph6=(Spherical(mag6,(az6.degrad+angle.degrad).wrap(pi.neg,pi),(el6.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

 mag_qy=((((Complex(sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),
sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),
cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


magnitudez=	21.collect{
			az7 = (az7+((180*2.pow(n/12))-((180*2.pow(n/12))/silver))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
			el7 = (el7+((90*2.pow(n/12))-((90*2.pow(n/12))/silver))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

sph7=(Spherical(mag7,(az7.degrad+angle.degrad).wrap(pi.neg,pi),(el7.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

//if(
//m_z.even,
mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread)
			//,
//mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho(2.sqrt)).pow(spread);
			//);
////z axis   ambi..  sin for odd numbers, cos for even
				};

angle=(angle+((180*2.pow(n/12))-((180*2.pow(n/12))/silver))).wrap(0,(180*2.pow(n/12)));

~az=~az++azimuth;~el=~el++elevation;
~magx=~magx++magnitudex;~magy=~magy++magnitudey;~magz=~magz++magnitudez;
~qx=~qx++qx;~qy=~qy++qy;

		az1=0;el1=0;az2=0;el2=0;az3=0;el3=0;
		az4=0;el4=0;az5=0;el5=0;az6=0;el6=0;az7=0;el7=0;
	}
}.value;
(
{
var nn=1.neg;
	~arrayL=(55*21).collect{nn=nn+1
}}.value;
thisThread.randSeed = 345;
~arrayL=~arrayL.scramble;
);
(
{
var nn=1.neg;
	~arrayR=(55*21).collect{nn=nn+1
}}.value;
thisThread.randSeed = 123;
~arrayR=~arrayR.scramble;
);
)

//(44100/1024)*170///sample rate/ fft size  times  partials number =spectrum
//((44100/4096)*143)*8  bins, b variable: 143  286  429  572 715 858 1001

(
SynthDef.new(\re, {
    var in1,in2,in3,in4,chaina,chainb,chainc,chaind,b=1001;///put b=143... for recording of rest of the spectrum
	var chainxx,chainyy,pl=0,amp,magg,lfo,per,sph1,sph2;
	var chainaa,chainbb,chaincc,chaindd,chainee,chainff;
	var ph,frames=(1024*4),sig1,sig2,sig3,sig4,spread=1;
	var delay,decay,sph,mod_angle,mod_angle1,m=2,mq=2;
	var magx,magy,magz,magx1,magy1,magz1,mag_x,mag_y,mag_z,mag_x1,mag_y1,mag_z1;
	var magqx,magqy,mag_qx,mag_qy,magg1,per1,ph1;

     in1 = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 0, doneAction:2);
	in2 = PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2.bufnum), loop: 0, doneAction:2);

	chaina = FFT(LocalBuf(frames), in1);
	chainb = FFT(LocalBuf(frames), in2);

	lfo=1;
	mod_angle=SinOsc.ar(lfo,0.degrad).range(90.neg.degrad,90.degrad);
	mod_angle1=SinOsc.ar(lfo,90.degrad).range(90.neg.degrad,90.degrad);

	143.do{

		sph=Spherical(1,~az.[pl],~el.[pl]);
		sph1=Spherical(1,~az.[~arrayR.[pl]],~el.[~arrayR.[pl]]);
		sph2=Spherical(1,~az.[~arrayL.[pl]],~el.[~arrayL.[pl]]);
(
magx=((Complex(cos(((sph1.theta+mod_angle).round(0.00001)*m).wrap(pi.neg,pi)),cos((((sph1.theta+mod_angle).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
(Complex(cos((sph1.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph1.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread););

magy=((Complex(sin(((sph1.theta+mod_angle1).round(0.00001)*m).wrap(pi.neg,pi)),sin(((sph1.theta+mod_angle1).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
(Complex(cos((sph1.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph1.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread););

magz=((Complex(cos(((sph1.phi+mod_angle).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((sph1.phi+mod_angle1).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

magx1=((Complex(cos(((sph2.theta+mod_angle).round(0.00001)*m).wrap(pi.neg,pi)),cos((((sph2.theta+mod_angle).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
(Complex(cos((sph2.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph2.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread););

magy1=((Complex(sin(((sph2.theta+mod_angle1).round(0.00001)*m).wrap(pi.neg,pi)),sin(((sph2.theta+mod_angle1).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
(Complex(cos((sph2.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph2.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread););

magz1=((Complex(cos(((sph2.phi+mod_angle).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((sph2.phi+mod_angle1).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

/*magqx=((((Complex(cos(((sph.theta.round(0.00001)+mod_angle)*mq).wrap(pi.neg,pi)),
cos(((sph.theta.round(0.00001)+mod_angle)*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);

 magqy=((((Complex(sin(((sph.theta.round(0.00001)+mod_angle1)*mq).wrap(pi.neg,pi)),
sin(((sph.theta.round(0.00001)+mod_angle1)*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);*/

mag_x=magx.value;mag_y=magy.value;mag_z=magz.value;//mag_qx=magqx.value;mag_qy=magqy.value
mag_x1=magx1.value;mag_y1=magy1.value;mag_z1=magz1.value;
);

magg=(Cartesian(mag_x,mag_y,mag_z).rho/2.sqrt);
magg1=(Cartesian(mag_x1,mag_y1,mag_z1).rho/2.sqrt);
		//+(Cartesian(mag_qx,mag_qy,0).rho/2.sqrt);

per=Spherical(90.degrad,sph1.theta,sph1.phi);
per1=Spherical(90.degrad,sph2.theta,sph2.phi);

ph=(per.x+per.y+per.z).wrap((pi/2).neg,(pi/2));
ph1=(per1.x+per1.y+per1.z).wrap((pi/2).neg,(pi/2));

chainaa = chaina.pvcollect(frames, {|mag, phase, index| [mag*magg, phase]; }, frombin: b, tobin: b, zeroothers: 1);
chainbb = chainb.pvcollect(frames, {|mag, phase, index| [mag*magg1, phase]; }, frombin: b, tobin: b, zeroothers: 1);

b=b+1;

Out.ar(0,VBAP.ar(8,LeakDC.ar(IFFT(chainaa)*3),
			~b.bufnum,(MouseX.kr(180.neg,180).lag(0.01)+sph1.theta.raddeg).wrap(180.neg,180),(MouseY.kr(90.neg,90).lag(0.01)+sph1.phi.raddeg).wrap(90.neg,90)));
Out.ar(0,VBAP.ar(8,LeakDC.ar(IFFT(chainbb)*3),
			~b.bufnum,(MouseX.kr(180.neg,180).lag(0.01)+sph2.theta.raddeg).wrap(180.neg,180),(MouseY.kr(90.neg,90).lag(0.01)+sph2.phi.raddeg).wrap(90.neg,90)));

		pl=pl+1;

	};
}).add;
)




(
Synth(\re);
s.record(numChannels:8,duration:(8*60));
)


/////mix rest of spectrum rec
Buffer.freeAll
(
~c1 = Buffer.readChannel(s,,channels:0 );
~c2 = Buffer.readChannel(s,,channels:1 );
~c3 = Buffer.readChannel(s,,channels:2 );
~c4 = Buffer.readChannel(s,,channels:3 );
~c5 = Buffer.readChannel(s,,channels:4 );
~c6 = Buffer.readChannel(s,,channels:5 );
~c7 = Buffer.readChannel(s,,channels:6 );
~c8 = Buffer.readChannel(s,,channels:7 );
~c9 = Buffer.readChannel(s,,channels:0 );
~c10 = Buffer.readChannel(s,,channels:1);
~c11 = Buffer.readChannel(s,,channels:2 );
~c12 = Buffer.readChannel(s,,channels:3 );
~c13 = Buffer.readChannel(s,,channels:4 );
~c14 = Buffer.readChannel(s,,channels:5 );
~c15 = Buffer.readChannel(s,,channels:6 );
~c16 = Buffer.readChannel(s,,channels:7 );
~c17 = Buffer.readChannel(s,,channels:0 );
~c18 = Buffer.readChannel(s,,channels:1);
~c19 = Buffer.readChannel(s,,channels:2 );
~c20 = Buffer.readChannel(s,,channels:3 );
~c21 = Buffer.readChannel(s,,channels:4 );
~c22 = Buffer.readChannel(s,,channels:5 );
~c23 = Buffer.readChannel(s,,channels:6 );
~c24 = Buffer.readChannel(s,,channels:7 );
~c25 = Buffer.readChannel(s,,channels:0 );
~c26 = Buffer.readChannel(s,,channels:1);
~c27 = Buffer.readChannel(s,,channels:2 );
~c28 = Buffer.readChannel(s,,channels:3 );
~c29 = Buffer.readChannel(s,,channels:4 );
~c30 = Buffer.readChannel(s,,channels:5 );
~c31 = Buffer.readChannel(s,,channels:6 );
~c32 = Buffer.readChannel(s,,channels:7 );
~c33 = Buffer.readChannel(s,,channels:0 );
~c34 = Buffer.readChannel(s,,channels:1);
~c35 = Buffer.readChannel(s,,channels:2 );
~c36 = Buffer.readChannel(s,,channels:3 );
~c37 = Buffer.readChannel(s,,channels:4 );
~c38 = Buffer.readChannel(s,,channels:5 );
~c39 = Buffer.readChannel(s,,channels:6 );
~c40 = Buffer.readChannel(s,,channels:7 );
~c41 = Buffer.readChannel(s,,channels:0 );
~c42 = Buffer.readChannel(s,,channels:1);
~c43 = Buffer.readChannel(s,,channels:2 );
~c44 = Buffer.readChannel(s,,channels:3 );
~c45 = Buffer.readChannel(s,,channels:4 );
~c46 = Buffer.readChannel(s,,channels:5 );
~c47 = Buffer.readChannel(s,,channels:6 );
~c48 = Buffer.readChannel(s,,channels:7 );
~c49 = Buffer.readChannel(s,,channels:0 );
~c50 = Buffer.readChannel(s,,channels:1);
~c51 = Buffer.readChannel(s,,channels:2 );
~c52 = Buffer.readChannel(s,,channels:3 );
~c53 = Buffer.readChannel(s,,channels:4 );
~c54 = Buffer.readChannel(s,,channels:5 );
~c55 = Buffer.readChannel(s,,channels:6 );
~c56 = Buffer.readChannel(s,,channels:7 );
~c57 = Buffer.readChannel(s,,channels:0 );
~c58 = Buffer.readChannel(s,,channels:1);
~c59 = Buffer.readChannel(s,,channels:2 );
~c60 = Buffer.readChannel(s,,channels:3 );
~c61 = Buffer.readChannel(s,,channels:4 );
~c62 = Buffer.readChannel(s,,channels:5 );
~c63 = Buffer.readChannel(s,,channels:6 );
~c64 = Buffer.readChannel(s,,channels:7 );
)

(
{Out.ar(0,PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(0,PlayBuf.ar(1, ~c9.bufnum, BufRateScale.kr(~c9.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(0,PlayBuf.ar(1, ~c17.bufnum, BufRateScale.kr(~c17.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(0,PlayBuf.ar(1, ~c25.bufnum, BufRateScale.kr(~c25.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(0,PlayBuf.ar(1, ~c33.bufnum, BufRateScale.kr(~c33.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(0,PlayBuf.ar(1, ~c41.bufnum, BufRateScale.kr(~c41.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(0,PlayBuf.ar(1, ~c49.bufnum, BufRateScale.kr(~c49.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(0,PlayBuf.ar(1, ~c57.bufnum, BufRateScale.kr(~c57.bufnum), loop: 0, doneAction:2)*0.8)}.play;

{Out.ar(1,PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(1,PlayBuf.ar(1, ~c10.bufnum, BufRateScale.kr(~c10.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(1,PlayBuf.ar(1, ~c18.bufnum, BufRateScale.kr(~c18.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(1,PlayBuf.ar(1, ~c26.bufnum, BufRateScale.kr(~c26.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(1,PlayBuf.ar(1, ~c34.bufnum, BufRateScale.kr(~c34.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(1,PlayBuf.ar(1, ~c42.bufnum, BufRateScale.kr(~c42.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(1,PlayBuf.ar(1, ~c50.bufnum, BufRateScale.kr(~c50.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(1,PlayBuf.ar(1, ~c58.bufnum, BufRateScale.kr(~c58.bufnum), loop: 0, doneAction:2)*0.8)}.play;

{Out.ar(2,PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(2,PlayBuf.ar(1, ~c11.bufnum, BufRateScale.kr(~c11.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(2,PlayBuf.ar(1, ~c19.bufnum, BufRateScale.kr(~c19.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(2,PlayBuf.ar(1, ~c27.bufnum, BufRateScale.kr(~c27.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(2,PlayBuf.ar(1, ~c35.bufnum, BufRateScale.kr(~c35.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(2,PlayBuf.ar(1, ~c43.bufnum, BufRateScale.kr(~c43.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(2,PlayBuf.ar(1, ~c51.bufnum, BufRateScale.kr(~c51.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(2,PlayBuf.ar(1, ~c59.bufnum, BufRateScale.kr(~c59.bufnum), loop: 0, doneAction:2)*0.8)}.play;

{Out.ar(3,PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(3,PlayBuf.ar(1, ~c12.bufnum, BufRateScale.kr(~c12.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(3,PlayBuf.ar(1, ~c20.bufnum, BufRateScale.kr(~c20.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(3,PlayBuf.ar(1, ~c28.bufnum, BufRateScale.kr(~c28.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(3,PlayBuf.ar(1, ~c36.bufnum, BufRateScale.kr(~c36.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(3,PlayBuf.ar(1, ~c44.bufnum, BufRateScale.kr(~c44.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(3,PlayBuf.ar(1, ~c52.bufnum, BufRateScale.kr(~c52.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(3,PlayBuf.ar(1, ~c60.bufnum, BufRateScale.kr(~c60.bufnum), loop: 0, doneAction:2)*0.8)}.play;

{Out.ar(4,PlayBuf.ar(1, ~c5.bufnum, BufRateScale.kr(~c5.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(4,PlayBuf.ar(1, ~c13.bufnum, BufRateScale.kr(~c13.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(4,PlayBuf.ar(1, ~c21.bufnum, BufRateScale.kr(~c21.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(4,PlayBuf.ar(1, ~c29.bufnum, BufRateScale.kr(~c29.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(4,PlayBuf.ar(1, ~c37.bufnum, BufRateScale.kr(~c37.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(4,PlayBuf.ar(1, ~c45.bufnum, BufRateScale.kr(~c45.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(4,PlayBuf.ar(1, ~c53.bufnum, BufRateScale.kr(~c53.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(4,PlayBuf.ar(1, ~c61.bufnum, BufRateScale.kr(~c61.bufnum), loop: 0, doneAction:2)*0.8)}.play;

{Out.ar(5,PlayBuf.ar(1, ~c6.bufnum, BufRateScale.kr(~c6.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(5,PlayBuf.ar(1, ~c14.bufnum, BufRateScale.kr(~c14.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(5,PlayBuf.ar(1, ~c22.bufnum, BufRateScale.kr(~c22.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(5,PlayBuf.ar(1, ~c30.bufnum, BufRateScale.kr(~c30.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(5,PlayBuf.ar(1, ~c38.bufnum, BufRateScale.kr(~c38.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(5,PlayBuf.ar(1, ~c46.bufnum, BufRateScale.kr(~c46.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(5,PlayBuf.ar(1, ~c54.bufnum, BufRateScale.kr(~c54.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(5,PlayBuf.ar(1, ~c62.bufnum, BufRateScale.kr(~c62.bufnum), loop: 0, doneAction:2)*0.8)}.play;

{Out.ar(6,PlayBuf.ar(1, ~c7.bufnum, BufRateScale.kr(~c7.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(6,PlayBuf.ar(1, ~c15.bufnum, BufRateScale.kr(~c15.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(6,PlayBuf.ar(1, ~c23.bufnum, BufRateScale.kr(~c23.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(6,PlayBuf.ar(1, ~c31.bufnum, BufRateScale.kr(~c31.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(6,PlayBuf.ar(1, ~c39.bufnum, BufRateScale.kr(~c39.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(6,PlayBuf.ar(1, ~c47.bufnum, BufRateScale.kr(~c47.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(6,PlayBuf.ar(1, ~c55.bufnum, BufRateScale.kr(~c55.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(6,PlayBuf.ar(1, ~c63.bufnum, BufRateScale.kr(~c63.bufnum), loop: 0, doneAction:2)*0.8)}.play;

{Out.ar(7,PlayBuf.ar(1, ~c8.bufnum, BufRateScale.kr(~c8.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(7,PlayBuf.ar(1, ~c16.bufnum, BufRateScale.kr(~c16.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(7,PlayBuf.ar(1, ~c24.bufnum, BufRateScale.kr(~c24.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(7,PlayBuf.ar(1, ~c32.bufnum, BufRateScale.kr(~c32.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(7,PlayBuf.ar(1, ~c40.bufnum, BufRateScale.kr(~c40.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(7,PlayBuf.ar(1, ~c48.bufnum, BufRateScale.kr(~c48.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(7,PlayBuf.ar(1, ~c56.bufnum, BufRateScale.kr(~c56.bufnum), loop: 0, doneAction:2)*0.8)}.play;
{Out.ar(7,PlayBuf.ar(1, ~c64.bufnum, BufRateScale.kr(~c64.bufnum), loop: 0, doneAction:2)*0.8)}.play;

s.record(numChannels:8,duration:(8*60));
)

/////////playback////
(
Buffer.freeAll;
~c1 = Buffer.readChannel(s,,channels:0 );
~c2 = Buffer.readChannel(s,,channels:1 );
~c3 = Buffer.readChannel(s,,channels:2 );
~c4 = Buffer.readChannel(s,,channels:3 );
~c5 = Buffer.readChannel(s,,channels:4 );
~c6 = Buffer.readChannel(s,,channels:5 );
~c7 = Buffer.readChannel(s,,channels:6 );
~c8 = Buffer.readChannel(s,,channels:7 );
)

(
{Out.ar(0,PlayBuf.ar(1, ~ca.bufnum, BufRateScale.kr(~ca.bufnum), loop: 0, doneAction:2))}.play;
{Out.ar(1,PlayBuf.ar(1, ~cb.bufnum, BufRateScale.kr(~cb.bufnum), loop: 0, doneAction:2))}.play;
{Out.ar(2,PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3.bufnum), loop: 0, doneAction:2))}.play;
{Out.ar(3,PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4.bufnum), loop: 0, doneAction:2))}.play;
{Out.ar(4,PlayBuf.ar(1, ~c5.bufnum, BufRateScale.kr(~c5.bufnum), loop: 0, doneAction:2))}.play;
{Out.ar(5,PlayBuf.ar(1, ~c6.bufnum, BufRateScale.kr(~c6.bufnum), loop: 0, doneAction:2))}.play;
{Out.ar(6,PlayBuf.ar(1, ~c7.bufnum, BufRateScale.kr(~c7.bufnum), loop: 0, doneAction:2))}.play;
{Out.ar(7,PlayBuf.ar(1, ~c8.bufnum, BufRateScale.kr(~c8.bufnum), loop: 0, doneAction:2))}.play;
//s.record(numChannels:8,duration:(8*60));
)


////4 stereo pairs

(
Buffer.freeAll;
~c1 = Buffer.readChannel(s,,channels:0 );
~c2 = Buffer.readChannel(s,,channels:1 );
~c3 = Buffer.readChannel(s,,channels:2 );
~c4 = Buffer.readChannel(s,,channels:3 );
~c5 = Buffer.readChannel(s,,channels:4 );
~c6 = Buffer.readChannel(s,,channels:5 );
~c7 = Buffer.readChannel(s,,channels:6 );
~c8 = Buffer.readChannel(s,,channels:7 );
)

////L1
(
{Out.ar(0,HPF.ar(PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 0, doneAction:2),56,pi.reciprocal))}.play;
{Out.ar(1,HPF.ar(PlayBuf.ar(1, ~c7.bufnum, BufRateScale.kr(~c7.bufnum), loop: 0, doneAction:2),56,pi.reciprocal))}.play;
s.record(numChannels:2,duration:(8*60));
)
////L2
(
{Out.ar(0,HPF.ar(PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2.bufnum), loop: 0, doneAction:2),56,pi.reciprocal))}.play;
{Out.ar(1,HPF.ar(PlayBuf.ar(1, ~c8.bufnum, BufRateScale.kr(~c8.bufnum), loop: 0, doneAction:2),56,pi.reciprocal))}.play;
s.record(numChannels:2,duration:(8*60));
)
////R1
(
{Out.ar(0,HPF.ar(PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3.bufnum), loop: 0, doneAction:2),56,pi.reciprocal))}.play;
{Out.ar(1,HPF.ar(PlayBuf.ar(1, ~c5.bufnum, BufRateScale.kr(~c5.bufnum), loop: 0, doneAction:2),56,pi.reciprocal))}.play;
s.record(numChannels:2,duration:(8*60));
)
///R2
(
{Out.ar(0,HPF.ar(PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4.bufnum), loop: 0, doneAction:2),56,pi.reciprocal))}.play;
{Out.ar(1,HPF.ar(PlayBuf.ar(1, ~c6.bufnum, BufRateScale.kr(~c6.bufnum), loop: 0, doneAction:2),56,pi.reciprocal))}.play;
s.record(numChannels:2,duration:(8*60));
)

