
Server.killAll
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=7;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*16;
s.options.blockSize = 128;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
//s.boot;
);


(
s.waitForBoot{
//s.freqscope;
//s.scope;
//s.makeWindow;
s.meter;
~tempo=1;
~orange=2;
~mass=10.pow(45.neg);
~fftsize = 64*128;
TempoClock.default.tempo_(~tempo);

Tdef(\drone, {


///animation control buffers
/*		(
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);
~controlBus3 = Bus.control(s, 1);
~controlBus4 = Bus.control(s, 1);
~controlBus5 = Bus.control(s, 1);
~controlBus6 = Bus.control(s, 1);
		);*/

/////tetrahedron
		(
~azimuth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
/////vbap
				/*(
~vbap = VBAPSpeakerArray .new(3,
[[~azimuth.[0],~elevation.[0]], [~azimuth.[1],~elevation.[1]], [~azimuth.[2],~elevation.[2]], [~azimuth.[3],~elevation.[3]]]);
	 ~vbap_buf = Buffer.loadCollection(s, ~vbap.getSetsAndMatrices);
)*/


////// wavetable
(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~n=(0-(2pi/992)); ~ph=992.collect{~n=~n+(2pi/992);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);

(
~wt= Buffer.alloc(s,~bufferSize);
{
var signal,wt;
signal=Signal.sineFill(~signalSize,~array,[0],~ph);
wt = signal.asWavetable;
~wt.loadCollection(wt);
//signal.plot;
}.value;
);

/////scales
		(
~note=10;
(
{
var nn=1.neg;
~scalee=~note.collect{nn=nn+1;Scale.majorPentatonic.performDegreeToKey(nn,12)};
}.value;
);
(
{
var nn=1.neg;
~scaleee=~note.collect{nn=nn+1;Scale.minorPentatonic.performDegreeToKey(nn,12)};
}.value;
);
~sc=[~scalee,~scaleee];
		);

/////sound engine
(
SynthDef.new(\synth,{

arg gain=1,drive=0,c=0,az=0,el=0,scalee=0,lowend=64,level=100,speaker_size=0.15,tone_axis=0,ran=0,rect_level=1,harmonic=1,
			dicay=4,fl=40,room=0.5,mix=0.5,pan_mod=0.01,spread=1,limit=0.8,fu=32,dyn=1,comp=1,sphharm=1,attack=0.01;

var expansion,heavy,fundamental,sph_mod,polytope,bessel_ripple,magx,magy,magz,sph,mod_timbre,mass=~mass;
var ton1,ton2,ton3,tonal_x,tonal_y,tonal_z,mod_x,mod_y,mod_z,phase_mod_x,phase_mod_y,phase_mod_z;
var mod_anglex,mod_angley,mod_anglez,m,mx,my,mz,sph_x,sph_y,sph_z,sph_mag,phasex,phasey,phasez;
var freq1,freq2,freq3,amp1,amp2,amp3,feed,control1,control2,control3,sig1,sig2,sig3;
var oct1,oct2,oct3,oct4,oct5,oct6,oct7,oct8,oct9,g=((1+5.sqrt)/2),s=(1+2.sqrt),pan,m_sphharm,tonal_polytope;
var step,ph,ph1,ph2,ph3,ph4,ph5,ph6,ph7,ph8,ph9,orange=~orange,polx,poly,polz,mag_sphharm;
var threshold1,threshold2,threshold3,g_ch1,g_ch2,g_ch3,g_ch4,pan1,pan2,pan3,pan4,bessel_wave;
var waveAmp,waveSpeed,waveFreq,dyn1,dyn2,dyn3,dyn4,dyn5,dyn6,dyn7,dyn8,dyn9,timbre;
var tonaldegree_x,tonaldegree_y,tonaldegree_z,feed1,feed2,feed3,bw,bx,by,bz,sstep;
var chainwet1,chainwet2,chainwet3,follower1,follower2,follower3;
var frames=~fftsize, chain1,chain2,chain3,bins,env1,env2,env3,gate1,gate2,gate3;
var dry1,dry2,dry3,chain11,chain22,chain33,sig111,sig222,sig333;
var n=0,verb1,verb2,verb3,threshold,env,decay;
var sig11,sig12,sig13,sig14,sig21,sig22,sig23,sig24,sig31,sig32,sig33,sig34;

env=EnvGen.ar(Env.perc(attack,dicay),doneAction:2);
//env=EnvGen.ar(Env.sine(decay),doneAction:2);
pan=2.pow(pan_mod.lag(0.001)/16256);
ph = (2pi-(2pi/s));
heavy=2.pow(drive.lag(0.001)/16256);
mass=heavy*mass;
dyn1=dyn.lag(0.01)*2;
dyn2=dyn.lag(0.01)*3;
dyn3=dyn.lag(0.01)*4;
dyn4=dyn.lag(0.01)*5;
dyn5=dyn.lag(0.01)*6;
dyn6=dyn.lag(0.01)*7;
dyn7=dyn.lag(0.01)*8;
dyn8=dyn.lag(0.01)*9;
dyn9=dyn.lag(0.01)*10;
expansion=2.pow(c.lag(0.001)/16256);
sstep=c.lag(0.001).linlin(0,(16256*orange),(16256*orange),0).round(1).asInteger;
step=ran.lag(0.001);
timbre=sstep+1;
fundamental=(fu*(9/8))*expansion;
polytope=Spherical(1,az.lag(0.001),el.lag(0.001));
tonal_polytope=Spherical(step,polytope.theta,polytope.phi);
//mag_sphharm=c.lag(0.01).linlin(0,(16256*orange),1,5).round(1).asInteger;
mag_sphharm=harmonic.lag(0.01);
//m_sphharm=Spherical(mag_sphharm,az.lag(0.001),el.lag(0.001));
sph_mod=2.pow(sphharm.lag(0.001)/16256);
mx=mag_sphharm;
my=mag_sphharm;
mz=mag_sphharm;
waveAmp=gain;
waveSpeed=expansion;
waveFreq=expansion.reciprocal;
bessel_wave=waveAmp*sin((waveFreq*polytope.theta)+(waveFreq * polytope.phi)-waveSpeed);
bessel_ripple=Complex(1,bessel_wave).theta*2;

/*	Out.kr(~controlBus1.index,c.lag(0.001));
	Out.kr(~controlBus2.index,ran.lag(0.001));
	Out.kr(~controlBus3.index,dyn.lag(0.01));
	Out.kr(~controlBus4.index,pan_mod.lag(0.001));
    Out.kr(~controlBus5.index,harmonic.lag(0.01));
	Out.kr(~controlBus6.index,bessel_wave);*/

ton1=2.pow(Select.kr(tonal_polytope.x.round(1).abs.linlin(1,timbre,0,~note).round(1), Select.kr(scalee.lag(0.001),~sc)) /12);
ton2=2.pow(Select.kr(tonal_polytope.y.round(1).abs.linlin(1,timbre,0,~note).round(1), Select.kr(scalee.lag(0.001),~sc)) /12);
ton3=2.pow(Select.kr(tonal_polytope.z.round(1).abs.linlin(1,timbre,0,~note).round(1), Select.kr(scalee.lag(0.001),~sc)) /12);

pan1=SinOsc.ar(pan,phase:0).range(spread.linlin(0.01,1,1,0.001),1);
pan2=SinOsc.ar(pan,phase:0.25pi).range(spread.linlin(0.01,1,1,0.001),1);
pan3=SinOsc.ar(pan,phase:0.5pi).range(spread.linlin(0.01,1,1,0.001),1);
pan4=SinOsc.ar(pan,phase:0.75pi).range(spread.linlin(0.01,1,1,0.001),1);

mod_x=polytope.x;
mod_y=polytope.y;
mod_z=polytope.z;
phase_mod_x=(Complex(1,mod_x).theta*4);
phase_mod_y=(Complex(1,mod_y).theta*4);
phase_mod_z=(Complex(1,mod_z).theta*2);

mod_anglex=SinOsc.ar(sph_mod,phase:phase_mod_x).range(0,pi);
mod_angley=SinOsc.ar(sph_mod,phase:phase_mod_y).range(0,pi);
mod_anglez=SinOsc.ar(sph_mod,phase:phase_mod_z).range(35.264390.degrad,35.264390.degrad.neg);

magx=((Complex(cos(((polytope.theta+mod_anglex)*mx).wrap(pi.neg,pi)),
cos((((polytope.theta+mod_anglex)*mx)).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi).wrap((pi/2).neg,(pi/2))),cos((polytope.phi).wrap((pi/2).neg,(pi/2)))).rho));

magy=((Complex(sin(((polytope.theta+mod_angley)*my).wrap(pi.neg,pi)),
sin(((polytope.theta+mod_angley)*my).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi).wrap((pi/2).neg,(pi/2))),cos((polytope.phi).wrap((pi/2).neg,(pi/2)))).rho));

magz=((Complex(cos(((polytope.phi+mod_anglez)*mz).wrap((pi/2).neg,(pi/2))),
cos(((polytope.phi)*mz).wrap((pi/2).neg,(pi/2)))).rho));

sph_x=(Cartesian(magx/2.sqrt,0,0).rho);
sph_y=(Cartesian(0,magy/2.sqrt,0).rho);
sph_z=(Cartesian(0,0,magz/2.sqrt).rho);
sph_mag=(Cartesian(sph_x,sph_y,sph_z));
sph=Spherical(sph_mag.rho/2.sqrt,polytope.theta,polytope.phi);
polx=Spherical((sph_x*timbre).round(1),polytope.theta,polytope.phi);
poly=Spherical((sph_y*timbre).round(1),polytope.theta,polytope.phi);
polz=Spherical((sph_z*timbre).round(1),polytope.theta,polytope.phi);

tonaldegree_x = Select.kr(tone_axis, [polx.x, poly.x, polz.x]);
tonaldegree_y = Select.kr(tone_axis, [polx.y, poly.y, polz.y]);
tonaldegree_z = Select.kr(tone_axis, [polx.z, poly.z, polz.z]);
tonal_x=2.pow(tonaldegree_x.round(1) /16256);
tonal_y=2.pow(tonaldegree_y.round(1) /16256);
tonal_z=2.pow(tonaldegree_z.round(1) /16256);

phasex=Complex(1,tonaldegree_x).theta*4;
phasey=Complex(1,tonaldegree_y).theta*4;
phasez=Complex(1,tonaldegree_z).theta*2;

freq1=fundamental*ton1*tonal_x;
freq2=fundamental*ton2*tonal_y;
freq3=fundamental*ton3*tonal_z;

amp1=expansion.reciprocal*ton1.reciprocal*tonal_x.reciprocal;
amp2=expansion.reciprocal*ton2.reciprocal*tonal_y.reciprocal;
amp3=expansion.reciprocal*ton3.reciprocal*tonal_z.reciprocal;

////calculate range of spectrum 2.pow((16256*1)/16256).pow(8)
oct9=dyn*2.pow(step/16256);
oct8=dyn1*2.pow(step/16256);
oct7=dyn2*2.pow(step/16256);
oct6=dyn3*2.pow(step/16256);
oct5=dyn4*2.pow(step/16256);
oct4=dyn5*2.pow(step/16256);
oct3=dyn6*2.pow(step/16256);
oct2=dyn7*2.pow(step/16256);
oct1=dyn8*2.pow(step/16256);

ph1=(ph+ph).wrap(pi.neg,pi);
ph2=(ph1+ph).wrap(pi.neg,pi);
ph3=(ph2+ph).wrap(pi.neg,pi);
ph4=(ph3+ph).wrap(pi.neg,pi);
ph5=(ph4+ph).wrap(pi.neg,pi);
ph6=(ph5+ph).wrap(pi.neg,pi);
ph7=(ph6+ph).wrap(pi.neg,pi);
ph8=(ph7+ph).wrap(pi.neg,pi);
ph9=(ph8+ph).wrap(pi.neg,pi);
ph=ph1=ph2=ph3=ph4=ph5=ph6=ph7=ph8=ph9=0;


///mult chain// beware of 32-bit underflow and value 0 smash
sig1=(((((((((((
					((((((((
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct2,phase:phasex+ph8,mul:level).abs*SinOsc.ar(freq1*oct2,phase:phasex+ph8)),freq1*heavy,amp1*oct2.reciprocal)).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct3,phase:phasex+ph7,mul:level).abs*SinOsc.ar(freq1*oct3,phase:phasex+ph7)),freq1*heavy,amp1*oct3.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct4,phase:phasex+ph6,mul:level).abs*SinOsc.ar(freq1*oct4,phase:phasex+ph6)),freq1*heavy,amp1*oct4.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct5,phase:phasex+ph5,mul:level).abs*SinOsc.ar(freq1*oct5,phase:phasex+ph5)),freq1*heavy,amp1*oct5.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct6,phase:phasex+ph4,mul:level).abs*SinOsc.ar(freq1*oct6,phase:phasex+ph4)),freq1*heavy,amp1*oct6.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct7,phase:phasex+ph3,mul:level).abs*SinOsc.ar(freq1*oct7,phase:phasex+ph3)),freq1*heavy,amp1*oct7.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct8,phase:phasex+ph2,mul:level).abs*SinOsc.ar(freq1*oct8,phase:phasex+ph2)),freq1*heavy,amp1*oct8.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct9,phase:phasex+ph1,mul:level).abs*SinOsc.ar(freq1*oct9,phase:phasex+ph1)),freq1*heavy,amp1*oct9.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex+ph,mul:level).abs*SinOsc.ar(freq1,phase:phasex+ph)),freq1*heavy,amp1)))*comp)*comp)+
(rect_level*LPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:level).abs*SinOsc.ar(freq1,phase:phasex+ph)),freq1*heavy,amp1))
));
sig2=((((((((((
					((((((((
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct2,phase:phasey+ph8,mul:level).abs*SinOsc.ar(freq2*oct2,phase:phasey+ph8)),freq2*heavy,amp2*oct2.reciprocal)).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct3,phase:phasey+ph7,mul:level).abs*SinOsc.ar(freq2*oct3,phase:phasey+ph7)),freq2*heavy,amp2*oct3.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct4,phase:phasey+ph6,mul:level).abs*SinOsc.ar(freq2*oct4,phase:phasey+ph6)),freq2*heavy,amp2*oct4.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct5,phase:phasey+ph5,mul:level).abs*SinOsc.ar(freq2*oct5,phase:phasey+ph5)),freq2*heavy,amp2*oct5.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct6,phase:phasey+ph4,mul:level).abs*SinOsc.ar(freq2*oct6,phase:phasey+ph4)),freq2*heavy,amp2*oct6.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct7,phase:phasey+ph3,mul:level).abs*SinOsc.ar(freq2*oct7,phase:phasey+ph3)),freq2*heavy,amp2*oct7.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct8,phase:phasey+ph2,mul:level).abs*SinOsc.ar(freq2*oct8,phase:phasey+ph2)),freq2*heavy,amp2*oct8.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct9,phase:phasey+ph1,mul:level).abs*SinOsc.ar(freq2*oct9,phase:phasey+ph1)),freq2*heavy,amp2*oct9.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey+ph,mul:level).abs*SinOsc.ar(freq2,phase:phasey+ph)),freq2*heavy,amp2)))*comp)+
(rect_level*LPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:level).abs*SinOsc.ar(freq2,phase:phasey+ph)),freq2*heavy,amp2))
)
);
sig3=((((((((((
					((((((((
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct2,phase:phasez+ph8,mul:level).abs*SinOsc.ar(freq3*oct2,phase:phasez+ph8)),freq3*heavy,amp3*oct2.reciprocal)).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct3,phase:phasez+ph7,mul:level).abs*SinOsc.ar(freq3*oct3,phase:phasez+ph7)),freq3*heavy,amp3*oct3.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct4,phase:phasez+ph6,mul:level).abs*SinOsc.ar(freq3*oct4,phase:phasez+ph6)),freq3*heavy,amp3*oct4.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct5,phase:phasez+ph5,mul:level).abs*SinOsc.ar(freq3*oct5,phase:phasez+ph5)),freq3*heavy,amp3*oct5.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct6,phase:phasez+ph4,mul:level).abs*SinOsc.ar(freq3*oct6,phase:phasez+ph4)),freq3*heavy,amp3*oct6.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct7,phase:phasez+ph3,mul:level).abs*SinOsc.ar(freq3*oct7,phase:phasez+ph3)),freq3*heavy,amp3*oct7.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct8,phase:phasez+ph2,mul:level).abs*SinOsc.ar(freq3*oct8,phase:phasez+ph2)),freq3*heavy,amp3*oct8.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct9,phase:phasez+ph1,mul:level).abs*SinOsc.ar(freq3*oct9,phase:phasez+ph1)),freq3*heavy,amp3*oct9.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez+ph,mul:level).abs*SinOsc.ar(freq3,phase:phasez+ph)),freq3*heavy,amp3)))*comp)+
(rect_level*LPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:level).abs*SinOsc.ar(freq3,phase:phasez+ph)),freq3*heavy,amp3))
)
);

