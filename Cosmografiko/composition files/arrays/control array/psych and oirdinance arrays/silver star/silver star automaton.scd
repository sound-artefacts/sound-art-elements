

///////////////////////////////////animated axis
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=12;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(1);
s.options.memSize = 8192*4*2;
s.options.blockSize = 64*1;
s.options.maxNodes = 1024 * 2;
//s.options.sampleRate= 44100;
s.boot;
)

(
Buffer.freeAll;

~controlBus_a1 = Bus.control(s, 1);~controlBus_a2 = Bus.control(s, 1);~controlBus_a3 = Bus.control(s, 1);
~controlBus_x1 = Bus.control(s, 1);~controlBus_x2 = Bus.control(s, 1);~controlBus_x3 = Bus.control(s, 1);
~controlBus_y1 = Bus.control(s, 1);~controlBus_y2 = Bus.control(s, 1);~controlBus_y3 = Bus.control(s, 1);
~controlBus_z1 = Bus.control(s, 1);~controlBus_z2 = Bus.control(s, 1);~controlBus_z3 = Bus.control(s, 1);


SynthDef.new(\player,{

	Out.kr(~controlBus_a1.index, SinOsc.kr(0.05,0.degrad,mul:pi));
	Out.kr(~controlBus_a2.index, SinOsc.kr(0.05,90.degrad,mul:pi));
	Out.kr(~controlBus_a3.index, SinOsc.kr(0.05,45.degrad,mul:pi));
	Out.kr(~controlBus_x1.index, SinOsc.kr(0.01,0.degrad,mul:1,add:0));
	Out.kr(~controlBus_y1.index, SinOsc.kr(0.01,90.degrad,mul:1,add:0));
	Out.kr(~controlBus_z1.index, SinOsc.kr(0.01,45.degrad,mul:1,add:0));
	Out.kr(~controlBus_x2.index, SinOsc.kr(0.01,0.degrad,mul:1,add:0));
	Out.kr(~controlBus_y2.index, SinOsc.kr(0.01,90.degrad,mul:1,add:0));
	Out.kr(~controlBus_z2.index, SinOsc.kr(0.01,45.degrad,mul:1,add:0));
	Out.kr(~controlBus_x3.index, SinOsc.kr(0.01,0.degrad,mul:1,add:0));
	Out.kr(~controlBus_y3.index, SinOsc.kr(0.01,90.degrad,mul:1,add:0));
	Out.kr(~controlBus_z3.index, SinOsc.kr(0.01,45.degrad,mul:1,add:0));

//Out.ar(0,sig*1);
//Out.ar(1,sig*1);

}).add;
)

/////////////array
(
{
	var az=0,el1=0,sph,n=90,iter=45,rep=360,el,silver=(1+2.sqrt),w=((1+5.sqrt)/2);
	~az=[];~el=[];

rep.do{
el=iter.collect{
		el1 = 90/n;
			n=n-2;
sph=Spherical(1,az.degrad,el1.degrad).phi.round(0.000000000001);
	};
~az=~az++az.degrad;~el=~el++el;
//az = (az+1).wrap(0,360);
		az=(az+(360-(360/silver))).wrap(0,360);
el1=0;n=90;
	};
}.value;
)

//Server.freeAll

//animation

(
var data,data1,data2,data3,data4,data5,run = true;
var az=0,el=0,pl=0,pl1=0,plb=0,plc=0,pld=0,ple=0,plf=0;
var el1=0,el2=0,el3=0,el4=0,el5=0,sph2a,sph3a,sph4a,sph5a;
var iter=50,rep=3,mag=1000,step=0.1;
var sph,sph1,sph2,sph3,sph4,sph5;
var y=1,x=1,y1=1,x1=1,y2=1,x2=1,y3=1,x3=1,y4=1,x4=1,y5=1,x5=1;
var silver=(1+2.sqrt),w=((1+5.sqrt)/2);
var ot=0.degrad;
var angle=(45).degrad,rotor1,rotor2,rotor3,rotor4,rotation1,rotation2,rotation3,rotation4;
var q1,q2,q3,q4,sph2q,sph3q,sph4q,sph5q;
var xyz1=[1,0,0].normalizeSum.sqrt,xyz2=[0,1,0].normalizeSum.sqrt,axis1,axis2;
var i=Quaternion(0, xyz1.[0], 0, 0),j=Quaternion(0, 0, xyz1.[1], 0),k=Quaternion(0, 0, 0, xyz1.[2]);
var i1=Quaternion(0, xyz2.[0], 0, 0),j1=Quaternion(0, 0, xyz2.[1], 0),k1=Quaternion(0, 0, 0, xyz2.[2]);
var sph6Da,sphcart6Da,q6Da,rotor6Da,sph6Daq,rotation6Da;
var sph6Db,sphcart6Db,q6Db,rotor6Db,sph6Dbq,rotation6Db;
var sph6Dc,sphcart6Dc,q6Dc,rotor6Dc,sph6Dcq,rotation6Dc;
var sph6Dd,sphcart6Dd,q6Dd,rotor6Dd,sph6Ddq,rotation6Dd;
var sph6De,sphcart6De,q6De,rotor6De,sph6Deq,rotation6De;
var sph6Df,sphcart6Df,q6Df,rotor6Df,sph6Dfq,rotation6Df;
var axisa,axisb,axisc,angle1=(0).degrad,angle2=(0).degrad,angle3=(0).degrad;
var xyza,xyzb,xyzc;
var ia,ja,ka,ib,jb,kb,ic,jc,kc;
var xa=1,ya=1,za=1,xb=1,yb=1,zb=1,xc=1,yc=1,zc=1;

Synth.new(\player);
~data = [];

axis1=i+j+k;
axis2=i1+j1+k1;


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
		ot=ot+0.01.degrad;

};

