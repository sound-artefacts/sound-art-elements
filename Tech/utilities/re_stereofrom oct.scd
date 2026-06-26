(
s.options.numWireBufs = 1024*2;s.options.memSize = 8192*8;s.options.blockSize = 64;
s.options.numOutputBusChannels=2;s.options.numInputBusChannels=0;
//s.options.maxNodes = 1024 * 16;
//s.options.sampleRate= 44100;
//s.recChannels = 4;s.recHeaderFormat="aiff";s.recSampleFormat ="int16";
s.boot;
)

(
Buffer.freeAll;


///mixdown
(
~c1 = Buffer.readChannel(s,,channels:0 );
~c2 = Buffer.readChannel(s,,channels:1 );
~c3 = Buffer.readChannel(s,,channels:2 );
~c4 = Buffer.readChannel(s,,channels:3 );
~c5 = Buffer.readChannel(s,,channels:4 );
~c6 = Buffer.readChannel(s,,channels:5 );
~c7 = Buffer.readChannel(s,,channels:6 );
~c8 = Buffer.readChannel(s,,channels:7 );
)
)

(
SynthDef.new(\re_stereo, {

	arg amp=1;
    var in1,in2,in3,in4,in5,in6,in7,in8;
	var chain1,chain2,chain3,chain4,chain5,chain6,chain7,chain8;
	var chain1a,chain2a,chain3a,chain4a,chain5a,chain6a,chain7a,chain8a;
	var frames=1024;
	var sig1,sig2,sig3,sig4,sig5,sig6,sig7,sig8;
	var silver=45,golden=45,l,r,phs=0,n=0;


	in1 = HPF.ar(PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 0, doneAction:2),56);
	 in2 = HPF.ar(PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2.bufnum), loop: 0, doneAction:2),56);
	 in3 = HPF.ar(PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3.bufnum), loop: 0, doneAction:2),56);
	 in4 = HPF.ar(PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4.bufnum), loop: 0, doneAction:2),56);

	 in5=  HPF.ar(PlayBuf.ar(1, ~c5.bufnum, BufRateScale.kr(~c5.bufnum), loop: 0, doneAction:2),56);
	 in6 = HPF.ar(PlayBuf.ar(1, ~c6.bufnum, BufRateScale.kr(~c6.bufnum), loop: 0, doneAction:2),56);
	 in7 = HPF.ar(PlayBuf.ar(1, ~c7.bufnum, BufRateScale.kr(~c7.bufnum), loop: 0, doneAction:2),56);
	 in8 = HPF.ar(PlayBuf.ar(1, ~c8.bufnum, BufRateScale.kr(~c8.bufnum), loop: 0, doneAction:2),56);


	chain1 = FFT(LocalBuf(frames), in1);chain2 = FFT(LocalBuf(frames), in2);
	chain3 = FFT(LocalBuf(frames), in3);chain4 = FFT(LocalBuf(frames), in4);
	chain5 = FFT(LocalBuf(frames), in5);chain6 = FFT(LocalBuf(frames), in6);
	chain7 = FFT(LocalBuf(frames), in7);chain8 = FFT(LocalBuf(frames), in8);

	(255).do{

chain1a = chain1.pvcollect(frames,
			{|mag, phase, index| [mag, (phase+90.degrad+180.degrad)]; }, frombin: n, tobin: n, zeroothers: 1);
chain2a = chain2.pvcollect(frames,
			{|mag, phase, index| [mag, (phase+90.degrad+180.degrad)]; }, frombin: n, tobin: n, zeroothers: 1);
chain3a = chain3.pvcollect(frames,
			{|mag, phase, index| [mag, (phase+90.degrad+180.degrad)]; }, frombin: n, tobin: n, zeroothers: 1);
chain4a = chain4.pvcollect(frames,
			{|mag, phase, index| [mag, (phase+90.degrad+180.degrad)]; }, frombin: n, tobin: n, zeroothers: 1);
chain5a = chain5.pvcollect(frames,
			{|mag, phase, index| [mag, (phase+180.degrad)]; }, frombin: n, tobin: n, zeroothers: 1);
chain6a = chain6.pvcollect(frames,
			{|mag, phase, index| [mag, (phase+180.degrad)]; }, frombin: n, tobin: n, zeroothers: 1);
chain7a = chain7.pvcollect(frames,
			{|mag, phase, index| [mag, (phase+180.degrad)]; }, frombin: n, tobin: n, zeroothers: 1);
chain8a = chain8.pvcollect(frames,
			{|mag, phase, index| [mag, (phase+180.degrad)]; }, frombin: n, tobin: n, zeroothers: 1);


l=exp(Complex(0,1)*golden.degrad).real.round(0.0001).abs;
r=exp(Complex(0,1)*golden.degrad).imag.round(0.0001).abs.neg;

silver=(silver+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.0001);
golden=(golden+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);
//phs=golden.degrad;
n=n+1;

sig1=IFFT(chain1a);sig2=IFFT(chain2a);sig3=IFFT(chain3a);sig4=IFFT(chain4a);
sig5=IFFT(chain5a);sig6=IFFT(chain6a);sig7=IFFT(chain7a);sig8=IFFT(chain8a);

Out.ar(0,Pan2.ar(sig1,l,amp));Out.ar(0,Pan2.ar(sig2,l,amp));
Out.ar(0,Pan2.ar(sig3,l,amp));Out.ar(0,Pan2.ar(sig4,l,amp));
Out.ar(0,Pan2.ar(sig5,r,amp));Out.ar(0,Pan2.ar(sig6,r,amp));
Out.ar(0,Pan2.ar(sig7,r,amp));Out.ar(0,Pan2.ar(sig8,r,amp));

	};
}).add;
)

(
Synth(\re_stereo,[\amp,1/2]);
s.record(duration:(8*60));
)

