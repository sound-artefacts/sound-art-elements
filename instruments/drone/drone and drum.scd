

(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*4;
s.options.blockSize = 64;
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
s.freqscope;
s.scope;
//s.makeWindow;
s.meter;
	Tdef(\drone, {
	Buffer.freeAll;
////sesor ased randomnes
//SerialPort.devices;
//~port = SerialPort.new("/dev/cu.usbserial-210",9600)

/*(
~charArray = [];
~getValues = Routine.new({

	var ascii;
	{ascii = ~port.read.asAscii;
		if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $a,{~val = ~charArray.collect(_.digit).convertDigits;
			~charArray =[];
		});
	}.loop;

}).play;
);*/

		///vbap

		///octahedron
		(
~az=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
);

(
~a = VBAPSpeakerArray.new(3,
[[~az.[0],~el.[0]], [~az.[1],~el.[1]], [~az.[2],~el.[2]], [~az.[3],~el.[3]],[~az.[4],~el.[4]],[~az.[5],~el.[5]]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);


///animation buses
		~controlBus_1a = Bus.control(s, 1);
		~controlBus_2a = Bus.control(s, 1);
		~controlBus_3a = Bus.control(s, 1);

	//	~controlBus_1b = Bus.control(s, 1);
	//	~controlBus_2b = Bus.control(s, 1);
	//	~controlBus_3b = Bus.control(s, 1);

	//	~controlBus_1c = Bus.control(s, 1);
	//	~controlBus_2c = Bus.control(s, 1);
		//~controlBus_3c = Bus.control(s, 1);

	//	~controlBus_1d = Bus.control(s, 1);
	//	~controlBus_2d = Bus.control(s, 1);
	//	~controlBus_3d = Bus.control(s, 1);

	//	~controlBus_1e = Bus.control(s, 1);
	//	~controlBus_2e = Bus.control(s, 1);
	//	~controlBus_3e = Bus.control(s, 1);

	//	~controlBus_1f = Bus.control(s, 1);
	//	~controlBus_2f = Bus.control(s, 1);
	//	~controlBus_3f = Bus.control(s, 1);

	//	~controlBus_1g = Bus.control(s, 1);
	//	~controlBus_2g = Bus.control(s, 1);
	//	~controlBus_3g = Bus.control(s, 1);

	//	~controlBus_1k = Bus.control(s, 1);
	//	~controlBus_2k = Bus.control(s, 1);
	//	~controlBus_3k = Bus.control(s, 1);

		~controlBus_x = Bus.control(s, 1);
		~controlBus_y = Bus.control(s, 1);
		~controlBus_z = Bus.control(s, 1);

////// wavetables

		//oscillator table
		(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~n=(0-(pi/496)); ~ph=992.collect{~n=~n+(pi/496);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);


		(
~w1= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
	signal=Signal.sineFill(~signalSize,~array,~ph);

wt = signal.asWavetable;
~w1.loadCollection(wt);
//signal.plot;
		}.value;
);


		/////distortion table
		(
		~transfer_function= Env([0.8.neg,0,0.8],[1,1],[8,8.neg]).asSignal(1024);
			~transfer_function=~transfer_function+(Signal.sineFill(~signalSize,~array,~ph)/8);
		~transfer_function=~transfer_function.normalize;
		//	~transfer_function.plot;
			~dist=Buffer.loadCollection(s,~transfer_function.asWavetableNoWrap);
		);

		////sound

(
SynthDef.new(\synth,{

	arg gain=1,low=992,tone=0,dron=0,x=1,pan=1,mix=0.3,a=1,panx=1,pany=1,panz=1,room=0.5,m=2,
				fu=32,drive=1,spread=1,drone_amp=1,rz=100,pann=0,az=0,el=0,azr=0;

	var rq=1,cloud=31,attack,decay,curve,band,azf=0,elf=0,q,r1,r2,r3,sq1,sq2,sq3,rotationx,rotationy,rotationz,core=(9/8).rand;
	var lamdoma,freq1,freq2,freq3,fund,amp1,amp2,amp3,alpha,cell_az,cell_el,x_pos,y_pos,control1,control2,control3;
	var sig1,sig2,bank=6,out1,out2,band_osc1,band_osc2,ton,threshold1,threshold2,threshold3,phase1,phase2,phase3;
	var band_osc3,band_osc4,band_osc5,band_osc6,sig3,out3,cell_tria,b_x,b_y,b_z,polytope,gain1,gain2,gain3,env,azimuth,elevation;
	var magx,magy,magz,magqx,magqy,mod_anglex,anglex,angley,anglez,phasex,phasey,phasez,rq1,rq2,rq3,rq4,rq5,rq6;
	var mod_angley,mod_anglez,mx,my,mz,mqx,mqy,mag,magq,mq=(m-1),lfo,sph;
	var loc1,loc2,loc3,axis1,axis2,axis3,g=((1+5.sqrt)/2),s=(1+2.sqrt),tensor;
	var amb_w,amb_x,amb_y,amb_z,out,amb_sig1,amb_sig2,amb_sig3,axisx,axisy,axisz,cx,cy,cz;
	var axi1,axi2,axi3,ds1,ds2,ds3,f1,f2,f3,g1,g2,g3,sph_object,lfon,spx,spy,spz,axis;
	var  axisx1=1,axisy1=1,axisz1=1,axisx2=1,axisy2=1,axisz2=1,axisx3=1,axisy3=1,axisz3=1,v1,v2,cross;

fund=fu*(9/8);
lamdoma=(x.lag(0.01)+a.lag(0.01))/x.lag(0.01);
				ton=2.pow((tone.lag(0.01))/56).round(0.0001)*2.pow(dron.lag.(0.01)/56);

						lfo=2.pow(pan/992);
				lfon=2.pow(pann/992);
					band=pan;

				spx=Spherical(1,az,el);spy=Spherical(1,azr,el);
				//spz=Spherical(1,az,(el+elr).wrap((pi/2).neg,(pi/2)));

				v1=[spx.x,spx.y,spx.z]; v2=[spy.x,spy.y,spy.z];

cross = [
    v1[1]*v2[2] - v1[2]*v2[1],  // x component
    v1[2]*v2[0] - v1[0]*v2[2],  // y component
    v1[0]*v2[1] - v1[1]*v2[0]   // z component
];
				spz=Cartesian(cross.[0],cross.[1],cross.[2]);


				//axisx=[axisx1,axisy1,axisz1];
				//axisy=[axisx2,axisy2,axisz2];
				//axisz=[axisx3,axisy3,axisz3];

				axisx=[spx.x,spx.y,spx.z];
				axisy=[spy.x,spy.y,spy.z];
				axisz=[spz.x,spz.y,spz.z];

				tensor=axisx+axisy+axisz;

				sph_object=Cartesian(tensor.[0],tensor.[1],tensor.[2]);


				cloud.do{

				axis=Spherical(992,(sph_object.theta+azf).wrap(pi,pi.neg),  (sph_object.phi+elf).wrap((pi/2),(pi/2).neg));

				polytope=Cartesian(axis.x,axis.y,axis.z);

b_x=2.pow(polytope.x.round(0.0001)/992);
b_y=2.pow(polytope.y.round(0.0001)/992);
b_z=2.pow(polytope.z.round(0.0001)/992);


anglex=(exp(Complex(0,1)*polytope.theta).real*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
angley=(exp(Complex(0,1)*polytope.theta).imag*exp(Complex(0,1)*polytope.phi).real).round(0.00001);
anglez=(exp(Complex(0,1)*polytope.phi).imag).round(0.00001);

phase1=Complex(1,anglex).theta;
phase2=Complex(1,angley).theta;
phase3=Complex(1,anglez).theta;


mod_anglex=SinOsc.ar(lfon,phase1).range(pi.neg,pi);
					mod_angley=SinOsc.ar(lfon*(2/3),phase2).range(pi.neg,pi);
					mod_anglez=SinOsc.ar(lfon*(1/2),phase3).range((pi/2).neg,(pi/2));

					(
		magx=((Complex(cos(((polytope.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((polytope.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magy=((Complex(sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
		(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt));
				);

magz=((Complex(cos(((polytope.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((polytope.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

/*magqx=((((Complex(cos(((polytope.theta.round(0.00001)+mod_angle)*mq).wrap(pi.neg,pi)),
cos(((polytope.theta.round(0.00001)+mod_angle)*mq).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);

 magqy=((((Complex(sin(((polytope.theta.round(0.00001)+mod_angle1)*mq).wrap(pi.neg,pi)),
sin(((polytope.theta.round(0.00001)+mod_angle1)*mq).wrap(pi.neg,pi))))*
(Complex(sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((polytope.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);*/
	);

					mx=(Cartesian(magx,0,0).rho);     //mqx=(Cartesian(magqx,0,0).rho);
					my=(Cartesian(0,magy,0).rho);      //mqy=(Cartesian(0,magqy,0).rho);
					mz=(Cartesian(0,0,magz).rho);
					mag=(Cartesian(magx,magy,magz).rho);	  //magq=(Cartesian(magqx,magqy,0).rho);


		sph=Spherical(mag,polytope.theta,polytope.phi);

	//	loc1=sph.x;  loc2=sph.y;  loc3=sph.z;
					loc1=mx;  loc2=my;  loc3=mz;

phasex=Complex(1,mx.value).theta;
phasey=Complex(1,my.value).theta;
phasez=Complex(1,mz.value).theta;


freq1=(fund*ton)*b_x.lag(0.01)*lamdoma;
freq2=(fund*ton)*b_y.lag(0.01)*lamdoma;
freq3=(fund*ton)*b_z.lag(0.01)*lamdoma;

f1=(fund)*b_x.lag(0.01)*lamdoma;
f2=(fund)*b_y.lag(0.01)*lamdoma;
f3=(fund)*b_z.lag(0.01)*lamdoma;

amp1=ton.reciprocal*b_x.reciprocal*lamdoma.reciprocal;
amp2=ton.reciprocal*b_y.reciprocal*lamdoma.reciprocal;
amp3=ton.reciprocal*b_z.reciprocal*lamdoma.reciprocal;

g1=b_x.reciprocal*lamdoma.reciprocal;
g2=b_y.reciprocal*lamdoma.reciprocal;
g3=b_z.reciprocal*lamdoma.reciprocal;


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

ds1=(LPF.ar((Osc.ar(~w1.bufnum,f1,phase:phasex,mul:rz).abs*SinOsc.ar(f1,phase:phasex)),f1*2.pow(low.lag(0.01)/992),g1/drone_amp));
ds2=(LPF.ar((Osc.ar(~w1.bufnum,f2,phase:phasey,mul:rz).abs*SinOsc.ar(f2,phase:phasey)),f2*2.pow(low.lag(0.01)/992),g2/drone_amp));
ds3=(LPF.ar((Osc.ar(~w1.bufnum,f3,phase:phasez,mul:rz).abs*SinOsc.ar(f3,phase:phasez)),f3*2.pow(low.lag(0.01)/992),g3/drone_amp));

					sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq1,phase:phasex,mul:rz).abs*SinOsc.ar(freq1,phase:phasex)),freq1*2.pow(low.lag(0.01)/992),amp1)+ds1);
					sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq2,phase:phasey,mul:rz).abs*SinOsc.ar(freq2,phase:phasey)),freq2*2.pow(low.lag(0.01)/992),amp2)+ds2);
					sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq3,phase:phasez,mul:rz).abs*SinOsc.ar(freq3,phase:phasez)),freq3*2.pow(low.lag(0.01)/992),amp3)+ds3);

	sig1=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig1,BPF.ar(BRF.ar(sig1,band_osc1.lag(0.1),rq1),band_osc4.lag(0.1),rq4)]);
	sig2=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig2,BPF.ar(BRF.ar(sig2,band_osc2.lag(0.1),rq2),band_osc5.lag(0.1),rq5)]);
	sig3=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig3,BPF.ar(BRF.ar(sig3,band_osc3.lag(0.1),rq3),band_osc6.lag(0.1),rq6)]);

threshold1=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/0.3)/fund).reciprocal.ampdb/2.sqrt).dbamp;

		sig1=HPF.ar(sig1,50);
		sig2=HPF.ar(sig2, 50);
		sig3=HPF.ar(sig3, 50);

		sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15);
		sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15);
		sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15);

	///distortion

	sig1 = sig1.softclip.distort; sig2 = sig2.softclip.distort;  sig3 = sig3.softclip.distort;

		sig1 = (tanh(sig1*2.pow(drive/992))) / (1 + (tanh(sig1*2.pow(drive/992))).abs);

		sig2 =  (tanh(sig2*2.pow(drive/992))) / (1 + (tanh(sig2*2.pow(drive/992))).abs);

	sig3 =  (tanh(sig3*2.pow(drive/992))) / (1 + (tanh(sig3*2.pow(drive/992))).abs);


	///final out
					gain1=gain*rq1.sqrt.reciprocal;
					gain2=gain*rq2.sqrt.reciprocal;
					gain3=gain*rq3.sqrt.reciprocal;

					///three channel
				//	Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01));
				//	Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01));
				//	Out.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01));

					////azimuthal multichannel expansion

		Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01),SinOsc.ar(panx,phasex),width:spread));
		Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01),SinOsc.ar(pany,phasey),width:spread));
		Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01),SinOsc.ar(panz,phasez),width:spread));

				///3d vbap expansion
