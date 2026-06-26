
=
	///vbap
			/*(
~a = VBAPSpeakerArray.new(3,
				[[45, 35.264390.neg],[135.neg, 35.264390.neg],[45.neg, 35.264390],[135,35.264390]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);*/
=

					/*(
out1=VBAP.ar(4,FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:mx),~b.bufnum,polytope.theta.raddeg,polytope.phi.raddeg,74);
out2=VBAP.ar(4,FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:my),~b.bufnum,,polytope.theta.raddeg,polytope.phi.raddeg,74);
out3=VBAP.ar(4,FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:mz),~b.bufnum,,polytope.theta.raddeg,polytope.phi.raddeg,74);

				Out.ar(2,Limiter.ar(LeakDC.ar(out1,mul:1,mul:gain),mix.lag(0.01)));
				Out.ar(2,Limiter.ar(LeakDC.ar(out2,mul:1,mul:gain),mix.lag(0.01)));
				Out.ar(2,Limiter.ar(LeakDC.ar(out3,mul:1,mul:gain),mix.lag(0.01)));
					)*/
