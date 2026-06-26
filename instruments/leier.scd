///in from e string instrument
///fft panning
///distortion

(
(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=1;
s.options.memSize = 8192*16;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
//s.boot;
);

//
(
s.waitForBoot{
s.freqscope;
s.scope;
//s.makeWindow;
s.meter;
	~frames=1024;
	Buffer.freeAll;

		///difusion array
(
{
var  sph1,sph2,az1=0,el1=0,az2=0,el2=0,azimuth,elevation,angle=0,g=((1+5.sqrt)/2),s=(1+2.sqrt);
	~az=[];~el=[];


	4.do{
azimuth=8.collect{
			az1 = (az1+(2pi-(2pi/s))).wrap(pi.neg,pi);
		   el1 = (el1+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
sph1=(Spherical(1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)))).theta.round(0.0001);

	};

elevation=8.collect{
				az2 = (az2+(2pi-(2pi/s))).wrap(pi.neg,pi);
			el2 = (el2+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
		sph2=(Spherical(1,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)))).phi.round(0.0001);

	};

angle=(angle+(2pi-(2pi/g))).wrap(pi.neg,pi);
~az=~az++azimuth;~el=~el++elevation;

		az1=0;el1=0;az2=0;el2=0;
				}
}.value;
);

		//difusion
		(
			{
var steps = 32;

~nVals = steps.collect { |i|
    i.linexp(0, steps-1, 0.18, 1024).round
};
			~nVals.asInteger;
			}.value;
		);

		////sound

(
SynthDef.new(\synth,{

	arg gain=1,pan=1,mix=0.3,a=1,room=0.5,m=2,pon=1,drive=1,spread=1;

	var g_ch1,g_ch2,g_ch3,g_ch4,pl=0,phasex,phasey,phasez;
	var out1,out2,out3,threshold1,threshold2,threshold3,phase1,phase2,phase3;
	var sig1,sig2,sig3,b_x,b_y,b_z,polytope,gain1,gain2,gain3,azimuth,elevation;
	var magx,magy,magz,magqx,magqy,mod_anglex,anglex,angley,anglez;
	var mod_angley,mod_anglez,mx,my,mz,mqx,mqy,mag,mq,lfo,sph,loc1,loc2,loc3;
	var amb_w,amb_x,amb_y,amb_z,out,amb_sig1,amb_sig2,amb_sig3,g1,g2,g3,axis;
	var gn ,g_sum,g_avg ,in,chain, frames=~frames,chainf1,chainf2,chainf3;

				mq=m+1;

		in = SoundIn.ar(0);
	chain = FFT(LocalBuf(frames),in);
						lfo=2.pow(pan/992);



				(31).do{

					axis=Spherical(1,~az.[pl],~el.[pl]);

				polytope=Cartesian(axis.x,axis.y,axis.z);

anglex=(exp(Complex(0,1)*polytope.theta).real*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
angley=(exp(Complex(0,1)*polytope.theta).imag*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
anglez=(exp(Complex(0,1)*polytope.phi).imag).round(0.00001);

phase1=Complex(1,anglex).theta;
phase2=Complex(1,angley).theta;
phase3=Complex(1,anglez).theta;


mod_anglex=SinOsc.ar(lfo,phase1).range(pi.neg,pi);
mod_angley=SinOsc.ar(lfo,phase2).range(pi.neg,pi);
mod_anglez=SinOsc.ar(lfo,phase3).range((pi/2).neg,(pi/2));

					(
	magx=((Complex(cos(((polytope.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((polytope.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magy=((Complex(sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magz=((Complex(cos(((polytope.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((polytope.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magqx=(((Complex(cos(((polytope.theta+mod_anglex)*mq).wrap(pi.neg,pi)),cos(((polytope.theta+mod_anglex)*mq).round(0.00001).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt);



 magqy=((((Complex(sin(((polytope.theta.round(0.00001)+mod_angley)*mq).wrap(pi.neg,pi)),
sin(((polytope.theta.round(0.00001)+mod_angley)*mq).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt));
	);

					mx=(Cartesian(magx,0,0).rho);
					my=(Cartesian(0,magy,0).rho);
					mz=(Cartesian(0,0,magz).rho);
					mag=(Cartesian(magqx,my,mz).rho/2.sqrt) ;

		sph=Spherical(mag,polytope.theta,polytope.phi);

loc1=magqx;  loc2=magy;  loc3=magz;

phasex=Complex(1,sph.x).theta;
phasey=Complex(1,sph.y).theta;
phasez=Complex(1,sph.z).theta;

chainf1= chain.pvcollect(frames,
						{|mag, phase, index| [(mag), (phase+phasex)]; }, frombin: ~nVals.[pl], tobin:  ~nVals.[pl]+1, zeroothers: 1);
chainf2= chain.pvcollect(frames,
						{|mag, phase, index| [(mag), (phase+phasey)]; }, frombin: ~nVals.[pl], tobin:  ~nVals.[pl]+1, zeroothers: 1);
chainf3= chain.pvcollect(frames,
						{|mag, phase, index| [(mag), (phase+phasez)]; }, frombin: ~nVals.[pl], tobin: ~nVals.[pl]+1, zeroothers: 1);

				sig1=IFFT(chainf1);
				sig2=IFFT(chainf2);
				sig3=IFFT(chainf3);

threshold1=(((343/0.15)/55).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/0.15)/55).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/0.15)/55).reciprocal.ampdb/2.sqrt).dbamp;

		sig1=HPF.ar(sig1,50);
		sig2=HPF.ar(sig2, 50);
		sig3=HPF.ar(sig3, 50);

		sig1=Compander.ar(sig1,sig1,threshold1,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
		sig2=Compander.ar(sig2,sig2,threshold2,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
		sig3=Compander.ar(sig3,sig3,threshold3,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);

	///distortion
	sig1 = (tanh(sig1.softclip*2.pow(drive/992))) / (1 + (tanh(sig1.softclip*2.pow(drive/992))).abs);

	sig2 =  (tanh(sig2.softclip*2.pow(drive/992))) / (1 + (tanh(sig2.softclip*2.pow(drive/992))).abs);

	sig3 =  (tanh(sig3.softclip*2.pow(drive/992))) / (1 + (tanh(sig3.softclip*2.pow(drive/992))).abs);


	///final out

	///three channel
//	Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.0001),room.lag(0.0001),mul:gain*loc1)),0.9,0.01));
//	Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.0001),room.lag(0.0001),mul:gain*loc2)),0.9,0.01));
//	Out.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.0001),room.lag(0.0001),mul:gain*loc3)),0.9,0.01));


///ambisonic decoded on stereo

amb_sig1=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.0001),room.lag(0.0001),mul:gain*loc1)),0.9,0.01));
amb_sig2=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.0001),room.lag(0.0001),mul:gain*loc2)),0.9,0.01));
amb_sig3=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.0001),room.lag(0.0001),mul:gain*loc3)),0.9,0.01));

			amb_w=(amb_sig1+amb_sig2+amb_sig3)/2.sqrt;
				amb_x=amb_sig1;
				amb_y=amb_sig2;
				amb_z=amb_sig3;
			out= Out.ar(0,BFDecode1.ar1(amb_w, amb_x, amb_y, amb_z,
					[sph.theta+SinOsc.ar(pon,0), sph.theta+SinOsc.ar(pon,pi/2)], [sph.phi,sph.phi],2 ));

pl=pl+1;
				};

}).add;);

		}
)
)



~synth=Synth.new(\synth,[\gain,1,\drive,496,\pan,(992*4).neg,\mix,0.3,\room,0.5,\m,2,\pon,0.01,\spread,0.6]);


~synth.set(\drive,496*0,\gain,1,\pan,(992*4).neg,\mix,0.5,\room,0.7,\m,2,\pon,0.01,\spread,1);