{ while { run } {~v.background_(Color.black); ~v.refresh; (1/100).wait } }.fork(AppClock);

  r= Routine({loop{
		pl1=0;
	~data=[];

	angle1=~controlBus_a1.getSynchronous;
	angle2=~controlBus_a2.getSynchronous;
	angle3=~controlBus_a3.getSynchronous;
	xa=~controlBus_x1.getSynchronous;
	ya=~controlBus_y1.getSynchronous;
	za=~controlBus_z1.getSynchronous;
	xb=~controlBus_x2.getSynchronous;
	yb=~controlBus_y2.getSynchronous;
	zb=~controlBus_z2.getSynchronous;
	xc=~controlBus_x3.getSynchronous;
	yc=~controlBus_y3.getSynchronous;
	zc=~controlBus_z3.getSynchronous;

xyza=[xa,ya,za].normalizeSum.sqrt;
xyzb=[xb,yb,zb].normalizeSum.sqrt;
xyzc=[xc,yc,zc].normalizeSum.sqrt;

ia=Quaternion(0, xyza.[0], 0, 0);
ja=Quaternion(0, 0, xyza.[1], 0);
ka=Quaternion(0, 0, 0, xyza.[2]);
ib=Quaternion(0, xyzb.[0], 0, 0);
jb=Quaternion(0, 0, xyzb.[1], 0);
kb=Quaternion(0, 0, 0, xyzb.[2]);
ic=Quaternion(0, xyzc.[0], 0, 0);
jc=Quaternion(0, 0, xyzc.[1], 0);
kc=Quaternion(0, 0, 0, xyzc.[2]);

axisa=ia+ja+ka;
axisb=ib+jb+kb;
axisc=ic+jc+kc;


	{ iter.do{
data=rep.collect{
	el=~el.[pl];
	y=1/x;
	x=x+step;
	pl=pl+1;

sph6Da=Spherical(mag,az,el);
sphcart6Da=Cartesian(sph6Da.x*y,sph6Da.y*y,sph6Da.z);

q6Da=Quaternion(0,sphcart6Da.x.round(0.00001),sphcart6Da.y.round(0.00001),sphcart6Da.z.round(0.00001));
rotor6Da=((axisa*exp(Complex(0,1)*angle1).imag)+exp(Complex(0,1)*angle1).real);
rotation6Da=rotor6Da*q6Da*rotor6Da.conjugate;

sph6Daq= Cartesian(rotation6Da.b,rotation6Da.c,rotation6Da.d);
sphcart6Da=Cartesian(sph6Daq.x,sph6Daq.y,sph6Daq.z).asArray;
};

data1=rep.collect{
	el1=~el.[plb];
	y1=1/x1;
	x1=x1+step;
	plb=plb+1;

sph6Db=Spherical(mag,az,el1.neg);
sphcart6Db=Cartesian(sph6Db.x*y1,sph6Db.y*y1,sph6Db.z);

q6Db=Quaternion(0,sphcart6Db.x.round(0.00001),sphcart6Db.y.round(0.00001),sphcart6Db.z.round(0.00001));
rotor6Db=((axisa*exp(Complex(0,1)*angle1).imag)+exp(Complex(0,1)*angle1).real);
rotation6Db=rotor6Db*q6Db*rotor6Db.conjugate;

sph6Dbq=Cartesian(rotation6Db.b,rotation6Db.c,rotation6Db.d);
sphcart6Db=Cartesian(sph6Dbq.x,sph6Dbq.y,sph6Dbq.z).asArray;
};

data2=rep.collect{
	el2=~el.[plc];
	y2=1/x2;
	x2=x2+step;
	plc=plc+1;

sph2=Spherical(mag,az,el2);
sph2a=Cartesian(sph2.x*y2,sph2.y*y2,sph2.z);

q1=Quaternion(0,sph2a.x.round(0.00001),sph2a.y.round(0.00001),sph2a.z.round(0.00001));
rotor1=((axis1*exp(Complex(0,1)*angle).imag)+exp(Complex(0,1)*angle).real);
rotation1=rotor1*q1*rotor1.conjugate;

sph2q= Cartesian(rotation1.b,rotation1.c,rotation1.d);

q6Dc=Quaternion(0,sph2q.x.round(0.00001),sph2q.y.round(0.00001),sph2q.z.round(0.00001));
rotor6Dc=((axisb*exp(Complex(0,1)*angle2).imag)+exp(Complex(0,1)*angle2).real);
rotation6Dc=rotor6Dc*q6Dc*rotor6Dc.conjugate;

sph6Dcq=Cartesian(rotation6Dc.b,rotation6Dc.c,rotation6Dc.d);
sphcart6Dc=Cartesian(sph6Dcq.x,sph6Dcq.y,sph6Dcq.z).asArray;
};

data3=rep.collect{
	el3=~el.[pld];
	y3=1/x3;
	x3=x3+step;
	pld=pld+1;

sph3=Spherical(mag,az,el3.neg);
sph3a=Cartesian(sph3.x*y3,sph3.y*y3,sph3.z);

q2=Quaternion(0,sph3a.x.round(0.00001),sph3a.y.round(0.00001),sph3a.z.round(0.00001));
rotor2=((axis1*exp(Complex(0,1)*angle).imag)+exp(Complex(0,1)*angle).real);
rotation2=rotor2*q2*rotor2.conjugate;

sph3q= Cartesian(rotation2.b,rotation2.c,rotation2.d);

q6Dd=Quaternion(0,sph3q.x.round(0.00001),sph3q.y.round(0.00001),sph3q.z.round(0.00001));
rotor6Dd=((axisb*exp(Complex(0,1)*angle2).imag)+exp(Complex(0,1)*angle2).real);
rotation6Dd=rotor6Dd*q6Dd*rotor6Dd.conjugate;

sph6Ddq=Cartesian(rotation6Dd.b,rotation6Dd.c,rotation6Dd.d);
sphcart6Dd=Cartesian(sph6Ddq.x,sph6Ddq.y,sph6Ddq.z).asArray;
};

data4=rep.collect{
	el4=~el.[ple];
	y4=1/x4;
	x4=x4+step;
	ple=ple+1;

sph4=Spherical(mag,az,el4);
sph4a=Cartesian(sph4.x*y4,sph4.y*y4,sph4.z);


q3=Quaternion(0,sph4a.x.round(0.00001),sph4a.y.round(0.00001),sph4a.z.round(0.00001));
rotor3=((axis2*exp(Complex(0,1)*angle).imag)+exp(Complex(0,1)*angle).real);
rotation3=rotor3*q3*rotor3.conjugate;

sph4q= Cartesian(rotation3.b,rotation3.c,rotation3.d);

q6De=Quaternion(0,sph4q.x.round(0.00001),sph4q.y.round(0.00001),sph4q.z.round(0.00001));
rotor6De=((axisc*exp(Complex(0,1)*angle3).imag)+exp(Complex(0,1)*angle3).real);
rotation6De=rotor6De*q6De*rotor6De.conjugate;

sph6Deq=Cartesian(rotation6De.b,rotation6De.c,rotation6De.d);
sphcart6De=Cartesian(sph6Deq.x,sph6Deq.y,sph6Deq.z).asArray;
};

data5=rep.collect{
	el5=~el.[plf];
	y5=1/x5;
	x5=x5+step;
	plf=plf+1;

sph5=Spherical(mag,az,el5.neg);
sph5a=Cartesian(sph5.x*y5,sph5.y*y5,sph5.z);

q4=Quaternion(0,sph5a.x.round(0.00001),sph5a.y.round(0.00001),sph5a.z.round(0.00001));
rotor4=((axis2*exp(Complex(0,1)*angle).imag)+exp(Complex(0,1)*angle).real);
rotation4=rotor4*q4*rotor4.conjugate;

sph5q= Cartesian(rotation4.b,rotation4.c,rotation4.d);

q6Df=Quaternion(0,sph5q.x.round(0.00001),sph5q.y.round(0.00001),sph5q.z.round(0.00001));
rotor6Df=((axisc*exp(Complex(0,1)*angle3).imag)+exp(Complex(0,1)*angle3).real);
rotation6Df=rotor6Df*q6Df*rotor6Df.conjugate;

sph6Dfq=Cartesian(rotation6Df.b,rotation6Df.c,rotation6Df.d);
sphcart6Df=Cartesian(sph6Dfq.x,sph6Dfq.y,sph6Dfq.z).asArray;
};
	az=~az.[pl1];
	pl1=pl1+1;
	y=1;x=1;pl=0;
	plb=0;y1=1;x1=1;
	plc=0;y2=1;x2=1;
	pld=0;y3=1;x3=1;
	ple=0;y4=1;x4=1;
	plf=0;y5=1;x5=1;

	~data=~data++data++data1++data2++data3++data4++data5;
		}
}.value;

 	b.data = ~data;            // Update ScatterView3d
0.1.wait
};

});
r.play;
);

