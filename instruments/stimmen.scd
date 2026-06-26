
Server.killAll
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=1;
s.options.memSize = 8192*4;
s.options.blockSize = 128;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
//s.boot;
);

//
(
s.waitForBoot{
//s.freqscope;
//s.scope;
//s.makeWindow;
s.meter;
	Tdef(\drone, {
	Buffer.freeAll;

/*(
~a = VBAPSpeakerArray.new(3,
[[~az.[0],~el.[0]], [~az.[1],~el.[1]], [~az.[2],~el.[2]], [~az.[3],~el.[3]],[~az.[4],~el.[4]],[~az.[5],~el.[5]]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);*/

					//tetr
		(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
////// wavetables

		//oscillator table
		(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~n=(0-(2pi/992)); ~ph=992.collect{~n=~n+(2pi/992);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);


		(
~w1= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
signal=Signal.sineFill(~signalSize,~array,[0],~ph);

wt = signal.asWavetable;
~w1.loadCollection(wt);
//signal.plot;
		}.value;
);

		/////scales

(
			{
				var nn=1.neg;
		~scalee=10.collect{nn=nn+1;Scale.majorPentatonic.performDegreeToKey(nn,12)};
			}.value;
		);

		(
			{
				var nn=1.neg;
		~scaleee=10.collect{nn=nn+1;Scale.minorPentatonic.performDegreeToKey(nn,12)};
			}.value;
		);

		~sc=[~scalee,~scaleee];

		////sound
(
SynthDef.new(\synthd,{

	arg gain=1,low=992,tone1=0,tone2=0,tone3=0,x=1,pan=1,mix=0.3,a=1,panx=1,pany=1,panz=1,room=0.5,m=2,pon=1,
				fu=32,drive=1,spread=1,drone_amp=1,pann=0,az=0,el=0,azr=0,dron=0,drone=1,theta=0,rx=0,ry=0,rz=0,	pneuma1=0,pneuma2=0,pneuma3=0,namp1=1,namp2=1,namp3=1,sc=14,qq=0.0000001,qqq=0,
spirit=0,amp=1,waveFreq=1,waveSpeed=1,rlx=1,rla1=1,rla2=1,rph=0;

	var rq=1,cloud=1,attack,decay,curve,band,azf=0,elf=0,q,r1,r2,r3,sq1,sq2,sq3,rotationx,rotationy,rotationz,core=(9/8).rand;
	var lamdoma,freq1,freq2,freq3,fund,amp1,amp2,amp3,alpha,cell_az,cell_el,x_pos,y_pos,control1,control2,control3;
	var sig1,sig2,bank=6,out1,out2,band_osc1,band_osc2,threshold1,threshold2,threshold3,phase1,phase2,phase3;
	var band_osc3,band_osc4,band_osc5,band_osc6,sig3,out3,cell_tria,b_x,b_y,b_z,polytope,gain1,gain2,gain3,env,azimuth,elevation;
	var magx,magy,magz,magqx,magqy,mod_anglex,anglex,angley,anglez,phasex,phasey,phasez,rq1,rq2,rq3,rq4,rq5,rq6;
	var mod_angley,mod_anglez,mx,my,mz,mqx,mqy,mag,mq,lfo,sph;
	var loc1,loc2,loc3,g=((1+5.sqrt)/2),s=(1+2.sqrt),tensor,dr;
	var amb_w,amb_x,amb_y,amb_z,out,amb_sig1,amb_sig2,amb_sig3,axisx,axisy,axisz,cx,cy,cz;
	var axi1,axi2,axi3,ds1,ds2,ds3,f1,f2,f3,g1,g2,g3,sph_object,lfon,axis;
	var r_axis, r_v, r, axisr,spr,rot,i,j,k,level=200,spx,spy,spz;
	var g_ch1,g_ch2,g_ch3,g_ch4,chan=4,dr1,dr2;
	var gn ,g_sum,g_avg ,ton1,ton2,ton3,laxis,sp,spl,g11,g22,g33,g44;
	var pon1,pon2,pon3,pon4,wave,angphi,angtheta;

fund=fu*(9/8);
lamdoma=(x.lag(0.01)+a.lag(0.01))/x.lag(0.01);

ton1=2.pow(Select.kr(tone1, Select.kr(qqq.lag(0.01),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.01)/992);
ton2=2.pow(Select.kr(tone2, Select.kr(qqq.lag(0.01),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.01)/992);
ton3=2.pow(Select.kr(tone3, Select.kr(qqq.lag(0.01),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.01)/992);


						lfo=2.pow(pan/992);
				lfon=2.pow(pann/992);
					band=pan;

				mq=(m.lag(0.01)+1);

					spr=Spherical(1,az,el);
				spx=Cartesian(spr.x,0,0);
				spy=Cartesian(0,spr.y,0);
				spz=Cartesian(0,0,spr.z);

				sph_object=spr;

				axis=Spherical(sc,(sph_object.theta+azf).wrap(pi,pi.neg),  (sph_object.phi+elf).wrap((pi/2),(pi/2).neg));

				polytope=Cartesian(axis.x,axis.y,axis.z);

b_x=2.pow(polytope.x.round(1) /992).round(0.0001)*lamdoma;
b_y=2.pow(polytope.y.round(1) /992).round(0.0001)*lamdoma;
b_z=2.pow(polytope.z.round(1) /992).round(0.0001)*lamdoma;


anglex=(exp(Complex(0,1)*polytope.theta).real*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
angley=(exp(Complex(0,1)*polytope.theta).imag*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
anglez=(exp(Complex(0,1)*polytope.phi).imag).round(0.00001);

phase1=(Complex(1,anglex).theta*4);
phase2=(Complex(1,angley).theta*4);
phase3=(Complex(1,anglez).theta*2);


//mod_anglex=SinOsc.ar(lfon,phase1).range(pi.neg,pi).lag(0.01);
//mod_angley=SinOsc.ar(lfon,phase2).range(pi.neg,pi).lag(0.01);
//mod_anglez=SinOsc.ar(lfon,phase3).range(35.264390.degrad,35.264390.degrad.neg).lag(0.01);

mod_anglex=(LPF.ar((Osc.ar(~w1.bufnum,lfon,phase:phase1,mul:level).abs*SinOsc.ar(lfon,phase:phase1)),lfon*2.pow(low.lag(0.01)/992),1).range(panx*1,1)+(LPF.ar((Osc.ar(~w1.bufnum,lfon/8,phase:phase1,mul:level).abs*SinOsc.ar(lfon/8,phase:phase1)),(lfon/8)*2.pow(low.lag(0.01)/992),(lfon/8).reciprocal))).range(pi.neg,pi).lag(0.01);

mod_angley=(LPF.ar((Osc.ar(~w1.bufnum,lfon,phase:phase2,mul:level).abs*SinOsc.ar(lfon,phase:phase2)),lfon*2.pow(low.lag(0.01)/992),1).range(pany*1,1)+(LPF.ar((Osc.ar(~w1.bufnum,lfon/8,phase:phase2,mul:level).abs*SinOsc.ar(lfon/8,phase:phase2)),(lfon/8)*2.pow(low.lag(0.01)/992),(lfon/8).reciprocal))).range(pi.neg,pi).lag(0.01);

mod_anglez=(LPF.ar((Osc.ar(~w1.bufnum,lfon,phase:phase3,mul:level).abs*SinOsc.ar(lfon,phase:phase3)),lfon*2.pow(low.lag(0.01)/992),1).range(panz*1,1)+(LPF.ar((Osc.ar(~w1.bufnum,lfon/8,phase:phase3,mul:level).abs*SinOsc.ar(lfon/8,phase:phase3)),(lfon/8)*2.pow(low.lag(0.01)/992),(lfon/8).reciprocal))).range(35.264390.degrad,35.264390.degrad.neg).lag(0.01);


					(
	magx=((Complex(cos(((polytope.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((polytope.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magy=((Complex(sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magz=((Complex(cos(((polytope.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((polytope.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magqx=(((Complex(cos(((polytope.theta+mod_anglex)*mq).wrap(pi.neg,pi)),cos(((polytope.theta+mod_anglex)*mq).round(0.00001).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt);



 magqy=((((Complex(sin(((polytope.theta.round(0.00001)+mod_angley)*mq).wrap(pi.neg,pi)),
sin(((polytope.theta.round(0.00001)+mod_angley)*mq).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt));
	);
	 angtheta = polytope.theta;
     angphi = polytope.phi;
	wave = amp*sin((waveFreq * angtheta) + (waveFreq * angphi )- waveSpeed);

					mx=(Cartesian(wave,0,0).rho);
					my=(Cartesian(0,magy,0).rho);
					mz=(Cartesian(0,0,magz).rho);
					mag=(Cartesian(mx,my,mz)) ;

		sph=Spherical(mag.rho,polytope.theta,polytope.phi);

loc1=mx;  loc2=magy;  loc3=magz;

phasex=Complex(1,sph.x).theta*4;
phasey=Complex(1,sph.y).theta*4;
phasez=Complex(1,sph.z).theta*2;


freq1=(fund*ton1)*b_x.lag(0.01);
freq2=(fund*ton2)*b_y.lag(0.01);
freq3=(fund*ton3)*b_z.lag(0.01);

					dr=2.pow(drone.lag(0.1)/12);

f1=(fund*ton1)*b_x.lag(0.01)*dr;
f2=(fund*ton2)*b_y.lag(0.01)*dr;
f3=(fund*ton3)*b_z.lag(0.01)*dr;

amp1=ton1.reciprocal*b_x.reciprocal;
amp2=ton2.reciprocal*b_y.reciprocal;
amp3=ton3.reciprocal*b_z.reciprocal;

g1=b_x.reciprocal*dr.reciprocal*ton1.reciprocal;
g2=b_y.reciprocal*dr.reciprocal*ton2.reciprocal;
g3=b_z.reciprocal*dr.reciprocal*ton3.reciprocal;

band_osc1=SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex).exprange(496,16256);
band_osc2=SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey).exprange(496,16256);
band_osc3=SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez).exprange(496,16256);
band_osc4=SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex.neg).exprange(496,16256);
band_osc5=SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey.neg).exprange(496,16256);
band_osc6=SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez.neg).exprange(496,16256);

rq1=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex,mul:rq).exprange(0.1,1)]);
rq2=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey,mul:rq).exprange(0.1,1)]);
rq3=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez,mul:rq).exprange(0.1,1)]);
rq4=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.01)/992),phase:phasex.neg,mul:rq).exprange(0.1,1)]);
rq5=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.01)/992),phase:phasey.neg,mul:rq).exprange(0.1,1)]);
rq6=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_z*2.pow(band.lag(0.01)/992),phase:phasez.neg,mul:rq).exprange(0.1,1)]);


control1=SinOsc.ar(freq1,phase:phasex,mul:amp1);
control2=SinOsc.ar(freq2,phase:phasey,mul:amp2);
control3=SinOsc.ar(freq3,phase:phasez,mul:amp3);


				//rectifier mod
				/*
BPF.ar(BrownNoise.ar(qq.sqrt.reciprocal),f1*dr,qq,g1/dr));
				)*/

				dr1=(rlx+rla1)/rlx;
				dr2= (rlx+rla2)/rlx;

				(
ds1=((LPF.ar(
(Osc.ar(~w1.bufnum,(f1*dr1.reciprocal),phase:phasex+rph,mul:level).abs*
SinOsc.ar((f1*dr1.reciprocal),phase:phasex+rph)),(f1*dr1.reciprocal)*2.pow(low.lag(0.01)/992),(g1*dr1))).abs
*BPF.ar((SoundIn.ar(0,gain)*qq.sqrt.reciprocal),(f1*dr2.reciprocal),qq,(g1*dr2)));

ds2=((LPF.ar(
(Osc.ar(~w1.bufnum,f2*dr1.reciprocal,phase:phasey+rph,mul:level).abs*
SinOsc.ar((f2*dr1.reciprocal),phase:phasey+rph)),(f2*dr1.reciprocal)*2.pow(low.lag(0.01)/992),(g2*dr1))).abs
*BPF.ar((SoundIn.ar(0,gain)*qq.sqrt.reciprocal),(f2*dr2.reciprocal),qq,(g2*dr2)));

ds3=((LPF.ar(
(Osc.ar(~w1.bufnum,(f3*dr1.reciprocal),phase:phasez+rph,mul:level).abs*
SinOsc.ar((f3*dr1.reciprocal),phase:phasez+rph)),(f3*dr1.reciprocal)*2.pow(low.lag(0.01)/992),(g3*dr1))).abs
*BPF.ar((SoundIn.ar(0,gain)*qq.sqrt.reciprocal),(f3*dr2.reciprocal),qq,(g3*dr2)));
				);

				/*(
ds1=((LPF.ar(
(Osc.ar(~w1.bufnum,(f1*dr1.reciprocal)+SinOsc.ar(dr1,phasex+rph,dr1.reciprocal),phase:phasex+rph,mul:level).abs*
SinOsc.ar((f1*dr1.reciprocal)+SinOsc.ar(dr1,phasex+rph,dr1.reciprocal),phase:phasex+rph)),
						(f1*dr1.reciprocal)*2.pow(low.lag(0.01)/992)+SinOsc.ar(dr1,phasex+rph,dr1.reciprocal),(g1*dr1))).abs
*BPF.ar((SoundIn.ar(0,gain)*qq.sqrt.reciprocal),(f1*dr2.reciprocal)+SinOsc.ar(dr2,phasex+rph,dr2.reciprocal),qq,(g1*dr2)));

ds2=((LPF.ar(
(Osc.ar(~w1.bufnum,(f2*dr1.reciprocal)+SinOsc.ar(dr1,phasey+rph,dr1.reciprocal),phase:phasey+rph,mul:level).abs*
SinOsc.ar((f2*dr1.reciprocal)+SinOsc.ar(dr1,phasey+rph,dr1.reciprocal),phase:phasey+rph)),
						(f2*dr1.reciprocal)*2.pow(low.lag(0.01)/992)+SinOsc.ar(dr1,phasey+rph,dr1.reciprocal),(g2*dr1))).abs
*BPF.ar((SoundIn.ar(0,gain)*qq.sqrt.reciprocal),(f2*dr2.reciprocal)+SinOsc.ar(dr2,phasey+rph,dr2.reciprocal),qq,(g2*dr2)));

ds3=((LPF.ar(
(Osc.ar(~w1.bufnum,(f3*dr1.reciprocal)+SinOsc.ar(dr1,phasez+rph,dr1.reciprocal),phase:phasez+rph,mul:level).abs*
SinOsc.ar((f3*dr1.reciprocal)+SinOsc.ar(dr1,phasez+rph,dr1.reciprocal),phase:phasez+rph)),
						(f3*dr1.reciprocal)*2.pow(low.lag(0.01)/992)+SinOsc.ar(dr1,phasez+rph,dr1.reciprocal),(g3*dr1))).abs
*BPF.ar((SoundIn.ar(0,gain)*qq.sqrt.reciprocal),(f3*dr2.reciprocal)+SinOsc.ar(dr2,phasez+rph,dr2.reciprocal),qq,(g3*dr2)));
				)*/



ds1 = (ds1*2.pow(drive/992)).softclip;
ds2 =  (ds2*2.pow(drive/992)).softclip;
ds3 =  (ds3*2.pow(drive/992)).softclip;

				//sig
sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq1,phase:phasex,mul:level).abs*SinOsc.ar(freq1,phase:phasex)),freq1*2.pow(low.lag(0.01)/992),amp1).abs*(ds1));
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq2,phase:phasey,mul:level).abs*SinOsc.ar(freq2,phase:phasey)),freq2*2.pow(low.lag(0.01)/992),amp2).abs*(ds2));
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq3,phase:phasez,mul:level).abs*SinOsc.ar(freq3,phase:phasez)),freq3*2.pow(low.lag(0.01)/992),amp3).abs*(ds3));

	sig1=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig1,BPF.ar(BRF.ar(sig1,band_osc1.lag(0.1),rq1),band_osc4.lag(0.1),rq4)]);
	sig2=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig2,BPF.ar(BRF.ar(sig2,band_osc2.lag(0.1),rq2),band_osc5.lag(0.1),rq5)]);
	sig3=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig3,BPF.ar(BRF.ar(sig3,band_osc3.lag(0.1),rq3),band_osc6.lag(0.1),rq6)]);


