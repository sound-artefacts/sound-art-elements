

/*(
////////////plotter
(
var data,datac;
var az=0,el=0;
var m=600,sph,azc,elc,pl=0,pl1=0,mk1=0;
var mag,magc,r,sph1;
var run = true,n=12,size1=100;
var ot=0.degrad,mk=0,size=2000;
~data=[];

1.do{

data = (5*13*5*5).collect{

	az=~az.[pl];
	el=~el.[pl];
	//mag=1000;
	// mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
		mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt));
		// mag=~magz.[pl];
	pl=pl+1;
			mk=(mk+((size*2.pow(n/12))-((size*2.pow(n/12))/1.6180339887499))).wrap(0,size*2.pow(n/12));
		//mk=(mk+1);
		sph=Spherical(mag*(size/2),az,el).asCartesian.asArray;
};

datac = (8*13).collect{

	azc=~core_az.[pl1];
	elc=~core_el.[pl1];
	//mag=1000;
	// mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
		magc=(Cartesian(~core_x.[pl1],~core_y.[pl1],~core_z.[pl1]).rho/(2.sqrt));
		// mag=~magz.[pl];
	pl1=pl1+1;
			mk1=(mk1+((size*2.pow(n/12))-((size*2.pow(n/12))/1.6180339887499))).wrap(0,size*2.pow(n/12));
		//mk=(mk+1);
		sph1=Spherical(magc*(size1/2),azc,elc).asCartesian.asArray;
};
	//pl=0;
	//mk=(mk+(1200-(1200/1.6180339887499))).wrap(0,1200);
	~data=~data++data++datac;
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

		ot=ot+0.5.degrad;

};
{ while { run } {~v.background_(Color.black); ~v.refresh; (1/1000).wait } }.fork(AppClock);
)


/////////////
(
{
var sph1,sph2,sph3,sph4,sph5,sph6,sph7,m_x=1,m_y=1,m_z=1,qx,qy,mq=0;
var angle1=0,angle2=0,angle3=0,angle4=0,angle5=0,angle6=0,angle7=0;
var sph11,sph22,sph33,sph44,sph55,sph66,sph77,sphx,sphy,sphz,sphqx,sphqy;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z,mag_qx,mag_qy;
var az11=0,el11=0,az22=0,el22=0,az33=0,el33=0,az44=0,el44=0,az55=0,el55=0,az66=0,el66=0,az77=0,el77=0;
var az4=0,el4=0,az5=0,el5=0,az6=0,el6=0,az7=0,el7=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez;
var angle=0,n=12,num=1.neg,ellipsis=[1,1,1],spread=1;
var mag1=1,mag2=1,mag3=1,mag4=1,mag5=1,mag6=1,mag7=1;
var scale=8,core_az,core_el,core_x,core_y,core_z,cx,cy,cz;

	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];
	~core_az=[];~core_el=[];~core_x=[];~core_y=[];~core_z=[];
//	spread = if(m_z < 1) { 1 / m_z } { m_z };

	5.do{

13.do{
			az1 = (az1+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el1 = (el1+(180-(180/1.6180339887499))).wrap(90.neg,90);
			sph1=(Spherical(mag1,(az1.degrad+angle.degrad).wrap(pi.neg,pi),(el1.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

		core_az=1.collect{sph1.theta};~core_az=~core_az++core_az;

			5.do{
				az11=az1;el11=el1;
	azimuth=5.collect{
				az11 = (az11+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el11 = (el11+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph11=(Spherical(mag1/scale,(az11.degrad+angle.degrad+angle1.degrad).wrap(pi.neg,pi),(el11.degrad+angle.degrad+angle1.degrad).wrap((pi/2).neg,(pi/2))));
				(sph1.asCartesian.round(0.000000000001)+sph11.asCartesian.round(0.000000000001)).asSpherical.theta.round(0.000000000001);

			};~az=~az++azimuth;angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);};
		};

13.do{
			az2 = (az2+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el2 = (el2+(180-(180/1.6180339887499))).wrap(90.neg,90);
			sph2=(Spherical(mag2,(az2.degrad+angle.degrad).wrap(pi.neg,pi),(el2.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

core_el=1.collect{sph2.phi};~core_el=~core_el++core_el;

			5.do{
				az22=az2;el22=el2;
	elevation=5.collect{
				az22 = (az22+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el22 = (el22+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph22=(Spherical(mag2/scale,(az22.degrad+angle.degrad+angle2.degrad).wrap(pi.neg,pi),(el22.degrad+angle.degrad+angle2.degrad).wrap((pi/2).neg,(pi/2))));
				(sph2.asCartesian.round(0.000000000001)+sph22.asCartesian.round(0.000000000001)).asSpherical.phi.round(0.000000000001);

			};~el=~el++elevation;angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);};
		};

13.do{
			az3 = (az3+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el3 = (el3+(180-(180/1.6180339887499))).wrap(90.neg,90);
		    sph3=(Spherical(mag3,(az3.degrad+angle.degrad).wrap(pi.neg,pi),(el3.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

core_x=1.collect{		cx=((Complex(cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

(Spherical(cx,sph3.theta,sph3.phi).asCartesian.round(0.000000000001)).rho;
			};~core_x=~core_x++core_x;

			5.do{
				az33=az3;el33=el3;
	magnitudex=5.collect{
				az33 = (az33+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el33 = (el33+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph33=(Spherical(mag3/scale,(az33.degrad+angle.degrad+angle3.degrad).wrap(pi.neg,pi),(el33.degrad+angle.degrad+angle3.degrad).wrap((pi/2).neg,(pi/2))));
	 mag_x=((Complex(cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
	sphx=(Spherical(mag_x,sph3.theta,sph3.phi).asCartesian.round(0.000000000001)+Spherical(mag_x/scale,sph33.theta,sph33.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~magx=~magx++magnitudex;angle3=(angle3+(360-(360/1.6180339887499))).wrap(0,360);};
		};

13.do{
			az4 = (az4+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el4 = (el4+(180-(180/1.6180339887499))).wrap(90.neg,90);
	sph4=(Spherical(mag4,(az4.degrad+angle.degrad).wrap(pi.neg,pi),(el4.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

		core_y=1.collect{		 cy=((Complex(sin((sph4.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),sin((sph4.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
			(Spherical(cy,sph4.theta,sph4.phi).asCartesian.round(0.000000000001)).rho;
			};~core_y=~core_y++core_y;

			5.do{
				az44=az4;el44=el4;
	magnitudey=5.collect{
				az44 = (az44+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el44 = (el44+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph44=(Spherical(mag4/scale,(az44.degrad+angle.degrad+angle4.degrad).wrap(pi.neg,pi),(el44.degrad+angle.degrad+angle4.degrad).wrap((pi/2).neg,(pi/2))));
	 mag_y=((Complex(sin((sph4.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),sin((sph4.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
	sphy=(Spherical(mag_y,sph4.theta,sph4.phi).asCartesian.round(0.000000000001)+Spherical(mag_y/scale,sph44.theta,sph44.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~magy=~magy++magnitudey;angle4=(angle4+(360-(360/1.6180339887499))).wrap(0,360);};
		};

/*(
13.do{
			az5 = (az5+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el5 = (el5+(180-(180/1.6180339887499))).wrap(90.neg,90);
	sph5=(Spherical(mag5,(az5.degrad+angle.degrad).wrap(pi.neg,pi),(el5.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

			5.do{
				az55=az5;el55=el5;
	qx=5.collect{
				az55 = (az55+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el55 = (el55+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph55=(Spherical(mag5/scale,(az55.degrad+angle.degrad+angle5.degrad).wrap(pi.neg,pi),(el55.degrad+angle.degrad+angle5.degrad).wrap((pi/2).neg,(pi/2))));
		mag_qx=((((Complex(cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
			(Complex(sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
			(Complex(cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
		sphqx=(Spherical(mag_qx,sph5.theta,sph5.phi).asCartesian.round(0.000000000001)+Spherical(mag_qx/scale,sph55.theta,sph55.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~qx=~qx++qx;angle5=(angle5+(360-(360/1.6180339887499))).wrap(0,360);};
		};



13.do{
			az6 = (az6+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el6 = (el6+(180-(180/1.6180339887499))).wrap(90.neg,90);
	sph6=(Spherical(mag6,(az6.degrad+angle.degrad).wrap(pi.neg,pi),(el6.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

			5.do{
				az66=az6;el66=el6;
		qy=5.collect{
				az66 = (az66+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el66 = (el66+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph66=(Spherical(mag6/scale,(az66.degrad+angle.degrad+angle6.degrad).wrap(pi.neg,pi),(el66.degrad+angle.degrad+angle6.degrad).wrap((pi/2).neg,(pi/2))));
		mag_qy=((((Complex(sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
				(Complex(sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
				(Complex(cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
		sphqy=(Spherical(mag_qy,sph6.theta,sph6.phi).asCartesian.round(0.000000000001)+Spherical(mag_qy/scale,sph66.theta,sph66.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~qy=~qy++qy;angle6=(angle6+(360-(360/1.6180339887499))).wrap(0,360);};
		};

		)*/
