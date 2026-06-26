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
~c1 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260509_123352.wav",channels:1 );
~c2 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260509_123352.wav",channels:2 );
~c3 = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260509_123352.wav",channels:3 );
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
				room=0.5,mix=0.5,pan_mod=0.01,spread=1,limit=0.8,fu=32,dyn=1,band=0.000001,comp=10.pow(35),buffer=1,sphharm=1;

var expansion,heavy,fundamental,sph_mod,polytope,bessel_ripple,magx,magy,magz,sph,mod_timbre,mass=~mass;
var ton1,ton2,ton3,tonal_x,tonal_y,tonal_z,mod_x,mod_y,mod_z,phase_mod_x,phase_mod_y,phase_mod_z;
var mod_anglex,mod_angley,mod_anglez,m,mx,my,mz,sph_x,sph_y,sph_z,sph_mag,phasex,phasey,phasez;
var freq1,freq2,freq3,amp1,amp2,amp3,feed,control1,control2,control3,sig1,sig2,sig3;
var oct1,oct2,oct3,oct4,oct5,oct6,oct7,oct8,oct9,g=((1+5.sqrt)/2),s=(1+2.sqrt),pan,m_sphharm,tonal_polytope;
var step,ph,ph1,ph2,ph3,ph4,ph5,ph6,ph7,ph8,ph9,orange=~orange,polx,poly,polz,mag_sphharm;
var threshold1,threshold2,threshold3,g_ch1,g_ch2,g_ch3,g_ch4,pan1,pan2,pan3,pan4,bessel_wave;
var waveAmp,waveSpeed,waveFreq,dyn1,dyn2,dyn3,dyn4,dyn5,dyn6,dyn7,dyn8,dyn9,timbre;
var tonaldegree_x,tonaldegree_y,tonaldegree_z,feed1,feed2,feed3,bw,bx,by,bz,sstep;

pan=2.pow(pan_mod.lag(0.001)/16256);
ph = (2pi-(2pi/s));
heavy=2.pow(drive.lag(0.001)/16256);
mass=heavy/comp;
dyn1=dyn*2;
dyn2=dyn*3;
dyn3=dyn*4;
dyn4=dyn*5;
dyn5=dyn*6;
dyn6=dyn*7;
dyn7=dyn*8;
dyn8=dyn*9;
dyn9=dyn*10;
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
waveAmp=expansion*gain;
waveSpeed=expansion*2;
waveFreq=expansion.reciprocal;
bessel_wave=waveAmp*sin((waveFreq*polytope.theta)+(waveFreq * polytope.phi)-waveSpeed);
bessel_ripple=Complex(1,bessel_wave).theta*2;

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

feed1=feed2=feed3=(SoundIn.ar(0,buffer));    ///input
//feed2=(SoundIn.ar(1,buffer));
//feed3=(feed1+feed2)/2.sqrt;
//feed=(WhiteNoise.ar(buffer));    ///noise
//feed1=(PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 1, doneAction:0)*(buffer/10));   ////buffer
//feed2=(PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2.bufnum), loop: 1, doneAction:0)*(buffer/10));
//feed3=(feed1+feed2)/2.sqrt;
//feed3=(PlayBuf.ar(1, ~c3.bufnum, BufRateScale.kr(~c3.bufnum), loop: 1, doneAction:0)*(buffer/10));


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
(BPF.ar(feed1,freq1,band,band.sqrt.reciprocal*amp1*buffer)))
);
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
(BPF.ar(feed2,freq2,band,band.sqrt.reciprocal*amp2*buffer)))
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
(BPF.ar(feed3,freq3,band,band.sqrt.reciprocal*amp3*buffer)))
);

sig1=(sig1*heavy).softclip;
sig2=(sig2*heavy).softclip;
sig3=(sig3*heavy).softclip;

control1=SinOsc.ar(freq1,phase:phasex+ph,mul:amp1)+feed1;
control2=SinOsc.ar(freq2,phase:phasey+ph,mul:amp2)+feed2;
control3=SinOsc.ar(freq3,phase:phasez+ph,mul:amp3)+feed3;
threshold1=(((343/speaker_size)/fundamental).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/speaker_size)/fundamental).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/speaker_size)/fundamental).reciprocal.ampdb/2.sqrt).dbamp;