sig1=(sig1*heavy).softclip;
sig2=(sig2*heavy).softclip;
sig3=(sig3*heavy).softclip;

control1=SinOsc.ar(freq1,phasex,amp1*gain);
control2=SinOsc.ar(freq2,phasey,amp2*gain);
control3=SinOsc.ar(freq3,phasez,amp3*gain);
threshold1=(((343/speaker_size)/fundamental).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/speaker_size)/fundamental).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/speaker_size)/fundamental).reciprocal.ampdb/2.sqrt).dbamp;

sig1=HPF.ar(sig1,lowend);
sig2=HPF.ar(sig2, lowend);
sig3=HPF.ar(sig3, lowend);

sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);

/////xyz out
Out.ar(4,sig1);
Out.ar(5,sig2);
Out.ar(6,sig3);

////verb
chainwet1 =  FFT(LocalBuf(frames), InFeedback.ar(4));
chainwet2 =  FFT(LocalBuf(frames), InFeedback.ar(5));
chainwet3 =  FFT(LocalBuf(frames), InFeedback.ar(6));
dry1=sig1;
dry2=sig2;
dry3=sig3;
follower1=Amplitude.kr(dry1,343.reciprocal*room.linlin(0,1,1,100),343.reciprocal*room.linlin(0,1,1,100),fl);
follower2=Amplitude.kr(dry2,343.reciprocal*room.linlin(0,1,1,100),343.reciprocal*room.linlin(0,1,1,100),fl);
follower3=Amplitude.kr(dry3,343.reciprocal*room.linlin(0,1,1,100),343.reciprocal*room.linlin(0,1,1,100),fl);
decay=(sph.rho*room.linlin(0.001,1,1,2))*mix.linlin(0.001,1,1,2);
threshold=(mix.linlin(0.001,1,1,0.001))/sph.rho;  ////////trigger reflection threshold
gate1=(follower1>threshold);
gate2=(follower2>threshold);
gate3=(follower3>threshold);
env1=Decay2.kr(gate1,0.01, decay) * mix;
env2=Decay2.kr(gate2,0.01, decay) * mix;
env3=Decay2.kr(gate3,0.01, decay) * mix;
//env=EnvGen.kr(Env.perc(0.01,decay,mix),gate);
chain1 = PV_Freeze(chainwet1,gate1);
chain2 = PV_Freeze(chainwet2,gate2);
chain3 = PV_Freeze(chainwet3,gate3);
verb1=IFFT(chain1);
verb2=IFFT(chain2);
verb3=IFFT(chain3);
sig111=(verb1*mix)+(dry1*mix.linlin(0.001,1,1,0.001));
sig222=(verb2*mix)+(dry2*mix.linlin(0.001,1,1,0.001));
sig333=(verb3*mix)+(dry3*mix.linlin(0.001,1,1,0.001));

