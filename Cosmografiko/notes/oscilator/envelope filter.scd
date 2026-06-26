(
SynthDef(\envFilter, {
    var sig, env, cutoff, filtered;

    // Sawtooth oscillator as input
    sig = Saw.ar(100, 0.3);

    // Envelope: attack, decay, sustain, release
    env = EnvGen.kr(
        Env.adsr(0.01, 0.2, 0.0, 0.5), // A-D-S-R shape
        gate: \gate.kr(1),             // trigger via gate
        doneAction: 2                  // free when done if gate is 0
    );

    // Map envelope value to filter cutoff
    cutoff = LinExp.kr(env, 0, 1, 200, 5000);

    // Resonant low-pass filter
    filtered = RLPF.ar(sig, cutoff, 0.2);

    Out.ar(0, filtered);
}).add;
)


// Example: play it
x = Synth(\envFilter);
x.set(\gate, 0);  // release






////lamdoma relation y=(x+1)/x between am modulator and carrier freq

{Out.ar(0,Saw.ar(6*64).abs+SinOsc.ar(5*64))}.play;



({Out.ar(1,
	LFTri.ar(3*32))}.play;
{Out.ar(1,
	SinOsc.ar(4*32,mul:1))}.play
)

//////////////////////////////////

{Out.ar(0,(SinOsc.ar(3*64)+Saw.ar(64*4).abs)*0.1)}.play;
{Out.ar(0,(SinOsc.ar(32*3)+LFTri.ar(32*4))*0.1)}.play;

/////////////////////////

{Out.ar(0,(SinOsc.ar(3*32*1,mul:1)+SinOsc.ar(3*32*2,1,mul:1/2)+SinOsc.ar(3*32*3,1,mul:1/3))+Saw.ar(4*32).abs)}.play;

(
	{Out.ar(0,Saw.ar(4*64).abs)}.play;

{Out.ar(0,SinOsc.ar((3*64)*1,mul:1/1))}.play;
//{Out.ar(0,SinOsc.ar((3*64)*2,mul:1/2))}.play;
//{Out.ar(0,SinOsc.ar((3*64)*3,mul:1/3))}.play;

);





