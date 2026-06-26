j/*amshark70
speech_balloon
Apr 2023
The thing I want to achieve is to be able to trigger a random argument for the bus of Out without expanding on the rest of the channels as mentioned above (previous entry).
To be honest, it’s still not clear what you’re after. Jordan is correct about the minimal example. If you want to get faster, more accurate help, it’s very useful to reduce your example to the minimum possible that demonstrates the issue. For example, if you are working with multiple 4-channel signals, we do not need the entire logic – you could just create e.g. SinOsc.ar([200, 300, 400, 500], 0, 0.1) and then explain that you want 200 Hz on this bus, 300 Hz on that bus etc.

Now… the quote, “trigger a random argument for the bus of Out without expanding on the rest of the channels.”

Let’s do this kind of like a truth table in logic. There are two parameters: bus number(s), and signal(s). These may be either single or multiple (arrays).

Mono signal, one bus number: self-explanatory. This is a normal case.
Mono signal, multiple buses: as you would expect, the signal is copied to each bus. This isn’t done very often, but is easy to understand.
Multichannel signal, one bus number: The channels are assigned to consecutive buses. With four channels, channel 1 → bus; channel 2 → bus+1; channel 3 → bus+2; channel 4 → bus+3. This is a normal case.
Multichannel signal, multiple buses: The entire multichannel signal is copied to every bus number. This is normally not what users want.
Mono signal	Multichannel
One bus number	:white_check_mark: Signal → bus	:white_check_mark: Signals → consecutive buses
Many bus numbers	:white_check_mark: One signal → each bus	:x: Signals → multiple consecutive buses
“Normally not what users want” but if it isn’t this way, then, every time a user wants to play a stereo signal onto the hardware, they would have to write Out.ar([0, 1], stereo) instead of Out.ar(0, stereo).

The current design makes the most common scenario easy (multichannel signal → consecutive buses), and an unusual scenario harder (splitting up a multichannel signal onto nonconsecutive buses). That makes your specific case a little harder, but it is a logical design decision.

So you will have to split up the multichannel signals by yourself. The Out UGen by itself doesn’t do what you want, period.

I thought about various ways to specify the buses that you want, and I think the easiest is exactly what Jordan suggested: declare an array argument for out, and then in the Synth(), specify exactly the buses you want.

This operation of splitting up the channels needs to be done multiple times. For convenience, you could write a function for it:
*/
var wrappedOut = { |busArray, signalArray|
	// magic trick to expand to the larger of the two arrays
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])
	}
};
Then:

SynthDef.new(\oa, {
	arg rotation1 = 1, rotation2 = 1, rotation3 = 1, rotation4 = 1, rotation5 = 1, rotation6 = 1, rotation7 = 1, rotation8 = 1, n=1, cutt = 496;
	var out = NamedControl.kr(\out, [0, 1, 2, 3]);  // multiple buses!
var wrappedOut = { |busArray, signalArray|
	// magic trick to expand to the larger of the two arrays
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])
	}
};
//	... the rest as is, until...

		wrappedOut.value(out, LeakDC.ar(LPF.ar(osc1 * env * (2/3), cutt)));

	...
})
//So it looks almost exactly like what you wrote initially, just substituting a different operation in place of Out.ar.

//Then:

Synth.new(\oa, [\n, 13.neg, \out, (0..3).rotate(4.rand)])
//Last… semiquaver is right that 61 lines of copy-paste num == xx is rather excessive, especially when there’s a clear pattern. Just one minor modification to his suggestion, below, to avoid n == 0. Also, you could use the noteNum filter to remove all of the if statements.

// also I need to fix your spacing and indentation
// your code is hard to read!
MIDIdef.noteOn(\synhtone, { |val, num, chan, src|
	[val, num, chan, src].postln;
	if(num < 49) {
		num = num - 1
	};
	Synth(\oa, [n: num - 48, out: (0..3).rotate(4.rand)]);
}, noteNum: (36..96))
//hjh