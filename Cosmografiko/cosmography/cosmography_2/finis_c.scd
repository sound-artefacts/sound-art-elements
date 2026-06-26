
Server.killAll
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=12;
s.options.numInputBusChannels=2;
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

//Buffer.freeAll;
///feed buffers, xyz from b-format or mono
(
~c11 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_104839.aiff",channels:1 );
~c21 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_104839.aiff",channels:2 );
~c31 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_104839.aiff",channels:3 );
~c12 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105124.aiff",channels:1 );
~c22 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105124.aiff",channels:2 );
~c32 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105124.aiff",channels:3 );
~c13 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105345.aiff",channels:1 );
~c23 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105345.aiff",channels:2 );
~c33 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105345.aiff",channels:3 );
~c14 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105552.aiff",channels:1 );
~c24 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105552.aiff",channels:2 );
~c34 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105552.aiff",channels:3 );
~c15 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105633.aiff",channels:1 );
~c25 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105633.aiff",channels:2 );
~c35 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105633.aiff",channels:3 );
~c16 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105719.aiff",channels:1 );
~c26 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105719.aiff",channels:2 );
~c36 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105719.aiff",channels:3 );
~c17 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105807.aiff",channels:1 );
~c27 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105807.aiff",channels:2 );
~c37 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_105807.aiff",channels:3 );
~c18 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_110014.aiff",channels:1 );
~c28 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_110014.aiff",channels:2 );
~c38 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_110014.aiff",channels:3 );
~c19 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_110120.aiff",channels:1 );
~c29 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_110120.aiff",channels:2 );
~c39 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_110120.aiff",channels:3 );
);

///animation control buffers
		(
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);
~controlBus3 = Bus.control(s, 1);
~controlBus4 = Bus.control(s, 1);
~controlBus5 = Bus.control(s, 1);
~controlBus6 = Bus.control(s, 1);
		);

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
				bg1=1,bg2=1,bg3=1,bg4=1,bg5=1,bg6=1,bg7=1,bg8=1,bg9=1,fl=40,attack=0.01,dicay=4,curv=4.neg,
				room=0.5,mix=0.5,pan_mod=0.01,spread=1,limit=0.8,fu=32,dyn=1,band=0.000001,comp=1,buffer=1,sphharm=1;

var expansion,heavy,fundamental,sph_mod,polytope,bessel_ripple,magx,magy,magz,sph,mod_timbre,mass=~mass;
var ton1,ton2,ton3,tonal_x,tonal_y,tonal_z,mod_x,mod_y,mod_z,phase_mod_x,phase_mod_y,phase_mod_z;
var mod_anglex,mod_angley,mod_anglez,m,mx,my,mz,sph_x,sph_y,sph_z,sph_mag,phasex,phasey,phasez;
var freq1,freq2,freq3,amp1,amp2,amp3,feed,control1,control2,control3,sig1,sig2,sig3;
var oct1,oct2,oct3,oct4,oct5,oct6,oct7,oct8,oct9,g=((1+5.sqrt)/2),s=(1+2.sqrt),pan,m_sphharm,tonal_polytope;
var step,ph,ph1,ph2,ph3,ph4,ph5,ph6,ph7,ph8,ph9,orange=~orange,polx,poly,polz,mag_sphharm;
var threshold1,threshold2,threshold3,g_ch1,g_ch2,g_ch3,g_ch4,pan1,pan2,pan3,pan4,bessel_wave;
var waveAmp,waveSpeed,waveFreq,dyn1,dyn2,dyn3,dyn4,dyn5,dyn6,dyn7,dyn8,dyn9,timbre;
var tonaldegree_x,tonaldegree_y,tonaldegree_z,feed1,feed2,feed3,bw,bx,by,bz,sstep;
var feed11,feed12,feed13,feed14,feed15,feed16,feed17,feed18,feed19;
var feed21,feed22,feed23,feed24,feed25,feed26,feed27,feed28,feed29;
var feed31,feed32,feed33,feed34,feed35,feed36,feed37,feed38,feed39;
var chainwet1,chainwet2,chainwet3,follower1,follower2,follower3;
var frames=~fftsize, chain1,chain2,chain3,bins,env1,env2,env3,gate1,gate2,gate3;
var dry1,dry2,dry3,chain11,chain22,chain33,sig11,sig22,sig33;
var n=0,verb1,verb2,verb3,threshold,env;

