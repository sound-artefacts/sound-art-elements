(
{
	(
								(SinOsc.ar(220*1,SinOsc.ar(55*4).range(0,pi/8),1/1)*SinOsc.ar(220*1,mul:1/1))

*
						(SinOsc.ar(220*1,SinOsc.ar(55*2).range(0,pi/4),1/1)*SinOsc.ar(220*1,mul:1/1))

*

				(SinOsc.ar(220*1,SinOsc.ar(55).range(0,pi/2),1/1)*SinOsc.ar(220*1,mul:1/1))

+
				(SinOsc.ar(220*1,SinOsc.ar(55/2).range(0,pi),1/1)*SinOsc.ar(220))


	)*0.1
}.play
)

(
{
var sig,sig1,m=0;

	(
		sig=	(SinOsc.ar(220,SinOsc.ar((55/2)*2.pow(m/56)).range(0,pi/2.pow(m/56)))*SinOsc.ar(220));

		56.do{
			m=m*1;
				sig1=	(SinOsc.ar(220,SinOsc.ar((55/2)*2.pow(m/56)).range(0,pi/2.pow(m/56)))*SinOsc.ar(220));
			sig=sig*sig1;
		};
		Out.ar(0,sig*0.1)
	)
}.play
)
s.options.numInputBusChannels=0;

(
{Out.ar(0,SinOsc.ar(55*4,phase:SinOsc.kr(55,0).range(pi.neg,pi)))}.play;
{Out.ar(1,SinOsc.ar(55*4,phase:SinOsc.kr(55,0.5pi).range(pi.neg,pi)))}.play;
	)
