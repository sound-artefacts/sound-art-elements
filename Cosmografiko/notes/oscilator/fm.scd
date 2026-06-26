/////fm notes
{SinOsc.ar(440+Saw.ar(880,mul:MouseX.kr(1,110)))!2}.play

{SinOsc.ar(440+LFNoise1.ar(880,mul:MouseX.kr(1,110)))!2}.play

{SinOsc.ar(440+Saw.ar(440,mul:LFNoise1.ar(440*64).range(220.neg,220)))!2}.play

{SinOsc.ar(440+Saw.ar(440,mul:LFNoise1.ar(440/64).range(220.neg,220)))!2}.play





/////fm oscillator variants

(
{SinOsc.ar((220*1)+Saw.ar(440,mul:LFNoise1.ar(440/2.pow(12)).range(220.neg,220)),mul:1/1)!2}.play;
{SinOsc.ar((220*2)+Saw.ar(440,mul:LFNoise1.ar(440/2.pow(12)).range(220.neg,220)),mul:1/2)!2}.play;
{SinOsc.ar((220*3)+Saw.ar(440,mul:LFNoise1.ar(440/2.pow(12)).range(220.neg,220)),mul:1/3)!2}.play;
{SinOsc.ar((220*4)+Saw.ar(440,mul:LFNoise1.ar(440/2.pow(12)).range(220.neg,220)),mul:1/4)!2}.play;
{SinOsc.ar((220*5)+Saw.ar(440,mul:LFNoise1.ar(440/2.pow(12)).range(220.neg,220)),mul:1/5)!2}.play;
)

(
{SinOsc.ar((220*1)+Saw.ar(440,mul:LFNoise1.ar(440/64).range(220.neg,220)),mul:1/1)!2}.play;
{SinOsc.ar((220*2)+Saw.ar(440,mul:LFNoise1.ar(440/64).range(220.neg,220)),mul:1/2)!2}.play;
{SinOsc.ar((220*3)+Saw.ar(440,mul:LFNoise1.ar(440/64).range(220.neg,220)),mul:1/3)!2}.play;
{SinOsc.ar((220*4)+Saw.ar(440,mul:LFNoise1.ar(440/64).range(220.neg,220)),mul:1/4)!2}.play;
{SinOsc.ar((220*5)+Saw.ar(440,mul:LFNoise1.ar(440/64).range(220.neg,220)),mul:1/5)!2}.play;
)