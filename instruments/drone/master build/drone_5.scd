

(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=12;
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


		///vbap

		///cube

(
~a = VBAPSpeakerArray.new(3,
[[45, 35.264390.neg], [135, 35.264390.neg], [45.neg, 35.264390.neg], [135.neg, 35.264390.neg],[45,35.264390],[135,35.264390],[45.neg,35.264390],[135.neg,35.264390]]);
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
			~transfer_function=~transfer_function+(Signal.sineFill(~signalSize,~array,~ph)/1);
		~transfer_function=~transfer_function.normalize;
			//~transfer_function.plot;
			~dist=Buffer.loadCollection(s,~transfer_function.asWavetableNoWrap);
		);




		////sound
(
SynthDef.new(\synth,{

	arg gain=1,low=992,tone=0,x=1,pan=1,mix=0.3,a=1,oct1=1,oct2=1,oct3=1,angle=0,panx=1,pany=1,panz=1,room=0.5,
				fu=16,drive=1,spread=1,azx=0,azy=0,elx=0,ely=0,overdrive=0.1,drone_amp=1,rz=100,
				axisx1=1,axisy1=1,axisz1=1,axisx2=1,axisy2=1,axisz2=1,axisx3=1,axisy3=1,axisz3=1;
	var rq=1,m=2,attack,decay,curve,band,azf=0,elf=0,q,r1,r2,r3,sq1,sq2,sq3,rotationx,rotationy,rotationz,cloud=1;
	var az1,el1,az2,el2,az3,el3,temp_mag1,temp_mag2,temp_mag3,core=(9/8).rand;
	var lamdoma,freq1,freq2,freq3,fund,amp1,amp2,amp3,alpha,cell_az,cell_el,x_pos,y_pos,control1,control2,control3;
	var sig1,sig2,bank=6,out1,out2,band_osc1,band_osc2,ton,threshold1,threshold2,threshold3,phase1,phase2,phase3;
	var band_osc3,band_osc4,band_osc5,band_osc6,sig3,out3,cell_tria,b_x,b_y,b_z,polytope,gain1,gain2,gain3,env,azimuth,elevation;
	var magx,magy,magz,magqx,magqy,mod_anglex,anglex,angley,anglez,phasex,phasey,phasez,rq1,rq2,rq3,rq4,rq5,rq6;
	var mod_angley,mod_anglez,mx,my,mz,mqx,mqy,mag,magq,mq=(m-1),lfo,sph1,loc1,loc2,loc3,axis1,axis2,axis3,g=((1+5.sqrt)/2),s=(1+2.sqrt);
	var amb_w,amb_x,amb_y,amb_z,out,amb_sig1,amb_sig2,amb_sig3,axisx,axisy,axisz,cx,cy,cz;
	var axi1,axi2,axi3,ds1,ds2,ds3,f1,f2,f3,g1,g2,g3;

fund=fu*(9/8);
lamdoma=(x.lag(0.01)+a.lag(0.01))/x.lag(0.01);

						lfo=2.pow(pan/992);
					band=pan;

					temp_mag1=992*oct1;
					temp_mag2=992*oct2;
					temp_mag3=992*oct3;

				axisx=[axisx1,axisy1,axisz1].normalizeSum.sqrt;
				axisy=[axisx2,axisy2,axisz2].normalizeSum.sqrt;
				axisz=[axisx3,axisy3,axisz3].normalizeSum.sqrt;

				cx=Cartesian(axisx.[0],axisx.[0],axisx.[0]);
				cy=Cartesian(axisy.[1],axisy.[1],axisy.[1]);
				cz=Cartesian(axisz.[2],axisz.[2],axisz.[2]);


					az1=cx.theta; el1=cy.phi;
					az2=cy.theta; el2=cy.phi;
					az3=cz.theta; el3=cz.phi;

				cloud.do{

				axis1=Spherical(temp_mag1,(az1.lag(0.01)+azf).wrap(pi,pi.neg),  (el1.lag(0.01)+elf).wrap((pi/2),(pi/2).neg));
					axis2=Spherical(temp_mag2,(az2.lag(0.01)+azf).wrap(pi,pi.neg), (el2.lag(0.01)+elf).wrap((pi/2),(pi/2).neg));
					axis3=Spherical(temp_mag3,(az3.lag(0.01)+azf).wrap(pi,pi.neg), (el3.lag(0.01)+elf).wrap((pi/2),(pi/2).neg));

				polytope=Cartesian(axis1.x,axis2.y,axis3.z);

b_x=2.pow(polytope.x.round(1)/992);
b_y=2.pow(polytope.y.round(1)/992);
b_z=2.pow(polytope.z.round(1)/992);


anglex=(exp(Complex(0,1)*polytope.theta.lag(0.01)).real*exp(Complex(0,1)*polytope.phi.lag(0.01)).real).round(0.00001);
angley=(exp(Complex(0,1)*polytope.theta.lag(0.01)).imag*exp(Complex(0,1)*polytope.phi.lag(0.01)).real).round(0.00001);
anglez=(exp(Complex(0,1)*polytope.phi.lag(0.01)).imag).round(0.00001);

phase1=Complex(1,anglex).theta;
phase2=Complex(1,angley).theta;
phase3=Complex(1,anglez).theta;


mod_anglex=SinOsc.ar(lfo,phase1).range(pi.neg,pi);
mod_angley=SinOsc.ar(lfo,phase2).range(pi.neg,pi);
mod_anglez=SinOsc.ar(lfo,phase3).range((pi/2).neg,(pi/2));

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

					mx=(Cartesian(magx.value,0,0).rho);
					//mqx=(Cartesian(magqx.value,0,0).rho);
					my=(Cartesian(0,magy.value,0).rho);
					//mqy=(Cartesian(0,magqy.value,0).rho);
					mz=(Cartesian(0,0,magz.value).rho);
					mag=(Cartesian(magx.value,magy.value,0).rho);
					//magq=(Cartesian(magqx.value,magqy.value,0).rho);


						sph1=Spherical(mag,polytope.theta,polytope.phi);
			loc1=sph1.x;
			loc2=sph1.y;
			loc3=sph1.z;

phasex=Complex(1,mx.value).theta;
phasey=Complex(1,my.value).theta;
phasez=Complex(1,mz.value).theta;


ton=2.pow((tone.lag(0.01))/56).round(0.0001);

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

					sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq1,phase:phasex,mul:rz).abs*Shaper.ar(~dist,SinOsc.ar(freq1,phase:phasex,mul:2.pow(overdrive/992)))),freq1*2.pow(low.lag(0.01)/992),amp1)+ds1);
					sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq2,phase:phasey,mul:rz).abs*Shaper.ar(~dist,SinOsc.ar(freq2,phase:phasey,mul:2.pow(overdrive/992)))),freq2*2.pow(low.lag(0.01)/992),amp2)+ds2);
					sig3=(LPF.ar((Osc.ar(~w1.bufnum,freq3,phase:phasez,mul:rz).abs*Shaper.ar(~dist,SinOsc.ar(freq3,phase:phasez,mul:2.pow(overdrive/992)))),freq3*2.pow(low.lag(0.01)/992),amp3)+ds3);

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
					gain1=gain*rq1.sqrt.reciprocal*fu.reciprocal;//*(2.pow(drive/992)).reciprocal;
					gain2=gain*rq2.sqrt.reciprocal*fu.reciprocal;//*(2.pow(drive/992)).reciprocal;
					gain3=gain*rq3.sqrt.reciprocal*fu.reciprocal;//*(2.pow(drive/992)).reciprocal;

					///three channel
				//	Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01));
				//	Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01));
				//	Out.ar(2,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01));

					////azimuthal multichannel expansion
			//Out.kr(0,PanAz.ar(5,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01),panx,width:spread));
			//Out.kr(0,PanAz.ar(5,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01),pany,width:spread));
			//Out.kr(0,PanAz.ar(5,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01),panz,width:spread));

				///3d vbap expansion
