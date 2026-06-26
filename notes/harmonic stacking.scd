(
{
	((SinOsc.ar(64*8,mul:1/4).abs*SinOsc.ar(64*2,mul:1/2)))*0.1
	}.play
)



(

{Out.ar(1,(
	((SinOsc.ar(128*8,mul:1/4).abs*
		SinOsc.ar(128*4,mul:1/1)).abs*
	SinOsc.ar(128*2,mul:1/2)).abs*
	SinOsc.ar(128*1,mul:1/1)
)*0.1)
	}.play
)



(0+(2pi-(2pi/g))).wrap(0,2pi)
var g=((1+5.sqrt)/2),s=(1+2.sqrt);