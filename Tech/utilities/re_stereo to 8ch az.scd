(
s.options.numWireBufs = 1024*2;s.options.memSize = 8192*8;s.options.blockSize = 64;
s.options.numOutputBusChannels=8;s.options.numInputBusChannels=0;
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
~c3 = Buffer.readChannel(s,,channels:0 );
~c4 = Buffer.readChannel(s,channels:1 );
)
)

(
SynthDef.new(\re_stereo, {

	arg amp=1;
    var in1,in2,in3,in4,in5,in6,in7,in8;
	var chain1,chain2,chain3,chain4,chain5,chain6,chain7,chain8;
	var chain1a,chain2a,chain3a,chain4a,chain5a,chain6a,chain7a,chain8a;
	var frames=1024,nn,l1,r1;
	var sig1,sig2,sig3,sig4,sig5,sig6,sig7,sig8;
	var silver=45,golden=45,golden1=45.neg,l,r,phs=0,n=0;


	in1 = HPF.ar(PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 0, doneAction:2),56);
	 in2 = HPF.ar(PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2.bufnum), loop: 0, doneAction:2),56);
	 in3 = HPF.ar(PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3.bufnum), loop: 0, doneAction:2),56);
	 in4 = HPF.ar(PlayBuf.ar(1, ~c4.bufnum, BufRateScale.kr(~c4.bufnum), loop: 0, doneAction:2),56);


	chain1 = FFT(LocalBuf(frames), in1);chain2 = FFT(LocalBuf(frames), in2);
	chain3 = FFT(LocalBuf(frames), in3);chain4 = FFT(LocalBuf(frames), in4);

	(171).do{

chain1a = chain1.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: n, tobin: n, zeroothers: 1);
chain2a = chain2.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: n, tobin: n, zeroothers: 1);
chain3a = chain3.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: n, tobin: n, zeroothers: 1);
chain4a = chain4.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: n, tobin: n, zeroothers: 1);


l=exp(Complex(0,1)*golden.degrad).real.round(0.0001).abs;
r=exp(Complex(0,1)*golden.degrad).imag.round(0.0001).abs;

l1=exp(Complex(0,1)*silver.degrad).real.round(0.0001).abs;
r1=exp(Complex(0,1)*silver.degrad).imag.round(0.0001).abs;

silver=(silver+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.0001);
golden=(golden+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);
//phs=golden.degrad;
n=n+1;
nn=(n/100);
sig1=IFFT(chain1a);sig2=IFFT(chain2a);sig3=IFFT(chain3a);sig4=IFFT(chain4a);

Out.ar(0,PanAz.ar(8,sig1,LFSaw.ar(nn*l.reciprocal),amp));
Out.ar(0,PanAz.ar(8,sig2,LFSaw.ar(nn*l1.reciprocal),amp));
Out.ar(0,PanAz.ar(8,sig3,LFSaw.ar(nn*r.reciprocal),amp));
Out.ar(0,PanAz.ar(8,sig4,LFSaw.ar(nn*r1.reciprocal),amp));

	};
}).add;
)


(
Synth(\re_stereo,[\amp,3]);
s.record(numChannels:8,duration:(8*60));
)