sig1 = (sig1*2.pow(drive/992)).softclip;
sig2 =  (sig2*2.pow(drive/992)).softclip;
sig3 =  (sig3*2.pow(drive/992)).softclip;

threshold1=(((343/0.05)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/0.05)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/0.05)/fund).reciprocal.ampdb/2.sqrt).dbamp;

		sig1=HPF.ar(sig1,80);
		sig2=HPF.ar(sig2, 80);
		sig3=HPF.ar(sig3, 80);

		sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
		sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
		sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);

	///final out

					gain1=gain*rq1.sqrt.reciprocal*cloud.reciprocal*10*namp1;
					gain2=gain*rq2.sqrt.reciprocal*cloud.reciprocal*10*namp2;
					gain3=gain*rq3.sqrt.reciprocal*cloud.reciprocal*10*namp3;

						cloud.do{

					//sp= LFNoise2.ar(6).range(spread*pi.neg, spread*pi);
					//spl= LFNoise2.ar(6).range(spread*(pi/2).neg, spread*(pi/2));
					sp=azf;
					spl=elf;

g_ch1 = (
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[0],~el[0]).x) +
 (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[0],~el[0]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[0],~el[0]).z)
);

g_ch2 = (
   (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[1],~el[1]).x)+
(Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[1],~el[1]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[1],~el[1]).z)
);

