
///////////////////////

(
~r = Buffer.readChannel(s,"/Users/amimid/Documents/cosmography/untitled folder/marine.wav", channels:[0]
);

~fftsize = 8192;

~freezeSynth = {

    var in;
    var chain1, chain2, chain3;
    var buf1, buf2, buf3;
    var sig;

    in = PlayBuf.ar(1, ~r.bufnum, BufRateScale.kr(~r.bufnum),  loop:1) * 0.2;

    // separate FFT memories

    buf1 = LocalBuf(~fftsize);
    buf2 = LocalBuf(~fftsize);
    buf3 = LocalBuf(~fftsize);

    chain1 = FFT(buf1, in);
    chain2 = FFT(buf2, in);
    chain3 = FFT(buf3, in);

    // each freezes differently

    chain1 = PV_Freeze(
        chain1,
		Amplitude.kr(in,mul:LFNoise1.kr(6))-\switchFreq.kr(1)
    );

    chain2 = PV_Freeze(
        chain2,
Amplitude.kr(in,mul:LFNoise1.kr(8))-\switchFreq.kr(1)
    );

    chain3 = PV_Freeze(
        chain3,
		(Amplitude.kr(in,mul:LFNoise1.kr(9))-\switchFreq.kr(1)).poll
    );

    sig =
        (IFFT(chain1) * 0.3) +
        (IFFT(chain2) * 0.3) +
        (IFFT(chain3) * 0.3);

    sig ! 2;

}.play;
)

~freezeSynth.set(\switchFreq,0.00001.neg);
