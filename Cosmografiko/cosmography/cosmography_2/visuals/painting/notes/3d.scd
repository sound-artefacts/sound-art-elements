
////////////////////////////////////////////painter
(
{
var  sph1,sph2,sph3,sph4,sph5,sph6,sph7,m_x=9,m_y=9,m_z=9,qx,qy,mq=m_x-1;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z,mag_qx,mag_qy;
var az4=0,el4=0,az5=0,el5=0,az6=0,el6=0,az7=0,el7=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez,angle=0,n=12;
var sphx,sphy,sphz,azx,elx,azy,ely,azz,elz,plx=1,ply=1,plz=1;
var ellipsis=[1,1,1],spread=1,silver_r=(1+2.sqrt);
var mag1=1,mag2=1,mag3=1,mag4=1,mag5=1,mag6=1,mag7=1;
	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];

//	spread = if(m_z < 1) { 1 / m_z } { m_z };

	16.do{
azimuth=32.collect{
			az1 = (az1+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
		   el1 = (el1+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

//	mag1=(mag1+(1-(1/1.6180339887499))).wrap(0,1);
sph1=(Spherical(mag1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)))).theta.round(0.000000000001);

	};

elevation=32.collect{
				az2 = (az2+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el2 = (el2+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

	//mag2=(mag2+(1-(1/1.6180339887499))).wrap(0,1);
		sph2=(Spherical(mag2,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)))).phi.round(0.000000000001);

	};

magnitudex=	32.collect{
			az3 = (az3+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el3 = (el3+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

	//mag3=(mag3+(1-(1/1.6180339887499))).wrap(0,1);
	sph3=(Spherical(mag3,(az3+angle).wrap(pi.neg,pi),(el3+angle).wrap((pi/2).neg,(pi/2))));

	 mag_x=((Complex(cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

				};

magnitudey=	32.collect{
			az4 = (az4+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
				el4 = (el4+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

	//mag4=(mag4+(1-(1/1.6180339887499))).wrap(0,1);
	sph4=(Spherical(mag4,(az4+angle).wrap(pi.neg,pi),(el4+angle).wrap((pi/2).neg,(pi/2))));

		 mag_y=((Complex(sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi)),sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
		 (Complex(cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
				};


qx=	32.collect{
			az5 = (az5+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el5 = (el5+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

		//mag5=(mag5+(1-(1/1.6180339887499))).wrap(0,1);
	sph5=(Spherical(mag5,(az5+angle).wrap(pi.neg,pi),(el5+angle).wrap((pi/2).neg,(pi/2))));


mag_qx=((((Complex(cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),
cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),
cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


qy=	32.collect{
			az6 = (az6+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el6 = (el6+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

	//mag6=(mag6+(1-(1/1.6180339887499))).wrap(0,1);
	sph6=(Spherical(mag6,(az6+angle).wrap(pi.neg,pi),(el6+angle).wrap((pi/2).neg,(pi/2))));

 mag_qy=((((Complex(sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),
sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),
cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


magnitudez=	32.collect{
			az7 = (az7+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el7 = (el7+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

//mag7=(mag7+(1-(1/1.6180339887499))).wrap(0,1);
sph7=(Spherical(mag7,(az7+angle).wrap(pi.neg,pi),(el7+angle).wrap((pi/2).neg,(pi/2))));

//if(
//m_z.even,
mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread)
			//,
//mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho(2.sqrt)).pow(spread);
			//);
////z axis   ambi..  sin for odd numbers, cos for even
				};

angle=(angle+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
~az=~az++azimuth;~el=~el++elevation;
~magx=~magx++magnitudex;~magy=~magy++magnitudey;~magz=~magz++magnitudez;
~qx=~qx++qx;~qy=~qy++qy;
		az1=0;el1=0;az2=0;el2=0;az3=0;el3=0;
		az4=0;el4=0;az5=0;el5=0;az6=0;el6=0;az7=0;el7=0;
	}
}.value;
)
(
var win,wx=0,wy=0,g=((1+5.sqrt)/2),s=(1+2.sqrt),rval=0,rvalc=0;
var size=1000,px=4,run=true,angle1=0,angle2=0;
var az,el,polytope,mag,xp=0,yp=0,dimx,dimy,c,n;
var bright,brightx,brighty,bval,pos,c1,c2,c3;
var valx=0,valy,limit=100,rval1=0,rval2=0;
var sph,az1,el1,plot,data;
var  ot=0,sizee=400,pl=0;

~amp1 = 0;
~amp2 = 0;
~amp3 = 0;
//~amp4= 0;
//~amp5 = 0;
//~amp6= 0;
//~amp7= 0;
Window.closeAll;
win = Window("RGB Audio", Rect(100, 10, size,size));
~view = UserView(win, Rect(0,0,size,size)).background_(Color.black);

SynthDef(\painting, {
arg lg=0.001,level=2;
var amp1 = A2K.kr(InFeedback.ar(9)*level).lag(lg);
var amp2 = A2K.kr(InFeedback.ar(10)*level).lag(lg);
var amp3 = A2K.kr(InFeedback.ar(11)*level).lag(lg);
//	var amp4 = A2K.kr(InFeedback.ar(0)*level).lag(lg);
//	var amp5 = A2K.kr(InFeedback.ar(1)*level).lag(lg);
//	var amp6 = (InFeedback.ar(7)*gain2).lag(lag);
//	var amp7 = (InFeedback.ar(8).abs*gain2).lag(lag);

SendReply.ar(Impulse.ar(60), '/amp1', amp1);
SendReply.ar(Impulse.ar(60), '/amp2', amp2);
SendReply.ar(Impulse.ar(60), '/amp3', amp3);
//SendReply.ar(Impulse.ar(60), '/amp4', amp4);
//SendReply.ar(Impulse.ar(60), '/amp5', amp5);
//	SendReply.ar(Impulse.ar(60), '/amp6', amp6);
//	SendReply.ar(Impulse.ar(60), '/amp7', amp7);
}).add;


OSCdef(\ampt1, { |msg|
~amp1 = msg[3];
//defer { ~view.refresh };
}, '/amp1');

OSCdef(\ampt2, { |msg|
~amp2 = msg[3];
//defer { ~view.refresh };
}, '/amp2');

OSCdef(\ampt3, { |msg|
~amp3 = msg[3];
//defer { ~view.refresh };
}, '/amp3');

// OSCdef(\ampt4, { |msg|
// 	~amp4 = msg[3];
// 	//	defer { ~view.refresh };
// }, '/amp4');
//
// OSCdef(\ampt5, { |msg|
// 	~amp5 = msg[3];
// 	//	defer { ~view.refresh };
// }, '/amp5');

/*OSCdef(\ampt6, { |msg|
	~amp6 = msg[3];
	defer { ~v1.refresh };
}, '/amp6');

OSCdef(\ampt7, { |msg|
	~amp7 = msg[3];
	defer { ~v1.refresh };
}, '/amp7');*/
//~view.animate=true;
~data=[];
data = (32*16).collect{

	az=~az.[pl];
	el=~el.[pl];
	pl=pl+1;
		sph=Spherical(sizee,az,el).asCartesian.asArray;
};
	~data=~data++data;
(
~view.drawFunc = {
Pen.translate(size/2,size/2);
polytope=	Cartesian(~amp1,~amp2,~amp3).asSpherical;
az=polytope.theta;
el=polytope.phi;
mag=polytope.rho;

c1 =Spherical(1,az,el).x;
c2 =Spherical(1,az,el).y;
c3 =Spherical(1,az,el).z;

bright=Complex(az.linlin(pi.neg,pi,0,2.sqrt.reciprocal),el.linlin(0.5pi.neg,05pi,0,2.sqrt.reciprocal)).theta;

sph=Spherical(sizee,az,el).asCartesian.asArray;
plot = ScatterView3d(~view, Rect(0,0, size,size), ~data,
[-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
plot .drawMethod = \fillRect;
plot .symbolSize = px;
plot .symbolColor = Color.new((c1+0).wrap(0,1),(c2+0).wrap(0,1),(c3+0).wrap(0,1),1);
plot .background =Color.black;
plot.rot(ot,ot,ot);
ot=ot+bright;
};
{ while { run } {~view.background_(Color.black); ~view.refresh; (1/60).wait } }.fork(AppClock);
win.front;
);
(
~synth=Synth.new(\synth,[\gain,10,\drive,0,\c,0,\az,pi.rand,\el,0,\size,0,\harmonic,1,\fl,7.5,
				\bg1,0.001,\bg2,0.001,\bg3,0.001,\bg4,0.001,\bg5,0.001,\bg6,0.001,\bg7,0.001,\bg8,0.001,\bg9,0.001,
				\lowend,64,\level,600,\dyn,1,\comp,1,\buffer,1,\tone_axis,1,\ran,16256,\rect_level,2,
\sphharm,16*16256.neg,\speaker_size,0.15,\room,0.5,\mix,0.3,\pan_mod,16*16256.neg,\spread,1,\limit,0.8,\fu,64,\band,10]).register);
~synthp = Synth(\painting).register;
)


~synthp.set(\lg,1)
~synthp.free

//thisThread.randSeed = rval;