//Out.ar(0,VBAP.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01),~b,spx.theta.raddeg,spx.phi.raddeg,width:spread));
//Out.ar(0,VBAP.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01),~b,spy.theta.raddeg,spy.phi.raddeg,width:spread));
//Out.ar(0,VBAP.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01),~b,spz.theta.raddeg,spz.phi.raddeg,width:spread));


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


	///animation control buses out

	//		Out.kr(~controlBus_1a, A2K.kr(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01)*100));
		//	Out.kr(~controlBus_2a, A2K.kr(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01)*100));
		//	Out.kr(~controlBus_3a, A2K.kr(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01)*100));

			//Out.kr(~controlBus_x, mod_anglex);
		//	Out.kr(~controlBus_y, mod_angley);
		//	Out.kr(~controlBus_z, mod_anglez);


						azf = (azf+(2pi-(2pi/s))).wrap(pi.neg,pi);
		   elf = (elf+(pi-(pi/s))).wrap((pi/2).neg,(pi/2))
				};

}).add;);

10.wait;

		//////kick

 (
SynthDef(\kick, {
	arg gain=1/8,tone=12,pan=1,low=0,noise=0.001,decay=1/2,attack=0.001,az=0,azr=0,el=0,m=1,rz=100,
			fu=32,mix=1,room=1,drive=1,panx=1,pany=1,panz=1,spread=1;
    var env,freq,anglex,angley,anglez,mod_anglex,mod_angley,mod_anglez,mx,my,mz,magx,magz,magy;
	var sph,phase,threshold,ton,phase1,phase2,phase3,sph1,loc1,loc2,loc3,mag,fund,freqq;
	var sig1,sig2,sig3,phasex,phasey,phasez,control1,control2,control3,axis1,axis2,axis3,lfo;
	var amb_w,amb_x,amb_y,amb_z,out,amb_sig1,amb_sig2,amb_sig3,axisx,axisy,axisz,az1,az2,az3,el1,el2,el3,cx,cy,cz,tensor;
	var axi1,axi2,axi3,ds1,ds2,ds3,f1,f2,f3,g1,g2,g3,sph_object,lfon,spx,spy,spz,axis;
	var  axisx1=1,axisy1=1,axisz1=1,axisx2=1,axisy2=1,axisz2=1,axisx3=1,axisy3=1,axisz3=1,v1,v2,cross;


			ton=2.pow(tone/992);
					fund=fu*(9/8);
	freqq = fund*ton;
					lfo=2.pow(pan/992);

				spx=Spherical(1,az,el);spy=Spherical(1,azr,el);

				v1=[spx.x,spx.y,spx.z]; v2=[spy.x,spy.y,spy.z];

cross = [
    v1[1]*v2[2] - v1[2]*v2[1],
    v1[2]*v2[0] - v1[0]*v2[2],
    v1[0]*v2[1] - v1[1]*v2[0]
];
				spz=Cartesian(cross.[0],cross.[1],cross.[2]);

				axisx=[spx.x,spx.y,spx.z];
				axisy=[spy.x,spy.y,spy.z];
				axisz=[spz.x,spz.y,spz.z];

				tensor=axisx+axisy+axisz;

				sph_object=Cartesian(tensor.[0],tensor.[1],tensor.[2]);


				freq = EnvGen.kr(Env([freqq, fund], [decay*2], curve: -8)); // pitch drop
	env= EnvGen.kr(Env.perc(attack, decay, curve: -4),doneAction:2,levelScale:gain*ton.reciprocal);

			threshold=(((343/0.3)/freq).reciprocal.ampdb/2.sqrt).dbamp;


					axis=Spherical(992,sph_object.theta, sph_object.phi);

				sph=Cartesian(axis.x,axis.y,axis.z);


anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;

phase1=Complex(1,anglex).theta;
phase2=Complex(1,angley).theta;
phase3=Complex(1,anglez).theta;

mod_anglex=SinOsc.ar(lfo,phase1).range(pi.neg,pi);
mod_angley=SinOsc.ar(lfo,phase2).range(pi.neg,pi);
mod_anglez=SinOsc.ar(lfo,phase3).range((pi/2).neg,(pi/2));

magx=((Complex(cos(((sph.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((sph.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
	(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magy=((Complex(sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
		(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magz=((Complex(cos(((sph.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((sph.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

mx=(Cartesian(magx.value,0,0).rho);my=(Cartesian(0,magy.value,0).rho);mz=(Cartesian(0,0,magz.value).rho);

phasex=Complex(1,mx.value).theta;
phasey=Complex(1,my.value).theta;
phasez=Complex(1,mz.value).theta;
									mag=(Cartesian(magx.value,magy.value,magz.value).rho);
									sph1=Spherical(mag,sph.theta,sph.phi);

		//	loc1=sph1.x;  loc2=sph1.y;  loc3=sph1.z;
					loc1=mx;  loc2=my;  loc3=mz;

sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasex,mul:rz).abs*SinOsc.ar(freq,phase:phasex)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal))*drive.reciprocal;
sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasey,mul:rz).abs*SinOsc.ar(freq,phase:phasey)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal))*drive.reciprocal;
sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phasez,mul:rz).abs*SinOsc.ar(freq,phase:phasez)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal))*drive.reciprocal;

control1=SinOsc.ar(freq,phasex,ton.reciprocal)*env;
control2=SinOsc.ar(freq,phasey,ton.reciprocal)*env;
control3=SinOsc.ar(freq,phasez,ton.reciprocal)*env;

sig1 = sig1 + (sig1 * BrownNoise.ar(noise*loc1)); sig2 = sig2 + (sig2 * BrownNoise.ar(noise*loc2)); sig3 = sig3 + (sig3 * BrownNoise.ar(noise*loc3));


		sig1=HPF.ar(sig1,50); sig2=HPF.ar(sig2, 50);sig3=HPF.ar(sig3, 50);
		sig1=Compander.ar(sig1,control1,threshold,1.2,1/3,0.03,0.15);
		sig2=Compander.ar(sig2,control2,threshold,1.2,1/3,0.03,0.15);
		sig3=Compander.ar(sig3,control3,threshold,1.2,1/3,0.03,0.15);
		sig1=tanh(sig1*drive);sig2=tanh(sig2*drive);sig3=tanh(sig2*drive);


	//amb_sig1= Limiter.ar(LeakDC.ar(FreeVerb.ar((sig1),mix.lag(0.01),room.lag(0.01),mul:env*loc1.abs)),0.9,0.01);
	/////amb_sig2=Limiter.ar( LeakDC.ar(FreeVerb.ar((sig2),mix.lag(0.01),room.lag(0.01),mul:env*loc2.abs)),0.9,0.01);
	//amb_sig3=Limiter.ar( LeakDC.ar(FreeVerb.ar((sig3),mix.lag(0.01),room.lag(0.01),mul:env*loc3.abs)),0.9,0.01);

			//				amb_w=(amb_sig1+amb_sig2+amb_sig3)/2.sqrt;
				//	amb_x=amb_sig1;
				///	amb_y=amb_sig2;
				////	amb_z=amb_sig3;

				///	out= Out.ar(0,BFDecode1.ar1(amb_w, amb_x, amb_y, amb_z, [sph1.theta, sph1.theta], [sph1.phi,sph1.phi],4 ));



//Out.ar(0,VBAP.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:env*loc1.abs)),0.9,0.01),~b,spx.theta.raddeg,spx.phi.raddeg,width:spread));
//Out.ar(0,VBAP.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:env*loc2.abs)),0.9,0.01),~b,spy.theta.raddeg,spy.phi.raddeg,width:spread));
//Out.ar(0,VBAP.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:env*loc3.abs)),0.9,0.01),~b,spz.theta.raddeg,spz.phi.raddeg,width:spread));

			// Out.kr(~controlBus_1.index,A2K.kr(sig1*env*loc1.abs*1000));
			//	Out.kr(~controlBus_2.index,A2K.kr(sig2*env*loc2.abs*1000));
			//	Out.kr(~controlBus_3.index,A2K.kr(sig3*env*loc3.abs*1000));

					//Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig1 ),mix.lag(0.01),room.lag(0.01),mul:env*loc1.abs)),0.9,0.01));
				///Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig2),mix.lag(0.01),room.lag(0.01),mul:env*loc2.abs)),0.9,0.01));
					//	Out.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig3),mix.lag(0.01),room.lag(0.01),mul:env*loc3.abs)),0.9,0.01));

			Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig1 ),mix.lag(0.01),room.lag(0.01),mul:env*loc1.abs)),0.9,0.01),SinOsc.ar(panx,phasex),width:spread));
			Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig2),mix.lag(0.01),room.lag(0.01),mul:env*loc2.abs)),0.9,0.01),SinOsc.ar(pany,phasey),width:spread));
			Out.ar(0,PanAz.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar((sig3),mix.lag(0.01),room.lag(0.01),mul:env*loc3.abs)),0.9,0.01),SinOsc.ar(panz,phasez),width:spread));


}).add);

	10.wait;
	/////solid