//Out.ar(0,VBAP.ar(8,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01),~b,sph1.theta.raddeg,sph1.phi.raddeg,width:spread));
//Out.ar(0,VBAP.ar(8,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01),~b,sph1.theta.raddeg,sph1.phi.raddeg,,width:spread));
//Out.ar(0,VBAP.ar(8,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01),~b,sph1.theta.raddeg,sph1.phi.raddeg,,width:spread));


///anbisonic decoded on stereo
					amb_sig1=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01));
					amb_sig2=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01));
					amb_sig3=(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01));

					amb_w=(amb_sig1+amb_sig2+amb_sig3)/2.sqrt;
					amb_x=amb_sig1;
					amb_y=amb_sig2;
					amb_z=amb_sig3;

				out= Out.ar(0,BFDecode1.ar1(amb_w, amb_x, amb_y, amb_z, [azx+azf, azy+azf], [elx+elf,ely+elf], 2 ));


	///aniumation control buses out

			Out.kr(~controlBus_1a, A2K.kr(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*loc1.abs)),0.9,0.01)*100));
			Out.kr(~controlBus_2a, A2K.kr(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*loc2.abs)),0.9,0.01)*100));
			Out.kr(~controlBus_3a, A2K.kr(Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*loc3.abs)),0.9,0.01)*100));

			Out.kr(~controlBus_x, mod_anglex);
			Out.kr(~controlBus_y, mod_angley);
			Out.kr(~controlBus_z, mod_anglez);


						azf = (azf+(2pi-(2pi/s))).wrap(pi.neg,pi);
		   elf = (elf+(pi-(pi/s))).wrap((pi/2).neg,(pi/2))
				};

}).add;);

