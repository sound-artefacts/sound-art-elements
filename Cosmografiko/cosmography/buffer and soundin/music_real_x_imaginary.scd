


(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=2;
s.options.memSize = 8192*4;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
s.boot;
~frames=1024;
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

(
~r1 = Buffer.readChannel(s,,channels:0 );
~r2 = Buffer.readChannel(s,,channels:0 );
~i3 = Buffer.readChannel(s,,channels:0 );
		);

		(
			{
var steps = 8;

~nVals = steps.collect { |i|
    i.linexp(0, steps-1, 0.18, 463).round
};
			~nVals.asInteger;
			}.value;
		);

(
SynthDef.new(\re_im, {

	arg amp1=1,amp2=1,amp3=1,amp4=1,amp5=1,amp6=1,amp7=1,amp8=1,
				amp1a=1,amp2a=1,amp3a=1,amp4a=1,amp5a=1,amp6a=1,amp7a=1,
				amp8a=1,amp1aa=1,amp2aa=1,amp3aa=1,amp4aa=1,amp5aa=1,amp6aa=1,amp7aa=1,amp8aa=1,az,el,azimuth,elevation;

	var chain1rl,chain2rl,chain3rl,chain4rl,chain5rl,chain6rl,chain7rl,chain8rl;
	var chain1rr,chain2rr,chain3rr,chain4rr,chain5rr,chain6rr,chain7rr,chain8rr;
	var chain1il,chain2il,chain3il,chain4il,chain5il,chain6il,chain7il,chain8il;
    var sig1rl,sig2rl,sig3rl,sig4rl,sig5rl,sig6rl,sig7rl,sig8rl;
	var sig1rr,sig2rr,sig3rr,sig4rr,sig5rr,sig6rr,sig7rr,sig8rr;
    var sig1il,sig2il,sig3il,sig4il,sig5il,sig6il,sig7il,sig8il;
	var sph, anglex,angley,anglez,in1,in2,in3,in4,n=0;
	var frames=~frames,silver=45,golden=45,l=1,r=1.neg,g=((1+5.sqrt)/2),s=(1+2.sqrt);


    in1 = PlayBuf.ar(1, ~r1.bufnum, BufRateScale.kr(~r1.bufnum), loop: 0, doneAction:0);
	in2 = PlayBuf.ar(1, ~r2.bufnum, BufRateScale.kr(~r2.bufnum), loop: 0, doneAction:0);
	//in1 = SoundIn.ar(0);
	//in2 = SoundIn.ar(1);
    in3 = PlayBuf.ar(1, ~i3.bufnum, BufRateScale.kr(~i3.bufnum), loop: 0, doneAction:0);
	//in3 = SoundIn.ar(2);


	chain1 = FFT(LocalBuf(frames), in1);	chain3 = FFT(LocalBuf(frames), in3);
	chain2 = FFT(LocalBuf(frames), in2);

chain1rl = chain1.pvcollect(frames,
						{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[0], tobin: ~nVals.[0], zeroothers: 1);
chain2rl = chain1.pvcollect(frames,
						{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[0]+1, tobin: ~nVals.[1], zeroothers: 1);
chain3rl = chain1.pvcollect(frames,
					{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[1]+1, tobin: ~nVals.[2], zeroothers: 1);
chain4rl = chain1.pvcollect(frames,
					{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[2]+1, tobin: ~nVals.[3], zeroothers: 1);
chain5rl = chain1.pvcollect(frames,
					{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[3]+1, tobin: ~nVals.[4], zeroothers: 1);
chain6rl = chain1.pvcollect(frames,
					{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[4]+1, tobin: ~nVals.[5], zeroothers: 1);
chain7rl = chain1.pvcollect(frames,
					{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[5]+1, tobin: ~nVals.[6], zeroothers: 1);
chain8rl = chain1.pvcollect(frames,
					{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[6]+1, tobin: ~nVals.[7], zeroothers: 1);

chain1rr = chain2.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; },  frombin: ~nVals.[0], tobin: ~nVals.[0], zeroothers: 1);
chain2rr = chain2.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; },  frombin: ~nVals.[0]+1, tobin: ~nVals.[1], zeroothers: 1);
chain3rr = chain2.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[1]+1, tobin: ~nVals.[2], zeroothers: 1);
chain4rr = chain2.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[2]+1, tobin: ~nVals.[3], zeroothers: 1);
chain5rr = chain2.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[3]+1, tobin: ~nVals.[4], zeroothers: 1);
chain6rr = chain2.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[4]+1, tobin: ~nVals.[5], zeroothers: 1);
chain7rr = chain2.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[5]+1, tobin: ~nVals.[6], zeroothers: 1);
chain8rr = chain2.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[6]+1, tobin: ~nVals.[7], zeroothers: 1);


chain1il = chain3.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; },  frombin: ~nVals.[0], tobin: ~nVals.[0], zeroothers: 1);
chain2il = chain3.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[0]+1, tobin: ~nVals.[1], zeroothers: 1);
chain3il = chain3.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[1]+1, tobin: ~nVals.[2], zeroothers: 1);
chain4il = chain3.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[2]+1, tobin: ~nVals.[3], zeroothers: 1);
chain5il = chain3.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[3]+1, tobin: ~nVals.[4], zeroothers: 1);
chain6il = chain3.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[4]+1, tobin: ~nVals.[5], zeroothers: 1);
chain7il = chain3.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[5]+1, tobin: ~nVals.[6], zeroothers: 1);
chain8il = chain3.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[6]+1, tobin: ~nVals.[7], zeroothers: 1);

	/*az=SinOsc.ar(azimuth,elevation).theta;
				el=SinOsc.ar(azimuth,elevation).phi;*/
		sph=Spherical.ar(1,az,el);


anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;


sig1rl=IFFT(chain1rl);sig2rl=IFFT(chain2rl);sig3rl=IFFT(chain3rl);sig4rl=IFFT(chain4rl);
sig5rl=IFFT(chain5rl);sig6rl=IFFT(chain6rl);sig7rl=IFFT(chain7rl);sig8rl=IFFT(chain8rl);

sig1rr=IFFT(chain1rr);sig2rr=IFFT(chain2rr);sig3rr=IFFT(chain3rr);sig4rr=IFFT(chain4rr);
sig5rr=IFFT(chain5rr);sig6rr=IFFT(chain6rr);sig7rr=IFFT(chain7rr);sig8rr=IFFT(chain8rr);

sig1il=IFFT(chain1il);sig2il=IFFT(chain2il);sig3il=IFFT(chain3il);sig4il=IFFT(chain4il);
sig5il=IFFT(chain5il);sig6il=IFFT(chain6il);sig7il=IFFT(chain7il);sig8il=IFFT(chain8il);


/*(
amp1=SinOsc.kr(0.023219954648526,0.degrad,0.2);
amp2=SinOsc.kr(0.023219954648526,45.degrad,0.2);
amp3=SinOsc.kr(0.023219954648526,90.degrad,0.2);
amp4=SinOsc.kr(0.023219954648526,(90+45).degrad,0.2);
amp5=SinOsc.kr(0.023219954648526,180.degrad,0.2);
amp6=SinOsc.kr(0.023219954648526,(180+45).degrad,0.2);
amp7=SinOsc.kr(0.023219954648526,(180+90).degrad,0.2);
amp8=SinOsc.kr(0.023219954648526,360.degrad,0.2);
amp1a=SinOsc.kr(0.023219954648526,90.degrad);
amp2a=SinOsc.kr(0.023219954648526,(90+45).degrad);
amp3a=SinOsc.kr(0.023219954648526,(90+90).degrad);
amp4a=SinOsc.kr(0.023219954648526,(90+90+45).degrad);
amp5a=SinOsc.kr(0.023219954648526,(90+180).degrad);
amp6a=SinOsc.kr(0.023219954648526,(90+180+45).degrad);
amp7a=SinOsc.kr(0.023219954648526,(90+180+90).degrad);
amp8a=SinOsc.kr(0.023219954648526,90.degrad);
				az=SinOsc.ar(azimuth,elevation).theta;
				el=SinOsc.ar(azimuth,elevation).phi;
				)*/