g_ch3 = (
  (Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[2],~el[2]).x)+
   (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[2],~el[2]).y)+
  (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[2],~el[2]).z)
);

g_ch4 = (
(Spherical(mx.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
							Spherical(mag.x,~az[3],~el[3]).x) +
 (Spherical(my.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
							Spherical(mag.y,~az[3],~el[3]).y)+
   (Spherical(mz.lag(0.01),(polytope.theta+sp).wrap(pi,pi.neg),(polytope.phi+spl).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
							Spherical(mag.z,~az[3],~el[3]).z)
					);

g_ch1 = g_ch1.pow(spread.reciprocal);
g_ch2 = g_ch2.pow(spread.reciprocal);
g_ch3 = g_ch3.pow(spread.reciprocal);
g_ch4 = g_ch4.pow(spread.reciprocal);

pon1=SinOsc.ar(pon,0).range(0.0001,1).lag(0.1);
pon2=SinOsc.ar(pon,0.25pi).range(0.0001,1).lag(0.1);
pon3=SinOsc.ar(pon,0.5pi).range(0.0001,1).lag(0.1);
pon4=SinOsc.ar(pon,0.75pi).range(0.0001,1).lag(0.1);

(
Out.ar(0,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
	sig1* g_ch1.lag(0.1)*pon1,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01)/cloud);
Out.ar(1,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch2.lag(0.1)*pon2,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01)/cloud);
Out.ar(2,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch3.lag(0.1)*pon3,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01)/cloud);
Out.ar(3,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig1* g_ch4.lag(0.1)*pon4,mix.lag(0.01),room.lag(0.01),mul:gain1)),0.9,0.01)/cloud);

