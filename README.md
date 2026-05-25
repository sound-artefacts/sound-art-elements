# instrumentally generative heavy metal fx and digital synthesis
 SuperCollider
 //for standalone put init file content in SC startup file,
  install Mathilib quark, optionally SC plugins

  
///basic synthesis components derived from work on previous repository:

-cosmic sound engine envelope///
harmonic rectifier logic wavefunction
(braiding method am additive synthesis), 
musical temprament (perfect numbers octave steps) cosmic timeline glissando, 
panning as viewer scope on installation (quad), 
tensor oscillators, 
wavetable, 
gain


-psychoacoustic arguments/// 
drive, 
reverb, 
spectrum band modulation, 
bessel function ripples, 
feedback or buffer band oscillator as fundamental additive, 
gain, 
panning, 
quad installation as virtual room


-sound technicalities/// 
drive, 
gain, 
reverb, 
panning, 
rectification/inversiin braid stepping scaler, 
limiter


-music and localization/// 
tensir melodic, tonal and rhythmic signatures, 
scale, 
amplitude compensation, 
tempo, 
synced panning to tonal events, 
randomness, 
tonal events in wavefunction partials



///Synthdef control arguments are midi 1-21 and include:

gain: sound gain amplitude multiplier 

drive: distortion and softclip gain multiplier

c: tonal range of fundamental, inverse as tonal range of spectrum synthesis. Conceptually a tonal index 0 corresponds to cosmic heatdeath scenario and spacetime at its max dynamic range ,as in contrary a tonal maximum and high octave tonal index corresponds to a bigbang setting with dynamic range being shorter and much more compressed. In the first range index scenario fundamental is low and energy scalar is high (compressed mass, longer distances), while on the high range, fundamental is high, spatial parameters have less numeric range energy scalar is low (compressed kinetic 'mass', energy)

az: azimuth angle for spatial data tensor

el: elevation angle for spatal data tensor

scale: musical scales selection, of tone note chord, default here major and minor pentatonic

lowend: synth high pass filter lowend cutoff frequency

level: DC amplitude level of audio oscillators

dyn: tonal and dynamic range scaler of spectrum synthesis

comp: level of signal level recovery after level loss due to synthesis multiplication chain,(without level recovery, signal level scales to underflow, note that the signal synthesis multiplication chain brings the wavefunction level to an 10^-45 underflow, and simple addition of pi*10^-45 on every layer of the chain times a range of pi*10^9-10^18 on the  synthesis chain as a while, brings the level back to normal scope and audible range. A bit like the physical workings and indiference bewtween E=mc^2 and E=pc)

buffer: amplitude level gain for buffer, noise or sound input feed to the synthesis

tone_axis: cartesian axis reference selection for spherical harmonic timbre modulation

sphharm: lfo frequency for spatial data tensor spherical harmonic modulation

speaker_size: size of speaker selection, for compressor

room: reverb room size

mix: reverb wet signal mix

pan_mod: lfo frequency for panning movement speed

spread: width of panner, range of diffusion between pann channel levels

limit: limiter threshold

fu: fundamental frequency, powers of two

band: band pass filter oscillator rq on feed buffer playback or loop



////main code file 'cosmography' also includes a musical automaton sequencer (Routine) and a response sequencer to data input from animations, eg. cosmos animation in file 'visuals'.


////all synthesis, geometry and math concepts considering this wotk, can be plotted with ScatterView3D Object via
array distribution cloud point tensor plots, as found on previous repository (under titles susch as visualization, spherical harmonics ets),
or explored by using adjuscent sound generating animations and code blocks. Plotts can give an estimate on how the spatial sound of the synth
and its distributions in the spectrum are formed and sculpted through the synthesis and its modulation.