(

///quaterion rhtyhm solid rotation
/*(var i=Quaternion(0,
axis_xyz.[0], 0, 0),j=Quaternion(0, 0, axis_xyz.[1], 0),k=Quaternion(0, 0, 0, axis_xyz.[2]);

axis=i+j+k;
~x1=tetrahedron.collect{
	plx1=plx1+1;
	qx1=Quaternion(0,Spherical(1,~az1[plx1],~el1[plx1]).x.round(0.00001),Spherical(1,~az1[plx1],~el1[plx1]).y.round(0.00001),Spherical(1,~az1[plx1],~el1[plx1]).z.round(0.00001));
	rotor_a=((axis*exp(Complex(0,1)*angle_a.degrad).imag)+exp(Complex(0,1)*angle_a.degrad).real); ax=rotor_a*qx1*rotor_a.conjugate;
	ax.b.round(0.00001);
};
)*/

	////durs
	({var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=6,time=32.reciprocal,beat=1,r=0;

~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[];

					3.do{
~x=bank.collect{
m1=m1+1;
					b=Spherical(beat,~az.[m1],~el.[m1]).rotate(r).tilt(r).tumble(r).x.round(0.00001);
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~az.[m2],~el.[m2]).rotate(r).tilt(r).tumble(r).y.round(0.00001);
	2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~az.[m3],~el.[m3]).rotate(r).tilt(r).tumble(r).z.round(0.00001);
	2.pow(d).round(time);
}; m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };

				18.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
		18.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
		18.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
	//	bank.do{~durs=~durs++~x.[n]++~y.[n]++~z.[n];n=n+1;}
//	~dur = ~duri.collect { |x|
  //  if (x == 0) { Rest(2) } { x }
//	}
}.value;
);


	(
				//	thisThread.randSeed = ~val;

		~dr=Pdef(\1, Pbind(\instrument, \kick,
			\dur,Pseq(~dur1,inf),
				\gain,0,
				\tone,992*0,
				\pan,992*1,
					\m,1,
			\low,0,
				\noise,0.0001,
\az,pi/4,
	\azr,pi/2,
	\el,pi/2,
				\decay,2,
				\attack,0.001,
					\spread,4,
					\panx,1,
	\pany,1,
	\panz,1,

					\rz,100,
					\mix,0.2,
					\room,0.5;
		))
);


);


	});
	Tdef(\drone).play;
}
)
)

