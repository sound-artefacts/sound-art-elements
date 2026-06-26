/*(
var win,view,red,green,blue;

~controlBus = Bus.control(s, 1);
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);

    // Create a window
    win = Window("RGB Audio Visualizer", Rect(100, 100, 400, 400));
    view = UserView(win, win.view.bounds);

  red = ~controlBus.getSynchronous;
green = ~controlBus1.getSynchronous;
 blue = ~controlBus2.getSynchronous;

    // Drawing function
    view.drawFunc = {
        Pen.fillColor = Color(red, green, blue);
        Pen.fillRect(view.bounds);
    };

    win.front;

)*/
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=10;
s.options.numInputBusChannels=1;
s.options.memSize = 8192*4;
s.options.blockSize = 128;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
s.boot;
s.meter;

)
(
{Out.ar(2,LFNoise1.ar(28))}.play;
{Out.ar(3,LFNoise1.ar(28))}.play;
{Out.ar(4,LFNoise1.ar(28))}.play;
{Out.ar(5,LFNoise1.ar(28))}.play;
{Out.ar(6,LFNoise1.ar((28)))}.play;
{Out.ar(7,LFNoise1.ar(28))}.play;
{Out.ar(8,LFNoise1.ar(28))}.play;
)


////////////////////////////////////////////painter

(
var win,wx=0,wy=0,g=((1+5.sqrt)/2),s=(1+2.sqrt), posit=0,size=1100,scale=150;
var xPos,yPos, ax,ay,ofset;
//Window.closeAll;

~amp1 = 0;
~amp2 = 0;
~amp3 = 0;
~amp4= 0;
~amp5 = 0;
~amp6= 0;
~amp7= 0;

win = Window("RGB Audio Visualizer", Rect(10, 10, 2*size,size));
~v1 = UserView(win, Rect(0,0,2*size,size)).background_(Color.black);

SynthDef(\painting, {
	arg lag=0.1,gain1=5,gain2=100;
	var amp1 = (InFeedback.ar(2).abs*gain1).lag(lag);
	var amp2 = (InFeedback.ar(3).abs*gain1).lag(lag);
	var amp3 = (InFeedback.ar(4).abs*gain1).lag(lag);
	var amp4 = (InFeedback.ar(5).abs*gain1).lag(lag);
	var amp5 = (InFeedback.ar(6)*gain2).lag(lag);
	var amp6 = (InFeedback.ar(7)*gain2).lag(lag);
	var amp7 = (InFeedback.ar(8).abs*gain2).lag(lag);

	SendReply.ar(Impulse.ar(60), '/amp1', amp1);
	SendReply.ar(Impulse.ar(60), '/amp2', amp2);
	SendReply.ar(Impulse.ar(60), '/amp3', amp3);
	SendReply.ar(Impulse.ar(60), '/amp4', amp4);
	SendReply.ar(Impulse.ar(60), '/amp5', amp5);
	SendReply.ar(Impulse.ar(60), '/amp6', amp6);
	SendReply.ar(Impulse.ar(60), '/amp7', amp7);
}).add;

// OSC
OSCdef(\ampt1, { |msg|
	~amp1 = msg[3];
	defer { ~v1.refresh };
}, '/amp1');

OSCdef(\ampt2, { |msg|
	~amp2 = msg[3];
	defer { ~v1.refresh };
}, '/amp2');

OSCdef(\ampt3, { |msg|
	~amp3 = msg[3];
	defer { ~v1.refresh };
}, '/amp3');

OSCdef(\ampt4, { |msg|
	~amp4 = msg[3];
	defer { ~v1.refresh };
}, '/amp4');

OSCdef(\ampt5, { |msg|
	~amp5 = msg[3];
	defer { ~v1.refresh };
}, '/amp5');

OSCdef(\ampt6, { |msg|
	~amp6 = msg[3];
	defer { ~v1.refresh };
}, '/amp6');

OSCdef(\ampt7, { |msg|
	~amp7 = msg[3];
	defer { ~v1.refresh };
}, '/amp7');

//  drawFunc
/*(
~v1.drawFunc = {
    Pen.translate(size/2, size/2);

ofset=0.01.rand;

    992.do { |y|
     //   1.do { |x|
			ax=exp(Complex(0,1)*posit).real;
			ay=exp(Complex(0,1)*posit).imag;

		xPos = ((y/15)*ax) * (size/scale) + (~amp5.lag(ofset));
	yPos = ((y/15)*ay) * (size/scale) + (~amp6.lag(ofset));

Pen.fillColor = Color(2.pow(~amp1/992.neg),
			2.pow(~amp2/992.neg),2.pow(~amp3/992.neg),2.pow(~amp4/992.neg));

     Pen.fillRect(Rect.aboutPoint(xPos @ yPos,
			~amp7.pow(0.1)*(size/scale),
			//(size/scale),
				~amp7.pow(0.1)*(size/scale)));
			//(size/scale)));

					//	posit = (posit+(2pi-(2pi/g))).wrap(0,2pi);
		posit=(posit+(2pi/56)).wrap(0,2pi);
      //  };
    };
};
);*/
(
~v1.drawFunc = {
    Pen.translate(size/2, size/2);

    10.do {
ofset=0.1.rand;
		xPos =  0+ (~amp5.lag(ofset));
	yPos = 0 + (~amp6.lag(ofset));

		Pen.fillColor = Color(~amp1.lag(ofset),
		~amp2.lag(ofset),
			~amp3.lag(ofset),
			~amp3.lag(ofset*10));

     Pen.fillRect(Rect.aboutPoint(xPos @ yPos,2*size,
			//(size/scale),
			size));
			//(size/scale)));

    };
};
);
win.front;

)

~a.set(\gain1,5)
~a.set(\gain2,1000)
~a.set(\lag,0.1)
~a.set(\lag,0.1)
~a.free


(
~a = Synth(\painting).register;
MIDIClient.init;
MIDIIn.connectAll;

					(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
		var k;
			k=val.linlin(0,127,0.1,2).round(0.00001);
		k.postln;
		if(~a.isPlaying,{~a.set(\gain1,k)});

},1);
						);

				(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
         var k;
		k=val.linlin(0,127,0.001,10).round(0.00001);
		k.postln;
		if(~a.isPlaying,{~a.set(\lag,k)});

},2);
	);
				(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var k;
			k=val.linlin(0,127,1,100).round(0.00001);
		k.postln;
		if(~a.isPlaying,{~a.set(\gain2,k)});
},3);
	)
)

