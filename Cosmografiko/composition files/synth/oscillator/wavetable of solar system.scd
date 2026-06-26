/*		~w= Buffer.alloc(s,2048);
		{
var signal,wt,m=0,amp,ph=0;

~level=32.collect{m=m+1;amp=m.reciprocal};
		signal=Signal.sineFill(1024,~level,[0]);

wt = signal.asWavetable;
~w.loadCollection(wt);
//signal.plot;
		}.value;

(

~w_function= Buffer.alloc(s,2048);
~function=Env([1.neg,1],[1],[0]).asSignal(1025);
~function=~function+(
	Signal.sineFill(1024,Array.fill(8, {20.rand}),[0])/4;
);
~function=~function.normalize;
//~function.plot;
~w_function.loadCollection(~function.asWavetableNoWrap);
//~w_function=Buffer.loadCollection(s,~function);

);*/

//λ=v/f speed of sound= 343m/s, 1234.8 km/h
//remember scale with float to get unwraped values
/// sun 0
/*(((343.0)/(57900000.0*1000.0))*100000000000.0).reciprocal.round(0.0000000000001)  //mercury 0.39, 90.degrad
 (((343.0)/(108200000.0*1000.0))*100000000000.0).reciprocal.round(0.0000000000001)  //venus 0.72, 180.degrad
 (((343.0)/(149600000.0*1000.0))*100000000000.0).reciprocal.round(0.0000000000001) //earth 1, 0.degrad
 (((343.0)/(227900000.0*1000.0))*100000000000.0).reciprocal.round(0.0000000000001) //mars 1.52, 60.degrad
 (((343.0)/(778600000.0)*1000.0)*100000000000.0).reciprocal.round(0.0000000000001) ///jupiter 5.2, 30.degrad
 (((343.0)/(1433500000.0*1000.0))*100000000000.0).reciprocal.round(0.0000000000001) //saturn 9.54, 20.degrad
 (((343.0)/(2872500000.0)*1000.0)*100000000000.0).reciprocal.round(0.0000000000001)  //uranus 19.2, 10.degrad
 (((343.0)/(4495100000.0*1000.0))*100000000000.0).reciprocal.round(0.0000000000001)  //neptune 30.06, 10.degrad*/

	(	~w= Buffer.alloc(s,2048);
		{
var signal,wt,m=0,amp,ph=0;

	signal=Signal.sineFill(1024,[0.39,0.72,1,1.52,5.2,9.54,19.2,30.06],
			[90.degrad,180.degrad,0.degrad,60.degrad,30.degrad,20.degrad,10.degrad,10.degrad]);  ///au units

wt = signal.asWavetable;
~w.loadCollection(wt);
signal.plot;
		}.value;
)
(
{Out.ar(0,Osc.ar(~w.bufnum,55,phase:0.degrad))}.play;
{Out.ar(1,Osc.ar(~w.bufnum,55,phase:90.degrad))}.play;
)

/////////////wavetable based on orbit periods

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

////additive synthesis

(
var mercury=0.24.reciprocal,venus=0.62.reciprocal,earth=1.reciprocal;
var mars=1.8.reciprocal,jupiter=11.86.reciprocal;
var saturn=29.46.reciprocal,uranus=84.01.reciprocal,neptune=164.8.reciprocal;
var pluto=248.reciprocal,fund=55*(9/8),sun=(256.0*1000000.0).reciprocal;

{Out.ar(0,SinOsc.ar(fund*mercury,mul:mercury.reciprocal,phase:0.degrad)*0.1)}.play;
{Out.ar(0,SinOsc.ar(fund*venus,mul:venus.reciprocal,phase:0.degrad)*0.1)}.play;
{Out.ar(0,SinOsc.ar(fund*earth,mul:earth.reciprocal,phase:0.degrad)*0.0)}.play;
//{Out.ar(0,SinOsc.ar(fund*mars,mul:mars.reciprocal,phase:0.degrad)*0.01)}.play;
//{Out.ar(0,SinOsc.ar(fund*jupiter,mul:jupiter.reciprocal,phase:0.degrad)*0.01)}.play;
//{Out.ar(0,SinOsc.ar(fund*saturn,mul:saturn.reciprocal,phase:0.degrad)*0.001)}.play;
//{Out.ar(0,SinOsc.ar(fund*uranus,mul:uranus.reciprocal,phase:0.degrad)*0.001)}.play;
//{Out.ar(0,SinOsc.ar(fund*neptune,mul:neptune.reciprocal,phase:0.degrad)*0.001)}.play;
//{Out.ar(0,SinOsc.ar(fund*pluto,mul:pluto.reciprocal,phase:0.degrad)*0.001)}.play;
//{Out.ar(0,SinOsc.ar(fund*sun,mul:sun.reciprocal,phase:0.degrad)*0.00001)}.play;
{Out.ar(1,SinOsc.ar(fund*mercury,mul:mercury.reciprocal,phase:90.degrad)*0.1)}.play;
{Out.ar(1,SinOsc.ar(fund*venus,mul:venus.reciprocal,phase:90.degrad)*0.1)}.play;
{Out.ar(1,SinOsc.ar(fund*earth,mul:earth.reciprocal,phase:90.degrad)*0.1)}.play;
//{Out.ar(1,SinOsc.ar(fund*mars,mul:mars.reciprocal,phase:90.degrad)*0.01)}.play;
//{Out.ar(1,SinOsc.ar(fund*jupiter,mul:jupiter.reciprocal,phase:90.degrad)*0.01)}.play;
//{Out.ar(1,SinOsc.ar(fund*saturn,mul:saturn.reciprocal,phase:90.degrad)*0.001)}.play;
//{Out.ar(1,SinOsc.ar(fund*uranus,mul:uranus.reciprocal,phase:90.degrad)*0.001)}.play;
//{Out.ar(1,SinOsc.ar(fund*neptune,mul:neptune.reciprocal,phase:90.degrad)*0.001)}.play;
//{Out.ar(1,SinOsc.ar(fund*pluto,mul:pluto.reciprocal,phase:90.degrad)*0.001)}.play;
//{Out.ar(1,SinOsc.ar(fund*sun,mul:sun.reciprocal,phase:90.degrad)*0.00001)}.play;
)

//NOTE OSC FREQ STRUCTURE IS SOLAR SYSTEM WAVETABLE, WITH FUNDAMENTAL * COORDINATE MAGNITUDE * (SAW SEQUENCE*INTERVAL) * COORDINATE MUSICAL TEMPERAMENT FROM MELODY
///////////////////////////////////////////////////////////////////////POTENTENTIALLY * COORDINATE MUSICAL TEMPERAMENT FROM CHORD (OSC1,OSC2,OSC3)
/////////INTERVAL MAY BY THE CLASSICAL HARMONY WHOLE TONE INTERVAL OF (9/8)