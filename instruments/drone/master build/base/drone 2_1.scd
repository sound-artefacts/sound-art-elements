

(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=6;
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

/////////////osc polytope
	(
{
var  sph1,sph2,az1=0,el1=0,az2=0,el2=0;
var azimuth,elevation,angle=0;
var num=1.neg,gold_r=((1+5.sqrt)/2),silver_r=(1+2.sqrt);
var ellipsis=[1,1,1],spread=1,mag1=1,mag2=1,temp=57,mt=56;
var n=0,n1=1.neg,n2=1.neg;
	~az=[];~el=[];


	temp.do{
azimuth=temp.collect{
			n1=n1+1;
						az1 =(2.pow(n1/mt).linlin(1,2,pi.neg,pi));
				el1 = (2.pow(n1/mt).linlin(1,2,(pi/2).neg,(pi/2)));

//	mag1=(mag1+(1-(1/silver_r))).wrap(0,1);
sph1=(Spherical(mag1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)))).theta.round(0.000000000001);

	};

elevation=temp.collect{
				n2=n2+1;
				az2 = (2.pow(n2/mt).linlin(1,2,pi.neg,pi));
			el2 = (2.pow(n2/mt).linlin(1,2,(pi/2).neg,(pi/2)));

	//mag2=(mag2+(1-(1/silver_r))).wrap(0,1);
		sph2=(Spherical(mag2,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)))).phi.round(0.000000000001);

	};
						n=n+1;
angle=(angle+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
//	angle=(2.pow(n/mt).linlin(1,2,0,2pi));
~az=~az++azimuth;~el=~el++elevation;
		n1=0;n2=0;az1=0;el1=0;az2=0;el2=0;

				};
}.value;
);
		/////check value range
		/*(var m,a,b,c; {m=MouseX.kr(0,1023).round(1).asInteger;
			a=Spherical(60,Select.kr(m,~az),Select.kr(m,~el)).z.abs;
			b=Spherical(60,Select.kr(m,~az),Select.kr(m,~el)).x.abs;
			c=Spherical(60,Select.kr(m,~az),Select.kr(m,~el)).y.abs;
			(2.pow(a/50)).poll;
			(2.pow(b/50)).poll;
			(2.pow(c/50)).poll;
		}.play
		)*/

