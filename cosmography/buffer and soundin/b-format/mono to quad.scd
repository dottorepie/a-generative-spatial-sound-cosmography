(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*16;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
s.boot;
~frames=1024;
)



(
~r1 = Buffer.readChannel(s,,channels:0 );
		)

		(
~azimuth=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~elevation=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
/////vbap
				(
~vbap = VBAPSpeakerArray .new(3,
[[~azimuth.[0],~elevation.[0]], [~azimuth.[1],~elevation.[1]], [~azimuth.[2],~elevation.[2]], [~azimuth.[3],~elevation.[3]]]);
	 ~vbap_buf = Buffer.loadCollection(s, ~vbap.getSetsAndMatrices);
)


(
			{
var steps = 8;

~nVals = steps.collect { |i|
    i.linexp(0, steps-1, 0.18, 463).round
};
			~nVals.asInteger;
			}.value;
		)

(
SynthDef.new(\quad, {

	arg spread;
	var frames=~frames, polytope, sig, in, chain, chain1;
	var g=((1+5.sqrt)/2),s=(1+2.sqrt),az=0,el=0;

    in = PlayBuf.ar(1, ~r1.bufnum, BufRateScale.kr(~r1.bufnum), loop: 0, doneAction:0);
	chain = FFT(LocalBuf(frames), in);

	frames.do{

		polytope=(Spherical(1,az,el);

chain1 = chain.pvcollect(frames,
						{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[0], tobin: ~nVals.[0], zeroothers: 1);

			sig=IFFT(LocalBuf(frames), in1)

Out.ar(0,VBAP.ar(4,sig,~b.bufnum,polytope.theta.raddeg,polytope.phi.raddeg,spread));

				az = (az+(2pi-(2pi/s))).wrap(pi.neg,pi);
		   el = (el+(pi-(pi/s))).wrap((pi/2).neg,(pi/2));
	};

elevation=32.collect{
				az2 = (az2+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el2 = (el2+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));


	}
}).add;
)

(
~synth=Synth.new(\quad,[\spread,10]);
s.record(numChannels:4)
)

