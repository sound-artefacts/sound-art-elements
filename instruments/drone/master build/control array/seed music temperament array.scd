(
var data;
var az=0,el=0,az_rot;
var m=600,sph,az1,el1,pl=0,daz,del,harm,mag,r=1.neg;
var r1,harm1,r2,harm2,rad,call,mk=50;

~data=[];

1.do{

data = (1temp*32).collect{

	az=~az.[pl];
	el=~el.[pl];
	//mag=1000;
	// mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
			//	 mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt));
		 mag=~magz.[pl];
	pl=pl+1;
			mk=(mk+(1200-(1200/silver_r))).wrap(0,1200);
		sph=Spherical(mag*mk/1.2,az,el).asCartesian.asArray;
};
	//pl=0;
	//mk=(mk+(1200-(1200/silver_r))).wrap(0,1200);
	~data=~data++data;
};
// data=(1temp*32).collect{
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
var run = true,n=12;
var ot=0.degrad,mk=0,size=1000,mt=12,temp=56;
~data=[];

1.do{

data = (temp*temp).collect{

	az=~az.[pl];
	el=~el.[pl];
	//mag=1000;
	// mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
	//mag=(Cartesian(~magx.[pl],0,0).rho/(2.sqrt));
		//mag=(Cartesian(~qx.[pl],0,0).rho/(2.sqrt));
			 mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt));
		// mag=~magz.[pl];
	pl=pl+1;
			//mk=(mk+((size*2.pow(n/12))-((size*2.pow(n/12))/silver_r))).wrap(0,size*2.pow(n/12));
		mk=(mk+250).wrap(1,1000);
		sph=Spherical(mag*size,az,el).asCartesian.asArray;
};
	//pl=0;
	//mk=(mk+(1200-(1200/silver_r))).wrap(0,1200);
	~data=~data++data;
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

		ot=ot+1.degrad;

};
{ while { run } {~v.background_(Color.black); ~v.refresh; (1/1000).wait } }.fork(AppClock);
)


/////////////


(
{
var  sph1,sph2,sph3,sph4,sph5,sph6,sph7,m_x=1,m_y=1,m_z=1,qx,qy,mq=m_x-1;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z,mag_qx,mag_qy;
var az4=0,el4=0,az5=0,el5=0,az6=0,el6=0,az7=0,el7=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez,angle=0;
var sphx,sphy,sphz,azx,elx,azy,ely,azz,elz,plx=1,ply=1,plz=1;
var gold_r=((1+5.sqrt)/2),silver_r=(1+2.sqrt);
var ellipsis=[1,1,1],spread=1;
var n1=1.neg,n2=1.neg,n3=1.neg,n4=1.neg,n5=1.neg,n6=1.neg,n7=1.neg,n=0;
var mag1=1,mag2=1,mag3=1,mag4=1,mag5=1,mag6=1,mag7=1,mt=57,temp=56;
	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];

//	spread = if(m_z < 1) { 1 / m_z } { m_z };

	temp.do{
azimuth=temp.collect{
			n1=n1+1;
			az1 =(2.pow(n1/mt).linlin(1,2,pi.neg,pi));
				el1 = (2.pow(n1/mt).linlin(1,2,(pi/2).neg,(pi/2)));

//	mag1=(mag1+(1-(1/silver_r))).wrap(0,1);
sph1=(Spherical(mag1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)))).theta.round(0.000000000001);

	};

elevation=temp.collect{
				n2=n2+1;
				az2 = (2.pow(n2/mt).linlin(1,2,pi.neg,pi));
			el2 = (2.pow(n2/mt).linlin(1,2,(pi/2).neg,(pi/2)));

	//mag2=(mag2+(1-(1/silver_r))).wrap(0,1);
		sph2=(Spherical(mag2,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)))).phi.round(0.000000000001);

	};

magnitudex=	temp.collect{
					n3=n3+1;
			az3 = (2.pow(n3/mt).linlin(1,2,pi.neg,pi));
			el3 = (2.pow(n3/mt).linlin(1,2,(pi/2).neg,(pi/2)));

	//mag3=(mag3+(1-(1/silver_r))).wrap(0,1);
	sph3=(Spherical(mag3,(az3+angle).wrap(pi.neg,pi),(el3+angle).wrap((pi/2).neg,(pi/2))));

	 mag_x=((Complex(cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

				};

magnitudey=	temp.collect{
						n4=n4+1;
			az4 = (2.pow(n4/mt).linlin(1,2,pi.neg,pi));
				el4 = (2.pow(n4/mt).linlin(1,2,(pi/2).neg,(pi/2)));

	//mag4=(mag4+(1-(1/silver_r))).wrap(0,1);
	sph4=(Spherical(mag4,(az4+angle).wrap(pi.neg,pi),(el4+angle).wrap((pi/2).neg,(pi/2))));

		 mag_y=((Complex(sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi)),sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
		 (Complex(cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
				};


qx=	temp.collect{
							n5=n5+1;
			az5 = (2.pow(n5/mt).linlin(1,2,pi.neg,pi));
			el5 = (2.pow(n5/mt).linlin(1,2,(pi/2).neg,(pi/2)));

		//mag5=(mag5+(1-(1/silver_r))).wrap(0,1);
	sph5=(Spherical(mag5,(az5+angle).wrap(pi.neg,pi),(el5+angle).wrap((pi/2).neg,(pi/2))));


mag_qx=((((Complex(cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),
cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),
cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


qy=	temp.collect{
								n6=n6+1;
			az6 = (2.pow(n6/mt).linlin(1,2,pi.neg,pi));
			el6 = (2.pow(n6/mt).linlin(1,2,(pi/2).neg,(pi/2)));

	//mag6=(mag6+(1-(1/silver_r))).wrap(0,1);
	sph6=(Spherical(mag6,(az6+angle).wrap(pi.neg,pi),(el6+angle).wrap((pi/2).neg,(pi/2))));

 mag_qy=((((Complex(sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),
sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),
cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


magnitudez=	temp.collect{
										n7=n7+1;
			az7 = (2.pow(n7/mt).linlin(1,2,pi.neg,pi));
			el7 = (2.pow(n7/mt).linlin(1,2,(pi/2).neg,(pi/2)));

//mag7=(mag7+(1-(1/silver_r))).wrap(0,1);
sph7=(Spherical(mag7,(az7+angle).wrap(pi.neg,pi),(el7+angle).wrap((pi/2).neg,(pi/2))));

//if(
//m_z.even,
mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread)
			//,
//mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho(2.sqrt)).pow(spread);
			//);
////z axis   ambi..  sin for odd numbers, cos for even
				};
		n=n+1;
		//angle=(angle+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
		angle=(2.pow(n/mt).linlin(1,2,pi.neg,pi));
	//angle=(n*(2pi/temp));
~az=~az++azimuth;~el=~el++elevation;
~magx=~magx++magnitudex;~magy=~magy++magnitudey;~magz=~magz++magnitudez;
~qx=~qx++qx;~qy=~qy++qy;
		n1=0;n2=0;n3=0;n4=0;n5=0;n6=0;n7=0;
		az1=0;el1=0;az2=0;el2=0;az3=0;el3=0;
		az4=0;el4=0;az5=0;el5=0;az6=0;el6=0;az7=0;el7=0;
	}
}.value;
)