\

TempoClock.default.tempo_(2);





(
~synth=Synth.new(\synth,[\gain,1,\drive,992,\fu,32,\tone,0,\low,992*0,\pan,(992*16).neg,
		\mix,0.3,\drone_amp,1,\rz,100,\room,0.5,\m,1,\pann,(992*3).neg,
			\x,1,\a,1,\panx,1,\pany,1,\panz,1,\spread,1,
			\az,0,\el,0,\azr,0,\dron,0]).register;
)
~dr.play;


(
MIDIClient.init;
MIDIIn.connectAll;

(
					(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
		var drive;
		drive=val.linlin(0,127,(992*1).neg,(992*16)).round(1).asInteger;
		drive.postln;
		if(~synth.isPlaying,{~synth.set(\drive,drive)});
},16);
						);

				(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
         var low;
		low=val.linlin(0,127,(992*4).neg),(992*4)).round(1).asInteger;
		low.postln;
		if(~synth.isPlaying,{~synth.set(\low,low)});
},20);
	);

									(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var pan;
			pan=val.linlin(0,127,(992*16).neg,(992*8)).round(1).asInteger;
		pan.postln;
		if(~synth.isPlaying,{~synth.set(\pan,pan)});
},24);
	);

												(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
		var pann;
			pann=val.linlin(0,127,(992*16).neg,(992*4)).round(1).asInteger;
		pann.postln;
		if(~synth.isPlaying,{~synth.set(\pann,pann)});
},28);
	);

														(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
		var dron;
			dron=val.linlin(0,127,0,56*4).round(1).asInteger;
		dron.postln;
		if(~synth.isPlaying,{~synth.set(\dron,dron)});
},46);
	);

														(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
		var drone_amp;
			drone_amp=val.linlin(0,127,1,100).round(0.0001);
		drone_amp.postln;
		if(~synth.isPlaying,{~synth.set(\drone_amp,drone_amp)});
},50);
	);

														(
MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
		var x;
			x=val.linlin(0,127,1,16).round(1).asInteger;
		x.postln;
		if(~synth.isPlaying,{~synth.set(\x,x)});
},54);
	);

																	(
MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
		var spread;
			spread=val.linlin(0,127,0,100).round(0.0001);
		spread.postln;
		if(~synth.isPlaying,{~synth.set(\spread,spread)});
},58);
	);


												(
MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
		var panx;
			panx=val.linlin(0,127,1,3).round(0.0001);
		panx.postln;
		if(~synth.isPlaying,{~synth.set(\panx,panx)});
},17);
	);

													(
MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
		var pany;
			pany=val.linlin(0,127,1,3).round(0.0001);
		pany.postln;
		if(~synth.isPlaying,{~synth.set(\pany,pany)});
},21);
	);

														(
MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
		var panz;
			panz=val.linlin(0,127,1,3).round(1).asInteger;
		panz.postln;
		if(~synth.isPlaying,{~synth.set(\panz,panz)});
},25);
	);

														(
MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
		var az;
			az=val.linlin(0,127,pi.neg,pi).round(0.0001);
		az.postln;
		if(~synth.isPlaying,{~synth.set(\az,az)});
},29);
	);

													(
MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|
		var azr;
			azr=val.linlin(0,127,pi.neg,pi).round(0.0001);
		azr.postln;
		if(~synth.isPlaying,{~synth.set(\azr,azr)});
},47);
	);

														(
MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|
		var el;
					el=val.linlin(0,127,(pi/2).neg,(pi/2)).round(0.0001);
		el.postln;
		if(~synth.isPlaying,{~synth.set(\el,el)});
},51);
	);
															(
MIDIdef.cc(\midi_pot15,{ |val, num, chan, src|
		var mix;
					mix=val.linlin(0,127,0,1).round(0.0001);
		mix.postln;
		if(~synth.isPlaying,{~synth.set(\mix,mix)});
},55);
				);

								(
MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|
		var room;
		room=val.linlin(0,127,0,1).round(0.0001);
		room.postln;
		if(~synth.isPlaying,{~synth.set(\room,room)});
},59);
	);
);