Out.ar(0,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch1.lag(0.1)*pon1,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01)/cloud);
Out.ar(1,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch2.lag(0.1)*pon2,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01)/cloud);
Out.ar(2,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch3.lag(0.1)*pon3,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01)/cloud);
Out.ar(3,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig2* g_ch4.lag(0.1)*pon4,mix.lag(0.01),room.lag(0.01),mul:gain2)),0.9,0.01)/cloud);

Out.ar(0,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch1.lag(0.1)*pon1,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01)/cloud);
Out.ar(1,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch2.lag(0.1)*pon2,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01)/cloud);
Out.ar(2,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch3.lag(0.1)*pon3,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01)/cloud);
Out.ar(3,
Limiter.ar(LeakDC.ar(FreeVerb.ar(
sig3* g_ch4.lag(0.1)*pon4,mix.lag(0.01),room.lag(0.01),mul:gain3)),0.9,0.01)/cloud);
				);

					Out.ar(0,WhiteNoise.ar(0.00001)!4);
			////stereo
					/*(
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*mx.lag(0.01))),0.9,0.01),
						SinOsc.ar(pon,0)));
Out.ar(0,Pan2.ar(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*my.lag(0.01))),0.9,0.01),
						SinOsc.ar(pon,90.degrad)));
Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*mz.lag(0.01))),0.9,0.01)!2);
					)*/

	///three channel
					/*(
Out.ar(4,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*mx.lag(0.01))),0.9,0.01));
Out.ar(5,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*my.lag(0.01))),0.9,0.01));
Out.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*mz.lag(0.01))),0.9,0.01));
					)*/
					////azimuthal multichannel expansion

//Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01),SinOsc.ar(panx,phasex),width:spread));	//Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01),SinOsc.ar(pany,phasey),width:spread));
//Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01),SinOsc.ar(panz,phasez),width:spread));

				/////3d vbap expansion
					//Out.ar(0,VBAP.ar(4,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01),~b,(spx.theta.raddeg+Saw.ar(panx).range(180,180.neg)).wrap(180,180.neg),
				//	(spx.phi.raddeg+SinOsc.ar(panx,phasex).range(90,90.neg)).wrap(90,90.neg),spread:spread));

//Out.ar(0,VBAP.ar(4,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01),~b,(spy.theta.raddeg+Saw.ar(pany).range(180,180.neg)).wrap(180,180.neg),
			//		(spy.phi.raddeg+SinOsc.ar(pany,phasey).range(90,90.neg)).wrap(90,90.neg),spread:spread));

//Out.ar(0,VBAP.ar(4,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01),~b,(spz.theta.raddeg+Saw.ar(panz).range(180,180.neg)).wrap(180,180.neg),
				//	(spz.phi.raddeg+SinOsc.ar(panz,phasez).range(90,90.neg)).wrap(90,90.neg),spread:spread));


///anbisonic decoded on stereo
					//amb_sig1=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01));
					/////amb_sig2=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01));
					//amb_sig3=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01));

					//amb_w=(amb_sig1+amb_sig2+amb_sig3)/2.sqrt;
					//amb_x=amb_sig1;
//					amb_y=amb_sig2;
			//		amb_z=amb_sig3;
