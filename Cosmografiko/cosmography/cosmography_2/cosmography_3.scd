
Server.killAll
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=6;
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

s.freqscope;
s.scope;
//s.makeWindow;
s.meter;
~tempo=1;
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
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);
~controlBus3 = Bus.control(s, 1);
~controlBus4 = Bus.control(s, 1);
~controlBus5 = Bus.control(s, 1);
~controlBus6 = Bus.control(s, 1);

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

~orange=3;
~mass=0;

/////sound engine
(
SynthDef.new(\synth,{

arg gain=1,drive=0,c=0,az=0,el=0,scale=0,lowend=64,level=100,speaker_size=0.15,tone_axis=0,ran=0,rect_level=1,harmonic=1,
				bg1=1,bg2=1,bg3=1,bg4=1,bg5=1,bg6=1,bg7=1,bg8=1,bg9=1,
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

pan=2.pow(pan_mod.lag(0.001)/16256);
ph = (2pi-(2pi/s));
heavy=2.pow(drive.lag(0.001)/16256);
level=level*heavy;
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
m_sphharm=Spherical(mag_sphharm,az.lag(0.001),el.lag(0.001));
sph_mod=2.pow(sphharm.lag(0.001)/16256);
mx=m_sphharm.x.abs;
my=m_sphharm.y.abs;
mz=m_sphharm.z.abs;
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

ton1=2.pow(Select.kr(tonal_polytope.x.round(1).abs.linlin(1,timbre,0,~note).round(1), Select.kr(scale.lag(0.001),~sc)) /12);
ton2=2.pow(Select.kr(tonal_polytope.y.round(1).abs.linlin(1,timbre,0,~note).round(1), Select.kr(scale.lag(0.001),~sc)) /12);
ton3=2.pow(Select.kr(tonal_polytope.z.round(1).abs.linlin(1,timbre,0,~note).round(1), Select.kr(scale.lag(0.001),~sc)) /12);

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

mod_anglex=(LPF.ar((Osc.ar(~wt.bufnum,sph_mod,phase:phase_mod_x,mul:100).abs*
SinOsc.ar(sph_mod,phase:phase_mod_x)),
sph_mod*heavy)).range(pi.neg,pi);
mod_angley=(LPF.ar((Osc.ar(~wt.bufnum,sph_mod,phase:phase_mod_y,mul:100).abs*
SinOsc.ar(sph_mod,phase:phase_mod_y)),
sph_mod*heavy)).range(pi.neg,pi);
mod_anglez=(LPF.ar((Osc.ar(~wt.bufnum,sph_mod,phase:phase_mod_z,mul:100).abs*
SinOsc.ar(sph_mod,phase:phase_mod_z)),
sph_mod*heavy)).range(35.264390.degrad,35.264390.degrad.neg);

magx=((Complex(cos(((polytope.theta+mod_anglex)*mx).wrap(pi.neg,pi)),
cos((((polytope.theta+mod_anglex)*mx)).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi).wrap((pi/2).neg,(pi/2))),cos((polytope.phi).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magy=((Complex(sin(((polytope.theta+mod_angley)*my).wrap(pi.neg,pi)),
sin(((polytope.theta+mod_angley)*my).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi).wrap((pi/2).neg,(pi/2))),cos((polytope.phi).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magz=((Complex(cos(((polytope.phi+mod_anglez)*mz).wrap((pi/2).neg,(pi/2))),
cos(((polytope.phi)*mz).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

sph_x=(Cartesian(magx,0,0).rho);
sph_y=(Cartesian(0,magy,0).rho);
sph_z=(Cartesian(0,0,magz).rho);
sph_mag=(Cartesian(sph_x,sph_y,sph_z));
sph=Spherical(sph_mag.rho,polytope.theta,polytope.phi);
polx=Spherical(sph_x*timbre,polytope.theta,polytope.phi);
poly=Spherical(sph_y*timbre,polytope.theta,polytope.phi);
polz=Spherical(sph_z*timbre,polytope.theta,polytope.phi);

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

//feed1=(SoundIn.ar(0,buffer));    ///input
//feed2=(SoundIn.ar(1,buffer));
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
((((((((((((
				/*	((((
					((
(SinOsc.ar(freq1*oct2,phasex+ph8,amp1*oct2.reciprocal)).abs*
(SinOsc.ar(freq1*oct3,phasex+ph7,amp1*oct3.reciprocal))).abs+mass)*
(SinOsc.ar(freq1*oct4,phasex+ph6,amp1*oct4.reciprocal))).abs+mass)*
(SinOsc.ar(freq1*oct5,phasex+ph5,amp1*oct5.reciprocal))).abs+mass)**/
(SinOsc.ar(freq1*oct6,phasex+ph4,amp1*oct6.reciprocal))).abs+mass)*
(SinOsc.ar(freq1*oct7,phasex+ph3,amp1*oct7.reciprocal))).abs+mass)*
(SinOsc.ar(freq1*oct8,phasex+ph2,amp1*oct8.reciprocal))).abs+mass)*
(SinOsc.ar(freq1*oct9,phasex+ph1,amp1*oct9.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex+ph,mul:level).abs*SinOsc.ar(freq1,phase:phasex+ph)),freq1*heavy,amp1)))*comp)+
(rect_level*LPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex+ph,mul:level).abs*SinOsc.ar(freq1,phase:phasex+ph)),freq1*heavy,amp1))+
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
((((((((((((
				/*	((((
					((
(SinOsc.ar(freq2*oct2,phasey+ph8,amp2*oct2.reciprocal)).abs*
(SinOsc.ar(freq2*oct3,phasey+ph7,amp2*oct3.reciprocal))).abs+mass)*
(SinOsc.ar(freq2*oct4,phasey+ph6,amp2*oct4.reciprocal))).abs+mass)*
(SinOsc.ar(freq2*oct5,phasey+ph5,amp2*oct5.reciprocal))).abs+mass)**/
(SinOsc.ar(freq2*oct6,phasey+ph4,amp2*oct6.reciprocal))).abs+mass)*
(SinOsc.ar(freq2*oct7,phasey+ph3,amp2*oct7.reciprocal))).abs+mass)*
(SinOsc.ar(freq2*oct8,phasey+ph2,amp2*oct8.reciprocal))).abs+mass)*
(SinOsc.ar(freq2*oct9,phasey+ph1,amp2*oct9.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey+ph,mul:level).abs*SinOsc.ar(freq2,phase:phasey+ph)),freq2*heavy,amp2)))*comp)+
(rect_level*LPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey+ph,mul:level).abs*SinOsc.ar(freq2,phase:phasey+ph)),freq2*heavy,amp2))+
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
((((((((((((
				/*	((((
					((
(SinOsc.ar(freq3*oct2,phasez+ph8,amp3*oct2.reciprocal)).abs*
(SinOsc.ar(freq3*oct3,phasez+ph7,amp3*oct3.reciprocal))).abs+mass)*
(SinOsc.ar(freq3*oct4,phasez+ph6,amp3*oct4.reciprocal))).abs+mass)*
(SinOsc.ar(freq3*oct5,phasez+ph5,amp3*oct5.reciprocal))).abs+mass)**/
(SinOsc.ar(freq3*oct6,phasez+ph4,amp3*oct6.reciprocal))).abs+mass)*
(SinOsc.ar(freq3*oct7,phasez+ph3,amp3*oct7.reciprocal))).abs+mass)*
(SinOsc.ar(freq3*oct8,phasez+ph2,amp3*oct8.reciprocal))).abs+mass)*
(SinOsc.ar(freq3*oct9,phasez+ph1,amp3*oct9.reciprocal))).abs+mass)*
(LPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez+ph,mul:level).abs*SinOsc.ar(freq3,phase:phasez+ph)),freq3*heavy,amp3)))*comp)+
(rect_level*LPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez+ph,mul:level).abs*SinOsc.ar(freq3,phase:phasez+ph)),freq3*heavy,amp3))+
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

gain=gain*dyn;

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
FreeVerb.ar(sig1*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(4,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(5,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(4,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(5,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(4,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(5,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
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

//Out.ar(0,DecodeB2.ar(2, bw, bx, by,0)*spread.linlin(0.1,1,0.5,1));
Out.ar(0,BFDecode1.ar(bw, bx, by, bz,[polytope.theta,polytope.theta+0.5pi], [polytope.phi,polytope.phi])*spread.linlin(0.1,1,0.5,1));

////stereo
/*(
Out.ar(0,Pan2.ar(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*sph_x)),limit,0.01),pan1));
Out.ar(0,Pan2.ar(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*sph_y)),limit,0.01),pan3));
Out.ar(0,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*sph_z)),limit,0.01)!2);
)*/
///three channel
/*(
Out.ar(4,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain*sph_x)),limit,0.01));
Out.ar(5,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain*sph_y)),limit,0.01));
Out.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain*sph_z)),limit,0.01));
)*/
////3d vbap expansion
/*(
Out.ar(0,VBAP.ar(4,
Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.001),room.lag(0.001),mul:gain*sph_x)),0.9,0.01),
~vbap_buf ,
(polytope.theta.raddeg+pan1.range(0.5pi.neg.raddeg,0.5pi.raddeg)).wrap(180,180.neg),
(polytope.phi.raddeg+bessel_ripple.raddeg).wrap(90,90.neg),
spread:spread.reciprocal));
Out.ar(0,VBAP.ar(4,
Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.001),room.lag(0.001),mul:gain*sph_y)),0.9,0.01),
~vbap_buf ,
(polytope.theta.raddeg+pan3.range(0.5pi.neg.raddeg,0.5pi.raddeg)).wrap(180,180.neg),
(polytope.phi.raddeg+bessel_ripple.raddeg).wrap(90,90.neg),
spread:spread.reciprocal));
Out.ar(0,VBAP.ar(4,
Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.001),room.lag(0.001),mul:gain*sph_z)),0.9,0.01),
~vbap_buf ,
(polytope.theta.raddeg+bessel_ripple.raddeg).wrap(180,180.neg),
(polytope.phi.raddeg).wrap(90,90.neg),
spread:spread.reciprocal));
)*/
}).add
);

2.wait;
//~mass=10.pow(45.neg);
		~mass=0;
(
~synth=Synth.new(\synth,[\gain,1,\drive,0,\c,0,\az,0,\el,0,\scale,0,\harmonic,1,
				\bg1,1,\bg2,1,\bg3,1,\bg4,1,\bg5,1,\bg6,1,\bg7,1,\bg8,1,\bg9,1,
				\lowend,64,\level,600,\dyn,1,\comp,1,\buffer,10,\tone_axis,1,\ran,16256,\rect_level,2,
\sphharm,0,\speaker_size,0.15,\room,0.5,\mix,0.3,\pan_mod,16*16256.neg,\spread,1,\limit,0.8,\fu,64,\band,10]).register);

		///midi control
(
MIDIClient.init;
MIDIIn.connectAll;
(
(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0,1);
a.postln;
if(~synth.isPlaying,{~synth.set(\gain,a)});
},1);
);
(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,(16256).neg,(16256*3)).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\drive,a)});
},2);
);
(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
var a;
a=val.linexp(0,127,0.000001,1);
a.postln;
if(~synth.isPlaying,{~synth.set(\band,a)});
},3);
);
(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,pi.neg,pi);
a.postln;
if(~synth.isPlaying,{~synth.set(\az,a)});
},4);
);
(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0.5pi.neg,0.5pi);
a.postln;
if(~synth.isPlaying,{~synth.set(\el,a)});
},5);
);
(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0,1).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\scale,a)});
},6);
);
(
MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,32,128);
a.postln;
if(~synth.isPlaying,{~synth.set(\lowend,a)});
},7);
);
(
MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0,16256*~orange).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\c,a)});
},8);
);
(
MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
var a;
a=val.linexp(0,127,1,3);
a.postln;
if(~synth.isPlaying,{~synth.set(\dyn,a)});
},9);
);
(
MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0.05,0.3);
a.postln;
if(~synth.isPlaying,{~synth.set(\speaker_size,a)});
},10);
);
(
MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
var a;
a=val.linexp(0,127,0.1,1);
a.postln;
if(~synth.isPlaying,{~synth.set(\room,a)});
},11);
);
(
MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0,1);
a.postln;
if(~synth.isPlaying,{~synth.set(\mix,a)});
},12);
);
(
MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|
var a;
	a=val.linlin(0,127,(16256*10).neg,(16256*5)).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\pan_mod,a)});
},13);
);
(
MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|
var a;
a=val.linexp(0,127,1,0.1);
a.postln;
if(~synth.isPlaying,{~synth.set(\spread,a)});
},14);
);
(
MIDIdef.cc(\midi_pot15,{ |val, num, chan, src|
var a;
a=val.linexp(0,127,1,0.001);
a.postln;
if(~synth.isPlaying,{~synth.set(\limit,a)});
},15);
);
(
MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|
var a,b;
a=val.linlin(0,127,2,9).round(1).asInteger;
b=2.pow(a);
b.postln;
if(~synth.isPlaying,{~synth.set(\fu,b)});
},16);
);
(
MIDIdef.cc(\midi_pot17,{ |val, num, chan, src|
var a,b;
b=val.linexp(0,127,0.00001,10000);
//b=10.pow(a);
b.postln;
if(~synth.isPlaying,{~synth.set(\comp,b)});
},17);
);
(
MIDIdef.cc(\midi_pot18,{ |val, num, chan, src|
var a;
a=val.linexp(0,127,0.001,100);
a.postln;
if(~synth.isPlaying,{~synth.set(\buffer,a)});
},18);
);
(
MIDIdef.cc(\midi_pot19,{ |val, num, chan, src|
var a;
a=val.linexp(0,127,0.00001,1000);
a.postln;
if(~synth.isPlaying,{~synth.set(\level,a)});
},19);
);
(
MIDIdef.cc(\midi_pot20,{|val, num, chan, src|
var a;
a=val.linlin(0,127,(16256*12).neg,(16256*6)).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\sphharm,a)});
},20);
);
(
MIDIdef.cc(\midi_pot21,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0,2).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\tone_axis,a)});
},21);
);
(
MIDIdef.cc(\midi_pot22,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0,16256*~orange).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\ran,a)});
},22);
);
(
MIDIdef.cc(\midi_pot23,{ |val, num, chan, src|
var a;
a=val.linexp(0,127,0.00001,100);
a.postln;
if(~synth.isPlaying,{~synth.set(\rect_level,a)});
},23);
);
(
MIDIdef.cc(\midi_pot24,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,1,10).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\harmonic,a)});
},24);
);
(
MIDIdef.cc(\midi_slider1,{ |val, num, chan, src|
var bfg;
bfg=val.linexp(0,127,0.001,1);
bfg.postln;
if(~synth.isPlaying,{~synth.set(\bg1,bfg)});
},25);
);
(
MIDIdef.cc(\midi_slider2,{ |val, num, chan, src|
var bfg;
bfg=val.linexp(0,127,0.001,1);
bfg.postln;
if(~synth.isPlaying,{~synth.set(\bg2,bfg)});
},26);
);
(
MIDIdef.cc(\midi_slider3,{ |val, num, chan, src|
var bfg;
bfg=val.linexp(0,127,0.001,1);
bfg.postln;
if(~synth.isPlaying,{~synth.set(\bg3,bfg)});
},27);
);
(
MIDIdef.cc(\midi_slider4,{ |val, num, chan, src|
var bfg;
bfg=val.linexp(0,127,0.001,1);
bfg.postln;
if(~synth.isPlaying,{~synth.set(\bg4,bfg)});
},28);
);
(
MIDIdef.cc(\midi_slider5,{ |val, num, chan, src|
var bfg;
bfg=val.linexp(0,127,0.001,1);
bfg.postln;
if(~synth.isPlaying,{~synth.set(\bg5,bfg)});
},29);
);
(
MIDIdef.cc(\midi_slider6,{ |val, num, chan, src|
var bfg;
bfg=val.linexp(0,127,0.001,1);
bfg.postln;
if(~synth.isPlaying,{~synth.set(\bg6,bfg)});
},30);
);
(
MIDIdef.cc(\midi_slider7,{ |val, num, chan, src|
var bfg;
bfg=val.linexp(0,127,0.001,1);
bfg.postln;
if(~synth.isPlaying,{~synth.set(\bg7,bfg)});
},31);
);
(
MIDIdef.cc(\midi_slider8,{ |val, num, chan, src|
	var bfg;
bfg=val.linexp(0,127,0.001,1);
bfg.postln;
if(~synth.isPlaying,{~synth.set(\bg8,bfg)});
},32);
);
(
MIDIdef.cc(\midi_slider9,{ |val, num, chan, src|
var bfg;
bfg=val.linexp(0,127,0.001,1);
bfg.postln;
if(~synth.isPlaying,{~synth.set(\bg9,bfg)});
},49);
));

); 2.wait;
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
	rotation=~controlBus4.getSynchronous.linlin((16256*10).neg,(16256*5),0.0001,28);
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
}.defer);

)

	}); Tdef(\drone).play;
})
)



