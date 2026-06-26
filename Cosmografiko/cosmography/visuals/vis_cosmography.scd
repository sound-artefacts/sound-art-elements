
//////////////////////////////////////////////////////////////////////animation
(
~orange=3;
~bspeed=1;
 ~bfreq=2;
~bamp=3;
~time=120;
~count=[2,2,2,4,2,6];
({
var ot=0,dota,pla=0;
var data;
var az=0,el=0;
var sph,mag,r,run = true;
var scale=1,scale1=10,scale2=10,harm,perspective;
var axis=~count.[0],cloud=~count.[1],axis1=~count.[2],gravity1=~count.[3],axis2=~count.[4],gravity2=~count.[5];
var m_x=1,m_y=1,m_z=1,mq=m_x+1;
var sph1,sph2,sph3,sph4,sph7,sph6;
var sph11,sph22,sph33,sph44,sph77,sph66;
var sph_1,sph_2,sph_3,sph_4,sph_7,sph_6;
var sph_11,sph_22,sph_33,sph_44,sph_77,sph_66;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,az4=0,el4=0,az7=0,el7=0,az6=0,el6=0;
var az11=0,el11=0,az22=0,el22=0,az33=0,el33=0,az44=0,el44=0,az77=0,el77=0,az66=0,el66=0;
var az_1=0,el_1=0,az_2=0,el_2=0,az_3=0,el_3=0,az_4=0,el_4=0,az_7=0,el_7=0,az_6=0,el_6=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez,magnitudeqx;
var magx,magy,magz,magqx,rotation;
var angle=0,angle1=0,angle11=0;
var g=((1+5.sqrt)/2),s=(1+2.sqrt),ott=pi.rand2,temp,space;
var waveSpeed = 1/2;
var waveFreq = 3;
var amp=2;
var theta,phi ,wave;

	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[]; ~cart=[];      ~detune=1;
data = [];
Window.free;
~w = Window.new("3D Scatterplot", Rect(40,40, 2000, 1200)).front;

~v = UserView.new(~w,Rect(0,0,1800,1000)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 1800,1000), ~data, [-5000, 5000].asSpec,[-5000, 5000].asSpec,[-5000, 5000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 2;
a.symbolColor = Color.white;
a.background = Color.clear;
b = ScatterView3d(~v, Rect(0,0, 1800,1000), ~data, [-4000, 4000].asSpec,[-4000, 4000].asSpec,[-9000, 4000].asSpec);
b.drawMethod = \fillRect;
b.symbolSize = 2;
b.symbolColor = Color.white;
b.background = Color.clear;

  r= Routine({loop{

 waveSpeed = ~bspeed;
 waveFreq = ~bfreq;
 amp=~bamp;

		scale=~controlBus1.getSynchronous.linlin(0,(16256*~orange),1,(16256));
	scale1=~controlBus2.getSynchronous.linlin(0,(16256*~orange),1000,1);
	scale2=~controlBus3.getSynchronous.linlin(1,3,1000,1);
	rotation=~controlBus4.getSynchronous.linlin((16256*10).neg,(16256*5),0.0001,10);
		harm=~controlBus5.getSynchronous;
		temp=~controlBus1.getSynchronous.linlin(0,(16256*~orange),1,0);
			space=~controlBus1.getSynchronous.linlin(0,(16256*~orange),0,1);

		~rev=harm/10;

	m_x=m_y=m_z=harm;
		mq=harm+1;


	axis=~count.[0];
	cloud=~count.[1];
	axis1=~count.[2];
	gravity1=~count.[3];
	axis2=~count.[4];
	gravity2=~count.[5];

        az1=0; el1=0;
        az2=0; el2=0;
        az3=0; el3=0;
        az4=0; el4=0;
        az7=0; el7=0;
        az6=0; el6=0;
angle = 0;
angle1 = 0;
angle11 = 0;

az11=0; el11=0;
az22=0; el22=0;
az33=0; el33=0;
az44=0; el44=0;
az77=0; el77=0;
az66=0; el66=0;

az_1=0; el_1=0;
az_2=0; el_2=0;
az_3=0; el_3=0;
az_4=0; el_4=0;
az_7=0; el_7=0;
az_6=0; el_6=0;

        data = [];
	dota=[];
        pla = 0;

	//scale=1;
	//scale.postln;

	(
{
	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~magqx=[];


	axis.do{

//////////////////////////// AZ
cloud.do{

az1=(az1+(2pi-(2pi/g))).wrap(pi.neg,pi);
el1=(el1+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph1=Spherical(1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az11=sph1.theta;
el11=sph1.phi;

gravity1.do{

az11=(az11+(2pi-(2pi/g))).wrap(pi.neg,pi);
el11=(el11+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph11=Spherical(1/scale1,(az11+angle1).wrap(pi.neg,pi),(el11+angle1).wrap((pi/2).neg,(pi/2)));

sph_1=(sph1.asCartesian+sph11.asCartesian);

axis2.do{

az_1=sph11.theta;
el_1=sph11.phi;

azimuth=gravity2.collect{

az_1=(az_1+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_1=(el_1+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_11=Spherical(1/scale2,(az_1+angle11).wrap(pi.neg,pi),(el_1+angle11).wrap((pi/2).neg,(pi/2)));

(sph_1+sph_11.asCartesian).asSpherical.theta

};

~az=~az++azimuth;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

//////////////////////////// EL
cloud.do{

az2=(az2+(2pi-(2pi/g))).wrap(pi.neg,pi);
el2=(el2+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph2=Spherical(1,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az22=sph2.theta;
el22=sph2.phi;

gravity1.do{

az22=(az22+(2pi-(2pi/g))).wrap(pi.neg,pi);
el22=(el22+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph22=Spherical(1/scale1,(az22+angle1).wrap(pi.neg,pi),(el22+angle1).wrap((pi/2).neg,(pi/2)));

sph_2=(sph2.asCartesian+sph22.asCartesian);

axis2.do{

az_2=sph22.theta;
el_2=sph22.phi;

elevation=gravity2.collect{

az_2=(az_2+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_2=(el_2+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_22=Spherical(1/scale2,(az_2+angle11).wrap(pi.neg,pi),(el_2+angle11).wrap((pi/2).neg,(pi/2)));

(sph_2+sph_22.asCartesian).asSpherical.phi

};

~el=~el++elevation;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

//////////////////////////// MAG X
cloud.do{

az3=(az3+(2pi-(2pi/g))).wrap(pi.neg,pi);
el3=(el3+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph3=Spherical(1,(az3+angle).wrap(pi.neg,pi),(el3+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az33=sph3.theta;
el33=sph3.phi;

gravity1.do{

az33=(az33+(2pi-(2pi/g))).wrap(pi.neg,pi);
el33=(el33+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph33=Spherical(1/scale1,(az33+angle1).wrap(pi.neg,pi),(el33+angle1).wrap((pi/2).neg,(pi/2)));

sph_3=(sph3.asCartesian+sph33.asCartesian);

axis2.do{

az_3=sph33.theta;
el_3=sph33.phi;

magnitudex=gravity2.collect{

az_3=(az_3+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_3=(el_3+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_33=Spherical(1/scale2,(az_3+angle11).wrap(pi.neg,pi),(el_3+angle11).wrap((pi/2).neg,(pi/2)));

magx=((Complex(cos((sph3.theta*m_x)),cos((sph3.theta*m_x))).rho/(2.sqrt))*
(Complex(cos((sph3.phi)),cos((sph3.phi))).rho/(2.sqrt)));

(Spherical(magx,sph3.theta,sph3.phi).asCartesian
+Spherical(magx/scale2,sph_33.theta,sph_33.phi).asCartesian).asSpherical.rho

};

								~magx=~magx++magnitudex;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

//////////////////////////// MAG Y
cloud.do{

az4=(az4+(2pi-(2pi/g))).wrap(pi.neg,pi);
el4=(el4+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph4=Spherical(1,(az4+angle).wrap(pi.neg,pi),(el4+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az44=sph4.theta;
el44=sph4.phi;

gravity1.do{

az44=(az44+(2pi-(2pi/g))).wrap(pi.neg,pi);
el44=(el44+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph44=Spherical(1/scale1,(az44+angle1).wrap(pi.neg,pi),(el44+angle1).wrap((pi/2).neg,(pi/2)));

sph_4=(sph4.asCartesian+sph44.asCartesian);

axis2.do{

az_4=sph44.theta;
el_4=sph44.phi;

magnitudey=gravity2.collect{

az_4=(az_4+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_4=(el_4+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_44=Spherical(1/scale2,(az_4+angle11).wrap(pi.neg,pi),(el_4+angle11).wrap((pi/2).neg,(pi/2)));

magy=((Complex(sin((sph4.theta*m_x)),sin((sph4.theta*m_x))).rho/(2.sqrt))*
(Complex(cos((sph4.phi)),cos((sph4.phi))).rho/(2.sqrt)));

(Spherical(magy,sph4.theta,sph4.phi).asCartesian
+Spherical(magy/scale2,sph_44.theta,sph_44.phi).asCartesian).asSpherical.rho

};

								~magy=~magy++magnitudey;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

//////////////////////////// MAG Z
cloud.do{

az7=(az7+(2pi-(2pi/g))).wrap(pi.neg,pi);
el7=(el7+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph7=Spherical(1,(az7+angle).wrap(pi.neg,pi),(el7+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az77=sph7.theta;
el77=sph7.phi;

gravity1.do{

az77=(az77+(2pi-(2pi/g))).wrap(pi.neg,pi);
el77=(el77+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph77=Spherical(1/scale1,(az77+angle1).wrap(pi.neg,pi),(el77+angle1).wrap((pi/2).neg,(pi/2)));

sph_7=(sph7.asCartesian+sph77.asCartesian);

axis2.do{

az_7=sph77.theta;
el_7=sph77.phi;

magnitudez=gravity2.collect{

az_7=(az_7+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_7=(el_7+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_77=Spherical(1/scale2,(az_7+angle11).wrap(pi.neg,pi),(el_7+angle11).wrap((pi/2).neg,(pi/2)));

magz=(Complex(sin((sph7.phi*m_z)),sin((sph7.phi*m_z))).rho/(2.sqrt));

(Spherical(magz,sph7.theta,sph7.phi).asCartesian
+Spherical(magz/scale2,sph_77.theta,sph_77.phi).asCartesian).asSpherical.rho

};

								~magz=~magz++magnitudez;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

/////////////////////////////////MAG QX
	cloud.do{

az6=(az6+(2pi-(2pi/g))).wrap(pi.neg,pi);
el6=(el6+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));
angle1=angle;

sph6=Spherical(1,(az6+angle).wrap(pi.neg,pi),(el6+angle).wrap((pi/2).neg,(pi/2)));

axis1.do{

az66=sph6.theta;
el66=sph6.phi;

gravity1.do{

az66=(az66+(2pi-(2pi/g))).wrap(pi.neg,pi);
el66=(el66+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

angle11=angle1;

sph66=Spherical(1/scale1,(az66+angle1).wrap(pi.neg,pi),(el66+angle1).wrap((pi/2).neg,(pi/2)));

sph_6=(sph6.asCartesian+sph66.asCartesian);

axis2.do{

az_6=sph66.theta;
el_6=sph66.phi;

magnitudeqx=gravity2.collect{

az_6=(az_6+(2pi-(2pi/g))).wrap(pi.neg,pi);
el_6=(el_6+(pi-(pi/g))).wrap((pi/2).neg,(pi/2));

sph_66=Spherical(1/scale2,(az_6+angle11).wrap(pi.neg,pi),(el_6+angle11).wrap((pi/2).neg,(pi/2)));

magqx=((((Complex(cos(((sph6.theta)*mq).wrap(pi.neg,pi)),cos(((sph6.theta)*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph6.phi*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((sph6.phi*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph6.phi).wrap((pi/2).neg,(pi/2))),cos((sph6.phi).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt));

(Spherical(magqx,sph6.theta,sph6.phi).asCartesian
+Spherical(magqx/scale2,sph_66.theta,sph_66.phi).asCartesian).asSpherical.rho

};

								~magqx=~magqx++magnitudeqx;
angle11=(angle11+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle1=(angle1+(2pi-(2pi/g))).wrap(0,2pi);

};

};

angle=(angle+(2pi-(2pi/g))).wrap(0,2pi);

az1=0;el1=0;
az2=0;el2=0;
az3=0;el3=0;
az4=0;el4=0;
az7=0;el7=0;
az6=0;el6=0;

};
}.value;
);
						~magxb = ~magx.collect { |val, i|

	 theta = ~az[i];
     phi = ~el[i];
	wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
    val * wave;
};

		~magyb = ~magy.collect { |val, i|

	 theta = ~az[i];
     phi = ~el[i];
	wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
    val * wave;
};

		~magzb = ~magz.collect { |val, i|

	 theta = ~az[i];
     phi = ~el[i];
	wave = amp*sin((waveFreq * theta) + (waveFreq * phi )- waveSpeed);
    val * wave;
};

	dota=(~count.[0]*~count.[1]*~count.[2]*~count.[3]*~count.[4]*~count.[5]).collect{

	az=~az.[pla];
	el=~el.[pla];
	//mag=1000;
			mag=(Cartesian(~magxb.[pla],~magyb.[pla],~magzb.[pla]).rho)/2.sqrt;
	//	mag=mag+(Cartesian(~magqx.[pla],0,0).rho);
	pla=pla+1;
			//mk=(mk+(1-(1/1.6180339887499))).wrap(0,1);
			//sph=Spherical(perspective*scale*mag,az,el).asCartesian.asArray;
		sph=Spherical(scale*mag,az,el).asCartesian.asArray;
};
	//mk=(mk+(1200-(1200/1.6180339887499))).wrap(0,1200);
	data =data++dota;

	//data.postln;
        // schedule GUI update on AppClock
        AppClock.sched(0, {
            a.data = data;   // ScatterView3d data
			b.data = data;

			~v.background_(Color(space,space,space));
            ~v.refresh;
          //  0;               // keep AppClock loop going
        }); /*~cart.postln;*/ (1/8).wait;
};};

);
r.play;


~v.animate;
~v.drawFunc ={

    Pen.translate(1000,600);

		b.symbolColor = Color.new(red:temp,blue:temp,green:temp);
		//a.symbolColor =Color.new(red:temp,blue:temp,green:temp);
   a.rot(ot,ot,ot);
		 b.rot(ott,ott,ott);
				~r1=ot; ~r2=ot; ~r3=ot;

		ot = (ot + rotation.degrad).wrap(0,2pi);
		ott = (ott + (0.1+rotation).degrad).wrap(0,2pi);

    ~cart = data.collect{|p|

        var x=p[0], y=p[1], z=p[2];
        var rx,ry,rz;

        // rotate X
		ry = (y*cos(ot)) - (z*sin(ot));
		rz = (y*sin(ot) )+ (z*cos(ot));
        y = ry; z = rz;

        // rotate Y
		rx = (x*cos(ot)) + (z*sin(ot));
		rz =( x.neg*sin(ot)) + (z*cos(ot));
        x = rx; z = rz;

        // rotate Z
		rx = (x*cos(ot)) -(y*sin(ot));
		ry = (x*sin(ot)) + (y*cos(ot));
        x = rx; y = ry;

        [x,y,z];
    };

};
//{ while { run } {~v.background_(Color.black); ~v.refresh; (1/100).wait } }.fork(AppClock);
}.value);

)


/////dac noise rremoval for generative instaλlation
/*Routine({
    loop {
        6*3600.wait;   // every 6 hours
        s.reboot;
    }
}).play;


/////*/