//gain=gain*dyn;
g_ch1 = (
(Spherical(sph_x,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~elevation[2],~elevation[1])).x *
Spherical(sph_x,~azimuth[0],~elevation[0]).x) +
(Spherical(sph_y,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~elevation[2],~elevation[1])).y *
Spherical(sph_y,~azimuth[0],~elevation[0]).y)+
(Spherical(sph_z,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~elevation[2],~elevation[1])).z *
Spherical(sph_z,~azimuth[0],~elevation[0]).z)
);
g_ch2 = (
(Spherical(sph_x,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~elevation[2],~elevation[1])).x *
Spherical(sph_x,~azimuth[1],~elevation[1]).x)+
(Spherical(sph_z,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~elevation[2],~elevation[1])).y *
Spherical(sph_y,~azimuth[1],~elevation[1]).y)+
(Spherical(sph_z,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~elevation[2],~elevation[1])).z *
Spherical(sph_z,~azimuth[1],~elevation[1]).z)
);
g_ch3 = (
(Spherical(sph_x,(polytope.theta).wrap(pi,pi.neg),(polytope.phi ).wrap(~elevation[2],~elevation[1])).x *
Spherical(sph_x,~azimuth[2],~elevation[2]).x)+
(Spherical(sph_y,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~elevation[2],~elevation[1])).y *
Spherical(sph_y,~azimuth[2],~elevation[2]).y)+
(Spherical(sph_z,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~elevation[2],~elevation[1])).z *
Spherical(sph_z,~azimuth[2],~elevation[2]).z)
);
g_ch4 = (
(Spherical(sph_x,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~elevation[2],~elevation[1])).x *
Spherical(sph_x,~azimuth[3],~elevation[3]).x) +
(Spherical(sph_y,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~elevation[2],~elevation[1])).y *
Spherical(sph_y,~azimuth[3],~elevation[3]).y)+
(Spherical(sph_z,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~elevation[2],~elevation[1])).z *
Spherical(sph_z,~azimuth[3],~elevation[3]).z)
);
g_ch1 = g_ch1.pow(spread);
g_ch2 = g_ch2.pow(spread);
g_ch3 = g_ch3.pow(spread);
g_ch4 = g_ch4.pow(spread);

