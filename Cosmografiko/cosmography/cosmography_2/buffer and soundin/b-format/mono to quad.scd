(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*32;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 4;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
s.boot;
~frames=1024;
///bin width= samplerate/fft size (frames) ,  44100/1024
//center freq= bin index * bin width
///fft size= power of two
///bin frequency= (index*sample rate)/ fft size
/// bin number  eg
///(44100/1024)*463
)

Buffer.freeAll;
(
(
~r = Buffer.readChannel(s,,channels:0 );
);

(
~azimuth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
/////vbap
(
~vbap = VBAPSpeakerArray .new(3,
[[~azimuth.[0],~elevation.[0]], [~azimuth.[1],~elevation.[1]], [~azimuth.[2],~elevation.[2]], [~azimuth.[3],~elevation.[3]]]);
~vbap_buf = Buffer.loadCollection(s, ~vbap.getSetsAndMatrices);
);

(
~bins=430;
{
var steps = ~bins;
~nVals = steps.collect { |i|
 i.linexp(0, steps-1, 0.18, 463).round};
~nVals.asInteger;}.value;
);


(
SynthDef.new(\quad, {
arg spread;
var frames=~frames, polytope, sig, in, chain, chain1,bins;
var g=((1+5.sqrt)/2),s=(1+2.sqrt),az=pi.rand2,el=0.5pi.rand2,n=0;

bins=~bins;
 in = PlayBuf.ar(1, ~r.bufnum, BufRateScale.kr(~r.bufnum), loop: 0, doneAction:0);
chain = FFT(LocalBuf(frames), in);
~bins.do{
az = (az+(2pi-(2pi/s))).wrap(pi.neg,pi);
el = (el+(pi-(pi/s))).wrap(0.5pi.neg,0.5pi);
polytope=Spherical(1,az,el);
chain1 = chain.pvcollect(frames,
{|mag, phase, index| [mag, phase]; }, frombin: ~nVals.[n], tobin: ~nVals.[n], zeroothers: 1);

sig=IFFT(chain1);
Out.ar(0,VBAP.ar(4,sig*0.1,~vbap_buf.bufnum,polytope.theta.raddeg,polytope.phi.raddeg,spread));

n=n+1;
}
}).add;
);
)

(
~synth=Synth.new(\quad,[\spread,30]);
s.record(numChannels:4,duration:(1*60)+60)
)

