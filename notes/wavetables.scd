	//oscillator table
		(
~bufferSize = 4096*8;
~signalSize = 2048*8;
);


(
~w1= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
		signal=Signal.newClear(~signalSize).waveFill({ |x|
    sin(x).abs * (sin(x/4) * 4)
}, 0, 8pi);
wt = signal.asWavetable;
~wt.loadCollection(wt);
signal.plot;
		}.value;
)


{Osc.ar(~w1.bufnum,110)}.play

//////
(
~wt=Array.fill(4,{
	var signal,wt;
		signal=Signal.newClear(~signalSize).waveFill({ |x|
    sin(x).abs * (sin(x/4) * 4)
}, 0, 8pi);
wt = signal.asWavetable;
		};
)


~buf=Bufer.allocConsecutive(4,s,2024);
(
~buf.do{
	arg buf,i;
	buf.loadCollection(~wt[i]);
})

(
{
	var sig,bufpos,buf=0,numBufs=0;
	bufpos=buf+MouseX.kr(0,numBufs-1);
	sig=VOsc.ar(bufpos,55);
}.play;
)
