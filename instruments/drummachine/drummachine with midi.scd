



(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*4;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
s.options.sampleRate= 44100;
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
	arg amp=1,n=12,pan=1,low=0,noise=0.001,decay=1,attack=0.01;
    var env,freq,anglex,angley,anglez,mod_anglex,mod_angley,mod_anglez,fund=32,mx,my,mz,magx,magz,magy;
	var sph,phase,threshold,ton,az=pi,el=pi/2,m=2;
	var sig1,sig2,sig3,phasex,phasey,phasez,control1,control2,control3;
n=24;
			ton=2.pow(n/12);
	freq = EnvGen.kr(Env([fund*ton, fund], [decay], curve: -4)); // pitch drop
	env= EnvGen.kr(Env.perc(attack, decay, curve: -4),doneAction:2,levelScale:amp);

			threshold=(((343/0.14)/freq).reciprocal.ampdb/2.sqrt).dbamp;

					az=SinOsc.ar(pan/2,0).range(pi,pi.neg);
			el=SinOsc.ar(pan/2,pi/2,pan.reciprocal).range((pi/2),(pi/2).neg);

		sph=Spherical(1,(az.lag(0.01)),(el.lag(0.01)));

anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;

phasex=Complex(0,anglex).theta;
phasey=Complex(0,angley).theta;
phasez=Complex(0,anglez).theta;

mod_anglex=SinOsc.ar(pan,Complex(anglex,angley).theta,pan.reciprocal).range(pi.neg,pi);
mod_angley=SinOsc.ar(pan,Complex(angley,anglex).theta,pan.reciprocal).range(pi.neg,pi);
mod_anglez=SinOsc.ar(pan,Complex(0,anglez).theta,pan.reciprocal).range((pi/2).neg,(pi/2));

magx=((Complex(cos(((sph.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((sph.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
	(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magy=((Complex(sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
		(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magz=((Complex(cos(((sph.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((sph.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

mx=(Cartesian(magx.value,0,0).rho);my=(Cartesian(0,magy.value,0).rho);mz=(Cartesian(0,0,magz.value).rho);



sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasex,mul:1000).abs*SinOsc.ar(freq,phase:phasex)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasey,mul:1000).abs*SinOsc.ar(freq,phase:phasey)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasez,mul:1000).abs*SinOsc.ar(freq,phase:phasez)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));

control1=SinOsc.ar(freq,phasex,ton.reciprocal);
control2=SinOsc.ar(freq,phasey,ton.reciprocal);
control3=SinOsc.ar(freq,phasez,ton.reciprocal);

sig1 = sig1 + (sig1 * BrownNoise.ar(noise)); sig2 = sig2 + (sig2 * BrownNoise.ar(noise)); sig3 = sig3 + (sig3 * BrownNoise.ar(noise));


		sig1=HPF.ar(sig1,50); sig2=HPF.ar(sig1, 50);sig3=HPF.ar(sig1, 50);
		sig1=Compander.ar(sig1,control1,threshold,1.2,1/3,0.03,0.15);
		sig2=Compander.ar(sig2,control2,threshold,1.2,1/3,0.03,0.15);
		sig3=Compander.ar(sig3,control3,threshold,1.2,1/3,0.03,0.15);
		sig1=tanh(sig1*1.5);sig2=tanh(sig2*1.5);sig3=tanh(sig2*1.5);


		Out.ar(0, Pan2.ar(sig1,anglex.round(0.0001)*mx,env));
		Out.ar(0, Pan2.ar(sig2,angley.round(0.0001)*my,env));
		Out.ar(0, Pan2.ar(sig3,anglez.round(0.0001)*mz,env));

}).add;);

Synth(\kick);

/////snare
(
SynthDef(\snare, {
	arg amp=1,n=48,pan=0.5,low=0,noise=0.1,decay=1,snare=8;
    var env,freq,anglex,angley,anglez,mod_anglex,mod_angley,mod_anglez,fund=32,mx,my,mz,magx,magz,magy;
	var sph,phase,threshold,ton,az=pi,el=pi/2,m=2,fr;
	var sig1,sig2,sig3,phasex,phasey,phasez,control1,control2,control3;

				n=24;
			ton=2.pow(n/12);
			fr=fund*ton;
	freq = EnvGen.kr(Env([fr+(9/8), fr], [decay], curve: -4));
	env= EnvGen.kr(Env.perc(0.01, decay),doneAction:0,levelScale:amp);

			threshold=(((343/0.14)/freq).reciprocal.ampdb/2.sqrt).dbamp;

					az=SinOsc.ar(pan,0).range(pi,pi.neg);
			el=SinOsc.ar(pan,pi/2,pan.reciprocal).range((pi/2),(pi/2).neg);

sph=Spherical(1,(az.lag(0.01)),(el.lag(0.01)));

anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;

phasex=Complex(0,anglex).theta;
phasey=Complex(0,angley).theta;
phasez=Complex(0,anglez).theta;

mod_anglex=SinOsc.ar(pan,Complex(anglex,angley).theta,pan.reciprocal).range(pi.neg,pi);
mod_angley=SinOsc.ar(pan,Complex(angley,anglex).theta,pan.reciprocal).range(pi.neg,pi);
mod_anglez=SinOsc.ar(pan,Complex(0,anglez).theta,pan.reciprocal).range((pi/2).neg,(pi/2));

magx=((Complex(cos(((sph.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((sph.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
	(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magy=((Complex(sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
		(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magz=((Complex(cos(((sph.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((sph.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

mx=(Cartesian(magx.value,0,0).rho);my=(Cartesian(0,magy.value,0).rho);mz=(Cartesian(0,0,magz.value).rho);



sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasex,mul:1000).abs*SinOsc.ar(freq,phase:phasex)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasey,mul:1000).abs*SinOsc.ar(freq,phase:phasey)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasez,mul:1000).abs*SinOsc.ar(freq,phase:phasez)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));

control1=SinOsc.ar(freq,phasex,ton.reciprocal);
control2=SinOsc.ar(freq,phasey,ton.reciprocal);
control3=SinOsc.ar(freq,phasez,ton.reciprocal);

	sig1 = (sig1+ (HPF.ar(BrownNoise.ar(noise),snare*fund)* Env.perc(0.01, 0.1).ar));
	sig2 = (sig2+ (HPF.ar(BrownNoise.ar(noise),snare*fund)* Env.perc(0.01, 0.1).ar));
	sig3 = (sig3+ (HPF.ar(BrownNoise.ar(noise),snare*fund)* Env.perc(0.01, 0.1).ar));

		sig1=HPF.ar(sig1,50); sig2=HPF.ar(sig1, 50);sig3=HPF.ar(sig1, 50);
		sig1=Compander.ar(sig1,control1,threshold,1.2,1/3,0.03,0.15);
		sig2=Compander.ar(sig2,control2,threshold,1.2,1/3,0.03,0.15);
		sig3=Compander.ar(sig3,control3,threshold,1.2,1/3,0.03,0.15);
		sig1=tanh(sig1*1.5);sig2=tanh(sig2*1.5);sig3=tanh(sig2*1.5);

	Out.ar(0, Pan2.ar(sig1,anglex.round(0.0001)*mx,env));
		Out.ar(0, Pan2.ar(sig2,angley.round(0.0001)*my,env));
		Out.ar(0, Pan2.ar(sig3,anglez.round(0.0001)*mz,env));
}).add;
);

//Synth(\snare);
////hihat
(
SynthDef(\hihat, {
	arg amp=1,decay=0.1,n=(56),pan=1,attack,rq=1;
	var env,silver=pi/4,bank=4,s1,s2,s3,fund=32,freq,threshold,ton;
	var sph,anglex,angley,anglez,az,el,noise,sig,control;

			n=(56*16);
			ton=2.pow(n/56);
freq=fund*128;
threshold=(((343/0.14)/freq).reciprocal.ampdb/2.sqrt).dbamp;
	env= EnvGen.kr(Env.perc(attack, decay,-8),doneAction:0,levelScale:amp);
	noise = BrownNoise.ar(env);
	sig = BPF.ar(noise, freq, rq,(2.sqrt/rq));
	sig = HPF.ar(sig, freq,ton.reciprocal);

	control=sig;

			az=SinOsc.ar(pan,0).range(pi,pi.neg);
			el=SinOsc.ar(pan,pi/2,pan.reciprocal).range((pi/2),(pi/2).neg);

sph=Spherical(1,(az.lag(0.01)),(el.lag(0.01)));

anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;



		sig=HPF.ar(sig,50);
		sig=Compander.ar(sig,control,threshold,1.2,1/3,0.03,0.15);
		sig=tanh(sig*1);

		bank.do{
				s1=silver-anglex; s2=silver-angley; s3=silver-anglez;

		Out.ar(0, Pan2.ar(sig,s1,bank.reciprocal));
		Out.ar(0, Pan2.ar(sig,s2,bank.reciprocal));
		Out.ar(0, Pan2.ar(sig,s3,bank.reciprocal));

silver=(silver+(2pi-(2pi/(1+2.sqrt)))).wrap(pi.neg,pi).round(0.00001);

	};
}).add;
);
	//Synth(\hihat);
/*(
SynthDef(\ride, {
	arg amp=1,decay=4,attack=0.01,n,pan=1,az=pi/2,el=pi/4,rq=1;
    var env,silver=45,bank=8,sig,wash,ping,noise;
	var sph,anglex,angley,anglez,control,freq,ton,fr;
	var s1,s2,s3,fund=56,threshold,bell1,bell2,bell3;
	var sig1,sig2,sig3,phasex,phasey,phasez,control1,control2,control3;

n=(56*4);
ton=2.pow(n/56);

	env= EnvGen.kr(Env.perc(attack, decay),doneAction:0,levelScale:1);
	noise = PinkNoise.ar(env);
freq=fund*ton;
	sig = BPF.ar(noise, freq, rq,(rq/2.sqrt));
	sig = HPF.ar(sig, freq,ton.reciprocal);

threshold=(((343/0.14)/freq).reciprocal.ampdb/2.sqrt).dbamp;

az=SinOsc.ar(pan,0).range(pi,pi.neg);
el=SinOsc.ar(pan,pi/2,pan.reciprocal).range((pi/2),(pi/2).neg);

sph=Spherical(1,(az.lag(0.01)),(el.lag(0.01)));

anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;

phasex=Complex(0,anglex).theta;
phasey=Complex(0,angley).theta;
phasez=Complex(0,anglez).theta;

// ping (stick attack)
    ping = LPF.ar((Osc.ar(~w1.bufnum,freq,mul:1000).abs*SinOsc.ar(freq)),freq,ton.reciprocal/2)* env;

			fr=exprand(freq,freq*1000);
    // metallic wash
    wash = Mix.fill(bank, {
     LPF.ar((Osc.ar(~w1.bufnum,fr,mul:1000).abs*SinOsc.ar(fr)),fr,bank.reciprocal)
    });
    wash = HPF.ar(wash, freq*1000);
			wash = wash * EnvGen.ar(Env.perc(attack, decay/2));

    bell1 = SinOsc.ar(freq, phasex, ton.reciprocal/2) * EnvGen.ar(Env.perc(attack, decay/2));
	 bell2 = SinOsc.ar(freq, phasey,ton.reciprocal/2) * EnvGen.ar(Env.perc(attack, decay/2));
	 bell3 = SinOsc.ar(freq, phasez, ton.reciprocal/2) * EnvGen.ar(Env.perc(attack, decay/2));

    sig1 = (ping + wash + bell1)*amp;  sig2 = (ping + wash + bell2)*amp;   sig3 = (ping + wash + bell3)*amp;

control1=(ping + wash + bell1+noise)*amp;
control2=(ping + wash + bell2+noise)*amp;
control3=(ping + wash + bell3+noise)*amp;

	sig1=HPF.ar(sig1,50);sig2=HPF.ar(sig2,50);sig3=HPF.ar(sig3,50);
	sig1=Compander.ar(sig1,control1,threshold,1.2,1/3,0.03,0.15);
	sig2=Compander.ar(sig2,control2,threshold,1.2,1/3,0.03,0.15);
	sig3=Compander.ar(sig3,control3,threshold,1.2,1/3,0.03,0.15);
			sig1=tanh(sig1*1);sig2=tanh(sig2*1);sig3=tanh(sig3*1);

bank.do{

s1=silver-anglex; s2=silver-angley; s3=silver-anglez;

		Out.ar(0, Pan2.ar(sig1,s1,bank.reciprocal));
		Out.ar(0, Pan2.ar(sig2,s2,bank.reciprocal));
		Out.ar(0, Pan2.ar(sig3,s3,bank.reciprocal));

silver=(silver+(2pi-(2pi/(1+2.sqrt)))).wrap(pi.neg,pi).round(0.00001);

			}
}).add;
);
	//Synth(\ride);

	(
SynthDef(\crash, {
	arg amp=1,decay=2,attack=0.01,n=128,pan=1,az=pi/2,el=pi/4,rq=1;
    var env,silver=45,bank=16,sig,wash,noise,ton,fr;
	var sph,anglex,angley,anglez,freq,control;
	var s1,s2,s3,fund=56,threshold,phasex,phasey,phasez;

		n=(56*4);
ton=2.pow(n/56);

freq=fund*ton;
threshold=(((343/0.14)/freq).reciprocal.ampdb/2.sqrt).dbamp;

	env= EnvGen.kr(Env.perc(attack, decay,-8),doneAction:0,levelScale:amp);
	noise = PinkNoise.ar(env);
	sig = BPF.ar(noise, freq,rq,(2.sqrt/rq));
	sig = HPF.ar(sig, freq,ton.reciprocal);

			az=SinOsc.ar(pan,0).range(pi,pi.neg);
			el=SinOsc.ar(pan,pi/2,pan.reciprocal).range((pi/2),(pi/2).neg);

sph=Spherical(1,(az.lag(0.01)),(el.lag(0.01)));

anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;

	//	fr=exprand(freq,freq*1000);
    // metallic wash
   // wash = Mix.fill(bank, {
   //  LPF.ar((Osc.ar(~w1.bufnum,fr,mul:1000).abs*SinOsc.ar(fr)),fr,bank.reciprocal)
  //  });
   // wash = HPF.ar(wash, freq*1000);
		//	wash = wash * EnvGen.ar(Env.perc(attack, decay/4));

			sig = (sig + (WhiteNoise.ar(0.001)*EnvGen.ar(Env.perc(attack, decay/2))))*amp;
control= sig;

				sig=HPF.ar(sig,50);
		sig=Compander.ar(sig,control,threshold,1.2,1/3,0.03,0.15);
		sig=tanh(sig*1.5);

		bank.do{
				s1=silver-anglex; s2=silver-angley; s3=silver-anglez;

		Out.ar(0, Pan2.ar(sig,s1,bank.reciprocal));
		Out.ar(0, Pan2.ar(sig,s2,bank.reciprocal));
		Out.ar(0, Pan2.ar(sig,s3,bank.reciprocal));

silver=(silver+(2pi-(2pi/(1+2.sqrt)))).wrap(pi.neg,pi).round(0.00001);

	};
}).add;
);
	//Synth(\crash);*/
(
SynthDef(\tom, {
	arg amp=20,n=48,pan=1,low=0,noise=0.001,decay=1,attack=0.01;
    var env,freq,anglex,angley,anglez,mod_anglex,mod_angley,mod_anglez,fund=32,mx,my,mz,magx,magz,magy;
	var sph,phase,threshold,ton,az=pi,el=pi/2,m=2,fr;
	var sig1,sig2,sig3,phasex,phasey,phasez,control1,control2,control3;

				n=12*3;  ton=2.pow(n/12);	fr=fund*ton;
	freq = EnvGen.kr(Env([fr*1.01, fr], [decay], curve: -4)); // pitch drop
	env= EnvGen.kr(Env.perc(attack, decay, curve: -4),doneAction:0,levelScale:amp);

			threshold=(((343/0.14)/freq).reciprocal.ampdb/2.sqrt).dbamp;

					az=SinOsc.ar(pan/2,0).range(pi,pi.neg);
			el=SinOsc.ar(pan/2,pi/2,pan.reciprocal).range((pi/2),(pi/2).neg);

		sph=Spherical(1,(az.lag(0.01)),(el.lag(0.01)));

anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;

phasex=Complex(0,anglex).theta;
phasey=Complex(0,angley).theta;
phasez=Complex(0,anglez).theta;

mod_anglex=SinOsc.ar(pan,Complex(anglex,angley).theta,pan.reciprocal).range(pi.neg,pi);
mod_angley=SinOsc.ar(pan,Complex(angley,anglex).theta,pan.reciprocal).range(pi.neg,pi);
mod_anglez=SinOsc.ar(pan,Complex(0,anglez).theta,pan.reciprocal).range((pi/2).neg,(pi/2));

magx=((Complex(cos(((sph.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((sph.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
	(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magy=((Complex(sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
		(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magz=((Complex(cos(((sph.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((sph.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

mx=(Cartesian(magx.value,0,0).rho);my=(Cartesian(0,magy.value,0).rho);mz=(Cartesian(0,0,magz.value).rho);



sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasex,mul:1000).abs*SinOsc.ar(freq,phase:phasex)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasey,mul:1000).abs*SinOsc.ar(freq,phase:phasey)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasez,mul:1000).abs*SinOsc.ar(freq,phase:phasez)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));

control1=SinOsc.ar(freq,phasex,ton.reciprocal);
control2=SinOsc.ar(freq,phasey,ton.reciprocal);
control3=SinOsc.ar(freq,phasez,ton.reciprocal);

sig1 = sig1 + (sig1 * BrownNoise.ar(noise)); sig2 = sig2 + (sig2 * BrownNoise.ar(noise)); sig3 = sig3 + (sig3 * BrownNoise.ar(noise));


		sig1=HPF.ar(sig1,50); sig2=HPF.ar(sig1, 50);sig3=HPF.ar(sig1, 50);
		sig1=Compander.ar(sig1,control1,threshold,1.2,1/3,0.03,0.15);
		sig2=Compander.ar(sig2,control2,threshold,1.2,1/3,0.03,0.15);
		sig3=Compander.ar(sig3,control3,threshold,1.2,1/3,0.03,0.15);
		sig1=tanh(sig1*1.5);sig2=tanh(sig2*1.5);sig3=tanh(sig2*1.5);


		Out.ar(0, Pan2.ar(sig1,anglex.round(0.0001)*mx,env));
		Out.ar(0, Pan2.ar(sig2,angley.round(0.0001)*my,env));
		Out.ar(0, Pan2.ar(sig3,anglez.round(0.0001)*mz,env));

}).add;);
	//	Synth(\tom);

		///Delay1.ar(in: 0.0, mul: 1.0, add: 0.0, x1: 0.0)
);
	3.wait;
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
	({var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=6,time=16.reciprocal,beat=1;

~dur1=[];~dur2=[];~dur3=[];

~x=bank.collect{
m1=m1+1;
	b=Spherical(beat,~az.[m1],~el.[m1]).x.round(0.00001);
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~az.[m2],~el.[m2]).y.round(0.00001);
	2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~az.[m3],~el.[m3]).z.round(0.00001);
	2.pow(d).round(time);
};
		bank.do{ ~dur1=~dur1++~x.[n];n=n+1;};n=0;
		bank.do{ ~dur2=~dur2++~y.[n];n=n+1;};n=0;
		bank.do{ ~dur3=~dur3++~z.[n];n=n+1;};n=0;
	//	bank.do{~durs=~durs++~x.[n]++~y.[n]++~z.[n];n=n+1;}
//	~dur = ~duri.collect { |x|
  //  if (x == 0) { Rest(2) } { x }
//	}
}.value;
);
			({var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=6,time=16.reciprocal,beat=1;

~dur4=[];~dur5=[];~dur6=[];

~x1=bank.collect{
m1=m1+1;
	b=Spherical(beat,~az.[m1],~el.[m1]).rotate(90.degrad).x.round(0.00001);
	2.pow(b).round(time);
};
~y1=bank.collect{
m2=m2+1;
	c=Spherical(beat,~az.[m2],~el.[m2]).rotate(90.degrad).y.round(0.00001);
	2.pow(c).round(time);
};
~z1=bank.collect{
m3=m3+1;
	d=Spherical(beat,~az.[m3],~el.[m3]).rotate(90.degrad).z.round(0.00001);
	2.pow(d).round(time);
};
		bank.do{ ~dur4=~dur4++~x1.[n];n=n+1;};n=0;
		bank.do{ ~dur5=~dur5++~y1.[n];n=n+1;};n=0;
		bank.do{ ~dur6=~dur6++~z1.[n];n=n+1;};n=0;
	//	bank.do{~durs=~durs++~x.[n]++~y.[n]++~z.[n];n=n+1;}
//	~dur = ~duri.collect { |x|
  //  if (x == 0) { Rest(2) } { x }
//	}
}.value;
);



/////sequence
	(
		~kick=Pdef(\1, Pbind(\instrument, \kick,
			\dur,Pseq(~dur1,inf),
				\amp,10,
				\n,24,
				\pan,1,
			\low,0,
				\noise,0.001,
				\decay,1,
				\attack,0.01;
		))
);

(
		~snare=Pdef(\2, Pbind(\instrument, \snare,
			\dur,Pseq(~dur2,inf),
		))
);
(
		~hihat=Pdef(\3, Pbind(\instrument, \hihat,
			\dur,Pseq(~dur3,inf),
		))
);
		(
		~ride=Pdef(\4, Pbind(\instrument, \ride,
			\dur,Pseq(~dur4,inf),
		))
);
(
		~crash=Pdef(\5, Pbind(\instrument, \crash,
			\dur,Pseq(~dur5,inf),
		))
);
		(
		~tom=Pdef(\6, Pbind(\instrument, \tom,
			\dur,Pseq(~dur6,inf),
		))
);

)



TempoClock.default.tempo_(4);

(
~kick.play;
~snare.play;
~hihat.play;
~ride.play;
~crash.play;
~tom.play;
~kick.pause;
~snare.pause;
~hihat.pause;
~ride.pause;
~crash.pause;
~tom.pause;
)

2.wait;
(
MIDIClient.init;
MIDIIn.connectAll;
		(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
		var gain;
	//[val, num, chan, src].postln;
	gain=val.linlin(0,127,0,10).round(0.000001);

		gain.postln;
		if(~synth.isPlaying,{~synth.set(\gain,gain)});
},20);
				);
	(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
		var pan;
		pan=val.linlin(0,127,(992*4).neg,(992*4)).round(0.00001).round(1).asInteger;
		pan.postln;
		if(~synth.isPlaying,{~synth.set(\pan,pan)});
},21);
	);

			(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var room;
	//[val, num, chan, src].postln;
	room=val.linlin(0,127,0,1).round(0.000001);

		room.postln;
		if(~synth.isPlaying,{~synth.set(\room,room)});
},24);
	);

	(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
		 var mix;
	mix=val.linlin(0,127,0,1).round(0.00001);
		mix.postln;
		if(~synth.isPlaying,{~synth.set(\mix,mix)});
},25);
	);
				(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
		var a;
	//[val, num, chan, src].postln;
	a=val.linlin(0,127,0,4).round(1).round(1).asInteger;

		a.postln;
		if(~synth.isPlaying,{~synth.set(\a,a)});
},26);
	);

	(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
         var low;
					low=val.linlin(0,127,0,(992*4)).round(1).asInteger;
		low.postln;
		if(~synth.isPlaying,{~synth.set(\low,low)});
},27);
	);

		(
MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
		var band;
	band=val.linlin(0,127,(992*4).neg,992*8).round(1).asInteger;
		band.postln;
		if(~synth.isPlaying,{~synth.set(\band,band)});
},28);
	);
					(
MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
		var tone;
		tone=val.linlin(0,127,0,992*4).round(1).asInteger;
		tone.postln;
		if(~synth.isPlaying,{~synth.set(\tone,tone)});
},29);
	);
					(
MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
		var loc;
		loc=val.linlin(0,127,0,3248).round(1).asInteger;
		loc.postln;
		if(~synth.isPlaying,{~synth.set(\brain,loc)});
},31);
	);
								(
MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
		var rq;
		rq=val.linlin(0,127,0.1,1).round(0.00001);
		rq.postln;
		if(~synth.isPlaying,{~synth.set(\rq,rq)});
},32);
	);
								(
MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
		var b;
		b=val.linlin(0,127,0.0001,12).round(0.00001);
		b.postln;
		if(~synth.isPlaying,{~synth.set(\b,b)});
},33);
	);
						(
MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
		var sph;
		sph=val.linlin(0,127,0,3).round(1).asInteger;
		sph.postln;
		if(~synth.isPlaying,{~synth.set(\m,sph)});
},36);
	);


	(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
		var gate, n=1, a=1;
				if(val>0,gate=1);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},38);
	);
	(
MIDIdef.cc(\midi_switch2,{ |val, num, chan, src|
		 var gate, n=1, a=1;
					if(val>0,gate=2);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},39);
	);
		(
MIDIdef.cc(\midi_switch3,{ |val, num, chan, src|
		var gate, n=2, a=1;
					if(val>0,gate=3);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},40);
	);

	(
MIDIdef.cc(\midi_switch4,{ |val, num, chan, src|
         var gate, n=3, a=1;
				if(val>0,gate=4);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},41);
	);
		(
MIDIdef.cc(\midi_switch5,{ |val, num, chan, src|
		var gate, n=4, a=1;
				if(val>0,gate=5);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},42);
	);
					(
MIDIdef.cc(\midi_switch6,{ |val, num, chan, src|
		var gate, n=5, a=1;
					if(val>0,gate=6);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},43);
					);
	(
MIDIdef.cc(\midi_switch7,{ |val, num, chan, src|
		var gate, n=1, a=1;
				if(val>0,gate=7);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},44);
	);
	(
MIDIdef.cc(\midi_switch8,{ |val, num, chan, src|
		 var gate, n=1, a=1;
						if(val>0,gate=8);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},45);
	);
		(
MIDIdef.cc(\midi_switch9,{ |val, num, chan, src|
		var gate, n=2, a=1;
					if(val>0,gate=9);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},46);
	);

	(
MIDIdef.cc(\midi_switch10,{ |val, num, chan, src|
         var gate, n=3, a=1;
				if(val>0,gate=10);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},47);
	);
		(
MIDIdef.cc(\midi_switch11,{ |val, num, chan, src|
		var gate, n=4, a=1;
				if(val>0,gate=11);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},48);
	);
					(
MIDIdef.cc(\midi_switch12,{ |val, num, chan, src|
		var gate, n=5, a=1;
					if(val>0,gate=12);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},49);
						);
	(
MIDIdef.cc(\midi_switch13,{ |val, num, chan, src|
		var gate, n=1, a=1;
				if(val>0,gate=13);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},50);
	);
	(
MIDIdef.cc(\midi_switch14,{ |val, num, chan, src|
		 var gate, n=1, a=1;
				if(val>0,gate=14);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},51);
	);
		(
MIDIdef.cc(\midi_switch15,{ |val, num, chan, src|
		var gate, n=2, a=1;
					if(val>0,gate=15);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},52);
	);

	(
MIDIdef.cc(\midi_switch16,{ |val, num, chan, src|
         var gate, n=3, a=1;
				if(val>0,gate=16);
		gate.postln;
		if(~synth.isPlaying,{~synth.set(\gate,gate)});
},53);
	);

)
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