(
			(
MIDIdef.cc(\midi_slider1,{ |val, num, chan, src|
		var gain;
	gain=val.linlin(0,127,0,10).round(0.0001);
		gain.postln;
		if(~synth.isPlaying,{~synth.set(\gain,gain)});
},19);
			);

											(
MIDIdef.cc(\midi_slider2,{ |val, num, chan, src|
		var m;
		m=val.linlin(0,127,1,16).round(1).asInteger;
		m.postln;
		if(~synth.isPlaying,{~synth.set(\m,m)});
},23);
	);

														(
MIDIdef.cc(\midi_slider3,{ |val, num, chan, src|
		var t;
		t=val.linlin(0,127,1/8,16).round(1/8);
		t.postln;
		TempoClock.default.tempo_(t);

},62);
	);
(
MIDIdef.cc(\midi_slider4,{ |val, num, chan, src|
		var cl;
		cl=val.linlin(0,127,0,56*4).round(1).asInteger;
		cl.postln;
			if(~synth.isPlaying,{~synth.set(\tone,cl)});


},27);
	);
(
MIDIdef.cc(\midi_slider5,{ |val, num, chan, src|
		var gain;
	gain=val.linlin(0,127,0,1).round(0.0001);
		gain.postln;
		~gain=gain;
},31);
			);
	(
MIDIdef.cc(\midi_slider6,{ |val, num, chan, src|
		var tone;
	tone=val.linlin(0,127,0,992*4).round(1).asInteger;
		tone.postln;
~tone=tone;
},49);
			);

											(
MIDIdef.cc(\midi_slider7,{ |val, num, chan, src|
		var m;
		m=val.linlin(0,127,1,16).round(1).asInteger;
		m.postln;
~m=m;
},53);
	);

(
MIDIdef.cc(\midi_slider8,{ |val, num, chan, src|
		var low;
		low=val.linlin(0,127,0,992*4).round(1).asInteger;
		low.postln;
~low=low;
},57);
	);

	(
MIDIdef.cc(\midi_slider9,{ |val, num, chan, src|
		var pan;
			pan=val.linlin(0,127,(992*2).neg,0,992*2).round(1).asInteger;
		pan.postln;
~pan=pan;
},61);
	)

);

