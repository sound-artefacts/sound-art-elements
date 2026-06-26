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

~c1 = Buffer.readChannel(s,
	,channels:0);
~c2 = Buffer.readChannel(s,
	,channels:1);
)


(
SynthDef.new(\re_stereo, {

	arg amp=1;
    var in1,in2,chaina,chainb,chainxx,chainyy,chainaa,chainbb;
	var frames=1024,sig1,sig2,silver=45,golden=45,l,r,phs=0,n=0;

	in1 = Compander.ar(PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 0, doneAction:2));
	in2 = Compander.ar(PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2.bufnum), loop: 0, doneAction:2));




	chaina = FFT(LocalBuf(frames), in1);
	chainb = FFT(LocalBuf(frames), in2);

	(256*1.5+1).do{

chainaa = chaina.pvcollect(frames,
			{|mag, phase, index| [mag, (phase+0.degrad)]; }, frombin: n, tobin: n, zeroothers: 1);
chainbb = chainb.pvcollect(frames,
			{|mag, phase, index| [mag, (phase+90.degrad)]; }, frombin: n, tobin: n, zeroothers: 1);


l=exp(Complex(0,1)*golden.degrad).real.round(0.0001).abs;
r=exp(Complex(0,1)*golden.degrad).imag.round(0.0001).abs.neg;

		silver=(silver+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.0001);
		golden=(golden+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);

//phs=golden.degrad;

n=n+1;

sig1=IFFT(chainaa);
sig2=IFFT(chainbb);

		Out.ar(0,Pan2.ar(sig1,l,amp));
		Out.ar(0,Pan2.ar(sig2,r,amp));

	};
}).add;
)


(
Synth(\re_stereo,[\amp,1]);
s.record(duration:(2*60)+44);
)