(
sig11=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig111*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
sig12=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig111*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
sig13=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig111*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
sig14=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig111*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
sig21=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig222*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
sig22=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig222*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
sig23=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig222*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
sig24=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig222*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
sig31=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig333*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
sig32=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig333*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
sig33=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig333*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
sig34=(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig33*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
);
/*(
Out.r(0,sig11);Out.r(1,sig12);Out.r(2,sig13);Out.r(3,sig14);
Out.r(0,sig21);Out.r(1,sig22);Out.r(2,sig23);Out.r(3,sig24);
Out.r(0,sig31);Out.r(1,sig32);Out.r(2,sig33);Out.r(3,sig34);
)*/
///b-format stereo defuser
///w=flu+frd+bld+bru
//x=flu+frd-bld-bru
//y=flu-frd+bld-bru
//z=flu-frd-bld+bru
(
bw=(
(sig11+sig21+sig31)+
(sig12+sig22+sig32)+
(sig13+sig23+sig33)+
(sig14+sig24+sig34));
bx=(
(sig11+sig21+sig31)-
(sig12+sig22+sig32)-
(sig13+sig23+sig33)+
(sig14+sig24+sig34));
by=(
(sig11+sig21+sig31)-
(sig12+sig22+sig32)+
(sig13+sig23+sig33)-
(sig14+sig24+sig34));
bz=(
(sig11+sig21+sig31)+
(sig12+sig22+sig32)-
(sig13+sig23+sig33)-
(sig14+sig24+sig34));
);
/////xyz out
//Out.ar(9,bx);
//Out.ar(10,by);
//Out.ar(11,bz);
////stereo
//Out.ar(0,DecodeB2.ar(2, bw, bx, by,0)*spread.linlin(0.01,1,0.5,1));
Out.ar(0,BFDecode1.ar(bw, bx, by, bz,[polytope.theta,polytope.theta+0.5pi], [polytope.phi,polytope.phi])*spread.linlin(0.01,1,0.5,1));
}).add
);