(
	(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
		var a;
				if(val>0,a=1);
a.postln;
		if(~synth.isPlaying,{~synth.set(\a, a)});
},1);
	);
	(
MIDIdef.cc(\midi_switch2,{ |val, num, chan, src|
		 var a;
					if(val>0,a=2);
a.postln;
		if(~synth.isPlaying,{~synth.set(\a, a)});
},3);
	);
		(
MIDIdef.cc(\midi_switch3,{ |val, num, chan, src|
			var a;
					if(val>0,a=3);
a.postln;
		if(~synth.isPlaying,{~synth.set(\a, a)});
},4);
	);

	(
MIDIdef.cc(\midi_switch4,{ |val, num, chan, src|
         	var a;
				if(val>0,a=4);
a.postln;
		if(~synth.isPlaying,{~synth.set(\a, a)});
},6);
	);
					(
MIDIdef.cc(\midi_switch5,{ |val, num, chan, src|
		var a;
				if(val>0,a=5);
a.postln;
		if(~synth.isPlaying,{~synth.set(\a, a)});
},7);
	);
	(
MIDIdef.cc(\midi_switch6,{ |val, num, chan, src|
		 var a;
					if(val>0,a=6);
a.postln;
		if(~synth.isPlaying,{~synth.set(\a, a)});
},9);
	);
		(
MIDIdef.cc(\midi_switch7,{ |val, num, chan, src|
			var a;
					if(val>0,a=7);
a.postln;
		if(~synth.isPlaying,{~synth.set(\a, a)});
},10);
	);

	(
MIDIdef.cc(\midi_switch8,{ |val, num, chan, src|
         	var a;
				if(val>0,a=8);
a.postln;
		if(~synth.isPlaying,{~synth.set(\a, a)});
},12);
	);
					(
MIDIdef.cc(\midi_switch9,{ |val, num, chan, src|
		var a;
				if(val>0,a=9);
a.postln;
		if(~synth.isPlaying,{~synth.set(\a, a)});
},13);
	);
	(
MIDIdef.cc(\midi_switch10,{ |val, num, chan, src|
		 var a;
					if(val>0,a=10);
a.postln;
		if(~synth.isPlaying,{~synth.set(\a, a)});
},15);
	)
);