sig1=HPF.ar(sig1,lowend);
sig2=HPF.ar(sig2, lowend);
sig3=HPF.ar(sig3, lowend);

sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);

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

Out.ar(0,DecodeB2.ar(2, bw, bx, by,0)*spread.reciprocal);
			//Out.ar(0,BFDecode1.ar(bw, bx, by, bz,[polytope.theta,polytope.theta+0.5pi], [polytope.phi,polytope.phi]));

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
~level=10.pow(0);
(
~synth=Synth.new(\synth,[\gain,1,\drive,16256,\c,0,\az,0.3pi,\el,0,\scale,0,\harmonic,1,
				\lowend,64,\level,700,\dyn,1,\comp,~level,\buffer,1,\tone_axis,1,\ran,0,\rect_level,1,
\sphharm,0,\speaker_size,0.15,\room,0.5,\mix,0.3,\pan_mod,16*16256.neg,\spread,1,\limit,0.8,\fu,64,\band,1]).register);

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


);

);2.wait;

			(
			{
var sizex=1450, sizey=750, sl=170;
var px1=0,py1=0,px2=sl+(sl/2),py2=0,px3=px2+sl+(sl/2),py3=0,px4=px3+sl+(sl/2),py4=0,px5=px4+sl+(sl/2),py5=0,px6=px5+sl+(sl/2),py6=0;
var px7=0,py7=sl+(sl/4),px8=px7+sl+(sl/2),py8=sl+(sl/4),px9=px8+sl+(sl/2),py9=sl+(sl/4);
var px10=px9+sl+(sl/2),py10=sl+(sl/4),px11=px10+sl+(sl/2),py11=sl+(sl/4),px12=px11+sl+(sl/2),py12=sl+(sl/4);
var px13=0,py13=py7+sl+(sl/4),px14=px13+sl+(sl/2),py14=py7+sl+(sl/4),px15=px14+sl+(sl/2),py15=py7+sl+(sl/4),px16=px15+sl+(sl/2);
var py16=py7+sl+(sl/4),px17=px16+sl+(sl/2),py17=py7+sl+(sl/4),px18=px17+sl+(sl/2), py18=py7+sl+(sl/4);
var px19=0,py19=py13+sl+(sl/4),px20=px19+sl+(sl/2),py20=py13+sl+(sl/4);
var px21=px20+sl+(sl/2),py21=py13+sl+(sl/4),px22=px21+sl+(sl/2),py22=py13+sl+(sl/4),px23=px22+sl+(sl/2),py23=py13+sl+(sl/4),px24=px23+sl+(sl/2),py24=py13+sl+(sl/4);
//Window.closeAll;
~orange=3;
w=Window.new("c_gui", Rect(10, 10, sizex,sizey)).front;
~v = UserView(w, Rect(0,0,sizex,sizey)).background_(Color.black);

(
~nb1=NumberBox(~v,Rect(0+px1,(sl/4)+py1,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl1=StaticText(~v,Rect((sl/2)+px1,(sl/4)+py1,sl/2,sl/4)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl1=Slider2D.new(~v,Rect.new(px1,py1,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,1).postln;
~synth.set(\gain,value);
~nb1.value_(value);
});
);
(
~nb2=NumberBox(~v,Rect(0+px2,(sl/4)+py2,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl2=StaticText(~v,Rect((sl/2)+px2,(sl/4)+py2,sl/2,sl/4)).string_("drive").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl2=Slider2D.new(~v,Rect.new(px2,py2,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,(16256).neg,(16256*3)).round(1).asInteger.postln;
~synth.set(\drive,value);
~nb2.value_(value);
});
);
(
~nb3=NumberBox(~v,Rect(0+px3,(sl/4)+py3,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl3=StaticText(~v,Rect((sl/2)+px3,(sl/4)+py3,sl/2,sl/4)).string_("band").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl3=Slider2D.new(~v,Rect.new(px3,py3,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0.0001,1).postln;
~synth.set(\band,value);
~nb3.value_(value);
});
);
(
~nb4=NumberBox(~v,Rect(0+px4,(sl/4)+py4,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl4=StaticText(~v,Rect((sl/2)+px4,(sl/4)+py4,sl/2,sl/4)).string_("azimuth").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl4=Slider2D.new(~v,Rect.new(px4,py4,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,pi.neg,pi).postln;
~synth.set(\az,value);
~nb4.value_(value);
});
);
(
~nb5=NumberBox(~v,Rect(0+px5,(sl/4)+py5,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl5=StaticText(~v,Rect((sl/2)+px5,(sl/4)+py5,sl/2,sl/4)).string_("elevation").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl5=Slider2D.new(~v,Rect.new(px5,py5,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0.5pi.neg,0.5pi).postln;
~synth.set(\el,value);
~nb5.value_(value);
});
);
(
~nb6=NumberBox(~v,Rect(0+px6,(sl/4)+py6,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl6=StaticText(~v,Rect((sl/2)+px6,(sl/4)+py6,sl/2,sl/4)).string_("scale").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl6=Slider2D.new(~v,Rect.new(px6,py6,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,1).round(1).asInteger.postln;
~synth.set(\scale,value);
~nb6.value_(value);
});
);
(
~nb7=NumberBox(~v,Rect(0+px7,(sl/4)+py7,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl7=StaticText(~v,Rect((sl/2)+px7,(sl/4)+py7,sl/2,sl/4)).string_("lowend").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl7=Slider2D.new(~v,Rect.new(px7,py7,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,32,128).postln;
~synth.set(\lowend,value);
~nb7.value_(value);
});
);
(
~nb8=NumberBox(~v,Rect(0+px8,(sl/4)+py8,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl8=StaticText(~v,Rect((sl/2)+px8,(sl/4)+py8,sl/2,sl/4)).string_("c").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl8=Slider2D.new(~v,Rect.new(px8,py8,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,16256*~orange).round(1).asInteger.postln;
~synth.set(\c,value);
~nb8.value_(value);
});
);
(
~nb9=NumberBox(~v,Rect(0+px9,(sl/4)+py9,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl9=StaticText(~v,Rect((sl/2)+px9,(sl/4)+py9,sl/2,sl/4)).string_("dynamic").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl9=Slider2D.new(~v,Rect.new(px9,py9,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,1,3).round(1/4).postln;
~synth.set(\dyn,value);
~nb9.value_(value);
});
);
(
~nb10=NumberBox(~v,Rect(0+px10,(sl/4)+py10,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl10=StaticText(~v,Rect((sl/2)+px10,(sl/4)+py10,sl/2,sl/4)).string_("speaker_size").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl10=Slider2D.new(~v,Rect.new(px10,py10,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0.05,0.3).postln;
~synth.set(\speaker_size,value);
~nb10.value_(value);
});
);
(
~nb11=NumberBox(~v,Rect(0+px11,(sl/4)+py11,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl11=StaticText(~v,Rect((sl/2)+px11,(sl/4)+py11,sl/2,sl/4)).string_("room").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl11=Slider2D.new(~v,Rect.new(px11,py11,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,1).postln;
~synth.set(\room,value);
~nb11.value_(value);
});
);
(
~nb12=NumberBox(~v,Rect(0+px12,(sl/4)+py12,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl12=StaticText(~v,Rect((sl/2)+px12,(sl/4)+py12,sl/2,sl/4)).string_("mix").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl12=Slider2D.new(~v,Rect.new(px12,py12,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,1).postln;
~synth.set(\mix,value);
~nb12.value_(value);
});
);
(
~nb13=NumberBox(~v,Rect(0+px13,(sl/4)+py13,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl13=StaticText(~v,Rect((sl/2)+px13,(sl/4)+py13,sl/2,sl/4)).string_("pann").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl13=Slider2D.new(~v,Rect.new(px13,py13,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,(16256*10).neg,(16256*5)).round(1).asInteger.postln;
~synth.set(\pan_mod,value);
~nb13.value_(value);
});
);
(
~nb14=NumberBox(~v,Rect(0+px14,(sl/4)+py14,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl14=StaticText(~v,Rect((sl/2)+px14,(sl/4)+py14,sl/2,sl/4)).string_("spread").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl14=Slider2D.new(~v,Rect.new(px14,py14,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,1,0.1).postln;
~synth.set(\spread,value);
~nb14.value_(value);
});
);
(
~nb15=NumberBox(~v,Rect(0+px15,(sl/4)+py15,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl15=StaticText(~v,Rect((sl/2)+px15,(sl/4)+py15,sl/2,sl/4)).string_("limiter").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl15=Slider2D.new(~v,Rect.new(px15,py15,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,1,0.001).postln;
~synth.set(\limit,value);
~nb15.value_(value);
});
);
(
~nb16=NumberBox(~v,Rect(0+px16,(sl/4)+py16,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl16=StaticText(~v,Rect((sl/2)+px16,(sl/4)+py16,sl/2,sl/4)).string_("fundamental").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl16=Slider2D.new(~v,Rect.new(px16,py16,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,2,9).round(1).asInteger.postln;
~synth.set(\fu,2.pow(value));
~nb16.value_(value);
});
);
(
~nb17=NumberBox(~v,Rect(0+px17,(sl/4)+py17,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl17=StaticText(~v,Rect((sl/2)+px17,(sl/4)+py17,sl/2,sl/4)).string_("comp").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl1=Slider2D.new(~v,Rect.new(px17,py17,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,10000000).postln;
~synth.set(\comp,value);
~nb17.value_(value);
});
);
(
~nb18=NumberBox(~v,Rect(0+px18,(sl/4)+py18,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl18=StaticText(~v,Rect((sl/2)+px18,(sl/4)+py18,sl/2,sl/4)).string_("buffer_gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl18=Slider2D.new(~v,Rect.new(px18,py18,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,500).postln;
~synth.set(\buffer,value);
~nb18.value_(value);
});
);
(
~nb19=NumberBox(~v,Rect(0+px19,(sl/4)+py19,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl19=StaticText(~v,Rect((sl/2)+px19,(sl/4)+py19,sl/2,sl/4)).string_("rect_level").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl19=Slider2D.new(~v,Rect.new(px19,py19,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,1000).postln;
~synth.set(\level,value);
~nb19.value_(value);
});
);
(
~nb20=NumberBox(~v,Rect(0+px20,(sl/4)+py20,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl20=StaticText(~v,Rect((sl/2)+px20,(sl/4)+py20,sl/2,sl/4)).string_("harm_mod").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl1=Slider2D.new(~v,Rect.new(px20,py20,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,(16256*12).neg,(16256*6)).round(1).asInteger.postln;
~synth.set(\sphharm,value);
~nb20.value_(value);
});
);
(
~nb21=NumberBox(~v,Rect(0+px21,(sl/4)+py21,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl21=StaticText(~v,Rect((sl/2)+px21,(sl/4)+py21,sl/2,sl/4)).string_("axis").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl21=Slider2D.new(~v,Rect.new(px21,py21,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,2).round(1).asInteger.postln;
~synth.set(\tone_axis,value);
~nb21.value_(value);
});
);
(
~nb22=NumberBox(~v,Rect(0+px22,(sl/4)+py22,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl22=StaticText(~v,Rect((sl/2)+px22,(sl/4)+py22,sl/2,sl/4)).string_("tonal_range").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl22=Slider2D.new(~v,Rect.new(px22,py22,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,16256*~orange).round(1).asInteger.postln;
~synth.set(\ran,value);
~nb22.value_(value);
});
);
(
~nb23=NumberBox(~v,Rect(0+px23,(sl/4)+py23,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl23=StaticText(~v,Rect((sl/2)+px23,(sl/4)+py23,sl/2,sl/4)).string_("drone_level").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl23=Slider2D.new(~v,Rect.new(px23,py23,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,100).postln;
~synth.set(\rect_level,value);
~nb23.value_(value);
});
);
(
~nb24=NumberBox(~v,Rect(0+px24,(sl/4)+py24,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl24=StaticText(~v,Rect((sl/2)+px24,(sl/4)+py24,sl/2,sl/4)).string_("spherical_harm").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl24=Slider2D.new(~v,Rect.new(px24,py24,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,1,10).round(1).asInteger.postln;
~synth.set(\harmonic,value);
~nb24.value_(value);
});
);
						}.defer
)


	}); Tdef(\drone).play;
})
)