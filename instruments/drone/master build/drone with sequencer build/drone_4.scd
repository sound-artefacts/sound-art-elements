

(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=16;
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

//
(
s.waitForBoot{
MIDIClient.init;
MIDIIn.connectAll;
s.freqscope;
s.scope;
//s.makeWindow;
s.meter;
	Tdef(\drone, {
	Buffer.freeAll;

	///vbap
			/*(
~a = VBAPSpeakerArray.new(3,
				[[45, 35.264390.neg],[135.neg, 35.264390.neg],[45.neg, 35.264390],[135,35.264390]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);*/
/////////////osc polytope sequencer
			////durs
		(
{
var  sph1,sph2,az1=0,el1=0,az2=0,el2=0,angle=0;
var azimuth,elevation,spread=1,silver_r=(1+2.sqrt);
var mag1=1,mag2=1,mag3=1,mag4=1,mag5=1,mag6=1,mag7=1;
	~az=[];~el=[];

	16.do{
azimuth=32.collect{
			az1 = (az1+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
		   el1 = (el1+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

//	mag1=(mag1+(1-(1/1.6180339887499))).wrap(0,1);
sph1=(Spherical(mag1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)))).theta.round(0.000000000001);

	};

elevation=32.collect{
				az2 = (az2+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el2 = (el2+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

	//mag2=(mag2+(1-(1/1.6180339887499))).wrap(0,1);
		sph2=(Spherical(mag2,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)))).phi.round(0.000000000001);

	};


angle=(angle+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
~az=~az++azimuth;~el=~el++elevation;
	}
}.value;
)

		(
~azr=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elr=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

	({var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=16.reciprocal,beat=1;

~dur1=[];~dur2=[];~dur3=[];

~x=bank.collect{
m1=m1+1;
	b=Spherical(beat,~azr.[m1],~elr.[m1]).x.round(0.00001);
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~azr.[m2],~elr.[m2]).y.round(0.00001);
	2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~azr.[m3],~elr.[m3]).z.round(0.00001);
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

		~controlBus_1 = Bus.control(s, 1);
		~controlBus_2 = Bus.control(s, 1);
		~controlBus_3 = Bus.control(s, 1);
		~controlBus_4 = Bus.control(s, 1);
		~controlBus_5 = Bus.control(s, 1);
		~controlBus_6 = Bus.control(s, 1);
		~controlBus_7 = Bus.control(s, 1);
		~controlBus_8 = Bus.control(s, 1);
		~controlBus_9 = Bus.control(s, 1);
	    ~controlBus_10 = Bus.control(s, 1);
		~controlBus_11 = Bus.control(s, 1);
		~controlBus_12 = Bus.control(s, 1);
	    ~controlBus_13 = Bus.control(s, 1);
		~controlBus_14 = Bus.control(s, 1);

////// wavetables

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

////control synth
(
SynthDef.new(\csynth,{

	arg gain=1,low=992,tone=0,band=1,a=1,rq=1,pan=1,m=2,az=0,el=0,attack=0.01,decay=4,curve,-4x=1;

				Out.kr(~controlBus_1.index,DC.kr(x));
				Out.kr(~controlBus_2.index,DC.kr(gain));
				Out.kr(~controlBus_3.index,DC.kr(low));
				Out.kr(~controlBus_4.index,DC.kr(tone));
				Out.kr(~controlBus_5.index,DC.kr(band));
				Out.kr(~controlBus_6.index,DC.kr(a));
				Out.kr(~controlBus_7.index,DC.kr(rq));
				Out.kr(~controlBus_8.index,DC.kr(pan));
				Out.kr(~controlBus_9.index,DC.kr(m));
				Out.kr(~controlBus_10.index,DC.kr(az));
				Out.kr(~controlBus_11.index,DC.kr(ell));
				Out.kr(~controlBus_12.index,DC.kr(attack));
				Out.kr(~controlBus_13.index,DC.kr(decay));
				Out.kr(~controlBus_14.index,DC.kr(curve));

			}
).add;);

		////sound
(
SynthDef.new(\synth,{

	var gain=1,low=992,tone=0,band=1,a=1,rq=0.1,pan=1,m=2,az=0,el=0,x=1,env,attack,decay,curve;
	var lamdoma,freq1,freq2,freq3,fund,amp1,amp2,amp3,alpha,cell_az,cell_el,x_pos,y_pos,control1,control2,control3;
	var sig1,sig2,bank=6,out1,out2,band_osc1,band_osc2,ton,threshold1,threshold2,threshold3,phase1,phase2,phase3;
	var band_osc3,band_osc4,band_osc5,band_osc6,sig3,out3,cell_tria,b_x,b_y,b_z,polytope,gain1,gain2,gain3,mix=0.4,room=0.7;
	var magx,magy,magz,magqx,magqy,mod_anglex,anglex,angley,anglez,phasex,phasey,phasez,rq1,rq2,rq3,rq4,rq5,rq6;
	var mod_angley,mod_anglez,mx,my,mz,mqx,mqy,mag,magq,spread=1,mq=(m-1),choice,nn=0,lfo,sph1,loc1,loc2,loc3;

fund=16*(9/8);


				x=~controlBus_1.getSynchronous;
				gain=~controlBus_2.getSynchronous;
				low=~controlBus_3.getSynchronous;
				tone=~controlBus_4.getSynchronous;
				band=~controlBus_5.getSynchronous;
				a=~controlBus_6.getSynchronous;
				rq=~controlBus_7.getSynchronous;
				pan=~controlBus_8.getSynchronous;
				m=~controlBus_9.getSynchronous;
				az=~controlBus_10.getSynchronous;
				el=~controlBus_11.getSynchronous;
				attack~controlBus_12.getSynchronous;
				decay=~controlBus_13.getSynchronous;
				curve=~controlBus_14.getSynchronous;

lamdoma=(x.lag(0.01)+a.lag(0.01))/x.lag(0.01);


polytope = Spherical(lamdoma * 56, az.lag(0.01), el.lag(0.01));

				env=EnvGen.ar(Env.perc(attack,decay,curve),doneAction:2);

b_x=2.pow(polytope.x.round(1)/56);
b_y=2.pow(polytope.y.round(1)/56);
b_z=2.pow(polytope.z.round(1)/56);


anglex=(exp(Complex(0,1)*polytope.theta.lag(0.01)).real*exp(Complex(0,1)*polytope.phi.lag(0.01)).real).round(0.00001);
angley=(exp(Complex(0,1)*polytope.theta.lag(0.01)).imag*exp(Complex(0,1)*polytope.phi.lag(0.01)).real).round(0.00001);
anglez=(exp(Complex(0,1)*polytope.phi.lag(0.01)).imag).round(0.00001);

phasex=Complex(0,anglex).theta;
phasey=Complex(0,angley).theta;
phasez=Complex(0,anglez).theta;

				lfo=2.pow(pan/992);

mod_anglex=SinOsc.ar(lfo,phasex).range(pi.neg,pi);
mod_angley=SinOsc.ar(lfo,phasey).range(pi.neg,pi);
mod_anglez=SinOsc.ar(lfo,phasez).range((pi/2).neg,(pi/2));

bank.do{

					(
		magx=((Complex(cos(((polytope.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((polytope.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magy=((Complex(sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
		(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magz=((Complex(cos(((polytope.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((polytope.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

/*magqx=((((Complex(cos(((polytope.theta.round(0.00001)+mod_angle)*mq).wrap(pi.neg,pi)),
cos(((polytope.theta.round(0.00001)+mod_angle)*mq).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);

 magqy=((((Complex(sin(((polytope.theta.round(0.00001)+mod_angle1)*mq).wrap(pi.neg,pi)),
sin(((polytope.theta.round(0.00001)+mod_angle1)*mq).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);*/
	);

					mx=(Cartesian(magx.value,0,0).rho);
					//mqx=(Cartesian(magqx.value,0,0).rho);
					my=(Cartesian(0,magy.value,0).rho);
					//mqy=(Cartesian(0,magqy.value,0).rho);
					mz=(Cartesian(0,0,magz.value).rho);
					//mag=(Cartesian(magx.value,magy.value,0).rho);
					//magq=(Cartesian(magqx.value,magqy.value,0).rho);

					sph1=Spherical(mx,polytope.theta,polytope.phi);

					loc1=sph1.x; loc2=sph1.y; loc3=sph1.z;
				///	phase1=Complex(0,loc1).theta;
				//	phase2=Complex(0,loc2).theta;
				//	phase3=Complex(0,loc3).theta;


ton=2.pow((tone.lag(0.01))/992).round(0.0001);

freq1=(fund*ton)*b_x.lag(0.01)*lamdoma;
freq2=(fund*ton)*b_y.lag(0.01)*lamdoma;
freq3=(fund*ton)*b_z.lag(0.01)*lamdoma;

amp1=ton.reciprocal*b_x.reciprocal*lamdoma.reciprocal;
amp2=ton.reciprocal*b_y.reciprocal*lamdoma.reciprocal;
amp3=ton.reciprocal*b_z.reciprocal*lamdoma.reciprocal;


band_osc1=SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex).exprange(496,16256);
band_osc2=SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey).exprange(496,16256);
band_osc3=SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez).exprange(496,16256);
band_osc4=SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex.neg).exprange(496,16256);
band_osc5=SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey.neg).exprange(496,16256);
band_osc6=SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez.neg).exprange(496,16256);

rq1=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex,mul:rq).exprange(0.001,1)]);
rq2=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey,mul:rq).exprange(0.001,1)]);
rq3=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez,mul:rq).exprange(0.001,1)]);
rq4=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex.neg,mul:rq).exprange(0.001,1)]);
rq5=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey.neg,mul:rq).exprange(0.001,1)]);
rq6=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez.neg,mul:rq).exprange(0.001,1)]);


control1=SinOsc.ar(freq1,phase:phasex,mul:amp1);
control2=SinOsc.ar(freq2,phase:phasey,mul:amp2);
control3=SinOsc.ar(freq3,phase:phasez,mul:amp3);

sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq1,phase:phasex,mul:100).abs*SinOsc.ar(freq1,phase:phasex)),freq1*2.pow(low.lag(0.01)/992),amp1));
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq2,phase:phasey,mul:100).abs*SinOsc.ar(freq2,phase:phasey)),freq2*2.pow(low.lag(0.01)/992),amp2));
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq3,phase:phasez,mul:100).abs*SinOsc.ar(freq3,phase:phasez)),freq3*2.pow(low.lag(0.01)/992),amp3));

	sig1=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig1,BPF.ar(BRF.ar(sig1,band_osc1.lag(0.1),rq1),band_osc4.lag(0.1),rq4)]);
	sig2=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig2,BPF.ar(BRF.ar(sig2,band_osc2.lag(0.1),rq2),band_osc5.lag(0.1),rq5)]);
	sig3=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig3,BPF.ar(BRF.ar(sig3,band_osc3.lag(0.1),rq3),band_osc6.lag(0.1),rq6)]);

