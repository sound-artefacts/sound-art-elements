
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

((sin((((360/8128)/2)/128).degrad)*2)*(8128*128))/2

///algorithmic sequence creation

///fibonacci

///pell numbers

////archimedes