//env=EnvGen.ar(Env.perc(attack,dicay,curve:curv),doneAction:2);
env=EnvGen.ar(Env.sine(dicay),doneAction:2);
pan=2.pow(pan_mod.lag(0.001)/16256);
ph = (2pi-(2pi/s));
heavy=2.pow(drive.lag(0.001)/16256);
mass=heavy/level/comp;
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

	Out.kr(~controlBus1.index,c.lag(0.001));
	Out.kr(~controlBus2.index,ran.lag(0.001));
	Out.kr(~controlBus3.index,dyn.lag(0.01));
	Out.kr(~controlBus4.index,pan_mod.lag(0.001));
    Out.kr(~controlBus5.index,harmonic.lag(0.01));
	Out.kr(~controlBus6.index,bessel_wave);

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

//feed1=(SoundInFeedback.ar(0,buffer));    ///input
//feed2=(SoundInFeedback.ar(1,buffer));
//feed3=(feed1+feed2)/2.sqrt;
//feed=(WhiteNoise.ar(buffer));    ///noise
feed11=(PlayBuf.ar(1, ~c11.bufnum, BufRateScale.kr(~c11.bufnum), loop: 1, doneAction:0));   ////buffer
feed12=(PlayBuf.ar(1, ~c12.bufnum, BufRateScale.kr(~c12.bufnum), loop: 1, doneAction:0));
feed13=(PlayBuf.ar(1, ~c13.bufnum, BufRateScale.kr(~c13.bufnum), loop: 1, doneAction:0));
feed14=(PlayBuf.ar(1, ~c14.bufnum, BufRateScale.kr(~c14.bufnum), loop: 1, doneAction:0));
feed15=(PlayBuf.ar(1, ~c15.bufnum, BufRateScale.kr(~c15.bufnum), loop: 1, doneAction:0));
feed16=(PlayBuf.ar(1, ~c16.bufnum, BufRateScale.kr(~c16.bufnum), loop: 1, doneAction:0));
feed17=(PlayBuf.ar(1, ~c17.bufnum, BufRateScale.kr(~c17.bufnum), loop: 1, doneAction:0));
feed18=(PlayBuf.ar(1, ~c18.bufnum, BufRateScale.kr(~c18.bufnum), loop: 1, doneAction:0));
feed19=(PlayBuf.ar(1, ~c19.bufnum, BufRateScale.kr(~c19.bufnum), loop: 1, doneAction:0));
feed21=(PlayBuf.ar(1, ~c21.bufnum, BufRateScale.kr(~c21.bufnum), loop: 1, doneAction:0));
feed22=(PlayBuf.ar(1, ~c22.bufnum, BufRateScale.kr(~c22.bufnum), loop: 1, doneAction:0));
feed23=(PlayBuf.ar(1, ~c23.bufnum, BufRateScale.kr(~c23.bufnum), loop: 1, doneAction:0));
feed24=(PlayBuf.ar(1, ~c24.bufnum, BufRateScale.kr(~c24.bufnum), loop: 1, doneAction:0));
feed25=(PlayBuf.ar(1, ~c25.bufnum, BufRateScale.kr(~c25.bufnum), loop: 1, doneAction:0));
feed26=(PlayBuf.ar(1, ~c26.bufnum, BufRateScale.kr(~c26.bufnum), loop: 1, doneAction:0));
feed27=(PlayBuf.ar(1, ~c27.bufnum, BufRateScale.kr(~c27.bufnum), loop: 1, doneAction:0));
feed28=(PlayBuf.ar(1, ~c28.bufnum, BufRateScale.kr(~c28.bufnum), loop: 1, doneAction:0));
feed29=(PlayBuf.ar(1, ~c29.bufnum, BufRateScale.kr(~c29.bufnum), loop: 1, doneAction:0));
feed31=(PlayBuf.ar(1, ~c31.bufnum, BufRateScale.kr(~c31.bufnum), loop: 1, doneAction:0));
feed32=(PlayBuf.ar(1, ~c32.bufnum, BufRateScale.kr(~c32.bufnum), loop: 1, doneAction:0));
feed33=(PlayBuf.ar(1, ~c33.bufnum, BufRateScale.kr(~c33.bufnum), loop: 1, doneAction:0));
feed34=(PlayBuf.ar(1, ~c34.bufnum, BufRateScale.kr(~c34.bufnum), loop: 1, doneAction:0));
feed35=(PlayBuf.ar(1, ~c35.bufnum, BufRateScale.kr(~c35.bufnum), loop: 1, doneAction:0));
feed36=(PlayBuf.ar(1, ~c36.bufnum, BufRateScale.kr(~c36.bufnum), loop: 1, doneAction:0));
feed37=(PlayBuf.ar(1, ~c37.bufnum, BufRateScale.kr(~c37.bufnum), loop: 1, doneAction:0));
feed38=(PlayBuf.ar(1, ~c38.bufnum, BufRateScale.kr(~c38.bufnum), loop: 1, doneAction:0));
feed39=(PlayBuf.ar(1, ~c39.bufnum, BufRateScale.kr(~c39.bufnum), loop: 1, doneAction:0));