//
				//out= Out.ar(0,BFDecode1.ar1(amb_w, amb_x, amb_y, amb_z,
				//		[sph.theta+azf, sph.theta+azf], [sph.phi+elf,sph.phi+elf],2 ));

						azf = (azf+(2pi-(2pi/s))).wrap(pi.neg,pi);
		   elf = (elf+(pi-(pi/s))).wrap((pi/2).neg,(pi/2))
				};

}).add;);
2.wait;


		(

~synthd=Synth.new(\synthd,[\gain,3,\drive,992*2,\fu,16,\tone1,0,\tone2,0,\tone3,0,\low,992*0,\pan,(992*16).neg,
		\mix,0.3,\drone_amp,1,\room,0.5,\m,1,\pann,(992*16).neg,\pon,0.001,\pneuma,0, \namp,1,\rph,0,\rlx,1,\rla1,1,\rla2,3,
			\x,1,\a,1,\panx,0.01,\pany,0.01,\panz,0.01,\spread,1,
			\az,pi/4,\el,pi/8,\azr,992,\dron,0,\drone,1,\sc,1]).register;
);

		(
MIDIClient.init;
MIDIIn.connectAll;

(
					(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
		var drive;
		drive=val.linlin(0,127,(992*1).neg,(992*3)).round(1).asInteger;
		drive.postln;
			if(~synthd.isPlaying,{~synthd.set(\drive,drive)});
					if(~synthd.isPlaying,{~synthd.set(\low,drive)});
},1);
						);

				(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
         var low;
		low=val.linlin(0,127,(992*2).neg,(992*3)).round(1).asInteger;
		low.postln;
					if(~synthd.isPlaying,{~synthd.set(\low,low)});
},2);
	);

									(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var pan;
			pan=val.linlin(0,127,(992*16).neg,(992*5)).round(1).asInteger;
		pan.postln;
							if(~synthd.isPlaying,{~synthd.set(\pan,pan)});
},3);
	);

												(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
		var pann;
			pann=val.linlin(0,127,(992*10).neg,(992*10)).round(1).asInteger;
		pann.postln;
							if(~synthd.isPlaying,{~synthd.set(\pann,pann)});
},4);
	);

														(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
		var dron;
			dron=val.linlin(0,127,0,992*3).round(1).asInteger;
		dron.postln;
							if(~synthd.isPlaying,{~synthd.set(\dron,dron)});
},5);
	);

														(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
		var pon;
			pon=val.linlin(0,127,0.0001,28).round(0.0001);
		pon.postln;
							if(~synthd.isPlaying,{~synthd.set(\pon,pon)});
},6);
	);

														(
MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
		var x;
			x=val.linlin(0,127,1,8).round(1).asInteger;
		x.postln;
							if(~synthd.isPlaying,{~synthd.set(\a,x)});
},7);
	);

																	(
MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
		var spread;
			spread=val.linlin(0,127,1,100).round(0.0001);
		spread.postln;
							if(~synthd.isPlaying,{~synthd.set(\spread,spread)});
},8);
	);


												(
MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
		var panx;
			panx=val.linlin(0,127,0,10).round(1).asInteger;
		panx.postln;
						if(~synthd.isPlaying,{~synthd.set(\tone1,panx)});
},9);
	);

													(
MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
		var pany;
			pany=val.linlin(0,127,0,10).round(1).asInteger;
		pany.postln;
								if(~synthd.isPlaying,{~synthd.set(\tone2,pany)});

},10);
	);

														(
MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
		var panz;
			panz=val.linlin(0,127,0,10).round(1).asInteger;
		panz.postln;
								if(~synthd.isPlaying,{~synthd.set(\tone3,panz)});

},11);
	);

														(
MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
		var az;
			az=val.linlin(0,127,pi.neg,pi).round(0.0001);
		az.postln;
								if(~synthd.isPlaying,{~synthd.set(\az,az)});

},12);
	);

													(
MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|
		var theta;
			theta=val.linlin(0,127,1,992).round(1).asInteger;
		theta.postln;
								if(~synthd.isPlaying,{~synthd.set(\sc,theta)});

},13);
	);

														(
MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|
		var el;
					el=val.linlin(0,127,(pi/2).neg,(pi/2)).round(0.0001);
		el.postln;
								if(~synthd.isPlaying,{~synthd.set(\el,el)});

},14);
	);
															(
MIDIdef.cc(\midi_pot15,{ |val, num, chan, src|
		var mix;
					mix=val.linlin(0,127,0,1).round(0.0001);
		mix.postln;
								if(~synthd.isPlaying,{~synthd.set(\mix,mix)});

},15);
				);

								(
MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|
		var room;
		room=val.linlin(0,127,0,1).round(0.0001);
		room.postln;
								if(~synthd.isPlaying,{~synthd.set(\room,room)});

},16);
	);

	(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
		var a;
				if(val>0,a=1);
a.postln;
							if(~synthd.isPlaying,{~synthd.set(\x, a)});

},33);
	);
	(
MIDIdef.cc(\midi_switch2,{ |val, num, chan, src|
		 var a;
					if(val>0,a=2);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\x, a)});


},34);
	);
		(
MIDIdef.cc(\midi_switch3,{ |val, num, chan, src|
			var a;
					if(val>0,a=3);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\x, a)});


},35);
	);

	(
MIDIdef.cc(\midi_switch4,{ |val, num, chan, src|
         	var a;
				if(val>0,a=4);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\x, a)});


},36);
	);
					(
MIDIdef.cc(\midi_switch5,{ |val, num, chan, src|
		var a;
				if(val>0,a=5);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\x, a)});


},37);
	);
	(
MIDIdef.cc(\midi_switch6,{ |val, num, chan, src|
		 var a;
					if(val>0,a=6);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\x, a)});


},38);
	);
		(
MIDIdef.cc(\midi_switch7,{ |val, num, chan, src|
			var a;
					if(val>0,a=7);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\x, a)});


},39);
	);

	(
MIDIdef.cc(\midi_switch8,{ |val, num, chan, src|
         	var a;
				if(val>0,a=8);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\x, a)});


},40);
	);

	(
MIDIdef.cc(\midi_switch9,{ |val, num, chan, src|
			var a;
					if(val>0,a=0.neg);
a.postln;
							if(~synthd.isPlaying,{~synthd.set(\drone,a)});


},41);
	);

	(
MIDIdef.cc(\midi_switch10,{ |val, num, chan, src|
         	var a;
				if(val>0,a=12.neg);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\drone,a)});
},42);
	);

					(
MIDIdef.cc(\midi_switch11,{ |val, num, chan, src|
		var a;
				if(val>0,a=24.neg);
a.postln;
							if(~synthd.isPlaying,{~synthd.set(\drone,a)});
},43);

	);
	(
MIDIdef.cc(\midi_switch12,{ |val, num, chan, src|
		 var a;
					if(val>0,a=36.neg);
a.postln;
							if(~synthd.isPlaying,{~synthd.set(\drone,a)});
},44);

	);
		(
MIDIdef.cc(\midi_switch13,{ |val, num, chan, src|
			var a;
					if(val>0,a=1);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\m, a)});
},45);
	);

	(
MIDIdef.cc(\midi_switch14,{ |val, num, chan, src|
         	var a;
				if(val>0,a=2);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\m, a)});
},46);
	);

				(
MIDIdef.cc(\midi_switch15,{ |val, num, chan, src|
			var a;
					if(val>0,a=3);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\m, a)});
},47);
	);

	(
MIDIdef.cc(\midi_switch16,{ |val, num, chan, src|
         	var a;
				if(val>0,a=4);
a.postln;
								if(~synthd.isPlaying,{~synthd.set(\m, a)});
},48);
	);
);

									(
MIDIdef.cc(\midi_seq_pot1,{ |val, num, chan, src|
         var s2;
					s2=val.linlin(0,127,1,10).round(1).asInteger;
		s2.postln;
			if(~synthd.isPlaying,{~synthd.set(\waveSpeed,s2)});
},17);
						);

				(
MIDIdef.cc(\midi_seq_pot2,{ |val, num, chan, src|
         var s2;
					s2=val.linlin(0,127,1,10).round(1).asInteger;
		s2.postln;
			if(~synthd.isPlaying,{~synthd.set(\waveFreq,s2)});
},18);
	);

									(
MIDIdef.cc(\midi_seq_pot3,{ |val, num, chan, src|
		var s3;
			s3=val.linlin(0,127,1,11).round(1).asInteger;
		s3.postln;
		if(~synthd.isPlaying,{~synthd.set(\rlx,s3)});
},19);
	);

												(
MIDIdef.cc(\midi_seq_pot4,{ |val, num, chan, src|
		var s4;
			s4=val.linlin(0,127,0,10).round(1).asInteger;
		s4.postln;
		if(~synthd.isPlaying,{~synthd.set(\rla1,s4)});
},20);
	);

														(
MIDIdef.cc(\midi_seq_pot5,{ |val, num, chan, src|
		var s5;
			s5=val.linlin(0,127,1,11).round(1).asInteger;
		s5.postln;
		if(~synthd.isPlaying,{~synthd.set(\rla2,s5)});
},21);
	);


			(
MIDIdef.cc(\midi_slider1,{ |val, num, chan, src|
		var gain;
	gain=val.linlin(0,127,0,100).round(0.00001);
		gain.postln;
							if(~synthd.isPlaying,{~synthd.set(\gain,gain)});
},49);
			);

											(
MIDIdef.cc(\midi_slider2,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
		if(~synthd.isPlaying,{~synthd.set(\amp,th)});
},25);

	);

					(
MIDIdef.cc(\midi_slider6,{ |val, num, chan, src|
			var spread;
			spread=val.linlin(0,0,0,1).round(1).asInteger;
		spread.postln;
					if(~synthd.isPlaying,{~synthd.set(\qqq,spread)});

},29);
			);
							(
MIDIdef.cc(\midi_slider7,{ |val, num, chan, src|
	var spread;
			spread=val.linlin(0,127,0,137.5.degrad).round(0.00001);
		spread.postln;
		if(~synth.isPlaying,{~synthd.set(\rph,spread)});
},30);
	);

