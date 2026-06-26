/*////cycle control array mag

(var x=1,a=0,y;

y=(x+a)/x;
Complex(x,y).abs*/

)/////////////array
(
{
	var data,el=1,az=0,rep=360,silver=(1+2.sqrt),w=((1+5.sqrt)/2);

	~az=[];~el=[];

rep.do{
		//az=(az+(360-(360/silver))).wrap(0,360);
		az=(az+1).wrap(0,360);
		~az=~az++az.degrad;
		~el=~el++el.degrad;
	};

}.value;
)



////plotters
(

var data,run = true,az=0,el=0,pl=0,rep=360,factor=1000;
var step=0,sph,sphcart,silver=(1+2.sqrt),w=((1+5.sqrt)/2);
var ot=0.degrad,magnitude,a=1;

~data=[];

data=rep.collect{
	el=~el.[pl];
	az=~az.[pl];
	/*	y=(x+a)/x;
		x=(step*interval);
		step=step+1;
		mag=Complex(x,y).rho;
		mag.postln;*/
pl=pl+1;
		sph=Spherical(factor,az,el);
		sphcart=Cartesian(sph.x,sph.y,sph.z).asArray;
};
~data=~data++data;

w = Window.new("3D Scatterplot", Rect(40,40, 1000, 800)).front;
a = ScatterView3d(w, Rect(0,0, 800,800), ~data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 1;
a.symbolColor = Color.white;
a.background = Color.black;

// Y Slider
Slider(w, Rect(820, 10, 10, 450)).action_{|me|
    a.rotY = me.value * 2pi;
    w.refresh;
};
// X Slider
Slider(w, Rect(870, 10, 10, 450)).action_{|me|
    a.rotX = me.value * 2pi;
    w.refresh;
};
// Z Slider
Slider(w, Rect(920, 10, 10, 450)).action_{|me|
    a.rotZ = me.value * 2pi;
    w.refresh;
};

)

///////////////////basic model
(
var data,run = true,az=0,el=0,pl=0,rep=360,factor=100;
var step=0,sph,sphcart,silver=(1+2.sqrt),w=((1+5.sqrt)/2);
var ot=0.degrad,mag=1,a=1,interval=1;
var xyz_rotor=[1,1,1].normalizeSum.sqrt,axis,q,sph_rot,angle=90,rotor,sph_spin;
var i=Quaternion(0, xyz_rotor.[0], 0, 0),j=Quaternion(0, 0, xyz_rotor.[1], 0),k=Quaternion(0, 0, 0, xyz_rotor.[2]);


axis=i+j+k;

~data=[];
3.do{
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



w = Window.new("3D Scatterplot", Rect(40,40, 800, 800)).front;

~v = UserView.new(w,Rect(0,0,800,800)).background_(Color.black);
b = ScatterView3d(~v, Rect(0,0, 800,800), ~data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
b.drawMethod = \fillRect;
b.symbolSize = 1;
b.symbolColor = Color.white;
b.background = Color.black;

~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

		b.rot(ot,ot,ot);
    ~v.refresh;
		ot=ot+1.degrad;

};

{ while { run } {~v.background_(Color.black); ~v.refresh; (1/1000).wait } }.fork(AppClock);
)












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
(
(
Buffer.freeAll;

~controlBus_spin = Bus.control(s, 1);



SynthDef.new(\player,{

	Out.kr(~controlBus_spin.index, Saw.kr(MouseX.kr(0.001,10),mul:2pi).round(0.0001).poll);

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
)
)

//Server.freeAll

//animation

(
var data,run = true,az=0,el=0,pl=0,rep=12,factor=1000;
var step=0,sph,sphcart,silver=(1+2.sqrt),w=((1+5.sqrt)/2);
var ot=0.degrad,mag=1,a=1,interval=1;
var xyz_rotor=[0,0,1].normalizeSum.sqrt,axis,q,sph_rot,angle=90,rotor,sph_spin;
var i=Quaternion(0, xyz_rotor.[0], 0, 0),j=Quaternion(0, 0, xyz_rotor.[1], 0),k=Quaternion(0, 0, 0, xyz_rotor.[2]);

Synth.new(\player);
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