///mult chain// beware of 32-bit underflow and value 0 smash
sig1=
(((((((((((
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
(rect_level*LPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:level).abs*SinOsc.ar(freq1,phase:phasex+ph)),freq1*heavy,amp1))+
(
Select.ar(band.round(1).asInteger,[BPF.ar(feed11,freq1*2,band,band.sqrt.reciprocal*amp1*buffer*bg1),
feed11*buffer*bg1])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed12,freq1*2,band,band.sqrt.reciprocal*amp1*buffer*bg2),
feed12*buffer*bg2])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed13,freq1*2,band,band.sqrt.reciprocal*amp1*buffer*bg3),
feed13*buffer*bg3])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed14,freq1*2,band,band.sqrt.reciprocal*amp1*buffer*bg4),
feed14*buffer*bg4])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed15,freq1*2,band,band.sqrt.reciprocal*amp1*buffer*bg5),
feed15*buffer*bg5])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed16,freq1*2,band,band.sqrt.reciprocal*amp1*buffer*bg6),
feed16*buffer*bg6])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed17,freq1*2,band,band.sqrt.reciprocal*amp1*buffer*bg7),
feed17*buffer*bg7])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed18,freq1*2,band,band.sqrt.reciprocal*amp1*buffer*bg8),
feed18*buffer*bg8])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed19,freq1*2,band,band.sqrt.reciprocal*amp1*buffer*bg9),
feed19*buffer*bg9])
)));
sig2=
((((((((((
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
(rect_level*LPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:level).abs*SinOsc.ar(freq2,phase:phasey+ph)),freq2*heavy,amp2))+
(
Select.ar(band.round(1).asInteger,[BPF.ar(feed21,freq2*2,band,band.sqrt.reciprocal*amp2*buffer*bg1),
feed21*buffer*bg1])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed22,freq2*2,band,band.sqrt.reciprocal*amp2*buffer*bg2),
feed22*buffer*bg2])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed23,freq2*2,band,band.sqrt.reciprocal*amp2*buffer*bg3),
feed23*buffer*bg3])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed24,freq2*2,band,band.sqrt.reciprocal*amp2*buffer*bg4),
feed24*buffer*bg4])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed25,freq2*2,band,band.sqrt.reciprocal*amp2*buffer*bg5),
feed25*buffer*bg5])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed26,freq2*2,band,band.sqrt.reciprocal*amp2*buffer*bg6),
feed26*buffer*bg6])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed27,freq2*2,band,band.sqrt.reciprocal*amp2*buffer*bg7),
feed27*buffer*bg7])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed28,freq2*2,band,band.sqrt.reciprocal*amp2*buffer*bg8),
feed28*buffer*bg8])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed29,freq2*2,band,band.sqrt.reciprocal*amp2*buffer*bg9),
feed29*buffer*bg9])
))
);
sig3=
((((((((((
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
(rect_level*LPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:level).abs*SinOsc.ar(freq3,phase:phasez+ph)),freq3*heavy,amp3))+
(
Select.ar(band.round(1).asInteger,[BPF.ar(feed31,freq3*2,band,band.sqrt.reciprocal*amp3*buffer*bg1),
feed31*buffer*bg1])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed32,freq3*2,band,band.sqrt.reciprocal*amp3*buffer*bg2),
feed32*buffer*bg2])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed33,freq3*2,band,band.sqrt.reciprocal*amp3*buffer*bg3),
feed33*buffer*bg3])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed34,freq3*2,band,band.sqrt.reciprocal*amp3*buffer*bg4),
feed34*buffer*bg4])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed35,freq3*2,band,band.sqrt.reciprocal*amp3*buffer*bg5),
feed35*buffer*bg5])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed36,freq3*2,band,band.sqrt.reciprocal*amp3*buffer*bg6),
feed36*buffer*bg6])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed37,freq3*2,band,band.sqrt.reciprocal*amp3*buffer*bg7),
feed37*buffer*bg7])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed38,freq3*2,band,band.sqrt.reciprocal*amp3*buffer*bg8),
feed38*buffer*bg8])+
Select.ar(band.round(1).asInteger,[BPF.ar(feed39,freq3*2,band,band.sqrt.reciprocal*amp3*buffer*bg9),
feed39*buffer*bg9])
))
);