////// wavetables

		(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~a=(0-(pi/496)); ~ph=992.collect{~a=~a+(pi/496);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);
		/*(
(
			{
var steps = 256;

~nVals = steps.collect { |i|
    i.linexp(0, steps-1, 1, 64)
};
			~nVals;
			}.value;
		);
(
~n=1.neg;~array=256.collect{~n=~n+1;~nVals.[~n]};
~a=(0-(pi/256)); ~ph=256.collect{~a=~a+(pi/256);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
)
)*/



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

(		~w= Buffer.alloc(s,2048);
		{
var signal,wt,m=0,amp,ph=0;

~level=64.collect{m=m+1;amp=m.reciprocal};
		signal=Signal.sineFill(1024,~level,[0]);

wt = signal.asWavetable;
~w.loadCollection(wt);
//signal.plot;
		}.value;
		);


(
SynthDef.new(\synth,{

	arg gain=1,low=992,mix=1,room=1,tone=0,band=1,x=1,a=1,brain=1,pan_speed1=1,pan_speed2=1,
				pan_speed3=1,m=4,rq=0.1,b=0,scale=1,equlibrium=180.degrad,f=1,pan=1;
	var lamdoma,freq1,freq2,freq3,fund,amp1,amp2,amp3,alpha,cell_az,cell_el,x_pos,y_pos,control1,control2,control3;
	var sig1,sig2,first=32*(9/8),bank=4,out1,out2,fm,band_osc1,band_osc2,ton,threshold=18.neg.dbamp;
	var band_osc3,band_osc4,band_osc5,band_osc6,octahedron,sig3,out3,cell_tria,b_x,b_y,b_z,polytope;
	var magx,magy,magz,magqx,magqy,mod_angle,phase1,phase2,angle,angle1x,angle2x,angle1y,angle2y,anglex,angley;
	var pos1,pos2,sph1,sph2,pan1,pan2,anglez;
	var mod_angle1,mod_anglez,mx,my,mz,mqx,mqy,mag,magq,spread=1,mq=(m-1),choice,nn=0;

				lamdoma=(x+a)/x;
octahedron=Spherical(lamdoma.lag(0.01),Select.kr(brain.lag(0.01),~az),Select.kr(brain.lag(0.01),~el));

gain=gain*(rq/(2.sqrt)).reciprocal;
b_x=octahedron.x;
b_y=octahedron.y;
b_z=octahedron.z;

mod_angle=SinOsc.ar(2.pow(pan_speed1.lag(0.01)/992),0.degrad).range(90.neg.degrad,90.degrad);
mod_angle1=SinOsc.ar(2.pow(pan_speed2.lag(0.01)/992),90.degrad).range(90.neg.degrad,90.degrad);
mod_anglez=SinOsc.ar(2.pow(pan_speed3.lag(0.01)/992),45.degrad).range(90.neg.degrad,90.degrad);

bank.do{

					//choice =brain.lag(0.01).rand;

polytope=Spherical(scale,Select.kr(brain.lag(0.01),~az),Select.kr(brain.lag(0.01),~el));

					(
		magx=((Complex(cos(((polytope.theta+mod_angle).round(0.00001)*m).wrap(pi.neg,pi)),cos((((polytope.theta+mod_angle).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
	(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread);
				);

magy=((Complex(sin(((polytope.theta+mod_angle1).round(0.00001)*m).wrap(pi.neg,pi)),sin(((polytope.theta+mod_angle1).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
		(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread);
				);

magz=((Complex(cos(((polytope.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((polytope.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

magqx=((((Complex(cos(((polytope.theta.round(0.00001)+mod_angle)*mq).wrap(pi.neg,pi)),
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
cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
	);

					mx=(Cartesian(magx.value,0,0).rho);
					mqx=(Cartesian(magqx.value,0,0).rho);
					my=(Cartesian(0,magy.value,0).rho);
					mqy=(Cartesian(0,magqy.value,0).rho);
					mz=(Cartesian(0,0,magz.value).rho);
					mag=(Cartesian(magx.value,magy.value,0).rho);
					magq=(Cartesian(magqx.value,magqy.value,0).rho);


ton=2.pow((tone.lag(0.01))/992).round(0.0001);

fund=first*lamdoma.lag(0.01).reciprocal;

fm=LFNoise1.ar(f,f.reciprocal);

freq1=(fund*ton)+b_x+fm;
freq2=(fund*ton)+b_y+fm;
freq3=(fund*ton)+b_z+fm;

amp1=ton.reciprocal*lamdoma.lag(0.01);
amp2=ton.reciprocal*lamdoma.lag(0.01);
amp3=ton.reciprocal*lamdoma.lag(0.01);


cell_tria=SinOsc.ar(mz,phase:90.degrad);

phase1=0.degrad; phase2=equlibrium.linlin(0,pi,0,pi/2);
pan1=SinOsc.ar(mx,phase:phase1);
pan2=SinOsc.ar(my,phase:phase2);



sph1=Spherical(1,polytope.theta,polytope.phi);
sph2=Spherical(1,polytope.theta,(polytope.phi-equlibrium).wrap2((pi/2)));

angle1x=Complex(exp(Complex(0,1)*sph1.theta).real,exp(Complex(0,1)*sph1.phi).real).theta;
angle1y=Complex(exp(Complex(0,1)*sph1.theta).imag,exp(Complex(0,1)*sph1.phi).real).theta;
angle2x=Complex(exp(Complex(0,1)*sph2.theta).real,exp(Complex(0,1)*sph2.phi).real).theta;
angle2y=Complex(exp(Complex(0,1)*sph2.theta).imag,exp(Complex(0,1)*sph2.phi).real).theta;


anglex=Complex(exp(Complex(0,1)*angle1x).real,exp(Complex(0,1)*angle1y).imag).theta;
angley=Complex(exp(Complex(0,1)*angle2x).real,exp(Complex(0,1)*angle2y).imag).theta;
anglez=Complex(exp(Complex(0,1)*sph1.phi).imag,exp(Complex(0,1)*sph2.phi).imag).theta;


angle=Complex(exp(Complex(0,1)*anglex).real,exp(Complex(0,1)*angley).imag).theta;

pos1=exp(Complex(0,1)*angle).real;
pos2=exp(Complex(0,1)*angle).imag;
cell_tria=SinOsc.ar(mz,phase:anglez);

band_osc1=SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:0.degrad).range(496,16256);
band_osc2=SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:90.degrad).range(496,16256);
band_osc3=SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:45.degrad).range(496,16256);
band_osc4=SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:180.degrad).range(496,16256);
band_osc5=SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:90.degrad.neg).range(496,16256);
band_osc6=SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:45.degrad.neg).range(496,16256);

control1=SinOsc.ar(freq1+b,phase:angle,mul:amp1);
control2=SinOsc.ar(freq2+b,phase:angle,mul:amp2);
control3=SinOsc.ar(freq3+b,phase:angle,mul:amp3);

sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq1+b,phase:angle,mul:100).abs*SinOsc.ar(freq1+b,phase:angle)),freq1*2.pow(low.lag(0.01)/992),amp1));
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq2+b,phase:angle,mul:100).abs*SinOsc.ar(freq2+b,phase:angle)),freq2*2.pow(low.lag(0.01)/992),amp2));
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq3+b,phase:angle,mul:100).abs*SinOsc.ar(freq3+b,phase:angle)),freq3*2.pow(low.lag(0.01)/992),amp3));

	sig1=Select.ar(band.linlin((992*4).neg,((992*4).neg+1),0,1).round(1).asInteger,
						[sig1,BPF.ar(BRF.ar(sig1,band_osc1.lag(0.1),rq),band_osc4.lag(0.1),rq)]);
	sig2=Select.ar(band.linlin((992*4).neg,((992*4).neg+1),0,1).round(1).asInteger,
						[sig2,BPF.ar(BRF.ar(sig2,band_osc2.lag(0.1),rq),band_osc5.lag(0.1),rq)]);
	sig3=Select.ar(band.linlin((992*4).neg,((992*4).neg+1),0,1).round(1).asInteger,
						[sig3,BPF.ar(BRF.ar(sig3,band_osc3.lag(0.1),rq),band_osc6.lag(0.1),rq)]);



		sig1=HPF.ar(sig1,50); sig2=HPF.ar(sig1, 50);sig3=HPF.ar(sig1, 50);
		sig1=Compander.ar(sig1,control1,threshold,1,0.3,0.015,0.3);
		sig2=Compander.ar(sig2,control2,threshold,1,0.3,0.015,0.3);
		sig3=Compander.ar(sig3,control3,threshold,1,0.3,0.015,0.3);
		sig1=tanh(sig1*2);sig2=tanh(sig2*2);sig3=tanh(sig2*2);

	Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain)),0.8,0.01),pos1)*pan1);
	Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain)),0.8,0.01),pos2)*pan2);
	Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain)),0.8,0.01),cell_tria));

					//x_pos=exp(Complex(0,1)*pan).real;
					//y_pos=exp(Complex(0,1)*pan).imag;

					//Out.ar(0,Pan4.ar(InFeedback.ar(4),xpos:x_pos,ypos:y_pos));
					//Out.ar(1,Pan4.ar(InFeedback.ar(5),xpos:y_pos,ypos:x_pos));
			}
}).add;);