Out.ar(0,Pan2.ar(sig1rl,anglex,amp1));Out.ar(0,Pan2.ar(sig2rl,anglex,amp2));Out.ar(0,Pan2.ar(sig3rl,anglex,amp3));Out.ar(0,Pan2.ar(sig4rl,anglex,amp4));
Out.ar(0,Pan2.ar(sig5rl,anglex,amp5));Out.ar(0,Pan2.ar(sig6rl,anglex,amp6));Out.ar(0,Pan2.ar(sig7rl,anglex,amp7));Out.ar(0,Pan2.ar(sig8rl,anglex,amp8));

Out.ar(0,Pan2.ar(sig1rr,angley,amp1a));Out.ar(0,Pan2.ar(sig2rr,angley,amp2a));Out.ar(0,Pan2.ar(sig3rr,angley,amp3a));Out.ar(0,Pan2.ar(sig4rr,angley,amp4a));
Out.ar(0,Pan2.ar(sig5rr,angley,amp5a));Out.ar(0,Pan2.ar(sig6rr,angley,amp6a));Out.ar(0,Pan2.ar(sig7rr,angley,amp7a));Out.ar(0,Pan2.ar(sig8rr,angley,amp8a));

Out.ar(0,Pan2.ar(sig1il,anglez,amp1aa));Out.ar(0,Pan2.ar(sig2il,anglez,amp2aa));Out.ar(0,Pan2.ar(sig3il,anglez,amp3aa));Out.ar(0,Pan2.ar(sig4il,anglez,amp4aa));
Out.ar(0,Pan2.ar(sig5il,anglez,amp5aa));Out.ar(0,Pan2.ar(sig6il,anglez,amp6aa));Out.ar(0,Pan2.ar(sig7il,anglez,amp7aa));Out.ar(0,Pan2.ar(sig8il,anglez,amp8aa));


}).add;
);