threshold1=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;

		sig1=HPF.ar(sig1,50);
		sig2=HPF.ar(sig2, 50);
		sig3=HPF.ar(sig3, 50);
		sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15);
		sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15);
		sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15);
		sig1=tanh(sig1*1.5);sig2=tanh(sig2*1.5);sig3=tanh(sig3*1.5);

					gain1=gain*rq1.sqrt.reciprocal;
					gain2=gain*rq2.sqrt.reciprocal;
					gain3=gain*rq3.sqrt.reciprocal;

					//Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1),mul:loc1.abs),0.9,0.01)*env);
					//Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2),mul:loc2.abs),0.9,0.01)*env);
					//Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3),mul:loc3.abs),0.9,0.01)*env);

Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(
						sig1,mix.lag(0.01),room.lag(0.01),mul:gain1)*SinOsc.ar(lfo,phase1).range(0,1/2.sqrt)),0.8,0.01),loc1,env));
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(
						sig2,mix.lag(0.01),room.lag(0.01),mul:gain2)*SinOsc.ar(lfo,phase2).range(0,1/2.sqrt)),0.8,0.01),loc2,env));
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(
						sig3,mix.lag(0.01),room.lag(0.01),mul:gain3)*SinOsc.ar(lfo,phase3).range(0,1/2.sqrt)),0.8,0.01),loc3,env));


			}
}).add;);

