
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=8;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*4;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
s.makeGui(w);
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
s.meter;
s.freqscope;
s.scope;
	Tdef(\drone, {
	Buffer.freeAll;

		///cube
		(
~a = VBAPSpeakerArray.new(3,
[[45, 35.264390.neg], [135, 35.264390.neg], [45.neg, 35.264390.neg], [135.neg, 35.264390.neg],[45,35.264390],[135,35.264390],[45.neg,35.264390],[135.neg,35.264390]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);
//////saw wavetable
		~w= Buffer.alloc(s,2048);
		{
var signal,wt,m=0,amp,ph=0;

~level=32.collect{m=m+1;amp=m.reciprocal};
		signal=Signal.sineFill(1024,~level,[0]);

wt = signal.asWavetable;
~w.loadCollection(wt);
//signal.plot;
		}.value;

(
SynthDef.new(\synth,{

	arg gain=1,low=7168,high=0,tone=0,band=1,lamdoma=1,brain=1,pan_speed=1;
	var gold=45,silver1=0,silver2=180,gold_r=((1+5.sqrt)/2),silver_r=(1+2.sqrt),room=0.9.rand,mix=0.3333;
	var freq,fund,n=0,m,phase,interval,alpha,cell_az,cell_el,pulsenum=32;
	var sig1,sig2,first=28,bank=9,out1,out2,fm,band_osc1,band_osc2,amp,ton;
	var linex,liney,silver3=45;


bank.do{

ton=2.pow(tone.lag(0.1)/16256).round(0.0001);

fund=(first*lamdoma.lag(0.1))*ton;
n=n+1;
interval=pi/2;
m=n*interval;
freq=fund*m;
amp=m.reciprocal*lamdoma.reciprocal*ton.reciprocal;
phase=gold.degrad;

fm=LFNoise1.ar(amp,amp.reciprocal);
freq=freq+fm;

band_osc1=SinOsc.kr(freq.reciprocal*band,phase:0.degrad).range(220,20000);
band_osc2=SinOsc.kr(freq.reciprocal*band,phase:90.degrad).range(220,20000);

linex=exp(Complex(0,1)*silver3.degrad).real.abs;
liney=exp(Complex(0,1)*silver3.degrad).imag.abs.neg;

sig1=LPF.ar(Pulse.ar((freq),width:0.5,mul:amp).abs,low/32)*SinOsc.ar((freq/pulsenum),phase,amp);
sig2=LPF.ar(Pulse.ar((freq)+brain,width:0.5,mul:amp).abs,low/32)*SinOsc.ar((freq/pulsenum)+brain,phase,amp);

sig1=LPF.ar(sig1,low.lag(0.1)); sig2=LPF.ar(sig2,low.lag(0.1)); sig1=HPF.ar(sig1,high.lag(0.1)); sig2=HPF.ar(sig2,high.lag(0.1));
cell_az=Osc.kr(~w.bufnum,pan_speed,phase:0.degrad).range(180.neg,180);
cell_el=Osc.kr(~w.bufnum,pan_speed,phase:90.degrad).range(90.neg,90);

out1=VBAP.ar(8,FreeVerb.ar(sig1,mix,room,mul:1),~b.bufnum,(silver1+cell_az.lag(0.1)).wrap(180.neg,180),
(silver1.wrap(90.neg,90)+cell_el.lag(0.1)).wrap(90.neg,90));

out2=VBAP.ar(8,FreeVerb.ar(sig2,mix,room,mul:1),~b.bufnum,(silver2+cell_az.lag(0.1)).wrap(180.neg,180),
(silver2.wrap(90.neg,90)+cell_el.lag(0.1)).wrap(90.neg,90));


	//Out.ar(0,LeakDC.ar(BPF.ar(out1,band_osc1.lag(0.1),1),mul:24)*gain);
	//Out.ar(0,LeakDC.ar(BPF.ar(out2,band_osc2.lag(0.1),1),mul:24)*gain);
	Out.ar(0,Pan2.ar(LeakDC.ar(BPF.ar(sig1,band_osc1.lag(0.1),1),mul:24)*gain,linex));
	Out.ar(0,Pan2.ar(LeakDC.ar(BPF.ar(sig2,band_osc2.lag(0.1),1),mul:24)*gain,liney));

gold=(gold+(360-gold_r)).wrap(180.neg,180).round(0.0001);
silver1=(silver1+(360-silver_r)).wrap(180.neg,180).round(0.0001);
silver2=(silver2+(360-silver_r)).wrap(180.neg,180).round(0.0001);
silver3=(silver3+(360-silver_r)).wrap(180.neg,180).round(0.0001);
			}
}).add;);

1.wait;
~synth=Synth.new(\synth,[\gain,1,\tone,0,\low,16256/2,\high,28,
			                     \pan_speed,0.1,\band,0.0001,\lamdoma,1/2,\brain,1]).register;//s.record
1.wait;

	(
MIDIClient.init;
MIDIIn.connectAll;
		(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
		var gain;
	//[val, num, chan, src].postln;
	gain=val.linlin(0,127,0,6).round(0.000001);
		gain.postln;
		if(~synth.isPlaying,{~synth.set(\gain,gain)});
},26);
	);
	(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
		 var high;
	high=val.linlin(0,127,28,8128).round(0.00001);
		high.postln;
		if(~synth.isPlaying,{~synth.set(\high,high)});
},27);
	);
		(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var pan;
	pan=val.linlin(0,127,0.001,12).round(0.00001);
		pan.postln;
		if(~synth.isPlaying,{~synth.set(\pan_speed,pan)});
},28);
	);

	(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
         var low;
	low=val.linlin(0,127,16256,496).round(0.00001);
		low.postln;
		if(~synth.isPlaying,{~synth.set(\low,low)});
},29);
	);
		(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
		var band;
	band=val.linlin(0,127,0.1,1000).round(0.00001);
		band.postln;
		if(~synth.isPlaying,{~synth.set(\band,band)});
},30);
	);
					(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
		var tone;
		tone=val.linlin(0,127,0,16256*4).round(1).asInteger;
		tone.postln;
		if(~synth.isPlaying,{~synth.set(\tone,tone)});
},31);
	);
		(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
		var brain;
					if(val>0,brain=2.9999.rand.wrap(0.5,3),brain=2.9999.rand.wrap(0.5,3));
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},14);
	);
	(
MIDIdef.cc(\midi_switch2,{ |val, num, chan, src|
		 var brain;
				if(val>0,brain=6.9999.rand.wrap(4,7),brain=6.9999.rand.wrap(4,7));
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},15);
	);
		(
MIDIdef.cc(\midi_switch3,{ |val, num, chan, src|
		var brain;
					if(val>0,brain=11.9999.rand.wrap(8,12),brain=11.9999.rand.wrap(8,12));
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},16);
	);

	(
MIDIdef.cc(\midi_switch4,{ |val, num, chan, src|
         var brain;
					if(val>0,brain=14.9999.rand.wrap(12.5,15),brain=14.9999.rand.wrap(12.5,15));
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},17);
	);
		(
MIDIdef.cc(\midi_switch5,{ |val, num, chan, src|
		var brain;
				if(val>0,brain=29.9999.rand.wrap(15,30),brain=29.9999.rand.wrap(15,30));
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},18);
	);
					(
MIDIdef.cc(\midi_switch6,{ |val, num, chan, src|
		var brain;
				if(val>0,brain=109.9999.rand.wrap(30,110),brain=109.9999.rand.wrap(30,110));
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},19);
	);

	(
MIDIdef.cc(\midi_switch7,{ |val, num, chan, src|
		var lamdoma;
				if(val>0,lamdoma=1/2,lamdoma=1/2);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},20);
	);
	(
MIDIdef.cc(\midi_switch8,{ |val, num, chan, src|
		 var lamdoma;
				if(val>0,lamdoma=2/3,lamdoma=2/3);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},21);
	);
		(
MIDIdef.cc(\midi_switch9,{ |val, num, chan, src|
		var lamdoma;
					if(val>0,lamdoma=1/1,lamdoma=1/1);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},22);
	);

	(
MIDIdef.cc(\midi_switch10,{ |val, num, chan, src|
         var lamdoma;
				if(val>0,lamdoma=4/3,lamdoma=4/3);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},23);
	);
		(
MIDIdef.cc(\midi_switch11,{ |val, num, chan, src|
		var lamdoma;
				if(val>0,lamdoma=3/2,lamdoma=3/2);
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},24);
	);
					(
MIDIdef.cc(\midi_switch12,{ |val, num, chan, src|
		var lamdoma;
				if(val>0,lamdoma=2/1,lamdoma=2);
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