(
{Out.ar(0,SinOsc.ar(220*(3/2),mul:(3/2).reciprocal)*0.1)}.play;
{Out.ar(0,SinOsc.ar(220*(2/1),mul:(2/1).reciprocal)*0.1)}.play;
)

(
(
{Out.ar(1,SinOsc.ar(220*(1/1),mul:(1/1).reciprocal)*0.1)}.play;
{Out.ar(1,SinOsc.ar(220*(2/1),mul:(2/1).reciprocal)*0.1)}.play;
);
(
{Out.ar(1,SinOsc.ar(220*(3/1),mul:(3/1).reciprocal)*0.1)}.play;
{Out.ar(1,SinOsc.ar(220*(2/1),mul:(2/1).reciprocal)*0.1)}.play;
);
(
{Out.ar(1,SinOsc.ar(220*(4/1),mul:(4/1).reciprocal)*0.1)}.play;
{Out.ar(1,SinOsc.ar(220*(3/1),mul:(3/1).reciprocal)*0.1)}.play;
)
)



(
{Out.ar(1,SinOsc.ar(220*(2.pow(5/12)),mul:(2.pow(5/12)).reciprocal)*0.1)}.play;
{Out.ar(1,SinOsc.ar(220*(2.pow(7/12)),mul:(2.pow(7/12)).reciprocal)*0.1)}.play;
{Out.ar(1,SinOsc.ar(220*(2.pow(12/12)),mul:(2.pow(12/12)).reciprocal)*0.1)}.play;
{Out.ar(1,SinOsc.ar(220*(2.pow(0/12)),mul:(2.pow(0/12)).reciprocal)*0.1)}.play;
)


(
{Out.ar(1,SinOsc.ar(220*(2.pow(5/12)),mul:(2.pow(5/12)).reciprocal)*0.1)}.play;
{Out.ar(1,SinOsc.ar(220*(2.pow(12/12)),mul:(2.pow(12/12)).reciprocal)*0.1)}.play;

)


(2.pow(5/12))

(
var x,y,a;

x=100;
a=99;

(2.pow(991/992)).postln;

y=(x+a)/x;
y.postln;
)

(
var x,y,a;

x=8;
a=7;

(2.pow(11/12)).postln;

y=(x+a)/x;
y.postln;
)

(
var x=8,a=7;
{Out.ar(0,SinOsc.ar(28*(x+a),mul:(x+a).reciprocal)*1)}.play;
{Out.ar(0,SinOsc.ar(28*(x),mul:(x).reciprocal)*1)}.play;
)