3.wait;

(
		(
({
var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=32.reciprocal,beat=1,r=0;
				~r=0;		~r1=0;		~r2=0;
(

~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~dur=[];

2.do{
~x=bank.collect{
m1=m1+1;
b=Spherical(beat,~azimuth.[m1],~elevation.[m1]).rotate(~r).tilt(~r1).tumble(~r2).x;
2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
c=Spherical(beat,~azimuth.[m2],~elevation.[m2]).rotate(~r).tilt(~r1).tumble(~r2).y;
2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
d=Spherical(beat,~azimuth.[m3],~elevation.[m3]).rotate(~r).tilt(~r1).tumble(~r2).z;
2.pow(d).round(time);
};
m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };
bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
//	~durx = ~dur1.collect { |x| if (x == 0) { Rest(2) } { x }};
bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
//	~dury = ~dur2.collect { |x| if (x == 0) { Rest(2) } { x }};
bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
//	~durz = ~dur3.collect { |x| if (x == 0) { Rest(2) } { x }};
~dur=~dur++~dur1++~dur2++~dur3;
)}.value);
);

~gain=1;~drive=0;~c=0;~az=0;~el=0;~scalee=0;~harmonic=1;~fl=7.5;~gate=0;
~lowend=64;~level=600;~dyn=1;~comp=1;~tone_axis=1;~ran=16256;~rect_level=2;
~sphharm=0;~speaker_size=0.15;~room=0.5;~mix=0.4;~pan_mod=16*16256.neg;~spread=1;~limit=1;~fu=64;

~incr=0;
~g=((1+5.sqrt)/2);
~s=(1+2.sqrt);
~seq= Pseq(~dur ,inf).asStream;
~val=1234;
TempoClock.default.tempo_(1);
(
~sq= Routine({loop{
//thisThread.randSeed = ~val;
~incr=(~incr+(2pi-(2pi/~s))).wrap(pi,pi.neg);
		~pattern = Pdef(\1,
    Pbind(
        \instrument, \synth,
        \dur, Pseq(~dur, inf),

        \gain, Pfunc { ~gain },
        \drive, Pfunc { ~drive },
        \c, Pfunc { ~c },

        \az, Pfunc { ~incr },
        \el, Pfunc { ~incr / 2 },

        \attack, 0.01,
        \dicay, 8,

        \scalee, Pfunc { ~scalee },
        \harmonic, Pfunc { ~harmonic },
        \fl, Pfunc { ~fl },

        \gate, Pfunc { ~gate },

        \lowend, Pfunc { ~lowend },
        \level, Pfunc { ~level },
        \dyn, Pfunc { ~dyn },
        \comp, Pfunc { ~comp },

        \tone_axis, Pfunc { ~tone_axis },
        \ran, Pfunc { ~ran },
        \rect_level, Pfunc { ~rect_level },

        \sphharm, Pfunc { ~sphharm },
        \speaker_size, Pfunc { ~speaker_size },

        \room, Pfunc { ~room },
        \mix, Pfunc { ~mix },

        \pan_mod, Pfunc { ~pan_mod },
        \spread, Pfunc { ~spread },
        \limit, Pfunc { ~limit },

        \fu, Pfunc { ~fu }
    )
);
  ~seq.next.wait;
}}));
			(
					~sq.play;
					~pattern.play;
			)
		);
		(
			MIDIClient.init;
			MIDIIn.connectAll;
			(
				(
					MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
						var a;
						a=val.linexp(0,127,0.00001,20);
						a.postln;
						~gain=a;
						if(~synth.isPlaying,{~synth.set(\gain,a)});
					},1);
				);
				(
					MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
						var a;
						a=val.linlin(0,127,(16256).neg,(16256*3)).round(1).asInteger;
						a.postln;
						~drive=a;
						if(~synth.isPlaying,{~synth.set(\drive,a)});
					},2);
				);
				(
					MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
						var a;
						a=val.linlin(0,127,pi.neg,pi);
						a.postln;
						~az=a;
						if(~synth.isPlaying,{~synth.set(\az,a)});
					},4);
				);
				(
					MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
						var a;
						a=val.linlin(0,127,0.5pi.neg,0.5pi);
						a.postln;
						~el=a;
						if(~synth.isPlaying,{~synth.set(\el,a)});
					},5);
				);
				(
					MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
						var a;
						a=val.linlin(0,127,0,1).round(1).asInteger;
						a.postln;
						~scale=a;
						if(~synth.isPlaying,{~synth.set(\scalee,a)});
					},6);
				);
				(
					MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
						var a;
						a=val.linlin(0,127,32,128);
						a.postln;
						~lowend=a;
						if(~synth.isPlaying,{~synth.set(\lowend,a)});
					},7);
				);
				(
					MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
						var a;
						a=val.linlin(0,127,0,16256*~orange).round(1).asInteger;
						a.postln;
						~c=a;
						if(~synth.isPlaying,{~synth.set(\c,a)});
					},8);
				);
				(
					MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
						var a;
						a=val.linexp(0,127,1,4);
						a.postln;
						~dyn=a;
						if(~synth.isPlaying,{~synth.set(\dyn,a)});
					},9);
				);
				(
					MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
						var a;
						a=val.linlin(0,127,0.05,0.3);
						a.postln;
						~speaker_size=a;
						if(~synth.isPlaying,{~synth.set(\speaker_size,a)});
					},10);
				);
				(
					MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
						var a;
						a=val.linexp(0,127,0.001,1);
						a.postln;
						~room=a;
						if(~synth.isPlaying,{~synth.set(\room,a)});
					},11);
				);
				(
					MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
						var a;
						a=val.linexp(0,127,0.001,1);
						a.postln;
						~mix=a;
						if(~synth.isPlaying,{~synth.set(\mix,a)});
					},12);
				);
				(
					MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|
						var a;
						a=val.linlin(0,127,(16256*10).neg,(16256*5)).round(1).asInteger;
						a.postln;
						~pan_mod=a;
						if(~synth.isPlaying,{~synth.set(\pan_mod,a)});
					},13);
				);
				(
					MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|
						var a;
						a=val.linexp(0,127,1,0.01);
						a.postln;
						~spread=a;
						if(~synth.isPlaying,{~synth.set(\spread,a)});
					},14);
				);
				(
					MIDIdef.cc(\midi_pot15,{ |val, num, chan, src|
						var a;
						a=val.linexp(0,127,1,0.001);
						a.postln;
						~limit=a;
						if(~synth.isPlaying,{~synth.set(\limit,a)});
					},15);
				);
				(
					MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|
						var a,b;
						a=val.linlin(0,127,2,9).round(1).asInteger;
						b=2.pow(a);
						b.postln;
						~fu=a;
						if(~synth.isPlaying,{~synth.set(\fu,b)});
					},16);
				);
