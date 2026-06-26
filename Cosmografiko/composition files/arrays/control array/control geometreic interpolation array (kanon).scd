(
var data;
var az=0,el=0,az_rot;
var m=600,sph,az1,el1,pl=0,daz,del,harm,mag,r=1.neg;
var r1,harm1,r2,harm2,rad,call,mk=50,size=200;

~data=[];

1.do{

data = (128*32).collect{

	az=~az.[pl];
	el=~el.[pl];
	//mag=1000;
	 mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
				// mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt));
		// mag=~magz.[pl];
	pl=pl+1;
			mk=(mk+((size*2.pow(n/12))-((size*2.pow(n/12))/1.6180339887499))).wrap(0,size*2.pow(n/12));
		sph=Spherical(mag*mk/1.2,az,el).asCartesian.asArray;
};
	//pl=0;
	//mk=(mk+(1200-(1200/1.6180339887499))).wrap(0,1200);
	~data=~data++data;
};
// data=(128*32).collect{
//
// 	az=~az.[pl];
// 	el=~el.[pl];
// 	//mag=2;
// 	mag=
// 	(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+
// 	(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
// 	//Cartesian(~magx.[pl],~magy.[pl],0).rho;
// 	//	Cartesian(~qx.[pl],~qy.[pl],0).rho;
// 	pl=pl+1;
// 	sph=Spherical(mag*400,az,el).asCartesian.asArray;
//
//
//
// };
// data.postln;

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


(
var data;
var az=0,el=0;
var m=600,sph,az1,el1,pl1=0,daz,del,harm,mag,r;
var r1,harm1,r2,harm2,rad;
var run = true,n=12;
var ot=0.degrad,mk=0,size=2.sqrt+100;

data = (8).collect{

	az=~az1.[pl1];
	el=~el1.[pl1];

	pl1=pl1+1;

		sph=Spherical(1000,az,el).asCartesian.asArray;
};

w = Window.new("3D Scatterplot", Rect(40,40, 800, 800)).front;

~v = UserView.new(w,Rect(0,0,800,800)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 800,800), data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 10;
a.symbolColor = Color.white;
a.background = Color.black;

~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

		a.rot(ot,ot,ot);
    ~v.refresh;

		ot=ot+0.05.degrad;

};
{ while { run } {~v.background_(Color.black); ~v.refresh; (1/1000).wait } }.fork(AppClock);
)


(
var data;
var az=0,el=0;
var m=600,sph,az1,el1,pl2=0,daz,del,harm,mag,r;
var r1,harm1,r2,harm2,rad;
var run = true,n=12;
var ot=0.degrad,mk=0,size=2.sqrt+100;

data = (4).collect{

	az=~az3.[pl2];
	el=~el3.[pl2];

	pl2=pl2+1;

		sph=Spherical(1000,az,el).asCartesian.asArray;
};

w = Window.new("3D Scatterplot", Rect(40,40, 800, 800)).front;

~v = UserView.new(w,Rect(0,0,800,800)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 800,800), data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 10;
a.symbolColor = Color.white;
a.background = Color.black;

~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

		a.rot(ot,ot,ot);
    ~v.refresh;

		ot=ot+0.05.degrad;

};
{ while { run } {~v.background_(Color.black); ~v.refresh; (1/1000).wait } }.fork(AppClock);
)

/////silver ratio 2.sqrt+1
/////////////
//////cube
(

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

)