5.wait;

		~synth=Synth.new(\synth,[\gain,10,\drive,992*4,\overdrive,992*1,\fu,32,\tone,0,\low,0,\pan,(992*16).neg,\mix,0.3,\drone_amp,1,\rz,100,\room,1
			\x,1,\a,1,\oct1,1,\oct2,1,\oct3,1,\angle,pi/2,\panx,1,\pany,1,\panz,1,\spread,1,\azx,0,\azy,pi/2,\elx,0,\ely,0,\axisx1,1,\axisy1,1,\axisz1,1\axisx2,1,\axisy2,1,\axisz2,1,\axisx3,1,\axisy3,1,\axisz3,1;]).register;//s.record


2.wait;
(
MIDIClient.init;
MIDIIn.connectAll;
		(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
		var gain;
	//[val, num, chan, src].postln;
	gain=val.linlin(0,127,0,10).round(0.000001);

		gain.postln;
		if(~synth.isPlaying,{~synth.set(\gain,gain)});
},26);
				);

	(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
         var low;
					low=val.linlin(0,127,0,(992*4)).round(1).asInteger;
		low.postln;
		if(~synth.isPlaying,{~synth.set(\low,low)});
},27);
	);

					(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var a;
		a=val.linlin(0,127,0,5).round(1).asInteger;
		a.postln;
		if(~synth.isPlaying,{~synth.set(\a,a)});
},28);
						);

									(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
		var pan;
			pan=val.linlin(0,127,(992*16).neg,(992*8));
		pan.postln;
		if(~synth.isPlaying,{~synth.set(\pan,pan)});
},29);
	);

													(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
		var mix;
					mix=val.linlin(0,127,0,1).round(0.0001);
		mix.postln;
		if(~synth.isPlaying,{~synth.set(\mix,mix)});
},31);
				);

									(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
		var x;
		x=val.linlin(0,127,1,4).round(1).asInteger;
		x.postln;
		if(~synth.isPlaying,{~synth.set(\x,x)});
},30);
	);




	(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
		var ton;
				if(val>0,ton=16);
ton.postln;
		if(~synth.isPlaying,{~synth.set(\fu, ton)});
},14);
	);
	(
MIDIdef.cc(\midi_switch2,{ |val, num, chan, src|
		 var ton;
					if(val>0,ton=32);
ton.postln;
		if(~synth.isPlaying,{~synth.set(\fu, ton)});
},15);
	);
		(
MIDIdef.cc(\midi_switch3,{ |val, num, chan, src|
			var ton;
					if(val>0,ton=64);
ton.postln;
		if(~synth.isPlaying,{~synth.set(\fu, ton)});
},16);
	);

	(
MIDIdef.cc(\midi_switch4,{ |val, num, chan, src|
         	var ton;
				if(val>0,ton=128);
ton.postln;
		if(~synth.isPlaying,{~synth.set(\fu, ton)});
},17);
	);

)
	});
	Tdef(\drone).play;
}
)
)


(
			////sequencer
	~s= Routine({loop{

	/*(
MIDIFunc.noteOn({  |val, num, chan, src|
				var ton;
		if(val>0,ton=(56*2).rand2);
ton.postln;
		~synth.set(\tone, ton)	;
});
)*/
	~synth.set(\tone, (56*2).rand)	;

0.1.wait
};
});
);

	~s.play;

