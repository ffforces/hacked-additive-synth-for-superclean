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

//pattern
y=x.play;
y.stop;

(
x=Pdef(\one,
Pseed(3,
Pbind(\type, \cln,
\snd, \additive,
\dur, Pdup(Pwhite(1,3),Prand([1,2,3]+5,inf)),
\ada, Prand([1,2,3]+5,inf),
\adr, Pdup(Pwhite(1,5),Prand([4.3,5,6,7,1]+4,inf)),
\bnd, Prand([-0.5,-0.2],inf),
\div, Prand([1,2,4,2.3,0.8],inf),
\freq, Ptuple([
				Prand([30,37,35,30,37,35,30,37,\],inf),
				Prand([42,44,\],inf),
				Prand([54,57,31,54,57,31,54,57,31,54,57,31,54,57,31,54,57,31,\],inf)
		],1).midicps,
\pan, Pwhite(-0.3,0.3),			
//\lhf, Pseg(Prand([0.0,1.0,0.5], inf),Pwhite(0.02,0.04),\lin,inf),
\jpr, 0.9,
\rev,0.8,
\dry, 0,			
\amp, 0.7,

);
);
);
)


