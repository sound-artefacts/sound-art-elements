
~control_seed=18.rand

(
//var silver_ratio=(1+2.sqrt),gold_ratio=((1+5.sqrt)/2), copper_ratio=pi;
var fibonacci=[1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181];
var pell=[0,1,2,5,12,29,70,169,408,985,2378,5741,13860,33461,80782,195025,470832,1136689];
//var polygon=[6,12,24,48,96,192,384,768,1536,3072,6144,12288,24576,49152,98304,196608,393216,786432];
//var polygon_octave=polygon.[~control_seed]/6, aprox,archimidis=polygon.[~control_seed];
var number=496/2,polygon=20.collect{number=number*2};
var interval_s,interval_g,interval_c,seed;

//aprox= ((sin((30/polygon_octave).degrad)*2)*polygon)/2;  //((sin((30/4).degrad)*2)*24)/2

///!!!
///((sin((((360/8128)/2)/128).degrad)*2)*(8128*128))/2  ///pi aproximation (archimedean) via perfect numbers "polygons" 6,28,496,8128

interval_g=fibonacci.[~control_seed];
interval_s=pell.[~control_seed];
interval_c=polygon.[~control_seed];

seed=interval_c.postln;
thisThread.randSeed = seed;

// create a function that returns a Routine

r = { Routine({
    loop({#[0,1,2,3].choose.yield })
}) };
Array.fill(4, r.value);
)



///algorithmic sequence creation

///fibonacci

///pell numbers

////archimedes



////////////////////true randomness

(
var trueRand;
trueRand = Pipe.new("head -c 4 /dev/urandom", "r");
trueRand.getInt32.postln;
trueRand.close;
)


thisThread.randSeed = trueRandomNumber;






(
{
    var in, amp;
    in  = SoundIn.ar(0);              // mic input
    amp = Amplitude.kr(in, 0.01, 0.05);
    amp.poll(10);                     // watch it
    Silent.ar
}.play;
)



(
{
    var in, amp, diff, quant;

    in   = SoundIn.ar(0);
    amp  = Amplitude.kr(in, 0.01, 0.05);

    diff = HPZ1.kr(amp);          // first derivative (change detector)
    quant = (diff * 100000).round(1);  // amplify + quantize

    quant.poll(10);
    Silent.ar
}.play;
)




(
{
    var in, amp, diff, q, hash;

    in   = SoundIn.ar(0);
    amp  = Amplitude.kr(in, 0.01, 0.05);

    diff = HPZ1.kr(amp);
    q    = (diff * 1e6).round(1);

    // chaotic nonlinear transform
    hash = (q * 1664525 + 1013904223) % 2147483647;

    hash = hash.abs / 2147483647;   // normalize 0–1

    hash.poll(10);

    Silent.ar
}.play;
)



(
SynthDef(\entropy, {
    var in, amp, diff, q;

    in  = SoundIn.ar(0);
    amp = Amplitude.kr(in);
    diff = HPZ1.kr(amp);
    q = (diff * 1e6).round(1);

    SendReply.kr(Impulse.kr(5), "/entropy", [q]);
}).add;
)

o = OSCFunc({ |msg|
    var val = msg[3].asInteger.abs;
    thisThread.randSeed = val;
    ("New seed: " ++ val).postln;
}, "/entropy");


///////////////randomness deriven from photocell with arduino

SerialPort.devices;
~port = SerialPort.new("/dev/cu.usbserial-210",9600)


(
~charArray = [];
~getValues = Routine.new({

	var ascii;
	{ascii = ~port.read.asAscii;
		if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $a,{~val = ~charArray.collect(_.digit).convertDigits;
			~charArray =[];
		});
	}.loop;

}).play;
)

(~control = Routine.new({
	{
	~val.postln;
		//~synth.set(\spin,~val.linlin(dark,light,0.001,10));
		0.01.wait;
	}.loop;
}).play;
)