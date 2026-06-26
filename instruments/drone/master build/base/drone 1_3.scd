

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
/*(
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
)*/
	(
{
var  sph1,sph2,az1=0,el1=0,az2=0,el2=0;
var azimuth,elevation,angle=0,n=12;
var num=1.neg,gold_r=((1+5.sqrt)/2),silver_r=(1+2.sqrt);
var ellipsis=[1,1,1],spread=1,mag1=1,mag2=1;
	~az=[];~el=[];

//	spread = if(m_z < 1) { 1 / m_z } { m_z };

	64.do{
azimuth=16.collect{
			az1 = (az1+(360-(360/silver_r))).wrap(180.neg,180);
		   el1 = (el1+(180-(180/silver_r))).wrap(90.neg,90);

//	mag1=(mag1+(1-(1/silver_r))).wrap(0,1);
sph1=(Spherical(mag1,(az1.degrad+angle.degrad).wrap(pi.neg,pi),(el1.degrad+angle.degrad).wrap((pi/2).neg,(pi/2)))).theta.round(0.000000000001);

	};

elevation=16.collect{
				az2 = (az2+(360-(360/silver_r))).wrap(180.neg,180);
			el2 = (el2+(180-(180/silver_r))).wrap(90.neg,90);

	//mag2=(mag2+(1-(1/silver_r))).wrap(0,1);
		sph2=(Spherical(mag2,(az2.degrad+angle.degrad).wrap(pi.neg,pi),(el2.degrad+angle.degrad).wrap((pi/2).neg,(pi/2)))).phi.round(0.000000000001);

	};


angle=(angle+(360-(360/silver_r))).wrap(0,360);
~az=~az++azimuth;~el=~el++elevation;

		az1=0;el1=0;az2=0;el2=0
	}
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

		/(
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

	arg gain=1,low=992,high=0,tone=0,band=1,lamdoma=1,brain=1,pan_speed=1;
	var gold=45,gold_r=((1+5.sqrt)/2),silver_r=(1+2.sqrt),room=1,mix=1;
	var freq1,freq2,freq3,fund,phase1,phase2,phase3,amp1,amp2,amp3,alpha,cell_az,cell_el;
	var sig1,sig2,first=32*(9/8),bank=2,out1,out2,fm,band_osc1,band_osc2,ton,freq;
	var linex,liney,cell_l,cell_r,band_osc3,band_osc4,band_osc5,band_osc6;
	var octahedron,sig3,out3,cell_tria,b_x,b_y,b_z,tetrahedron;
	var magx,magy,magz,magqx,magqy,mod_angle;
	var mod_angle1,mod_anglez,mx,my,mz,mqx,mqy,mag,magq;
	var spread=1,m=9,mq=(m-1),rq=0.1,b=0,f=1,choice;
	//var xyz=[1,1,1].normalizeSum.sqrt,axis,q,rotor,rotation;
  //  var i=Quaternion(0, xyz.[0], 0, 0),j=Quaternion(0, 0, xyz.[1], 0),k=Quaternion(0, 0, 0, xyz.[2]);

//axis=i+j+k;

	mix=high.lag(0.01);

octahedron=Spherical(lamdoma.lag(0.01).reciprocal,Select.kr(brain.lag(0.01),~az),Select.kr(brain.lag(0.01),~el));

gain=gain*(rq/(2.sqrt)).reciprocal;
b_x=octahedron.x;
b_y=octahedron.y;
b_z=octahedron.z;

mod_angle=SinOsc.ar(2.pow(pan_speed.lag(0.01)/992),0.degrad).range(90.neg.degrad,90.degrad);
mod_angle1=SinOsc.ar(2.pow(pan_speed.lag(0.01)/992),90.degrad).range(90.neg.degrad,90.degrad);
mod_anglez=SinOsc.ar(2.pow(pan_speed.lag(0.01)/992),45.degrad).range(90.neg.degrad,90.degrad);

bank.do{

					choice =brain.lag(0.01).rand;

tetrahedron=Spherical(1,Select.kr(choice,~az),Select.kr(choice,~el));

					(
		magx=((Complex(cos(((tetrahedron.theta+mod_angle).round(0.00001)*m).wrap(pi.neg,pi)),cos((((tetrahedron.theta+mod_angle).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
	(Complex(cos((tetrahedron.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((tetrahedron.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread);
				);

magy=((Complex(sin(((tetrahedron.theta+mod_angle1).round(0.00001)*m).wrap(pi.neg,pi)),sin(((tetrahedron.theta+mod_angle1).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
		(Complex(cos((tetrahedron.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((tetrahedron.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread);
				);

magz=((Complex(cos(((tetrahedron.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((tetrahedron.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

magqx=((((Complex(cos(((tetrahedron.theta.round(0.00001)+mod_angle)*mq).wrap(pi.neg,pi)),
cos(((tetrahedron.theta.round(0.00001)+mod_angle)*mq).wrap(pi.neg,pi))))*
(Complex(sin((tetrahedron.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((tetrahedron.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((tetrahedron.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((tetrahedron.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);

 magqy=((((Complex(sin(((tetrahedron.theta.round(0.00001)+mod_angle1)*mq).wrap(pi.neg,pi)),
sin(((tetrahedron.theta.round(0.00001)+mod_angle1)*mq).wrap(pi.neg,pi))))*
(Complex(sin((tetrahedron.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((tetrahedron.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((tetrahedron.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((tetrahedron.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
	);

					mx=(Cartesian(magx.value,0,0).rho);
					mqx=(Cartesian(magqx.value,0,0).rho);
					my=(Cartesian(0,magy.value,0).rho);
					mqy=(Cartesian(0,magqy.value,0).rho);
					mz=(Cartesian(0,0,magz.value).rho);
					mag=(Cartesian(magx.value,magy.value,0).rho);
					magq=(Cartesian(magqx.value,magqy.value,0).rho);

linex=Complex(tetrahedron.theta.linlin(180.neg.degrad,180.degrad,1.neg,1),tetrahedron.phi.linlin(90.neg.degrad,90.degrad,1.neg,1)).real.abs;
liney=Complex(tetrahedron.theta.linlin(180.neg.degrad,180.degrad,1.neg,1),tetrahedron.phi.linlin(90.neg.degrad,90.degrad,1.neg,1)).imag.abs.neg;

ton=2.pow((tone.lag(0.01))/992).round(0.0001);

fund=first*lamdoma.lag(0.01).reciprocal;

freq1=(fund*ton)+b_x;
freq2=(fund*ton)+b_y;
freq3=(fund*ton)+b_z;
freq=fund*ton;

amp1=ton.reciprocal*lamdoma.lag(0.01);
amp2=ton.reciprocal*lamdoma.lag(0.01);
amp3=ton.reciprocal*lamdoma.lag(0.01);

					phase1=b_x.linlin((10*lamdoma.lag(0.01)),(10*lamdoma.lag(0.01)).neg,pi.neg,pi);
					phase2=b_y.linlin((10*lamdoma.lag(0.01)),(10*lamdoma.lag(0.01)).neg,pi.neg,pi);
					phase3=b_z.linlin((10*lamdoma.lag(0.01)),(10*lamdoma.lag(0.01)).neg,pi.neg,pi);

//fm=LFNoise1.ar(f,f.reciprocal);
freq=freq;

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


cell_az=Osc.kr(~w.bufnum,mag,phase:0.degrad).range(0,360);
cell_el=SinOsc.kr(mz,phase:90.degrad).range(90.neg,90);

cell_l=SinOsc.ar(mqx,phase:0.degrad).range(0,1);
cell_r=SinOsc.ar(mqy,phase:90.degrad).range(0,1.neg);
cell_tria=SinOsc.ar(mz,phase:45.degrad);

out1=VBAP.ar(6,FreeVerb.ar(sig1,mix,room,mul:1),~b.bufnum,(tetrahedron.theta+cell_az.lag(0.01)).wrap(180.neg,180),
(tetrahedron.phi+cell_el.lag(0.01)).wrap(90.neg,90));
out2=VBAP.ar(6,FreeVerb.ar(sig2,mix,room,mul:1),~b.bufnum,(tetrahedron.theta+cell_az.lag(0.01)).wrap(180.neg,180),
(tetrahedron.phi+cell_el.lag(0.01)).wrap(90.neg,90));
out3=VBAP.ar(6,FreeVerb.ar(sig3,mix,room,mul:1),~b.bufnum,(tetrahedron.theta+cell_az.lag(0.01)).wrap(180.neg,180),
(tetrahedron.phi+cell_el.lag(0.01)).wrap(90.neg,90));

Out.ar(2,Limiter.ar(LeakDC.ar(out1,mul:1)*gain,room));
Out.ar(2,Limiter.ar(LeakDC.ar(out2,mul:1)*gain,room));
Out.ar(2,Limiter.ar(LeakDC.ar(out3,mul:1)*gain,room));


Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix,room,mul:1),mul:1)*gain,room),cell_l.lag(0.01)));
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix,room,mul:1),mul:1)*gain,room),cell_r.lag(0.01)));
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix,room,mul:1),mul:1)*gain,room),(cell_tria)));
			}
}).add;);

10.wait;
~synth=Synth.new(\synth,[\gain,1,\tone,0,\low,0,\high,0,\pan_speed,0,\band,(992*4).neg,\lamdoma,1,\brain,4]).register;//s.record
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
},26);
	);
			////note//2.pow((496*8*(6/5))/992)
			////note//2.pow((56*32)/56).round(000.1)
	(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
		 var high;
	high=val.linlin(0,127,0,1).round(0.00001);
		high.postln;
		if(~synth.isPlaying,{~synth.set(\high,high)});
},27);
	);
		(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var pan;
		pan=val.linlin(0,127,(992*4).neg,(992*4)).round(0.00001).round(1).asInteger;
		pan.postln;
		if(~synth.isPlaying,{~synth.set(\pan_speed,pan)});
},28);
	);

	(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
         var low;
					low=val.linlin(0,127,0,(992*4)).round(1).asInteger;
		low.postln;
		if(~synth.isPlaying,{~synth.set(\low,low)});
},29);
	);

		(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
		var band;
	band=val.linlin(0,127,(992*4).neg,992*8).round(1).asInteger;
		band.postln;
		if(~synth.isPlaying,{~synth.set(\band,band)});
},30);
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
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
		var brain;
					if(val>0,brain=1024.rand,brain=1024.rand);
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},14);
	);
	(
MIDIdef.cc(\midi_switch2,{ |val, num, chan, src|
		 var brain;
					if(val>0,brain=1024.rand,brain=1024.rand);
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},15);
	);
		(
MIDIdef.cc(\midi_switch3,{ |val, num, chan, src|
		var brain;
					if(val>0,brain=1024.rand,brain=1024.rand);

		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},16);
	);

	(
MIDIdef.cc(\midi_switch4,{ |val, num, chan, src|
         var brain;
					if(val>0,brain=1024.rand,brain=1024.rand);
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},17);
	);
		(
MIDIdef.cc(\midi_switch5,{ |val, num, chan, src|
		var brain;
				if(val>0,brain=1024.rand,brain=1024.rand);

		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},18);
	);
					(
MIDIdef.cc(\midi_switch6,{ |val, num, chan, src|
		var brain;
				if(val>0,brain=1024.rand,brain=1024.rand);
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},19);
	);

	(
MIDIdef.cc(\midi_switch7,{ |val, num, chan, src|
		var lamdoma, n=1, a=1;
				if(val>0,lamdoma=1,lamdoma=1);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},20);
	);
	(
MIDIdef.cc(\midi_switch8,{ |val, num, chan, src|
		 var lamdoma, n=1, a=1;
				if(val>0,lamdoma=5/6,lamdoma=5/6);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},21);
	);
		(
MIDIdef.cc(\midi_switch9,{ |val, num, chan, src|
		var lamdoma, n=2, a=1;
					if(val>0,lamdoma=4/5,lamdoma=4/5);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},22);
	);

	(
MIDIdef.cc(\midi_switch10,{ |val, num, chan, src|
         var lamdoma, n=3, a=1;
				if(val>0,lamdoma=3/4,lamdoma=3/4);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},23);
	);
		(
MIDIdef.cc(\midi_switch11,{ |val, num, chan, src|
		var lamdoma, n=4, a=1;
				if(val>0,lamdoma=2/3,lamdoma=2/3);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},24);
	);
					(
MIDIdef.cc(\midi_switch12,{ |val, num, chan, src|
		var lamdoma, n=5, a=1;
					if(val>0,lamdoma=1/2,lamdoma=1/2);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},25);
	);

)
});
	Tdef(\drone).play;
}
)
)





/*	r=val.linlin(0,127,(0.0001),1).round(0.0001);
		r.postln;
		if(~synth.isPlaying,{~synth.set(\room,r)});

	m=val.linlin(0,127,0.1,1).round(0.1);
		m.postln;
		if(~synth.isPlaying,{~synth.set(\mix,m)});*/







/*	r=val.linlin(0,127,(0.0001),1).round(0.0001);
		r.postln;
		if(~synth.isPlaying,{~synth.set(\room,r)});

	m=val.linlin(0,127,0.1,1).round(0.1);
		m.postln;
		if(~synth.isPlaying,{~synth.set(\mix,m)});*/