(
					(
MIDIdef.cc(\midi_seq_pot1,{ |val, num, chan, src|
		var s1;
		s1=val.linlin(0,127,0,56*2).round(1).asInteger;
		s1.postln;
		~s1=s1;
},18);
						);

				(
MIDIdef.cc(\midi_seq_pot2,{ |val, num, chan, src|
         var s2;
					s2=val.linlin(0,127,0,56*2).round(1).asInteger;
		s2.postln;
		~s2=s2;
},22);
	);

									(
MIDIdef.cc(\midi_seq_pot3,{ |val, num, chan, src|
		var s3;
			s3=val.linlin(0,127,0,56*2).round(1).asInteger;
		s3.postln;
		~s3=s3;
},26);
	);

												(
MIDIdef.cc(\midi_seq_pot4,{ |val, num, chan, src|
		var s4;
			s4=val.linlin(0,127,0,56*2).round(1).asInteger;
		s4.postln;
		~s4=s4;
},30);
	);

														(
MIDIdef.cc(\midi_seq_pot5,{ |val, num, chan, src|
		var s5;
			s5=val.linlin(0,127,0,56*2).round(1).asInteger;
		s5.postln;
		~s5=s5;
},48);
	);

														(
MIDIdef.cc(\midi_seq_pot6,{ |val, num, chan, src|
		var s6;
			s6=val.linlin(0,127,0,56*2).round(1).asInteger;
		s6.postln;
		~s6=s6;
},52);
	);

														(
MIDIdef.cc(\midi_seq_pot7,{ |val, num, chan, src|
		var s7;
			s7=val.linlin(0,127,0,56*2).round(1).asInteger;
		s7.postln;
		~s7=s7;
},56);
	);

																	(
MIDIdef.cc(\midi_seq_pot8,{ |val, num, chan, src|
		var s8;
			s8=val.linlin(0,127,0,56*2).round(1).asInteger;
		s8.postln;
		~s8=s8;
},60);
	);
);


)



