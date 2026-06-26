(
~n=1.neg;~array=56.collect{~n=~n+1;2.pow(~n/56)};
~n=(0-(2pi/56)); ~ph=56.collect{~n=~n+(2pi/56);};
~bufferSize = 4096*1;
~signalSize = 2048*1;
);

(

~signal = Signal.sineFill(~signalSize, ~array, [0]);

~env = Env(
    ~signal.asArray,
    Array.fill(~signal.size - 1, 1 / (~signal.size - 1))
);

~env.plot;

)

////////////////////////////////////////////////////////////////////////////
(
~signal = Signal.sineFill(~signalSize, ~array, [0]);

// rotate by half a cycle
~signal = ~signal.rotate(~signal.size/2);

~env = Env(
    ~signal.asArray,
    Array.fill(~signal.size - 1, 1 / (~signal.size - 1))
);

~env.plot;
)
(
~signal = Signal.sineFill(~signalSize, ~array, [0]);
~signal = ~signal.rotate(~signal.size/2);

~rip = Env([0,1,0],[0.1,1],[4,-4]).asSignal(~signal.size);

~rip = ~rip * (1 + (~signal /1));
~rip=~rip.normalize;
~env = Env(
    ~rip.asArray,
    Array.fill(~rip.size - 1, 1 / (~rip.size - 1))
);

~env.plot;
)
////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////

(
var peak, times,signal,rip,enva,attack=1,dicay=4;

signal = Signal.sineFill(~signalSizee, ~arraye, [0]);
signal = signal.rotate(signal.size div: 2);
peak = signal.abs.maxIndex.max(1);
rip = Env.perc(0.5,0.5).asSignal(~signalSizee);
rip = rip * (1 + (signal / 3));
rip = rip.normalize;
peak = peak.min(signal.size - 2).max(1);
times =Array.fill(peak, attack / peak) ++ Array.fill(signal.size - peak - 1, dicay / (signal.size - peak - 1));
enva = Env(rip.asArray, times).plot;
)


//////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
(
var attack = 0.1;
var decay  = 1;
var peak, times;


~signal = Signal.sineFill(~signalSize, ~array, [0]);

// center the transient approximately
~signal = ~signal.rotate(~signal.size/2);

// find actual transient position
peak = ~signal.abs.maxIndex;
~rip = Env([0,1,0],[attack,decay],[4,-4]).asSignal(~signal.size);

~rip = ~rip * (1 + (~signal /5));
~rip=~rip.normalize;
times =
    Array.fill(
        peak,
        attack / peak
    )
    ++
    Array.fill(
        ~rip.size - peak - 1,
        decay / (~rip.size - peak - 1)
    );

~env = Env(
    ~rip.asArray,
    times
);

~env.plot;
)
//////

////////////////////////////////////////////////////////////
(
var attack = 0.1;
var decay  = 1;
var peak, times;

~signal = Signal.sineFill(~signalSize, ~array, [0]);

// center the transient approximately
~signal = ~signal.rotate(~signal.size/2);

// find actual transient position
peak = ~signal.abs.maxIndex;

times =
    Array.fill(
        peak,
        attack / peak
    )
    ++
    Array.fill(
        ~signal.size - peak - 1,
        decay / (~signal.size - peak - 1)
    );

~env = Env(
    ~signal.asArray,
    times
);

~env.plot;
)