3.wait;
~synth=Synth.new(\csynth,[\gain,10,\tone,0,\low,0,\a,1,\pan,0.1,\band,(992*2).neg,\x,1,\m,1,\rq,1,\az,0,\el,0]).register;//s.record
(
		~s=Pdef(\1, Pbind(\instrument, \synth,
			\dur,Pseq(~dur1,inf),
				\amp,10,
				\n,24,
				\pan,1,
			\low,0,
				\noise,0.001,
				\decay,1,
				\attack,0.01;
		))
)

2.wait;
(
MIDIClient.init;
MIDIIn.connectAll;
		(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
		var gain;
	//[val, num, chan, src].postln;
	gain=val.linlin(0,127,0,100).round(0.000001);

		gain.postln;
		if(~synth.isPlaying,{~synth.set(\gain,gain)});
},26);
				);
	(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
		var pan;
		pan=val.linlin(0,127,(992*8).neg,(992*8)).round(0.00001).round(1).asInteger;
		pan.postln;
		if(~synth.isPlaying,{~synth.set(\pan,pan)});
},40);
	);

				(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var a;
	//[val, num, chan, src].postln;
	a=val.linlin(0,127,1,4).round(1).round(1).asInteger;

		a.postln;
		if(~synth.isPlaying,{~synth.set(\a,a)});
},38);
	);

	(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
         var low;
					low=val.linlin(0,127,0,(992*4)).round(1).asInteger;
		low.postln;
		if(~synth.isPlaying,{~synth.set(\low,low)});
},39);
	);

		(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
		var band;
	band=val.linlin(0,127,(992*16).neg,992*8).round(1).asInteger;
		band.postln;
		if(~synth.isPlaying,{~synth.set(\band,band)});
},29);
	);
					(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
		var tone;
		tone=val.linlin(0,127,0,992*4).round(1).asInteger;
		tone.postln;
		if(~synth.isPlaying,{~synth.set(\tone,tone)});
},31);
	);

								(
MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
		var rq;
		rq=val.linlin(0,127,0.1,1).round(0.00001);
		rq.postln;
		if(~synth.isPlaying,{~synth.set(\rq,rq)});
},32);
	);

						(
MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
		var sph;
		sph=val.linlin(0,127,0,3).round(1).asInteger;
		sph.postln;
		if(~synth.isPlaying,{~synth.set(\m,sph)});
},33);
	);

									(
MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
		var el;
					el=val.linlin(0,127,(pi/2).neg,(pi/2));
		el.postln;
		if(~synth.isPlaying,{~synth.set(\el,el)});
},28);
	);

									(
MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
		var az;
		az=val.linlin(0,127,pi.neg,pi);
		az.postln;
		if(~synth.isPlaying,{~synth.set(\az,az)});
},41);
	);

										(
MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
		var at;
		at=val.linlin(0,127,0.01,4);
		at.postln;
		if(~synth.isPlaying,{~synth.set(\attack,at)});
},41);
	);


												(
MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
		var dec;
		dec=val.linlin(0,127,1,8);
		dec.postln;
		if(~synth.isPlaying,{~synth.set(\decay,dec)});
},42);
	);


												(
MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|
		var cu;
		cu=val.linlin(0,127,1.neg,16.neg);
		cu.postln;
		if(~synth.isPlaying,{~synth.set(\curve,cu)});
},43);
	);


									(
MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|
		var t;
					t=val.linlin(0,1/8,8).round(0.25);
		t.postln;
		TempoClock.default.tempo_(t);
},45);
	);

	(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
		var lamdoma, n=1, a=1;
				if(val>0,lamdoma=1);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},14);
	);
	(
MIDIdef.cc(\midi_switch2,{ |val, num, chan, src|
		 var lamdoma, n=1, a=1;
					if(val>0,lamdoma=2);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},15);
	);
		(
MIDIdef.cc(\midi_switch3,{ |val, num, chan, src|
		var lamdoma, n=2, a=1;
					if(val>0,lamdoma=3);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},16);
	);

	(
MIDIdef.cc(\midi_switch4,{ |val, num, chan, src|
         var lamdoma, n=3, a=1;
				if(val>0,lamdoma=4);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},17);
	);
		(
MIDIdef.cc(\midi_switch5,{ |val, num, chan, src|
		var lamdoma, n=4, a=1;
				if(val>0,lamdoma=5);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},18);
	);
					(
MIDIdef.cc(\midi_switch6,{ |val, num, chan, src|
		var lamdoma, n=5, a=1;
					if(val>0,lamdoma=6);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},19);
					);
	(
MIDIdef.cc(\midi_switch7,{ |val, num, chan, src|
		var lamdoma, n=1, a=1;
				if(val>0,lamdoma=7);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},20);
	);
	(
MIDIdef.cc(\midi_switch8,{ |val, num, chan, src|
		 var lamdoma, n=1, a=1;
						if(val>0,lamdoma=8);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},21);
	);
		(
MIDIdef.cc(\midi_switch9,{ |val, num, chan, src|
		var lamdoma, n=2, a=1;
					if(val>0,lamdoma=9);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},22);
	);

	(
MIDIdef.cc(\midi_switch10,{ |val, num, chan, src|
         var lamdoma, n=3, a=1;
				if(val>0,lamdoma=10);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},23);
	);
		(
MIDIdef.cc(\midi_switch11,{ |val, num, chan, src|
		var lamdoma, n=4, a=1;
				if(val>0,lamdoma=11);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},24);
	);
					(
MIDIdef.cc(\midi_switch12,{ |val, num, chan, src|
		var lamdoma, n=5, a=1;
					if(val>0,lamdoma=12);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},13);
						);
	(
MIDIdef.cc(\midi_switch13,{ |val, num, chan, src|
		var lamdoma, n=1, a=1;
				if(val>0,lamdoma=13);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},12);
	);
	(
MIDIdef.cc(\midi_switch14,{ |val, num, chan, src|
		 var lamdoma, n=1, a=1;
				if(val>0,lamdoma=14);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},11);
	);
		(
MIDIdef.cc(\midi_switch15,{ |val, num, chan, src|
		var lamdoma, n=2, a=1;
					if(val>0,lamdoma=15);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},10);
	);

	(
MIDIdef.cc(\midi_switch16,{ |val, num, chan, src|
         var lamdoma, n=3, a=1;
				if(val>0,lamdoma=16);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},9);
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

