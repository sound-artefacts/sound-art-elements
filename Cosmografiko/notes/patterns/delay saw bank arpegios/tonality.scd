(
var n=1,ar;
ar=30.collect{n=n*2};
~octaves=[1]++ar
)

(
var n=0, m=1,p;
 ~perfects=30.collect{n=n+1;
	m=m+~octaves[n];
	m.postln;
	'f'.postln;
	~octaves.[n].postln;
	p=if(m.isPrime) {~octaves.[n]*m} {0};
	p=p
}
)

(
{Out.ar(0,SinOsc.ar(6*10,0.degrad,mul:6.reciprocal))}.play;
{Out.ar(1,SinOsc.ar(6*10,90.degrad,mul:6.reciprocal))}.play;
{Out.ar(0,SinOsc.ar(28*10,0.degrad,mul:28.reciprocal))}.play;
{Out.ar(1,SinOsc.ar(28*10,90.degrad,mul:28.reciprocal))}.play;
{Out.ar(0,SinOsc.ar(496*10,0.degrad,mul:496.reciprocal))}.play;
{Out.ar(1,SinOsc.ar(496*10,90.degrad,mul:496.reciprocal))}.play;
{Out.ar(0,SinOsc.ar(8128*10,0.degrad,mul:8128.reciprocal))}.play;
{Out.ar(1,SinOsc.ar(8128*10,90.degrad,mul:8128.reciprocal))}.play;
)

(
{Out.ar(0,SinOsc.ar((6*10)
*2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992),0.degrad,mul:6.reciprocal*(2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992)).reciprocal))}.play;

{Out.ar(1,SinOsc.ar((6*10)*2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992),90.degrad,mul:6.reciprocal*(2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992)).reciprocal))}.play;

{Out.ar(0,SinOsc.ar((28*10)*2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992),0.degrad,mul:28.reciprocal*(2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992)).reciprocal))}.play;

{Out.ar(1,SinOsc.ar((28*10)*2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992),90.degrad,mul:28.reciprocal*(2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992)).reciprocal))}.play;

{Out.ar(0,SinOsc.ar((496*10)*2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992),0.degrad,mul:496.reciprocal*(2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992)).reciprocal))}.play;

{Out.ar(1,SinOsc.ar((496*10)*2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992),90.degrad,mul:496.reciprocal*(2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992)).reciprocal))}.play;

{Out.ar(0,SinOsc.ar((8128*10)*2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992),0.degrad,mul:8128.reciprocal*(2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992)).reciprocal))}.play;

{Out.ar(1,SinOsc.ar((8128*10)*2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992),90.degrad,mul:8128.reciprocal*(2.pow(SinOsc.ar(1,0.degrad).range(0,992).round(1)/992)).reciprocal))}.play;
)

////so the oscillator is the above bank as fundamental wave, times the multiplier 1,2,3,4 for the saw wave (depth), times the specified intervals: tonesun *tonegalaxy*tonecosmos*some fundamental. Note that if ig tonegalaxy=0 then the amp becomes inf, so there must be a limit ig 0.00001 as 0, max freq 10Hz.
//note that maybe 8128 is the tone n for the cosmos, 496 the galaxy, 28 the sun and 6 the core. A different way would be to have a standard n distribution for all layers ig 496, which is the most perfect one, and relate the three layers in frequency bands like so: cosmos is 6mult, galaxy 9, sun 12. This would mean that the oscillator has ig a fundamental of 5 (times the 4 fund wave freq components) and if location sun x, then freq=(fundamental*saw_sequence_of_sun_location_vektor)*tone_of_sun_location (4/4) *tone_of_sun_galaxy_location (one 4/4 event, out of three events of different suns, forming 12/4) *tone_cosmos_location_of galaxy (one 12/4 event out of 'pattern dependedant' events which are different galaxies or the same,depends on the randomness)

