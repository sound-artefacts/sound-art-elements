

(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=8;
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

		///octahedron
		(
~a = VBAPSpeakerArray.new(3,
				[[0, 90.neg],[0, 0],[90, 0],[180,0],[90.neg,0],[0,90]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);
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
		/////sawtooth  method
/*(
~n=0;~array=512.collect{~n=~n+1;};
//~a=(0-(pi/256)); ~ph=512.collect{~a=~a+(pi/256);};
~ph=[0];
~bufferSize = 4096*8;
~signalSize = 2048*8;
)*/

		/////lamdoma method
/*(
~n=0;~array=512.collect{~n=~n+1;(~n+1)/~n};
~a=(0-(pi/256)); ~ph=512.collect{~a=~a+(pi/256);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
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

	arg gain=1,low=992,mix=1,room=1,tone=0,band=1,x=1,a=1,brain=1,pan_speed1=1,pan_speed2=1,pan_speed3=1,m=4,rq=0.1,b=0,scale=1;
	var gold=45,gold_r=((1+5.sqrt)/2),silver_r=(1+2.sqrt),lamdoma;
	var freq1,freq2,freq3,fund,phase1,phase2,phase3,amp1,amp2,amp3,alpha,cell_az,cell_el;
	var sig1,sig2,first=32*(9/8),bank=3,out1,out2,fm,band_osc1,band_osc2,ton;
	var linex,liney,cell_l,cell_r,band_osc3,band_osc4,band_osc5,band_osc6;
	var octahedron,sig3,out3,cell_tria,b_x,b_y,b_z,polytope;
	var magx,magy,magz,magqx,magqy,mod_angle;
	var mod_angle1,mod_anglez,mx,my,mz,mqx,mqy,mag,magq;
	var spread=1,mq=(m-1),f=1,choice,angle,nn=0;
	//var xyz=[1,1,1].normalizeSum.sqrt,axis,q,rotor,rotation;
  //  var i=Quaternion(0, xyz.[0], 0, 0),j=Quaternion(0, 0, xyz.[1], 0),k=Quaternion(0, 0, 0, xyz.[2]);

//axis=i+j+k;

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

//linex=Complex(polytope.theta.linlin(180.neg.degrad,180.degrad,1.neg,1),polytope.phi.linlin(90.neg.degrad,90.degrad,1.neg,1)).real.abs;
//liney=Complex(polytope.theta.linlin(180.neg.degrad,180.degrad,1.neg,1),polytope.phi.linlin(90.neg.degrad,90.degrad,1.neg,1)).imag.abs.neg;

//nn=nn+1;  angle=nn*(pi/6); linex=exp(Complex(0,1)*angle).real;  liney=exp(Complex(0,1)*angle).imag;


ton=2.pow((tone.lag(0.01))/992).round(0.0001);

fund=first*lamdoma.lag(0.01).reciprocal;

freq1=(fund*ton)+b_x;
freq2=(fund*ton)+b_y;
freq3=(fund*ton)+b_z;

amp1=ton.reciprocal*lamdoma.lag(0.01);
amp2=ton.reciprocal*lamdoma.lag(0.01);
amp3=ton.reciprocal*lamdoma.lag(0.01);

					phase1=b_x.linlin((lamdoma.lag(0.01)).neg,(lamdoma.lag(0.01)),pi.neg,pi);
					phase2=b_y.linlin((lamdoma.lag(0.01)).neg,(lamdoma.lag(0.01)),pi.neg,pi);
					phase3=b_z.linlin((lamdoma.lag(0.01)).neg,(lamdoma.lag(0.01)),pi.neg,pi);

//fm=LFNoise1.ar(f,f.reciprocal);

band_osc1=SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:0.degrad).range(496,16256);
band_osc2=SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:90.degrad).range(496,16256);
band_osc3=SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:45.degrad).range(496,16256);
band_osc4=SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:180.degrad).range(496,16256);
band_osc5=SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:90.degrad.neg).range(496,16256);
band_osc6=SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:45.degrad.neg).range(496,16256);

sig1=BPF.ar(BRF.ar(LPF.ar((Osc.ar(~w1.bufnum,freq1+b,phase:phase1,mul:100).abs*SinOsc.ar(freq1+b,phase:phase1)),freq1*2.pow(low.lag(0.01)/992),amp1),
band_osc1.lag(0.1),rq),band_osc4.lag(0.1),rq);
sig2=BPF.ar(BRF.ar(LPF.ar((Osc.ar(~w1.bufnum,freq2+b,phase:phase2,mul:100).abs*SinOsc.ar(freq2+b,phase:phase2)),freq2*2.pow(low.lag(0.01)/992),amp2),
band_osc2.lag(0.1),rq),band_osc5.lag(0.1),rq);
sig3=BPF.ar(BRF.ar(LPF.ar((Osc.ar(~w1.bufnum,freq3+b,phase:phase3,mul:100).abs*SinOsc.ar(freq3+b,phase:phase3)),freq3*2.pow(low.lag(0.01)/992),amp3),
band_osc3.lag(0.1),rq),band_osc6.lag(0.1),rq);

//sig1=LPF.ar((Osc.ar(~w1.bufnum,freq1+b,phase:phase1,mul:100).abs*SinOsc.ar(freq1+b,phase:phase1)),freq1*2.pow(low.lag(0.01)/992),amp1);
//sig2=LPF.ar((Osc.ar(~w1.bufnum,freq2+b,phase:phase2,mul:100).abs*SinOsc.ar(freq2+b,phase:phase2)),freq2*2.pow(low.lag(0.01)/992),amp2);
//sig3=LPF.ar((Osc.ar(~w1.bufnum,freq3+b,phase:phase3,mul:100).abs*SinOsc.ar(freq3+b,phase:phase3)),freq3*2.pow(low.lag(0.01)/992),amp3);


cell_az=Osc.kr(~w.bufnum,mag,phase:0.degrad).range(0,360);
cell_el=SinOsc.kr(mz,phase:90.degrad).range(90.neg,90);

cell_l=SinOsc.ar(mx,phase:0.degrad);
cell_r=SinOsc.ar(my,phase:90.degrad);
cell_tria=SinOsc.ar(mz,phase:45.degrad);

out1=VBAP.ar(6,FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:1),~b.bufnum,(polytope.theta+cell_az.lag(0.01)).wrap(180.neg,180),
(polytope.phi+cell_el.lag(0.01)).wrap(90.neg,90));
out2=VBAP.ar(6,FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:1),~b.bufnum,(polytope.theta+cell_az.lag(0.01)).wrap(180.neg,180),
(polytope.phi+cell_el.lag(0.01)).wrap(90.neg,90));
out3=VBAP.ar(6,FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:1),~b.bufnum,(polytope.theta+cell_az.lag(0.01)).wrap(180.neg,180),
(polytope.phi+cell_el.lag(0.01)).wrap(90.neg,90));

Out.ar(2,Limiter.ar(LeakDC.ar(out1,mul:1)*gain,room.lag(0.01)));
Out.ar(2,Limiter.ar(LeakDC.ar(out2,mul:1)*gain,room.lag(0.01)));
Out.ar(2,Limiter.ar(LeakDC.ar(out3,mul:1)*gain,room.lag(0.01)));

//Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:1),mul:1)*gain,room.lag(0.01)),(liney+cell_r.lag(0.01)).wrap(1.neg,1)));
//Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:1),mul:1)*gain,room.lag(0.01)),(linex+cell_l.lag(0.01)).wrap(1.neg,1)));
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:1),mul:1)*gain,room.lag(0.01)),cell_l));
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:1),mul:1)*gain,room.lag(0.01)),cell_r));
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:1),mul:1)*gain,room.lag(0.01)),cell_tria));
			}
}).add;);

10.wait;
~synth=Synth.new(\synth,[\gain,1,\tone,992,\low,0,\mix,0,\room,1,\a,1,\pan_speed1,992,\pan_speed2,992,\pan_speed3,992,
			\band,(992*4).neg,\x,1,\brain,4,\m,4,\rq,1,\b,1,\scale,100]).register;//s.record
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
MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
		var loc;
		loc=val.linlin(0,127,0,3248).round(1).asInteger;
		loc.postln;
		if(~synth.isPlaying,{~synth.set(\brain,loc)});
},31);
	);
								(
MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
		var rq;
		rq=val.linlin(0,127,0.1,1).round(0.00001);
		rq.postln;
		if(~synth.isPlaying,{~synth.set(\rq,rq)});
},32);
	);
								(
MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|
		var b;
		b=val.linlin(0,127,0,12).round(0.00001);
		b.postln;
		if(~synth.isPlaying,{~synth.set(\b,b)});
},33);
	);

									(
MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|
		var scale;
		scale=val.linlin(0,127,1,100).round(0.00001);
		scale.postln;
		if(~synth.isPlaying,{~synth.set(\scale,scale)});
},34);
	);

	(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
		var lamdoma, n=1, a=1;
				if(val>0,lamdoma=1);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},35);
	);
	(
MIDIdef.cc(\midi_switch2,{ |val, num, chan, src|
		 var lamdoma, n=1, a=1;
					if(val>0,lamdoma=2);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},36);
	);
		(
MIDIdef.cc(\midi_switch3,{ |val, num, chan, src|
		var lamdoma, n=2, a=1;
					if(val>0,lamdoma=3);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},37);
	);

	(
MIDIdef.cc(\midi_switch4,{ |val, num, chan, src|
         var lamdoma, n=3, a=1;
				if(val>0,lamdoma=4);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},38);
	);
		(
MIDIdef.cc(\midi_switch5,{ |val, num, chan, src|
		var lamdoma, n=4, a=1;
				if(val>0,lamdoma=5);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},39);
	);
					(
MIDIdef.cc(\midi_switch6,{ |val, num, chan, src|
		var lamdoma, n=5, a=1;
					if(val>0,lamdoma=6);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},40);
					);
	(
MIDIdef.cc(\midi_switch7,{ |val, num, chan, src|
		var lamdoma, n=1, a=1;
				if(val>0,lamdoma=7);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},41);
	);
	(
MIDIdef.cc(\midi_switch8,{ |val, num, chan, src|
		 var lamdoma, n=1, a=1;
						if(val>0,lamdoma=8);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},42);
	);
		(
MIDIdef.cc(\midi_switch9,{ |val, num, chan, src|
		var lamdoma, n=2, a=1;
					if(val>0,lamdoma=9);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},43);
	);

	(
MIDIdef.cc(\midi_switch10,{ |val, num, chan, src|
         var lamdoma, n=3, a=1;
				if(val>0,lamdoma=10);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},44);
	);
		(
MIDIdef.cc(\midi_switch11,{ |val, num, chan, src|
		var lamdoma, n=4, a=1;
				if(val>0,lamdoma=11);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},45);
	);
					(
MIDIdef.cc(\midi_switch12,{ |val, num, chan, src|
		var lamdoma, n=5, a=1;
					if(val>0,lamdoma=12);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},46);
						);
	(
MIDIdef.cc(\midi_switch13,{ |val, num, chan, src|
		var lamdoma, n=1, a=1;
				if(val>0,lamdoma=13);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},47);
	);
	(
MIDIdef.cc(\midi_switch14,{ |val, num, chan, src|
		 var lamdoma, n=1, a=1;
				if(val>0,lamdoma=14);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},48);
	);
		(
MIDIdef.cc(\midi_switch15,{ |val, num, chan, src|
		var lamdoma, n=2, a=1;
					if(val>0,lamdoma=15);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},49);
	);

	(
MIDIdef.cc(\midi_switch16,{ |val, num, chan, src|
         var lamdoma, n=3, a=1;
				if(val>0,lamdoma=16);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\x,lamdoma)});
},50);
	);

)
});
	Tdef(\drone).play;
}
)
)



