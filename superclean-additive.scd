// An additive synth.
SynthDef(\additive,  {| out, ada = 0.001, adr = 1, amp = 1, adc = 1, freq = 200, pan = 0.5, slw = 0.001
	bnd = 0, bno = 0, bnt = 0.2, bnc = 0, index=1,div=1, o2, o3, o4, o5, o6,o7,o8, o9, o10|
	var ee, e, o, freqclipped, gliss, sum;
	gliss = EnvGen.kr(Env(
        [1, 1, 1 + bnd.clip(-1.0, 1.0)],
        [bno, bnt],
        [0, 0, bnc]  //optional curvature
    ));
	freqclipped = (freq * gliss).clip(20, 20000);
	ee = Env([0, 1, 0], [ada ,adr + slw], [-30, 30]);
	e = Env.perc(ada, adr + 0.0001, amp, adc);
	ee = EnvGen.ar(ee);
	e = EnvGen.ar(e, doneAction:2);
	o = SinOsc.ar(freqclipped * ee);
	o2 = SinOsc.ar(((div * 2) * freqclipped) * ee);
	o3=SinOsc.ar(((div * 3) * freqclipped) * ee);
	o4=SinOsc.ar(((div * 4) * freqclipped) * ee);
	o5=SinOsc.ar(((div * 5) * freqclipped) * ee);
	o6=SinOsc.ar(((div * 6) * freqclipped) * ee);
	o7=SinOsc.ar(((div * 7) * freqclipped) * ee);
	o8=SinOsc.ar(((div * 8) * freqclipped) * ee);
	o9=SinOsc.ar(((div * 9) * freqclipped) * ee);
	o10=SinOsc.ar(((div * 10) * freqclipped) * ee);
	o=(o+o2+o3+o4+o5+o6+o7+o8+o9+o10)*0.1;


	//o = o * e * AmpComp.ar(freqclipped, 40, 0.3);
	o=o*e;
	o=Limiter.ar(o);
	o=LeakDC.ar(o);
	o = CleanPan.ar(o, ~clean.numChannels, pan);
	Out.ar(out, o);
}).store;