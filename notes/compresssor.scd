///compression notes
//	slopeAbove:
//4" → 0.35–0.45
//5" → 0.45–0.60
//8" → 0.60–0.80
		///the larger the speaker cone the more relax time is possible and less difference between slopes, also less threshhold//Relax time ≈ 5–10× the attack time
//clampTime (attack)
//Fast attack → kills transients → fewer high-frequency spikes
//Slow attack → transients pass → brighter sound
//relaxTime (release)
//Fast release → pumping, rhythmic spectral motion
//Slow release → smoother, denser spectrum
//Relax too short (< 80 ms)
//Bass “breathes”
//Mids wobble
//Small speakers sound cheap
//Relax too long (> 300 ms)
//Bass dominates gain control
//Mix sounds flat, distant
//Quiet detail doesn’t recover fast enough
//tanh saturation mul less as speaker size increase///

(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~a=(0-(pi/496)); ~ph=992.collect{~a=~a+(pi/496);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);

(
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
)


(
~w1= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
	signal=Signal.sineFill(~signalSize,~array,~ph);

wt = signal.asWavetable;
~w1.loadCollection(wt);
signal.plot;
		}.value;
);


(
{
	var sig,freq=220,low=8,control;

	sig=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:0,mul:100).abs*SinOsc.ar(freq,phase:0)),freq*low))!2;
	control=SinOsc.ar(220);

	sig=HPF.ar(sig,1);
	sig=Compander.ar(sig,control,-78.dbamp,10,0,0.01,0.3);
	sig=tanh(sig*1.8);
	sig=Limiter.ar(sig,1/2,0.01);
}.play)



(
{
	var sig,sig1,sig2,freq=110,low=2,control,out1,out2;

	//sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:0,mul:100).abs*SinOsc.ar(freq,phase:0)),freq*low));
   // sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq*32,phase:0,mul:100).abs*SinOsc.ar(freq,phase:0)),freq*low,1/32));
	sig1=BrownNoise.ar(1);
	//control=SinOsc.ar(freq,mul:1);
	control=BrownNoise.ar(1);

	sig1=HPF.ar(sig1,120);
	//sig2=HPF.ar(sig2,50);
	sig1=Compander.ar(control,control,-30.dbamp,1.2,1/3,0.001,0.15);
	//sig2=Compander.ar(sig1,control,-24.dbamp,1.2,0.25,0.03,0.15);
	sig1=tanh(sig1*1.8);
	//sig2=tanh(sig2*1);
	//sig1=Limiter.ar(sig1,0.9,0.01);
	//sig2=Limiter.ar(sig2,0.9,0.01);

	out1=Out.ar(0,sig1);
	out2=Out.ar(1,control);
}.play)




///freqsweep
(
{
var m=MouseX.kr(10,10000);
	SinOsc.ar((2*m).poll,mul:m.reciprocal)*10}.play
)

/////////////compressor example low carrier 343/0.07
(
{
	var sig,freq=55,low=1,control,out,threshold;

	sig=((LPF.ar((Osc.ar(~w1.bufnum,freq,phase:0,mul:100).abs*SinOsc.ar(freq,phase:0)),freq*low))+(LPF.ar((Osc.ar(~w1.bufnum,freq*32,phase:0,mul:100).abs*SinOsc.ar(freq*16,phase:0)),(freq*16)*low,1/16)))*0.1;
	//control=SinOsc.ar(freq,mul:1);
	control=(SinOsc.ar(freq,phase:0)+SinOsc.ar(freq*16,phase:0,mul:1/16))*0.1;

sig=HPF.ar(sig,50);

	threshold=(((343/0.07)/20).reciprocal.ampdb/2.sqrt).dbamp;
	sig=Compander.ar(sig,control,threshold,1.2,1/3,0.03,0.15);
	sig=tanh(sig*1.8)*10;


	out=Out.ar(0,sig!2);

}.play)


(((speed of sound / speaker size)/20Hz).reciprocal.ampdb/2.sqrt).dbamp;


/////not audio based/// the latter method was written with the help of ChatGpt
~t=(((343/0.07)/20).reciprocal.ampdb/2.sqrt).dbamp
(
SynthDef(\compressedSaw, {
    arg out=0, f0=110,
        thresh=0.020445816577977,
        k=0.7, attack=0.03, release=0.15;

    var n = 20;
    var baseAmps, energy;
    var gainTarget, gainEnv;
    var sig;

    // base spectral law (saw)
    baseAmps = Array.fill(n, { |i| 1 / (i+1) });

    // static energy proxy
    energy = baseAmps.collect { |a| a*a }.sum;

    // compression curve
    gainTarget = Select.kr(
        energy > thresh,
        [
            1,                              // below threshold
            (thresh / energy).pow(k)        // compressed
        ]
    );

    // envelope shaping (always runs, but target depends on threshold)
    gainEnv = EnvGen.kr(
        Env(
            levels: [1, gainTarget, gainTarget],
            times: [attack, release],
            curve: -4
        ),
        gate: 1
    );

    // additive synthesis
    sig = Mix.fill(n, { |i|
        SinOsc.ar(f0 * (i+1)) * baseAmps[i] * gainEnv
    });

    Out.ar(out, sig);
}).add;
)
Synth.new(\compressedSaw)