///the bigger the steps 8128-6 the closer is the distribution to cosmos, eg cosmos 28, galaxy 496, sun 8128, then 6 is the basic pulse /|\, that is if normalized to decimal: 8128/6=1354.6666666667, 496/6=82.666666666667, 28/6=4.6666666666667, 6/6=1, that is n/2709.3333333333 , n/165.33333333333, n/9.3333333333333, n/2
//n/2 is three degrees with first close to 1.5 and octave and so on


2.pow(19599999/33550336)
2.pow(4750/8128)
2.pow(290/496)
2.pow(16/28)
////ara kaliteri aidrash ston sigerasmo exei to 496

(
{Out.ar(0,SinOsc.ar(6*10,0.degrad,mul:6.reciprocal))}.play;
{Out.ar(1,SinOsc.ar(6*10,90.degrad,mul:6.reciprocal))}.play;
{Out.ar(0,SinOsc.ar(8*10,0.degrad,mul:28.reciprocal))}.play;
{Out.ar(1,SinOsc.ar(8*10,90.degrad,mul:28.reciprocal))}.play;
{Out.ar(0,SinOsc.ar(9*10,0.degrad,mul:496.reciprocal))}.play;
{Out.ar(1,SinOsc.ar(9*10,90.degrad,mul:496.reciprocal))}.play;
{Out.ar(0,SinOsc.ar(12*10,0.degrad,mul:8128.reciprocal))}.play;
{Out.ar(1,SinOsc.ar(12*10,90.degrad,mul:8128.reciprocal))}.play;
)




/////////////////////saw

(
var c=1;
1.do{
{Out.ar(0,SinOsc.ar(
((6/6)*20)*c*2.pow(SinOsc.ar(MouseX.kr(0.01,(8128/6)),0.degrad).range(0,12).round(1)/12),0.degrad,
mul:6.reciprocal*c.reciprocal*(2.pow(SinOsc.ar(0.1,0.degrad).range(0,12).round(1)/12)).reciprocal))}.play;
{Out.ar(1,SinOsc.ar(
((6/6)*20)*c*2.pow(SinOsc.ar(MouseX.kr(0.01,(8128/6)),0.degrad).range(0,12).round(1)/12),90.degrad,
mul:6.reciprocal*c.reciprocal*(2.pow(SinOsc.ar(0.1,0.degrad).range(0,12).round(1)/12)).reciprocal))}.play;
{Out.ar(0,SinOsc.ar(
((28/6)*20)*c*2.pow(SinOsc.ar(MouseX.kr(0.01,(8128/6)),0.degrad).range(0,28).round(1)/28),0.degrad,
mul:28.reciprocal*c.reciprocal*(2.pow(SinOsc.ar(0.1,0.degrad).range(0,28).round(1)/28)).reciprocal))}.play;
{Out.ar(1,SinOsc.ar(
((28/6)*20)*c*2.pow(SinOsc.ar(MouseX.kr(0.01,(8128/6)),0.degrad).range(0,28).round(1)/28),90.degrad,
mul:28.reciprocal*c.reciprocal*(2.pow(SinOsc.ar(0.1,0.degrad).range(0,28).round(1)/28)).reciprocal))}.play;
{Out.ar(0,SinOsc.ar(
((496/6)*20)*c*2.pow(SinOsc.ar(MouseX.kr(0.01,(8128/6)),0.degrad).range(0,496).round(1)/496),0.degrad,
mul:496.reciprocal*c.reciprocal*(2.pow(SinOsc.ar(0.1,0.degrad).range(0,496).round(1)/496)).reciprocal))}.play;
{Out.ar(1,SinOsc.ar(
((496/6)*20)*c*2.pow(SinOsc.ar(MouseX.kr(0.01,(8128/6)),0.degrad).range(0,496).round(1)/496),90.degrad,
mul:496.reciprocal*c.reciprocal*(2.pow(SinOsc.ar(0.1,0.degrad).range(0,496).round(1)/496)).reciprocal))}.play;
{Out.ar(0,SinOsc.ar(
((8128/6)*20)*c*2.pow(SinOsc.ar(MouseX.kr(0.01,(8128/6)),0.degrad).range(0,8128).round(1)/8128),0.degrad,
mul:8128.reciprocal*c.reciprocal*(2.pow(SinOsc.ar(0.1,0.degrad).range(0,8128).round(1)/8128)).reciprocal))}.play;
{Out.ar(1,SinOsc.ar(
((8128/6)*20)*c*2.pow(SinOsc.ar(MouseX.kr(0.01,(8128/6)),0.degrad).range(0,8128).round(1)/8128),90.degrad,
mul:8128.reciprocal*c.reciprocal*(2.pow(SinOsc.ar(0.1,0.degrad).range(0,8128).round(1)/8128)).reciprocal))}.play;
c=c+1;
}
)