s.record(numChannels:4)



///sequencer///musical automaton
(
({
var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=32.reciprocal,beat=1,r=0;
~r=0;		~r1=0;		~r2=0;
(

~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~dur=[];

1.do{
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

~seq= Pseq(~dur ,inf).asStream;
~val=1234;
~tempo=1;
TempoClock.default.tempo_(~tempo);

(
~sq= Routine({loop{
thisThread.randSeed = ~val;

~synth.set(\az, pi.rand2);
~synth.set(\el, 0.5.rand2);
  ~seq.next.wait;
}}));

)
~sq.play;


///reactive control to cosmos animation

(
	~val=1234;

~str = Routine({
    var i=0,m,l,az=0,el=0,expansion;
	var r1,r2,r3,sphr,time=1/32,melody,rhythm;

    loop {
								thisThread.randSeed = ~val;
							i= ~cart.lag(0.01).size.rand;
				//	i=0;
	expansion=Cartesian(~cart.lag(0.01).[i].[0],
						~cart.lag(0.01).[i].[1],
						~cart.lag(0.00001).[i].[2]);
					rhythm=Spherical(0.25,expansion.theta,expansion.phi);
					melody=Spherical(10,expansion.theta,expansion.phi);
				r1=2.pow(rhythm.x.abs).round(time);
				r2=2.pow(rhythm.y.abs).round(time);
				r3=2.pow(rhythm.z.abs).round(time);
					sphr=[r1,r2,r3];

		~synth.set(\az, melody.theta,\c,(expansion.rho*3).round(1).asInteger);
~synth.set(\el, melody.phi,\c,(expansion.rho*3).round(1).asInteger);
		sphr.[0].next.wait;
			~synth.set(\az, melody.theta,\c,(expansion.rho*3).round(1).asInteger);
~synth.set(\el, melody.phi,\c,(expansion.rho*3).round(1).asInteger);
		sphr.[1].next.wait;
			~synth.set(\az, melody.theta,\c,(expansion.rho*3).round(1).asInteger);
~synth.set(\el, melody.phi,\c,(expansion.rho*3).round(1).asInteger);
		sphr.[2].next.wait;
    }
		});


		) ;
			~str.play;
~str.stop;

////////further spatial arrays
/*
/tetrahedron
(
~azimuth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
//////cube
(
~azimuth=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////octahedron

(
~azimuth=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~elevation=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
)

//////icosahedron
(
~azimuth=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~elevation=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)

/////dodecahedron

(
~azimuth=[45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,
	90.neg.degrad,69.09.degrad,110.91.degrad,110.91.neg.degrad,69.09.neg.degrad,0.degrad,180.degrad];

~elevation=[35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,69.09.neg.degrad,69.09.neg.degrad,20.91.neg.degrad,20.91.neg.degrad,
	35.26.degrad,35.26.degrad,35.26.degrad,35.26.degrad,69.09.degrad,69.09.degrad,0.degrad,0.degrad,0.degrad,0.degrad,20.91.degrad,20.91.degrad]
)

/////Rhombic dodecahedron//// hull

(
~azimuth=[0.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,0.degrad,180.degrad,90.degrad,90.neg.degrad,0.degrad,
	45.degrad,135.neg.degrad,135.degrad,45.neg.degrad];
~elevation=[90.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,0.degrad
	,0.degrad,0.degrad,0.degrad,90.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////cuboctahedron//// core

(
~azimuth=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~elevation=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)


///////////////Rhombic Triacontahedron//// hull
(
~azimuth=[0.degrad,0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,0.degrad];

~elevation=[90.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,90.degrad];

)

///////icosidodecahedron//// core
(
~azimuth=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~elevation=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];

)*/