(
MIDIdef.cc(\midi_pot17,{ |val, num, chan, src|
var a,b;
a=val.linlin(0,127,20.neg,12);
b=10.pow(a);
b.postln;
~comp=b;
if(~synth.isPlaying,{~synth.set(\comp,b)});
},17);
);
				(
					MIDIdef.cc(\midi_pot19,{ |val, num, chan, src|
						var a;
						a=val.linexp(0,127,0.00001,1000);
						a.postln;
						~level=a;
						if(~synth.isPlaying,{~synth.set(\level,a)});
					},19);
				);
				(
					MIDIdef.cc(\midi_pot20,{|val, num, chan, src|
						var a;
						a=val.linlin(0,127,(16256*12).neg,(16256*6)).round(1).asInteger;
						a.postln;
						~sphharm=a;
						if(~synth.isPlaying,{~synth.set(\sphharm,a)});
					},20);
				);
				(
					MIDIdef.cc(\midi_pot21,{ |val, num, chan, src|
						var a;
						a=val.linlin(0,127,0,2).round(1).asInteger;
						a.postln;
						~tone_axis=a;
						if(~synth.isPlaying,{~synth.set(\tone_axis,a)});
					},21);
				);
				(
					MIDIdef.cc(\midi_pot22,{ |val, num, chan, src|
						var a;
						a=val.linlin(0,127,0,16256*~orange).round(1).asInteger;
						a.postln;
						~ran=a;
						if(~synth.isPlaying,{~synth.set(\ran,a)});
					},22);
				);
				(
					MIDIdef.cc(\midi_pot23,{ |val, num, chan, src|
						var a;
						a=val.linexp(0,127,0.00001,100);
						a.postln;
						~rect_level=a;
						if(~synth.isPlaying,{~synth.set(\rect_level,a)});
					},23);
				);
				(
					MIDIdef.cc(\midi_pot24,{ |val, num, chan, src|
						var a;
						a=val.linlin(0,127,1,10).round(1).asInteger;
						a.postln;
						~harmonic=a;
						if(~synth.isPlaying,{~synth.set(\harmonic,a)});
					},24);
				);
				))

			TempoClock.default.tempo_(1/4);

	}); Tdef(\drone).play;
})
)


s.record(numChannels:4)





