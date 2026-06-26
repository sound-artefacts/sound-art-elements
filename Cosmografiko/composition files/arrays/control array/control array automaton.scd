/*(

~az1=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~el1=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];

)

/////octahedron

(

~az2=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el2=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];

)

////tetrahedron

(
~az3=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el3=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];

)*/

/*(
var silver=(1+2.sqrt),gold=((1+5.sqrt)/2),kanon;

kanon= (gold*silver);
kanon.postln;
)*/


(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(1);
s.options.memSize = 8192*4*2;
s.options.blockSize = 64*1;
s.options.maxNodes = 1024 * 2;
//s.options.sampleRate= 44100;
s.boot;
)

(

(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];

);
Buffer.freeAll;

~controlBus_expansion = Bus.control(s, 1);
~controlBus_noise1 = Bus.control(s, 1);
~controlBus_noise2 = Bus.control(s, 1);



SynthDef.new(\player,{

	var silver=(1+2.sqrt),gold=((1+5.sqrt)/2),kanon;
	kanon=silver*gold;

	Out.kr(~controlBus_expansion.index, LFSaw.kr(0.1,iphase:1,mul:kanon,add:kanon));
	Out.kr(~controlBus_noise1.index, LFNoise1.kr(6,kanon.reciprocal));
Out.kr(~controlBus_noise2.index, LFNoise1.kr(6,kanon.reciprocal));

//Out.ar(0,sig*1);
//Out.ar(1,sig*1);

}).add;
)

(
var data1,data2,expansion,polytope=4,noise1,noise2;
var sph1,sph2,az1,el1,az2,el2,pl1=0,pl2=0;
var ot=0.degrad,size=400,run = true;

Synth.new(\player);
~data = [];
w = Window.new("3D Scatterplot", Rect(40,40, 800, 800)).front;

~v = UserView.new(w,Rect(0,0,800,800)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 800,800), ~data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 2;
a.symbolColor = Color.white;
a.background = Color.black;

~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

		a.rot(ot,ot,ot);
    ~v.refresh;

		ot=ot+0.1.degrad;

};

{ while { run } {~v.background_(Color.black); ~v.refresh; (1/100).wait } }.fork(AppClock);

  r= Routine({loop{

	~data=[];pl1=0;pl2=0;
	expansion=~controlBus_expansion.getSynchronous;
	noise1=~controlBus_noise1.getSynchronous;
	noise2=~controlBus_noise2.getSynchronous;

	data1=polytope.collect{

	az1=~az.[pl1];
	el1=~el.[pl1];

pl1=pl1+1;
		sph1=Spherical((expansion+noise1)*size,az1,el1).asCartesian.asArray;
		};

		data2=polytope.collect{

	az2=~az.[pl2];
	el2=~el.[pl2];

pl2=pl2+1;
		sph2=Spherical((expansion+noise2)*size,az2,el2).rotate(90.degrad).asCartesian.asArray;
		};
	~data=~data++data1++data2;

a.data = ~data;            // Update ScatterView3d
	0.01.wait

}});
r.play;
)