13.do{
			az7 = (az7+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el7 = (el7+(180-(180/1.6180339887499))).wrap(90.neg,90);
sph7=(Spherical(mag7,(az7.degrad+angle.degrad).wrap(pi.neg,pi),(el7.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

			core_z=	1.collect{
			cz=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread);
			(Spherical(cz,sph7.theta,sph7.phi).asCartesian.round(0.000000000001)).rho;
			};	~core_z=~core_z++core_z;

			5.do{
				az77=az7;el77=el7;
	magnitudez=	5.collect{
				az77 = (az77+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el77 = (el77+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph77=(Spherical(mag7/scale,(az77.degrad+angle.degrad+angle7.degrad).wrap(pi.neg,pi),(el77.degrad+angle.degrad+angle7.degrad).wrap((pi/2).neg,(pi/2))));
		mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread);
		sphz=(Spherical(mag_z,sph7.theta,sph7.phi).asCartesian.round(0.000000000001)+Spherical(mag_z/scale,sph77.theta,sph77.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~magz=~magz++magnitudez;angle7=(angle7+(360-(360/1.6180339887499))).wrap(0,360);};
		};

angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
		angle1=0;angle2=0;angle3=0;angle4=0;angle5=0;angle6=0;angle7=0;
		az1=0;el1=0;az2=0;el2=0;az3=0;el3=0;az4=0;el4=0;az5=0;el5=0;az6=0;el6=0;az7=0;el7=0;
	}
}.value;
)
)*/

////////////////////////////////////


(
s.waitForBoot;
Buffer.freeAll;
~controlBus = Bus.control(s, 1);
~controlBus_spin = Bus.control(s, 1);


	~w1= Buffer.alloc(s,2048);
		{
var signal,wt,m=0,amp,ph=0;

	signal=Env([1,100,100,1000],[1,1,1],[8,0,8]);

	wt = signal.asSignal(1024).asWavetable;
~w1.loadCollection(wt);
signal.plot;
		}.value;

	~w2= Buffer.alloc(s,2048);
		{
var signal,wt,m=0,amp,ph=0, time=1/4;

	signal=Env([90,30,90,90,30,90],[(1-(time)).reciprocal,time,1,time,(1-(time)).reciprocal],[4.neg,8,0,8.neg,4]);

	wt = signal.asSignal(1024).asWavetable;
~w2.loadCollection(wt);
signal.plot;
		}.value;

SynthDef.new(\player,{
	arg tempo;

	Out.kr(~controlBus.index, (Osc.kr(~w1.bufnum,0.01).abs));
	Out.kr(~controlBus_spin.index, (Osc.kr(~w2.bufnum,0.01).abs));


}).add;
)


Server.freeAll


//////////////////////////////////////////////////////////////////////animation

(
var ot=0.degrad,dota,pla=0;
var data,dota1,plb=0;
var az=0,el=0,azc,elc,sphb;
var sph,pl=0,magb,r,run = true;
var sph1,sph2,sph3,sph4,sph5,sph6,sph7,m_x=3,m_y=3,m_z=3,qx,qy,mq=0;
var angle1=0,angle2=0,angle3=0,angle4=0,angle5=0,angle6=0,angle7=0;
var sph11,sph22,sph33,sph44,sph55,sph66,sph77,sphx,sphy,sphz,sphqx,sphqy;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z,mag_qx,mag_qy;
var az11=0,el11=0,az22=0,el22=0,az33=0,el33=0,az44=0,el44=0,az55=0,el55=0,az66=0,el66=0,az77=0,el77=0;
var az4=0,el4=0,az5=0,el5=0,az6=0,el6=0,az7=0,el7=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez;
var angle=0,n=12,num=1.neg,ellipsis=[1,1,1],spread=1;
var mag1=1,mag2=1,mag3=1,mag4=1,mag5=1,mag6=1,mag7=1;
var scale=8,core_az,core_el,core_x,core_y,core_z,cx,cy,cz;
var size=1000,size1=100,spin;

	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];
	~core_az=[];~core_el=[];~core_x=[];~core_y=[];~core_z=[];
//	spread = if(m_z < 1) { 1 / m_z } { m_z };
Synth.new(\player);
data = [];

w = Window.new("3D Scatterplot", Rect(40,40, 800, 800)).front;

~v = UserView.new(w,Rect(0,0,800,800)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 800,800), ~data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 1;
a.symbolColor = Color.white;
a.background = Color.black;


  r= Routine({loop{

	data=[];
	scale=~controlBus.getSynchronous;
	spin=~controlBus_spin.getSynchronous;
	//scale=1;
	scale.postln;

	(
{
	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];
	~core_az=[];~core_el=[];~core_x=[];~core_y=[];~core_z=[];

	8.do{

5.do{
					az1 = (az1+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el1 = (el1+(180-(180/1.6180339887499))).wrap(90.neg,90);
			sph1=(Spherical(mag1,(az1.degrad+angle.degrad).wrap(pi.neg,pi),(el1.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

		core_az=1.collect{sph1.theta};~core_az=~core_az++core_az;

			3.do{
				az11=az1;el11=el1;
	azimuth=3.collect{
				az11 = (az11+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el11 = (el11+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph11=(Spherical(mag1/scale,(az11.degrad+angle.degrad+angle1.degrad).wrap(pi.neg,pi),(el11.degrad+angle.degrad+angle1.degrad).wrap((pi/2).neg,(pi/2))));
				(sph1.asCartesian.round(0.000000000001)+sph11.asCartesian.round(0.000000000001)).asSpherical.theta.round(0.000000000001);

			};~az=~az++azimuth;angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);};
		};

5.do{
			az2 = (az2+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el2 = (el2+(180-(180/1.6180339887499))).wrap(90.neg,90);
			sph2=(Spherical(mag2,(az2.degrad+angle.degrad).wrap(pi.neg,pi),(el2.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

core_el=1.collect{sph2.phi.wrap(spin.degrad.neg,spin.degrad)};~core_el=~core_el++core_el;

			3.do{
				az22=az2;el22=el2;
	elevation=3.collect{
				az22 = (az22+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el22 = (el22+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph22=(Spherical(mag2/scale,(az22.degrad+angle.degrad+angle2.degrad).wrap(pi.neg,pi),(el22.degrad+angle.degrad+angle2.degrad).wrap((pi/2).neg,(pi/2))));
				(sph2.asCartesian.round(0.000000000001)+sph22.asCartesian.round(0.000000000001)).asSpherical.phi.round(0.000000000001).wrap(spin.degrad.neg,spin.degrad);

			};~el=~el++elevation;angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);};
		};

5.do{
			az3 = (az3+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el3 = (el3+(180-(180/1.6180339887499))).wrap(90.neg,90);
		    sph3=(Spherical(mag3,(az3.degrad+angle.degrad).wrap(pi.neg,pi),(el3.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

core_x=1.collect{		cx=((Complex(cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

(Spherical(cx,sph3.theta,sph3.phi).asCartesian.round(0.000000000001)).rho;
			};~core_x=~core_x++core_x;

			3.do{
				az33=az3;el33=el3;
	magnitudex=3.collect{
				az33 = (az33+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el33 = (el33+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph33=(Spherical(mag3/scale,(az33.degrad+angle.degrad+angle3.degrad).wrap(pi.neg,pi),(el33.degrad+angle.degrad+angle3.degrad).wrap((pi/2).neg,(pi/2))));
	 mag_x=((Complex(cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
	sphx=(Spherical(mag_x,sph3.theta,sph3.phi).asCartesian.round(0.000000000001)+Spherical(mag_x/scale,sph33.theta,sph33.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~magx=~magx++magnitudex;angle3=(angle3+(360-(360/1.6180339887499))).wrap(0,360);};
		};

5.do{
			az4 = (az4+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el4 = (el4+(180-(180/1.6180339887499))).wrap(90.neg,90);
	sph4=(Spherical(mag4,(az4.degrad+angle.degrad).wrap(pi.neg,pi),(el4.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

		core_y=1.collect{		 cy=((Complex(sin((sph4.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),sin((sph4.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
			(Spherical(cy,sph4.theta,sph4.phi).asCartesian.round(0.000000000001)).rho;
			};~core_y=~core_y++core_y;

			3.do{
				az44=az4;el44=el4;
	magnitudey=3.collect{
				az44 = (az44+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el44 = (el44+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph44=(Spherical(mag4/scale,(az44.degrad+angle.degrad+angle4.degrad).wrap(pi.neg,pi),(el44.degrad+angle.degrad+angle4.degrad).wrap((pi/2).neg,(pi/2))));
	 mag_y=((Complex(sin((sph4.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),sin((sph4.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
	sphy=(Spherical(mag_y,sph4.theta,sph4.phi).asCartesian.round(0.000000000001)+Spherical(mag_y/scale,sph44.theta,sph44.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~magy=~magy++magnitudey;angle4=(angle4+(360-(360/1.6180339887499))).wrap(0,360);};
		};

/*(
13.do{
			az5 = (az5+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el5 = (el5+(180-(180/1.6180339887499))).wrap(90.neg,90);
	sph5=(Spherical(mag5,(az5.degrad+angle.degrad).wrap(pi.neg,pi),(el5.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

			5.do{
				az55=az5;el55=el5;
	qx=5.collect{
				az55 = (az55+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el55 = (el55+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph55=(Spherical(mag5/scale,(az55.degrad+angle.degrad+angle5.degrad).wrap(pi.neg,pi),(el55.degrad+angle.degrad+angle5.degrad).wrap((pi/2).neg,(pi/2))));
		mag_qx=((((Complex(cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
			(Complex(sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
			(Complex(cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
		sphqx=(Spherical(mag_qx,sph5.theta,sph5.phi).asCartesian.round(0.000000000001)+Spherical(mag_qx/scale,sph55.theta,sph55.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~qx=~qx++qx;angle5=(angle5+(360-(360/1.6180339887499))).wrap(0,360);};
		};



13.do{
			az6 = (az6+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el6 = (el6+(180-(180/1.6180339887499))).wrap(90.neg,90);
	sph6=(Spherical(mag6,(az6.degrad+angle.degrad).wrap(pi.neg,pi),(el6.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

			5.do{
				az66=az6;el66=el6;
		qy=5.collect{
				az66 = (az66+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el66 = (el66+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph66=(Spherical(mag6/scale,(az66.degrad+angle.degrad+angle6.degrad).wrap(pi.neg,pi),(el66.degrad+angle.degrad+angle6.degrad).wrap((pi/2).neg,(pi/2))));
		mag_qy=((((Complex(sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
				(Complex(sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
				(Complex(cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
		sphqy=(Spherical(mag_qy,sph6.theta,sph6.phi).asCartesian.round(0.000000000001)+Spherical(mag_qy/scale,sph66.theta,sph66.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~qy=~qy++qy;angle6=(angle6+(360-(360/1.6180339887499))).wrap(0,360);};
		};

		)*/
5.do{
			az7 = (az7+(360-(360/1.6180339887499))).wrap(180.neg,180);
			el7 = (el7+(180-(180/1.6180339887499))).wrap(90.neg,90);
sph7=(Spherical(mag7,(az7.degrad+angle.degrad).wrap(pi.neg,pi),(el7.degrad+angle.degrad).wrap((pi/2).neg,(pi/2))));

			core_z=	1.collect{
			cz=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread);
			(Spherical(cz,sph7.theta,sph7.phi).asCartesian.round(0.000000000001)).rho;
			};	~core_z=~core_z++core_z;

			3.do{
				az77=az7;el77=el7;
	magnitudez=	3.collect{
				az77 = (az77+(360-(360/1.6180339887499))).wrap(180.neg,180);
				el77 = (el77+(180-(180/1.6180339887499))).wrap(90.neg,90);

				sph77=(Spherical(mag7/scale,(az77.degrad+angle.degrad+angle7.degrad).wrap(pi.neg,pi),(el77.degrad+angle.degrad+angle7.degrad).wrap((pi/2).neg,(pi/2))));
		mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread);
		sphz=(Spherical(mag_z,sph7.theta,sph7.phi).asCartesian.round(0.000000000001)+Spherical(mag_z/scale,sph77.theta,sph77.phi).asCartesian.round(0.000000000001)).asSpherical.rho;

			};~magz=~magz++magnitudez;angle7=(angle7+(360-(360/1.6180339887499))).wrap(0,360);};
		};

angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
		angle1=0;angle2=0;angle3=0;angle4=0;angle5=0;angle6=0;angle7=0;
		az1=0;el1=0;az2=0;el2=0;az3=0;el3=0;az4=0;el4=0;az5=0;el5=0;az6=0;el6=0;az7=0;el7=0;
	}
}.value;
);
	dota=(8*3*3*5).collect{

	az=~az.[pla];
	el=~el.[pla];

	//mag=1000;
	// mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
				 mag=(Cartesian(~magx.[pla],~magy.[pla],~magz.[pla]).rho/(2.sqrt));
		// mag=~magz.[pl];
	pla=pla+1;
			//mk=(mk+(1-(1/1.6180339887499))).wrap(0,1);
		sph=Spherical((size-scale)*mag,az,el).asCartesian.asArray;
};
		dota1=(8*5).collect{

	azc=~core_az.[plb];
	elc=~core_el.[plb];

	//mag=1000;
	// mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
				 magb=(Cartesian(~core_x.[plb],~core_y.[plb],~core_z.[plb]).rho/(2.sqrt));
		// mag=~magz.[pl];
	plb=plb+1;
			//mk=(mk+(1-(1/1.6180339887499))).wrap(0,1);
		sphb=Spherical((size1-(scale/100)),azc,elc).asCartesian.asArray;
};
	//mk=(mk+(1200-(1200/1.6180339887499))).wrap(0,1200);
	pla=0;plb=0;
	data =data++dota1++dota;
	//data.postln;
 	a.data = data;  // Update ScatterView3d
	(0.1).wait
}});
r.play;


~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

		a.rot(ot,ot,ot);
    ~v.refresh;

		ot=ot+0.5.degrad;

};
{ while { run } {~v.background_(Color.black); ~v.refresh; (1/100).wait } }.fork(AppClock);
);




/////