(
MIDIdef.cc(\midi_slider8,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.000001,0.0001).round(0.0000000001);
		th.postln;
							if(~synthd.isPlaying,{~synthd.set(\qq,th)});
},31);
	);


				(
MIDIdef.cc(\midi_seq_pot6,{ |val, num, chan, src|
		var s6;
						s6=val.linlin(0,127,0,10).round(1).asInteger;
		s6.postln;
		~s1=s6;
},22);
	);

														(
MIDIdef.cc(\midi_seq_pot7,{ |val, num, chan, src|
		var s7;
			s7=val.linlin(0,127,0,10).round(1).asInteger;
		s7.postln;
		~s2=s7;
},23);
	);

																	(
MIDIdef.cc(\midi_seq_pot8,{ |val, num, chan, src|
		var s8;
			s8=val.linlin(0,127,0,10).round(1).asInteger;
		s8.postln;
		~s3=s8;
},24);
	);
			(
MIDIdef.cc(\midi_slider2,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0,10).round(1).asInteger;
		th.postln;
~s4=th;
},26);
	);

														(
MIDIdef.cc(\midi_slider3,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0,10).round(1).asInteger;
		th.postln;
~s5=th;

},27);
	);
(
MIDIdef.cc(\midi_slider4,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0,10).round(1).asInteger;
		th.postln;
~s6=th;
},28);
	);
			(
MIDIdef.cc(\midi_slider9,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0,10).round(1).asInteger;
		th.postln;
~s7=th;
},32);
			)
		);



	});
	Tdef(\drone).play;
}
)
)





s.record(numChannels:4)

