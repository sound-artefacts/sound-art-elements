(
~n=1.neg;~array=16256.collect{~n=~n+1;2.pow(~n/16256)};
~a=(0-(pi/8128)); ~ph=16256.collect{~a=~a+(pi/8128);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
)


(
Buffer.freeAll;
~w= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
	signal=Signal.sineFill(~signalSize,~array,~ph);

wt = signal.asWavetable;
~w.loadCollection(wt);
signal.plot;
		}.value;
)


////ornal osc///sawtooth
(
var freq=6*32, b=1,amp=1, f=1;
{Out.ar(0,LPF.ar((Osc.ar(~w.bufnum,freq,phase:0.degrad,mul:100).abs*SinOsc.ar(freq,phase:0.degrad)),freq*f,amp))}.play;
{Out.ar(1,LPF.ar((Osc.ar(~w.bufnum,freq,phase:90.degrad,mul:100).abs*SinOsc.ar(freq,phase:90.degrad)),freq*f,amp))}.play;
)

/////shaper///triangle
(
var freq=6*32, b=1,amp=1, f=4,r=0.8;
{Out.ar(0,LPF.ar((Shaper.ar(~w.bufnum,SinOsc.ar(freq,phase:0.degrad,mul:r),mul:100).abs*SinOsc.ar(freq,phase:0.degrad)),freq*f,amp))}.play;
{Out.ar(1,LPF.ar((Shaper.ar(~w.bufnum,SinOsc.ar(freq,phase:90.degrad,mul:r),mul:100).abs*SinOsc.ar(freq,phase:90.degrad)),freq*f,amp))}.play;
)
