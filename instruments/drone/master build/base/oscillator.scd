///perfect number sequence
///note that there is a number for evety prime number of 0s to 1 like in the 10s, 100s,1000s,10000s,10000000s, 100000000000s and so on, but this symmetry breaks at
///7 to 11 0s including nine 0s. Primes are weird i would say
(
~primes=[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71];
(
{
var n=1.neg,c;
	~ps=8.collect{n=n+1; c=(2.pow(~primes.[n])-1).asInteger;
		if(c.isPrime,2.pow(~primes.[n]-1)*(2.pow(~primes.[n])-1),nil);
	}.reject(_.isNil);
	~ps.asFloat;
}.value
)
)
/////////////////
////////oscilator

////musical temperament method
(
~n=1.neg;~array=16256.collect{~n=~n+1;2.pow(~n/16256)};
~a=(0-(pi/8128)); ~ph=16256.collect{~a=~a+(pi/8128);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
)

/////lamdoma method
(
~n=0;~array=512.collect{~n=~n+1;(~n+1)/~n};
~a=(0-(pi/256)); ~ph=512.collect{~a=~a+(pi/256);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
)

/////sawtooth  method
(
~n=0;~array=512.collect{~n=~n+1;};
//~a=(0-(pi/256)); ~ph=512.collect{~a=~a+(pi/256);};
~ph=[0];
~bufferSize = 4096*8;
~signalSize = 2048*8;
)

/////////wavetable
(
Buffer.freeAll;
~w= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
	signal=Signal.sineFill(~signalSize,~array,~ph);

wt = signal.asWavetable;
~w.loadCollection(wt);
signal.plot;
		}.value;
)


(
{
	var freq=6*32, b=1,f=8,rz=100,amp=1;

Out.ar(0,LPF.ar((Osc.ar(~w.bufnum,freq,phase:0.degrad,mul:rz).abs*SinOsc.ar(freq,phase:0.degrad)),freq*f.round(1),amp));
Out.ar(1,LPF.ar((Osc.ar(~w.bufnum,freq,phase:90.degrad,mul:rz).abs*SinOsc.ar(freq,phase:90.degrad)),freq*f.round(1),amp));
}.play;
)


/*///additive synthesis

(
var fund=6*16, b=1,amp=1,freq,m=1,left,right,a=1,x=1,lamdoma,angle1=45;
var silver_ratio=(1+2.sqrt),gold_ratio=((1+5.sqrt)/2),interval,angle=0,ph=0.degrad;

64.do{

	lamdoma=(x+a)/x;

	interval=(m*lamdoma);
	freq=fund;

	amp=interval.reciprocal;

	left=exp(Complex(0,1)*angle1.degrad).real.abs;
	right=exp(Complex(0,1)*angle1.degrad).imag.abs.neg;

	{Out.ar(0,Pan2.ar(LPF.ar((Osc.ar(~w.bufnum,freq,phase:0.degrad+ph,mul:100).abs*SinOsc.ar(freq,phase:0.degrad+ph)),freq*m,amp),left))}.play;
	{Out.ar(0,Pan2.ar(LPF.ar((Osc.ar(~w.bufnum,freq,phase:90.degrad+ph,mul:100).abs*SinOsc.ar(freq,phase:90.degrad+ph)),freq*m,amp),right))}.play;
	ph=angle.degrad;
	m=m+1;
	angle=(angle+(360-(360/gold_ratio))).wrap(0,360);
	angle1=(angle1+(360-(360/silver_ratio))).wrap(0,360);
}
)*/


/*(
~control_seed=18.rand

(
//var silver_ratio=(1+2.sqrt),gold_ratio=((1+5.sqrt)/2), copper_ratio=pi;
var fibonacci=[1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181];
var pell=[0,1,2,5,12,29,70,169,408,985,2378,5741,13860,33461,80782,195025,470832,1136689];
//var polygon=[6,12,24,48,96,192,384,768,1536,3072,6144,12288,24576,49152,98304,196608,393216,786432];
//var polygon_octave=polygon.[~control_seed]/6, aprox,archimidis=polygon.[~control_seed];
var number=496/2,polygon=20.collect{number=number*2};
var interval_s,interval_g,interval_c,seed;

//aprox= ((sin((30/polygon_octave).degrad)*2)*polygon)/2;  //((sin((30/4).degrad)*2)*24)/2

///!!!
///((sin((((360/8128)/2)/128).degrad)*2)*(8128*128))/2  ///pi aproximation (archimedean) via perfect numbers "polygons" 6,28,496,8128

interval_g=fibonacci.[~control_seed];
interval_s=pell.[~control_seed];
interval_c=polygon.[~control_seed];

seed=interval_c.postln;
thisThread.randSeed = seed;

// create a function that returns a Routine

r = { Routine({
    loop({#[0,1,2,3].choose.yield })
}) };
Array.fill(4, r.value);
)

//((sin((((360/8128)/2)/128).degrad)*2)*(8128*128))/2
)*/

/*
(	~w= Buffer.alloc(s,2048);
		{
var signal,wt,m=0,amp,ph=0;
var mercury=0.24,venus=0.62,earth=1;
var mars=1.8,jupiter=11.86;
var saturn=29.46,uranus=84.01,neptune=164.8;
var pluto=248;
var sun= (256.0*1000000.0); ///revolution around galaxy

	signal=Signal.sineFill(1024,[mercury,venus,earth,mars,jupiter,saturn,uranus,neptune,pluto],
			[0]);  ///au units

wt = signal.asWavetable;
~w.loadCollection(wt);
signal.plot;
		}.value;
)

*/

//////shaper form
/*(
(
Buffer.freeAll;
(
~n=1/2;~array=28.collect{~n=~n*2};
~a=(0-(pi/28)); ~ph=56.collect{~a=~a+(pi/28);}
);
~w_function= Buffer.alloc(s,2048);
~function=Env([1.neg,1],[1],[0]).asSignal(1025);
~function=~function+(
	Signal.sineFill(1024,~array,~ph)/8;
);
~function=~function.normalize;
~function.plot;
~w_function.loadCollection(~function.asWavetableNoWrap);
//~w_function=Buffer.loadCollection(s,~function);

)

(
~ton=(496*4).neg;
~tonal=(496*4).collect{~ton=~ton+1;2.pow(~ton/496)}
)
~ton=(12*4-1).neg;
~tonal=(12*4).collect{~ton=~ton+1;2.pow(~ton/12)}

(
var freq=110, b=55,amp=1/8;

//{Out.ar(0,Shaper.ar(~w_function.bufnum,SinOsc.ar(freq,mul:Select.kr(MouseX.kr(0,(496*2)),~tonal),phase:0.degrad)))}.play;
//{Out.ar(1,Shaper.ar(~w_function.bufnum,SinOsc.ar(freq,mul:Select.kr(MouseX.kr(0,(496*2)),~tonal),phase:90.degrad)))}.play;

{Out.ar(0,Shaper.ar(~w_function.bufnum,SinOsc.ar(freq,mul:0.1,phase:0.degrad)))}.play;
{Out.ar(1,Shaper.ar(~w_function.bufnum,SinOsc.ar(freq,mul:0.1,phase:90.degrad)))}.play;
)
)*/