10.wait;
~synth=Synth.new(\synth,[\gain,1,\tone,992*2,\low,0,\mix,0,\room,1,\a,1,\pan_speed1,992,\pan_speed2,992,\pan_speed3,992,
			\band,(992*4).neg,\x,1,\brain,4,\m,4,\rq,1,\b,1,\scale,100,\equilibrium,pi,\f,1,\pan,45.degrad]).register;//s.record
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
		if(~synth.isPlaying,{~synth.set(\pan_speed1,pan)});
},21);
	);
		(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var pan;
	//[val, num, chan, src].postln;
	pan=val.linlin(0,127,(992*4).neg,(992*4)).round(0.000001);

		pan.postln;
		if(~synth.isPlaying,{~synth.set(\pan_speed2,pan)});
},22);
	);
		(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
		var pan;
	//[val, num, chan, src].postln;
	pan=val.linlin(0,127,(992*4).neg,(992*4)).round(0.000001);

		pan.postln;
		if(~synth.isPlaying,{~synth.set(\pan_speed3,pan)});
},23);
	);

			(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
		var room;
	//[val, num, chan, src].postln;
	room=val.linlin(0,127,0,1).round(0.000001);

		room.postln;
		if(~synth.isPlaying,{~synth.set(\room,room)});
},24);
	);

	(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
		 var mix;
	mix=val.linlin(0,127,0,1).round(0.00001);
		mix.postln;
		if(~synth.isPlaying,{~synth.set(\mix,mix)});
},25);
	);

				(
MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
		var a;
	//[val, num, chan, src].postln;
	a=val.linlin(0,127,0,4).round(1).round(1).asInteger;

		a.postln;
		if(~synth.isPlaying,{~synth.set(\a,a)});
},26);
	);

	(
MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
         var low;
					low=val.linlin(0,127,0,(992*4)).round(1).asInteger;
		low.postln;
		if(~synth.isPlaying,{~synth.set(\low,low)});
},27);
	);

		(
MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
		var band;
	band=val.linlin(0,127,(992*4).neg,992*8).round(1).asInteger;
		band.postln;
		if(~synth.isPlaying,{~synth.set(\band,band)});
},28);
	);
					(
MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
		var tone;
		tone=val.linlin(0,127,0,992*4).round(1).asInteger;
		tone.postln;
		if(~synth.isPlaying,{~synth.set(\tone,tone)});
},29);
	);
								(
MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
		var tone;
		tone=val.linlin(0,127,1,9).round(1).asInteger;
		tone.postln;
		if(~synth.isPlaying,{~synth.set(\tone,tone)});
},30);
	);
					(
MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
		var loc;
		loc=val.linlin(0,127,0,3248).round(1).asInteger;
		loc.postln;
		if(~synth.isPlaying,{~synth.set(\brain,loc)});
},31);
	);
								(
MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|
		var rq;
		rq=val.linlin(0,127,0.1,1).round(0.00001);
		rq.postln;
		if(~synth.isPlaying,{~synth.set(\rq,rq)});
},32);
	);
								(
MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|
		var b;
		b=val.linlin(0,127,0,12).round(0.00001);
		b.postln;
		if(~synth.isPlaying,{~synth.set(\b,b)});
},33);
	);

									(
MIDIdef.cc(\midi_pot15,{ |val, num, chan, src|
		var scale;
		scale=val.linlin(0,127,1,100).round(0.00001);
		scale.postln;
		if(~synth.isPlaying,{~synth.set(\scale,scale)});
},34);
	);
			(
MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|
		var eq;
		eq=val.linlin(0,127,pi.neg,pi).round(0.00001);
		eq.postln;
		if(~synth.isPlaying,{~synth.set(\equilibrium,eq)});
},35);
	);
						(
MIDIdef.cc(\midi_pot17,{ |val, num, chan, src|
		var f;
		f=val.linlin(0,127,0.001,100).round(0.00001);
		f.postln;
		if(~synth.isPlaying,{~synth.set(\f,f)});
},36);
	);

	(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
		var lamdoma, n=1, a=1;
				if(val>0,lamdoma=1);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},38);
	);
	(
MIDIdef.cc(\midi_switch2,{ |val, num, chan, src|
		 var lamdoma, n=1, a=1;
					if(val>0,lamdoma=2);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},39);
	);
		(
MIDIdef.cc(\midi_switch3,{ |val, num, chan, src|
		var lamdoma, n=2, a=1;
					if(val>0,lamdoma=3);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},40);
	);

	(
MIDIdef.cc(\midi_switch4,{ |val, num, chan, src|
         var lamdoma, n=3, a=1;
				if(val>0,lamdoma=4);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},41);
	);
		(
MIDIdef.cc(\midi_switch5,{ |val, num, chan, src|
		var lamdoma, n=4, a=1;
				if(val>0,lamdoma=5);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},42);
	);
					(
MIDIdef.cc(\midi_switch6,{ |val, num, chan, src|
		var lamdoma, n=5, a=1;
					if(val>0,lamdoma=6);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},43);
					);
	(
MIDIdef.cc(\midi_switch7,{ |val, num, chan, src|
		var lamdoma, n=1, a=1;
				if(val>0,lamdoma=7);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},44);
	);
	(
MIDIdef.cc(\midi_switch8,{ |val, num, chan, src|
		 var lamdoma, n=1, a=1;
						if(val>0,lamdoma=8);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},45);
	);
		(
MIDIdef.cc(\midi_switch9,{ |val, num, chan, src|
		var lamdoma, n=2, a=1;
					if(val>0,lamdoma=9);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},46);
	);

	(
MIDIdef.cc(\midi_switch10,{ |val, num, chan, src|
         var lamdoma, n=3, a=1;
				if(val>0,lamdoma=10);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},47);
	);
		(
MIDIdef.cc(\midi_switch11,{ |val, num, chan, src|
		var lamdoma, n=4, a=1;
				if(val>0,lamdoma=11);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},48);
	);
					(
MIDIdef.cc(\midi_switch12,{ |val, num, chan, src|
		var lamdoma, n=5, a=1;
					if(val>0,lamdoma=12);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},49);
						);
	(
MIDIdef.cc(\midi_switch13,{ |val, num, chan, src|
		var lamdoma, n=1, a=1;
				if(val>0,lamdoma=13);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},50);
	);
	(
MIDIdef.cc(\midi_switch14,{ |val, num, chan, src|
		 var lamdoma, n=1, a=1;
				if(val>0,lamdoma=14);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},51);
	);
		(
MIDIdef.cc(\midi_switch15,{ |val, num, chan, src|
		var lamdoma, n=2, a=1;
					if(val>0,lamdoma=15);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},52);
	);

	(
MIDIdef.cc(\midi_switch16,{ |val, num, chan, src|
         var lamdoma, n=3, a=1;
				if(val>0,lamdoma=16);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},53);
	);

)
});
	Tdef(\drone).play;
}
)
)



