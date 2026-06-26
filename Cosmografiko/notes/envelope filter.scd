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