sig1=(sig1*heavy).softclip;
sig2=(sig2*heavy).softclip;
sig3=(sig3*heavy).softclip;

control1=(sig1/1);
control2=(sig2/1);
control3=(sig3/1);
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
Out.ar(6,sig1*gain*env);
Out.ar(7,sig2*gain*env);
Out.ar(8,sig3*gain*env);

////verb
chainwet1 =  FFT(LocalBuf(frames), InFeedback.ar(6));
chainwet2 =  FFT(LocalBuf(frames), InFeedback.ar(7));
chainwet3 =  FFT(LocalBuf(frames), InFeedback.ar(8));

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
sig11=(verb1*mix)+(dry1*mix.linlin(0.001,1,1,0.001));
sig22=(verb2*mix)+(dry2*mix.linlin(0.001,1,1,0.001));
sig33=(verb3*mix)+(dry3*mix.linlin(0.001,1,1,0.001));

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
Out.ar(2,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig11*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig11*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
Out.ar(4,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig11*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
Out.ar(5,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig11*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig22*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig22*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
Out.ar(4,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig22*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
Out.ar(5,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig22*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig33*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig33*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
Out.ar(4,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig33*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
Out.ar(5,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig33*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain*env)),limit,0.01));
);

///b-format stereo defuser
///w=flu+frd+bld+bru
//x=flu+frd-bld-bru
//y=flu-frd+bld-bru
//z=flu-frd-bld+bru
(
bw=(
InFeedback.ar(2)+
InFeedback.ar(3)+
InFeedback.ar(4)+
InFeedback.ar(5));
bx=(
InFeedback.ar(2)-
InFeedback.ar(3)-
InFeedback.ar(4)+
InFeedback.ar(5));
by=(
InFeedback.ar(2)-
InFeedback.ar(3)+
InFeedback.ar(4)-
InFeedback.ar(5));
bz=(
InFeedback.ar(2)+
InFeedback.ar(3)-
InFeedback.ar(4)-
InFeedback.ar(5));
);
/////xyz out
//Out.ar(9,bx);
//Out.ar(10,by);
//Out.ar(11,bz);
////stereo
//Out.ar(0,DecodeB2.ar(2, bw, bx, by,0)*spread.linlin(0.01,1,0.5,1));
Out.ar(0,BFDecode1.ar(bw, bx, by, bz,[polytope.theta,polytope.theta+0.5pi], [polytope.phi,polytope.phi])*spread.linlin(0.01,1,0.5,1)*env);
}).add
);

3.wait;

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

