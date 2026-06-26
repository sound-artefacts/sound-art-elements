
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

}).play
)

~val

(
SynthDef(\noise ,{ arg amp; var sig;

sig = WhiteNoise.ar(amp.lag(0.02));

	Out.ar(0,sig);
}).add;

)
(
~synth=Synth.new(\noise, [amp:0.1]);

(~control = Routine.new({
	{
		~synth.set(\amp,~val.linlin(20,1100,0.0001,1));
		0.01.wait;
	}.loop;
}).play;
)
)