~synth=Synth(\synth,[\cloud,5]).register;


			////sequencer

	~s= Routine({loop{

	thisThread.randSeed = ~val;

		~val.postln;

	~synth.set(\tone, (56).rand)	;

2.wait
};
});
)

	~s.play;
/////server based randomes
(
~seq = Pseq(~dur1, inf).asStream;
	~s= Routine({loop{


	~synth.set(\tone, (56).rand)	;

    ~seq.next.wait;
};
});
)
/////////////sequencer with midi
(
~seq = Pseq(~dur1/2, inf).asStream;
~seq = Pseq([1/2], inf).asStream;

	~s= Routine({loop{


	~synth.set(\tone, ~s1)	;

    ~seq.next.wait;

	~synth.set(\tone, ~s2)	;

	    ~seq.next.wait;

	~synth.set(\tone, ~s3)	;

	    ~seq.next.wait;

	~synth.set(\tone, ~s4)	;

	    ~seq.next.wait;

	~synth.set(\tone, ~s5)	;

	    ~seq.next.wait;

	~synth.set(\tone, ~s6)	;

	    ~seq.next.wait;

	~synth.set(\tone, ~s7)	;

	    ~seq.next.wait;

	~synth.set(\tone, ~s8)	;

	    ~seq.next.wait;
};
});
)
	~s.play;
~s.stop



~dr.play;
~dr.pause





(
				//	thisThread.randSeed = ~val;

		~dr=Pdef(\1, Pbind(\instrument, \kick,
			\dur,Pseq(~dur1,inf),
				\gain,~gian,
				\tone,~tone,
				\pan,~pan,
					\m,~m,
			\low,~low,
				\noise,0.0001,
\az,pi/4,
	\azr,pi/2,
	\el,pi/2,
				\decay,2,
				\attack,0.001,
	\spread,3,
	\panx,1,
	\pany,1,
	\panz,1,

					\rz,200,
					\mix,0.2,
					\room,0.5;
		))
)







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

