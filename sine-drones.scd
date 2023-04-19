(
d = {
	arg hz=220, amp=10, rq=0.01, len=5;
	var snd, env, trig;
	var pitches = hz * [1, 1/2, 2, 5/4];

	trig = Impulse.kr(1/(len + 1));
	env = EnvGen.kr(Env.sine(len), trig);

	snd = PinkNoise.ar;
	snd = BPF.ar(snd, Demand.kr(trig, 0, Drand(pitches, inf)), {rq * ((LFNoise1.kr(0.2) * 0.1) + 1)}!2);
	snd = snd * env * amp;
	snd = snd.softclip;

}.play
)

d.set(\hz, 440)
d.set(\rq, 0.005)
d.set(\amp, 15)


// What about using LFOs instead of envelopes, and generating randomly close periods up front then just letting them run (maybe very periodically resyncing them?)

(
SynthDef(\bandnoise, {
	arg hz=110, amp=10, rq=0.002, len=10, pan=0, out=0;
	var snd, env, trig;

	var pitches = hz * [1, 2, 5/4, (2 + 3/2)];
	trig = Impulse.kr(1/len);

	env = EnvGen.ar(Env.sine(len), trig);

	snd = PinkNoise.ar;
	snd = BPF.ar(snd, freq:Demand.kr(trig, 0, Drand(pitches, inf)), rq:rq);
	snd = snd * env * amp;
	snd = snd.softclip;
	snd = Pan2.ar(snd, pan);

	Out.ar(out, snd);
}).add;

// b = Synth(\bandnoise, [\hz, 440])
// b.set(\pan, 0.5)

// Multiple \bandnoise, each with randomly-generated (but fixed) lengths.
b = ({1.sum3rand}!4).collect({ |dev|
	var len = 10 + (5 * dev); // time displacement as fn of deviation [-1, 1]
	var pan = dev;
	dev.postln;
	Synth(\bandnoise, [\len, len, \pan, pan])
});

)

(
// fixed-lengths with minimal common multiples
b = [5, 7, 14, 15].collect({ |len|
	Synth(\bandnoise, [\len, len, \pan, 1.sum3rand])
});
b.do({ |it| it.set(\hz, 110, \rq, 0.003) });

)


b.do({ |it| it.set(\hz, 110, \rq, 0.003) })


// Continuous curve segments with DemandEnvGen.kr(Dseq([0, 1], inf), ...),
// or introduce silence in between up/down with DemandEnvGen.kr(Dseq([0, 1, 0], inf), ...)
{DemandEnvGen.kr(Dseq([0, 1], inf), Drand([0.5, 2, 1], inf), shape:3, curve:3)}.plot(5);


(
// Use DemandEnvGen to cause cycling envelope with varying length (actually, varying segment length)
SynthDef(\bandnoise_env, {
	arg hz=110, amp=10, rq=0.003, len=10, spread=0.7, out=0;
	var snd, env, trig;

	var pitches = hz * [1, 2, 5/4, (2 + 3/2)];
	trig = Impulse.kr(1/len);

	env = DemandEnvGen.kr(
		Dseq([0, 1, 0], inf), // allow for silent pauses between rise/fall segments
		Dwhite(5, 10),
		shape: 3);

	snd = PinkNoise.ar;
	snd = BPF.ar(snd, freq:Demand.kr(trig, 0, Drand(pitches, inf)), rq:rq);
	snd = snd * env * amp;
	snd = snd.softclip;
	snd = Pan2.ar(snd, spread * Demand.kr(trig, 0, Dwhite(-1, 1)));

	Out.ar(out, snd);
}).add;
)

// This synthdef encapsulates all the pitch- and length-randomization; no need to pass args
(
b = 4.collect({Synth(\bandnoise_env)})
)

// Some texture with randomly bursting filtered triggers
// (Next: scale frequency with `amp` arg (higher "volume" = faster rate)
(
d = { |freq=(2), amp=0.2, hz=1000, res=0.7|
	var snd;
	snd = Dust.ar(freq);
	snd = MoogVCF.ar(snd, hz, res=res);
	snd = Pan2.ar(snd, {LFNoise1.kr(1/5, 0.7)})
}.play
)
d.set(\amp, 0.2)
d.set(\hz, 1000)
d.set(\res, 0.7)

d.free
