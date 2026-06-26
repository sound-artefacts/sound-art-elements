///////////////////////////////////animated axis sping
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(1);
s.options.memSize = 8192*4;
s.options.blockSize = 64*1;
s.options.maxNodes = 1024 * 2;
//s.options.sampleRate= 44100;
s.boot;
)
SerialPort.devices;
~port = SerialPort.new("/dev/cu.usbserial-210",9600)

(
(
Buffer.freeAll;

~controlBus_spin = Bus.control(s, 1);



SynthDef.new(\player,{ arg spin;

	Out.kr(~controlBus_spin.index, Saw.kr(spin,mul:2pi).round(0.0001));

}).add;
);

/////////////array
(
{
	var data,el=1,az=0,rep=360,silver=(1+2.sqrt),w=((1+5.sqrt)/2);

	~az=[];~el=[];

rep.do{
		az=(az+(360-(360/silver))).wrap(0,360);
		~az=~az++az.degrad;
		~el=~el++el.degrad;
	};

}.value;
);
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
)

//Server.freeAll

//animation

(
var data,run = true,az=0,el=0,pl=0,rep=12,factor=1000;
var step=0,sph,sphcart,silver=(1+2.sqrt),w=((1+5.sqrt)/2);
var ot=0.degrad,mag=1,a=1,interval=1,dark=500,light=1200;
var xyz_rotor=[0,0,1].normalizeSum.sqrt,axis,q,sph_rot,angle=90,rotor,sph_spin;
var i=Quaternion(0, xyz_rotor.[0], 0, 0),j=Quaternion(0, 0, xyz_rotor.[1], 0),k=Quaternion(0, 0, 0, xyz_rotor.[2]);

~synth=Synth.new(\player);

(~control = Routine.new({
	{
	~val.postln;
		~synth.set(\spin,~val.linlin(dark,light,0.001,10));
		0.01.wait;
	}.loop;
}).play;
);

axis=i+j+k;
~data=[];


w = Window.new("3D Scatterplot", Rect(40,40, 800, 800)).front;

~v = UserView.new(w,Rect(0,0,800,800)).background_(Color.black);
b = ScatterView3d(~v, Rect(0,0, 800,800), ~data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
b.drawMethod = \fillRect;
b.symbolSize = 2;
b.symbolColor = Color.white;
b.background = Color.black;
//b.rot(45.degrad,0,0);

~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

		b.rot(ot,ot,ot);

    ~v.refresh;
		ot=ot+0.1.degrad;

};

{ while { run } {~v.background_(Color.black); ~v.refresh; (1/1000).wait } }.fork(AppClock);

  r= Routine({loop{
	~data=[];

	angle=~controlBus_spin.getSynchronous;



{1.do{
data=rep.collect{
	el=~el.[pl];
	az=~az.[pl];

pl=pl+1;
		sph=Spherical(factor,az,el);
		sphcart=Cartesian(sph.x,sph.y,sph.z).asArray;

q=Quaternion(0,sph.x.round(0.00001),sph.y.round(0.00001),sph.z.round(0.00001));
rotor=((axis*exp(Complex(0,1)*angle).imag)+exp(Complex(0,1)*angle).real);
sph_rot=rotor*q*rotor.conjugate;

sph_spin=Cartesian(sph_rot.b,sph_rot.c,sph_rot.d).asArray;

};
	pl=0;
~data=~data++data;
	step=step+1;
		x=(step*interval);
		y=(x+a)/x;

};
}.value;

 	b.data = ~data;            // Update ScatterView3d
	0.01.wait};
});
r.play;
);