(
var c=1;
100.do{
{Out.ar(0,SinOsc.ar((6*10)*c,0.degrad,mul:6.reciprocal*c.reciprocal))}.play;
{Out.ar(1,SinOsc.ar((6*10)*c,90.degrad,mul:6.reciprocal*c.reciprocal))}.play;
{Out.ar(0,SinOsc.ar((28*10)*c,0.degrad,mul:28.reciprocal*c.reciprocal))}.play;
{Out.ar(1,SinOsc.ar((28*10)*c,90.degrad,mul:28.reciprocal*c.reciprocal))}.play;
{Out.ar(0,SinOsc.ar((496*10)*c,0.degrad,mul:496.reciprocal*c.reciprocal))}.play;
{Out.ar(1,SinOsc.ar((496*10)*c,90.degrad,mul:496.reciprocal*c.reciprocal))}.play;
{Out.ar(0,SinOsc.ar((8128*10)*c,0.degrad,mul:8128.reciprocal*c.reciprocal))}.play;
{Out.ar(1,SinOsc.ar((8128*10)*c,90.degrad,mul:8128.reciprocal*c.reciprocal))}.play;
	c=c+1;
}
)



(
var c=1,angle=0;
6.do{
	{Out.ar(0,SinOsc.ar(((28/6)*10)*c,(0+angle).degrad,mul:(28/6).reciprocal*c.reciprocal))}.play;
{Out.ar(1,SinOsc.ar(((28/6)*10)*c,(90+angle).degrad,mul:(28/6).reciprocal*c.reciprocal))}.play;
{Out.ar(0,SinOsc.ar(((496/6)*10)*c,(0+angle).degrad,mul:(496/6).reciprocal*c.reciprocal))}.play;
{Out.ar(1,SinOsc.ar(((496/6)*10)*c,(90+angle).degrad,mul:(496/6).reciprocal*c.reciprocal))}.play;
{Out.ar(0,SinOsc.ar(((8128/6)*10)*c,(0+angle).degrad,mul:(8128/6).reciprocal*c.reciprocal))}.play;
{Out.ar(1,SinOsc.ar(((8128/6)*10)*c,(90+angle).degrad,mul:(8128/6).reciprocal*c.reciprocal))}.play;
//{Out.ar(0,SinOsc.ar(((6/6)*10)*c,(0+angle).degrad,mul:(6/6).reciprocal*c.reciprocal))}.play;
//{Out.ar(1,SinOsc.ar(((6/6)*10)*c,(90+angle).degrad,mul:(6/6).reciprocal*c.reciprocal))}.play;
		angle=(angle+(360-(1/1.6180339887499))).wrap(0,360);
	c=c+1;
}
)





/////////silver ratio
(
{Out.ar(0,SinOsc.ar(220*2.414213562.pow(MouseX.kr(0,992).round(1).poll/992),90.degrad,mul:2.414213562.pow(MouseX.kr(0,992).round(1)/992).reciprocal))}.play;
{Out.ar(1,SinOsc.ar(220*2.414213562.pow(MouseX.kr(0,992).round(1).poll/992),mul:2.414213562.pow(MouseX.kr(0,992).round(1)/992).reciprocal))}.play;
)











