

(
var data;
var az=0,el=0;
var m=600,sph,az1,el1,pl=0,daz,del,harm,mag,r;
var r1,harm1,r2,harm2,rad;
var run = true;
var ot=0.degrad;

data = (12).collect{

	az=~az.[pl];
	el=~el.[pl];
	mag=1.5;
	// mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
	pl=pl+1;
		sph=Spherical(mag*600,az,el).asCartesian.asArray;



};

w = Window.new("3D Scatterplot", Rect(40,40, 800, 800)).front;

~v = UserView.new(w,Rect(0,0,800,800)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 800,800), data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 1;
a.symbolColor = Color.white;
a.background = Color.black;

~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

		a.rot(ot,ot,ot);
    ~v.refresh;

		ot=ot+0.1.degrad;

};
{ while { run } {~v.background_(Color.black); ~v.refresh; (1/1000).wait } }.fork(AppClock);
)


(
var data;
var az=0,el=0,az_rot;
var m=600,sph,az1,el1,pl=0,daz,del,harm,mag,r=1.neg;
var r1,harm1,r2,harm2,rad,call;


data=(12).collect{

	az=~az.[pl];
	el=~el.[pl];
	//mag=~magz.[pl];
	mag=2;
//(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+
//	(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
		//Cartesian(~magx.[pl],~magy.[pl],0).rho;
	//	Cartesian(~qx.[pl],~qy.[pl],0).rho;
	pl=pl+1;
		sph=Spherical(mag*400,az,el).asCartesian.asArray;



};
data.postln;

w = Window.new("3D Scatterplot", Rect(40,40, 1000, 800)).front;
a = ScatterView3d(w, Rect(0,0, 800,800), data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
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
//Cartesian(ellipsis.normalizeSum.sqrt.[0],ellipsis.normalizeSum.sqrt.[1],ellipsis.normalizeSum.sqrt.[2])
(
{
var  sph1,sph2,sph3,sph4,sph5,sph6,sph7,m_x=3,m_y=3,m_z=3,qx,qy,mq=2;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z,mag_qx,mag_qy;
var az4=0,el4=0,az5=0,el5=0,az6=0,el6=0,az7=0,el7=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez;
var durx,dury,durz,angle=0;
var sphx,sphy,sphz,azx=0,elx=0,azy=0,ely=0,azz=0,elz=0;
var num=1.neg;
var ellipsis=[1,1,1];
var spread=1;
	~dur=[];~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];

	1.do{
16.do{
	durx=	32.collect{	azx = (azx+(360-(360/1.6180339887499))).wrap(180.neg,180);
			sphx=(Spherical(1,(azx.degrad),(elx.degrad))).x.round(0.000000001).abs;};
		elx = (elx+(180-(180/1.6180339887499))).wrap(90.neg,90);


	dury=	32.collect{	azy = (azy+(360-(360/1.6180339887499))).wrap(180.neg,180);

		sphy=(Spherical(1,(azy.degrad),(ely.degrad))).y.round(0.000000001).abs;
			};
	ely = (ely+(180-(180/1.6180339887499))).wrap(90.neg,90);

	durz=		360.collect{	azz = (azz+(360-(360/1.6180339887499))).wrap(180.neg,180);

		sphz=(Spherical(1,(azz.degrad),(elz.degrad))/Cartesian(ellipsis.normalizeSum.sqrt.[0],ellipsis.normalizeSum.sqrt.[1],ellipsis.normalizeSum.sqrt.[2])).z.round(0.000000001).abs;
			};
elz = (elz+(180-(180/1.6180339887499))).wrap(90.neg,90);


	azimuth=	32.collect{		az1 = (az1+(360-(360/1.6180339887499))).wrap(180.neg,180);

		sph1=(Spherical(1,(az1.degrad),(el1.degrad))).theta.round(0.00001);
			};
			el1 = (el1+(180-(180/1.6180339887499))).wrap(90.neg,90);


elevation=		32.collect{		az2 = (az2+(360-(360/1.6180339887499))).wrap(180.neg,180);

		sph2=(Spherical(1,(az2.degrad),(el2.degrad))).phi.round(0.00001);
	};
								el2 = (el2+(180-(180/1.6180339887499))).wrap(90.neg,90);


	magnitudex=	32.collect{		az3 = (az3+(360-(360/1.6180339887499))).wrap(180.neg,180);

	sph3=(Spherical(1,(az3.degrad),(el3.degrad)));

	 mag_x=((Complex(cos((sph3.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

				};		el3 = (el3+ (180-(180/1.6180339887499))).wrap(90.neg,90);


	magnitudey=	32.collect{		az4 = (az4+(360-(360/1.6180339887499))).wrap(180.neg,180);

	sph4=(Spherical(1,(az4.degrad),(el4.degrad)));

		 mag_y=((Complex(sin((sph4.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sph4.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
		 (Complex(cos((sph4.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
				};
				el4 = (el4+(180-(180/1.6180339887499))).wrap(90.neg,90);


	qx=	32.collect{		az5 = (az5+(360-(360/1.6180339887499))).wrap(180.neg,180);

	sph5=(Spherical(1,(az5.degrad),(el5.degrad)));


mag_qx=((((Complex(cos(((sph5.theta.round(0.00001))*mq).wrap(pi.neg,pi)),
cos(((sph5.theta.round(0.00001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph5.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph5.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph5.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((sph5.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};			el5 = (el5+(360-(360/1.6180339887499))).wrap(90.neg,90);


		qy=	32.collect{		az6 = (az6+(360-(360/1.6180339887499))).wrap(180.neg,180);

	sph6=(Spherical(1,(az6.degrad),(el6.degrad)));

 mag_qy=((((Complex(sin(((sph6.theta.round(0.00001))*mq).wrap(pi.neg,pi)),
sin(((sph6.theta.round(0.00001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph6.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph6.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph6.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((sph6.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};							el6 = (el6+(180-(180/1.6180339887499))).wrap(90.neg,90);


	magnitudez=	32.collect{		az7 = (az7+(360-(360/1.6180339887499))).wrap(180.neg,180);

sph7=(Spherical(1,(az7.degrad),(el7.degrad)));

if(
m_z.even,
mag_z=(Complex(cos((sph7.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sph7.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread),
mag_z=(Complex(sin((sph7.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread)
	);
////z axis   ambi..  sin for odd numbers, cos for even
				};		el7 = (el7+(180-(180/1.6180339887499))).wrap(90.neg,90);

		~az=~az++azimuth;~el=~el++elevation;~magx=~magx++magnitudex;~magy=~magy++magnitudey;~magz=~magz++magnitudez;
		~qx=~qx++qx;~qy=~qy++qy;
				12.do{ num=num+1; ~dur=~dur++durx.[num]++dury.[num]++durz.[num];};num=1.neg;

	};angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);};

}.value;

)


/////////


(
{
var  sph1,sph2,sph3,sph4,sph5,sph6,sph7,m_x=2,m_y=2,m_z=2,qx,qy,mq=1;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z,mag_qx,mag_qy;
var az4=0,el4=0,az5=0,el5=0,az6=0,el6=0,az7=0,el7=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez;
var durx,dury,durz,angle=0;
var sphx,sphy,sphz,azx,elx,azy,ely,azz,elz,plx=1,ply=1,plz=1;
var num=1.neg;
var ellipsis=[1,1,1],spread=1;
			~dur=[];~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];

	(2.pow(7)).do{
azimuth=32.collect{

			az1 = (az1+(360-(360/1.6180339887499))).wrap(180.neg,180);  // Increment azimuth
				el1 = (el1+(180-(180/1.6180339887499))).wrap(90.neg,90);

sph1=(Spherical(1,(az1.degrad+angle.degrad).wrap(pi.neg,pi),(el1.degrad+angle.degrad).wrap((pi/2).neg,(pi/2)))).theta.round(0.00001);

	};

elevation=(32).collect{

				az2 = (az2+(360-(360/1.6180339887499))).wrap(180.neg,180);  // Increment azimuth
			el2 = (el2+(180-(180/1.6180339887499))).wrap(90.neg,90);

		sph2=(Spherical(1,(az2.degrad+angle.degrad).wrap(pi.neg,pi),(el2.degrad+angle.degrad).wrap((pi/2).neg,(pi/2)))).phi.round(0.00001);

	};

			magnitudex=	32.collect{
			az3 = (az3+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el3 = (el3+ (180-(180/1.6180339887499))).wrap(90.neg,90);

	sph3=(Spherical(1,(az3.degrad+angle.degrad).wrap(pi.neg,pi),(el3.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

	 mag_x=((Complex(cos((sph3.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

				};


	magnitudey=	32.collect{		az4 = (az4+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el4 = (el4+(180-(180/1.6180339887499))).wrap(90.neg,90);

	sph4=(Spherical(1,(az4.degrad+angle.degrad).wrap(pi.neg,pi),(el4.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

		 mag_y=((Complex(sin((sph4.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sph4.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
		 (Complex(cos((sph4.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
				};


	qx=	32.collect{		az5 = (az5+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el5 = (el5+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph5=(Spherical(1,(az5.degrad+angle.degrad).wrap(pi.neg,pi),(el5.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));


mag_qx=((((Complex(cos(((sph5.theta.round(0.00001))*mq).wrap(pi.neg,pi)),
cos(((sph5.theta.round(0.00001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph5.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph5.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph5.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((sph5.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


		qy=	32.collect{		az6 = (az6+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el6 = (el6+(180-(180/1.6180339887499))).wrap(90.neg,90);

	sph6=(Spherical(1,(az6.degrad+angle.degrad).wrap(pi.neg,pi),(el6.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

 mag_qy=((((Complex(sin(((sph6.theta.round(0.00001))*mq).wrap(pi.neg,pi)),
sin(((sph6.theta.round(0.00001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph6.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph6.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph6.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((sph6.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


	magnitudez=	32.collect{		az7 = (az7+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el7 = (el7+(180-(180/1.6180339887499))).wrap(90.neg,90);

sph7=(Spherical(1,(az7.degrad+angle.degrad).wrap(pi.neg,pi),(el7.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

if(
m_z.even,
mag_z=(Complex(cos((sph7.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sph7.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread),
mag_z=(Complex(sin((sph7.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread)
	);
////z axis   ambi..  sin for odd numbers, cos for even
				};

angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
~az=~az++azimuth;~el=~el++elevation;
~magx=~magx++magnitudex;~magy=~magy++magnitudey;~magz=~magz++magnitudez;
~qx=~qx++qx;~qy=~qy++qy;
		az1=0;el1=0;az2=0;el2=0;az3=0;el3=0;
		az4=0;el4=0;az5=0;el5=0;az6=0;el6=0;az7=0;el7=0;
	}
}.value;
)


/////

(
var data;
var az=0,el=0,az_rot;
var m=600,sph,az1,el1,pl=0,daz,del,harm,mag,r=1.neg;
var r1,harm1,r2,harm2,rad,call,mk=50;

~data=[];

4.do{

data = (32*128).collect{

	az=~az.[pl];
	el=~el.[pl];
	//mag=mk;
	 mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
	pl=pl+1;
		sph=Spherical(mag*mk,az,el).asCartesian.asArray;
};
	pl=0;mk=mk*2; ~data=~data++data;
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
var m=600,sph,az1,el1,pl=0,daz,del,harm,mag,r;
var r1,harm1,r2,harm2,rad;
var run = true;
var ot=0.degrad,mk=0.2;
~data=[];

4.do{

data = (32*128).collect{

	az=~az.[pl];
	el=~el.[pl];
	mag=mk;
	// mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
	pl=pl+1;
		sph=Spherical(mag*600,az,el).asCartesian.asArray;
};
	pl=0;mk=mk*2; ~data=~data++data;
};

w = Window.new("3D Scatterplot", Rect(40,40, 800, 800)).front;

~v = UserView.new(w,Rect(0,0,800,800)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 800,800), ~data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 1;
a.symbolColor = Color.white;
a.background = Color.black;

~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

		a.rot(ot,ot,ot);
    ~v.refresh;

		ot=ot+0.8.degrad;

};
{ while { run } {~v.background_(Color.black); ~v.refresh; (1/1000).wait } }.fork(AppClock);
)