(
	TempoClock.default.tempo_(3);
///sequencer
({
			var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=8.reciprocal,beat=1,r=0;
			~r=0;		~r1=0;		~r2=0;
				(

			~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~dur=[];

					1.do{
~x=bank.collect{
m1=m1+1;
					b=Spherical(beat,~az.[m1],~el.[m1]).rotate(~r).tilt(~r1).tumble(~r2).x.round(0.00001);
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~az.[m2],~el.[m2]).rotate(~r).tilt(~r1).tumble(~r2).y.round(0.00001);
	2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~az.[m3],~el.[m3]).rotate(~r).tilt(~r1).tumble(~r2).z.round(0.00001);
	2.pow(d).round(time);
}; m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };

				bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
		//	~durx = ~dur1.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
			//	~dury = ~dur2.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
			//	~durz = ~dur3.collect { |x| if (x == 0) { Rest(2) } { x }};

			~dur=~dur++~dur1++~dur2++~dur3;
);
		}.value);

				~seqen= Pseq(~dur ,inf).asStream;


		(
	~str1= Routine({loop{



	~synthd.set(\tone1, ~s1);
~synthd.set(\tone2, ~s1);
	~synthd.set(\tone3, ~s1);
    ~seqen.next.wait;

		~synthd.set(\tone1, ~s2);
~synthd.set(\tone2, ~s2);
	~synthd.set(\tone3, ~s2);

	    ~seqen.next.wait;

	~synthd.set(\tone1, ~s3);
~synthd.set(\tone2, ~s3);
	~synthd.set(\tone3, ~s3);

	    ~seqen.next.wait;

	~synthd.set(\tone1, ~s4);
~synthd.set(\tone2, ~s4);
	~synthd.set(\tone3, ~s4);

	    ~seqen.next.wait;

				~synthd.set(\tone1, ~s5);
~synthd.set(\tone2, ~s5);
	~synthd.set(\tone3, ~s5);

	    ~seqen.next.wait;

	~synthd.set(\tone1, ~s6);
~synthd.set(\tone2, ~s6);
		~synthd.set(\tone3, ~s6);

	    ~seqen.next.wait;

	~synthd.set(\tone1, ~s7);
~synthd.set(\tone2, ~s7);
	~synthd.set(\tone3, ~s7);

	    ~seqen.next.wait;

};
		}));

)
	~str1.play;


////musical automaton

(
	TempoClock.default.tempo_(1);
		~val=1234;
		(
	~str1= Routine({
			var m1,m2,m3,r1,r2,r3,sphm,sphr,time=1/4,melody,rhythm,az,el;

				loop{
						thisThread.randSeed = ~val;
					rhythm=exp(Complex(0,1)*((1/992)*2pi)*992.rand);
					az=Complex(1,rhythm.real).theta*4;   el=Complex(1,rhythm.imag).theta*2;
					melody=Spherical(5,az,el);
				r1=2.pow(rhythm.real.abs).round(time);  r2=2.pow(rhythm.imag.abs).round(time); // r3=2.pow(rhythm.z).round(time);
					m1=melody.x.round(1);  	m2=melody.y.round(1);  	m3=melody.z.round(1);
					sphm=[m1.abs,m2.abs,m3.abs];   sphr=[r1,r2];

		~synth.set(\tone1,sphm.[0]);
~synth.set(\tone2,sphm.[1]);
	~synth.set(\tone3,sphm.[2]);

					sphr.[0].wait;

		~synth.set(\tone1,sphm.[0]);
~synth.set(\tone2,sphm.[1]);
	~synth.set(\tone3,sphm.[2]);

	sphr.[1].wait;

};
		}));

)

			~str1.play;


/*
/tetrahedron
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
//////cube
(
~az=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////octahedron

(
~az=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
)

//////icosahedron
(
~az=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~el=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)

/////dodecahedron

(
~az=[45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,
	90.neg.degrad,69.09.degrad,110.91.degrad,110.91.neg.degrad,69.09.neg.degrad,0.degrad,180.degrad];

~el=[35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,69.09.neg.degrad,69.09.neg.degrad,20.91.neg.degrad,20.91.neg.degrad,
	35.26.degrad,35.26.degrad,35.26.degrad,35.26.degrad,69.09.degrad,69.09.degrad,0.degrad,0.degrad,0.degrad,0.degrad,20.91.degrad,20.91.degrad]
)

/////Rhombic dodecahedron//// hull

(
~az=[0.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,0.degrad,180.degrad,90.degrad,90.neg.degrad,0.degrad,
	45.degrad,135.neg.degrad,135.degrad,45.neg.degrad];
~el=[90.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,0.degrad
	,0.degrad,0.degrad,0.degrad,90.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////cuboctahedron//// core

(
~az=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~el=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)


///////////////Rhombic Triacontahedron//// hull
(
~az=[0.degrad,0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,0.degrad];

~el=[90.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,90.degrad];

)

///////icosidodecahedron//// core
(
~az=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~el=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];

)*/