5.wait;
~synth=Synth.new(\re_im,[\amp1,0.33,\amp2,0.5,\amp3,0.2,\amp4,0.1,\amp5,1,\amp6,0.6,\amp7,0.3,\amp8,0.4,
		\amp1a,1,\amp2a,0.333,\amp3a,1,\amp4a,0.7,\amp5a,0.1,\amp6a,0.8,\amp7a,1,\amp8a,0.7,
			\amp1aa,1,\amp2aa,0.333,\amp3aa,1,\amp4aa,0.7,\amp5aa,0.1,\amp6aa,0.8,\amp7aa,1,\amp8aa,0.7,\az,0,\el,pi/4).register;//s.record
	//	~synth=Synth.new(\re_im);
2.wait;
(
MIDIClient.init;
MIDIIn.connectAll;
		(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
		var a1;

	a1=val.linlin(0,127,0,1).round(0.000001);
		a1.postln;
		if(~synth.isPlaying,{~synth.set(\amp1,a1)});
},20);
				);
	(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
		var a2;
		a2=val.linlin(0,127,0,1).round(0.000001);
		a2.postln;
		if(~synth.isPlaying,{~synth.set(\amp2,a2)});
},21);
	);
		(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var a3;
	a3=val.linlin(0,127,0,1).round(0.000001);
		a3.postln;
		if(~synth.isPlaying,{~synth.set(\amp3,a3)});
},22);
	);
		(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
		var a4;
	a4=val.linlin(0,127,0,1).round(0.000001);
		a4.postln;
		if(~synth.isPlaying,{~synth.set(\amp4,a4)});
},23);
	);

			(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
		var a5;
	a5=val.linlin(0,127,0,1).round(0.000001);
		a5.postln;
		if(~synth.isPlaying,{~synth.(\amp5,a5)});
},24);
	);

	(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
		 var a6;
	a6=val.linlin(0,127,0,1).round(0.00001);
		a6.postln;
		if(~synth.isPlaying,{~synth.set(\amp6,a6)});
},25);
	);

				(
MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
		var a7;
	a7=val.linlin(0,127,0,1).round(0.000001);
		a7.postln;
		if(~synth.isPlaying,{~synth.set(\amp7,a7)});
},26);
	);

	(
MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
         var a8;
		a8=val.linlin(0,127,0,1).round(0.000001);
		a8.postln;
		if(~synth.isPlaying,{~synth.set(\amp8,a8)});
},27);
	);

		(
MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
		var a9;
	a9=val.linlin(0,127,0,1).round(0.000001);
		a9.postln;
		if(~synth.isPlaying,{~synth.set(\amp1a,a9)});
},28);
	);
					(
MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
		var a10;
		a10=val.linlin(0,127,0,1).round(0.000001);
		a10.postln;
		if(~synth.isPlaying,{~synth.set(\amp2a,a10)});
},29);
	);
								(
MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
		var a11;
		a11=val.linlin(0,127,0,1).round(0.000001);
		a11.postln;
		if(~synth.isPlaying,{~synth.set(\amp3a,a11)});
},30);
	);
					(
MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
		var a12;
		a12=val.linlin(0,127,0,1).round(0.000001);
		a12.postln;
		if(~synth.isPlaying,{~synth.set(\amp4a,a12)});
},31);
	);
								(
MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|
		var a13;
		a13=val.linlin(0,127,0,1).round(0.000001);
		a13.postln;
		if(~synth.isPlaying,{~synth.set(\amp5a,a13)});
},32);
	);
								(
MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|
		var a14;
		a14=val.linlin(0,127,0,1).round(0.000001);
		a14.postln;
		if(~synth.isPlaying,{~synth.set(\amp6a,a14)});
},33);
	);
											(
MIDIdef.cc(\midi_pot15,{ |val, num, chan, src|
		var a15;
		a15=val.linlin(0,127,0,1).round(0.000001);
		a15.postln;
		if(~synth.isPlaying,{~synth.set(\amp7a,a15)});
},34);
	);
											(
MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|
		var a16;
		a16=val.linlin(0,127,0,1).round(0.000001);
		a16.postln;
		if(~synth.isPlaying,{~synth.set(\amp8a,a16)});
},35);
			);

		(
MIDIdef.cc(\midi_pot17,{ |val, num, chan, src|
		var a9;
	a9=val.linlin(0,127,0,1).round(0.000001);
		a9.postln;
		if(~synth.isPlaying,{~synth.set(\amp1aa,a9)});
},35);
	);
					(
MIDIdef.cc(\midi_pot18,{ |val, num, chan, src|
		var a10;
		a10=val.linlin(0,127,0,1).round(0.000001);
		a10.postln;
		if(~synth.isPlaying,{~synth.set(\amp2aa,a10)});
},36);
	);
								(
MIDIdef.cc(\midi_pot19,{ |val, num, chan, src|
		var a11;
		a11=val.linlin(0,127,0,1).round(0.000001);
		a11.postln;
		if(~synth.isPlaying,{~synth.set(\amp3aa,a11)});
},37);
	);
					(
MIDIdef.cc(\midi_pot20,{ |val, num, chan, src|
		var a12;
		a12=val.linlin(0,127,0,1).round(0.000001);
		a12.postln;
		if(~synth.isPlaying,{~synth.set(\amp4aa,a12)});
},38);
	);
								(
MIDIdef.cc(\midi_pot21,{ |val, num, chan, src|
		var a13;
		a13=val.linlin(0,127,0,1).round(0.000001);
		a13.postln;
		if(~synth.isPlaying,{~synth.set(\amp5aa,a13)});
},39);
	);
								(
MIDIdef.cc(\midi_pot22,{ |val, num, chan, src|
		var a14;
		a14=val.linlin(0,127,0,1).round(0.000001);
		a14.postln;
		if(~synth.isPlaying,{~synth.set(\amp6aa,a14)});
},40);
	);
											(
MIDIdef.cc(\midi_pot23,{ |val, num, chan, src|
		var a15;
		a15=val.linlin(0,127,0,1).round(0.000001);
		a15.postln;
		if(~synth.isPlaying,{~synth.set(\amp7aa,a15)});
},31);
	);
											(
MIDIdef.cc(\midi_pot24,{ |val, num, chan, src|
		var a16;
		a16=val.linlin(0,127,0,1).round(0.000001);
		a16.postln;
		if(~synth.isPlaying,{~synth.set(\amp8aa,a16)});
},42);
	);



)
});
	Tdef(\drone).play;
}
)
)
s.record(numchannels:2,duration:(4*60));