(
		~pattern=Pdef(\1, Pbind(\instrument, \synth,
			\dur,Pseq(~dur*1,inf),
				\gain,Pbrown(0.4,0.6,exp(4.neg),inf),\drive,Pbrown((8128).neg,(16256*1),exp(4).round(1).asInteger,inf),
				\c,Pbrown(16256,16256*~orange,exp(1).round(1).asInteger,inf),
				\az,Pbrown(pi.neg,pi,14.degrad,inf),\el,Pbrown(0.5pi.neg,0.5pi,7.5.degrad,inf),
				\scalee,2.rand,\harmonic,4.rand,\fl,7.5,
				\bg1,Pbrown(0.0001,0.3,exp(1.neg),inf),\bg2,Pbrown(0.0001,0.3,exp(3.neg),inf),\bg3,Pbrown(0.0001,0.3,exp(4.neg),inf),
				\bg4,Pbrown(0.0001,0.3,exp(3.neg),inf),\bg5,Pbrown(0.0001,0.3,exp(2.neg),inf),\bg6,Pbrown(0.0001,0.3,exp(3.neg),inf),
				\bg7,Pbrown(0.0001,0.3,exp(1.neg),inf),\bg8,Pbrown(0.0001,0.3,exp(3.neg),inf),
				\bg9,Pbrown(0.0001,0.3,exp(4.neg),inf),\bg9,Pbrown(0.0001,1,exp(4.neg),inf),
				\lowend,32,\level,Pbrown(100,1000,exp(0.01),inf),\dyn,Pbrown(1,3,exp(4.neg),inf),
				\comp,Pbrown(10.pow(10),10.pow(12),10.pow(2),inf),\buffer,Pbrown(0.1,1,exp(1),inf),
				\tone_axis,0,
				\ran,Pbrown(16256,16256*~orange,exp(4).round(1).asInteger,inf),\rect_level,Pbrown(30,50,exp(2),inf),
				\sphharm,Pbrown((16256*12).neg,(16256*8).neg,exp(3).round(1).asInteger,inf),
				\speaker_size,Pbrown(0.1,0.3,exp(5.neg),inf),\room,Pbrown(0.8,1,exp(4.neg),inf),\mix,Pbrown(0.5,0.7,exp(4.neg),inf),
				\pan_mod,Pbrown((16256*10).neg,(16256*0),exp(3).round(1).asInteger,inf),\spread,Pbrown(0.05,1,exp(3.neg),inf),
				\limit,Pbrown(0.5,1,exp(4.neg),inf),
				\fu,32,\band,Pbrown(0.000001,1,exp(8.neg),inf),\attack,Pbrown(1/64,0.1,0.01,inf),
				\dicay,Pbrown(24,32,0.1,inf),\curv,Pbrown(2.neg,8.neg,0.1,inf);
	)));
		2.wait;
		~pattern.play;
			TempoClock.default.tempo_(1/4);

	}); Tdef(\drone).play;
})
)

s.record(numChannels:4)


////visual
(
~orange=3;
~bspeed=1;
 ~bfreq=2;
~bamp=3;
~time=120;
~count=[2,2,2,2,2,2];
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
var amp=2,range=16256;
var theta,phi ,wave,bessel;

	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[]; ~cart=[];      ~detune=1;
data = [];
Window.free;
~w = Window.new("3D Scatterplot", Rect(40,40, 2000, 1200)).front;

~v = UserView.new(~w,Rect(0,0,1800,1000)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 1800,1000), ~data, [range.neg, range].asSpec,[range.neg, range].asSpec,[range.neg, range].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 2;
a.symbolColor = Color.white;
a.background = Color.clear;
b = ScatterView3d(~v, Rect(0,0, 1800,1000), ~data, [range.neg, range].asSpec,[range.neg, range].asSpec,[range.neg, range].asSpec);
b.drawMethod = \fillRect;
b.symbolSize = 2;
b.symbolColor = Color.white;
b.background = Color.clear;

  r= Routine({loop{

 waveSpeed = ~bspeed;
 waveFreq = ~bfreq;
 amp=~bamp;

		scale=~controlBus1.getSynchronous.linexp(0,(16256*~orange),(16256),1);
	scale1=~controlBus2.getSynchronous.linexp(0,(16256*~orange),992,1);
	scale2=~controlBus3.getSynchronous.linexp(1,3,496,1);
	rotation=~controlBus4.getSynchronous.linlin((16256*10).neg,(16256*5),0.0001,20);
		harm=~controlBus5.getSynchronous;
		temp=~controlBus1.getSynchronous.linexp(0,(16256*~orange),1,0);
			space=~controlBus1.getSynchronous.linexp(0,(16256*~orange),0,1);
						bessel=~controlBus6.getSynchronous*10;

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
			mag=(Cartesian(~magx.[pla],~magy.[pla],~magz.[pla]).rho)/2.sqrt;
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
}.defer);

)

