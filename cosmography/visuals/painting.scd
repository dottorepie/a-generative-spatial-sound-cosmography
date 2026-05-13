
////////////////////////////////////////////painter

(
var win,wx=0,wy=0,g=((1+5.sqrt)/2),s=(1+2.sqrt), posit=0,size=200,scale=150;
var xPos,yPos, ax,ay,ofset;
//Window.closeAll;

~amp1 = 0;
~amp2 = 0;
~amp3 = 0;
~amp4= 0;
//~amp5 = 0;
//~amp6= 0;
//~amp7= 0;

win = Window("RGB Audio", Rect(10, 10, size,size));
~v1 = UserView(win, Rect(0,0,size,size)).background_(Color.black);

SynthDef(\painting, {
	arg lag=0.1,gain1=5,gain2=100;
	var amp1 = (InFeedback.ar(2).abs*gain1).lag(lag);
	var amp2 = (InFeedback.ar(3).abs*gain1).lag(lag);
	var amp3 = (InFeedback.ar(4).abs*gain1).lag(lag);
	var amp4 = (InFeedback.ar(5).abs*gain1).lag(lag);
//	var amp5 = (InFeedback.ar(6)*gain2).lag(lag);
//	var amp6 = (InFeedback.ar(7)*gain2).lag(lag);
//	var amp7 = (InFeedback.ar(8).abs*gain2).lag(lag);

	SendReply.ar(Impulse.ar(60), '/amp1', amp1);
	SendReply.ar(Impulse.ar(60), '/amp2', amp2);
	SendReply.ar(Impulse.ar(60), '/amp3', amp3);
	SendReply.ar(Impulse.ar(60), '/amp4', amp4);
//	SendReply.ar(Impulse.ar(60), '/amp5', amp5);
//	SendReply.ar(Impulse.ar(60), '/amp6', amp6);
//	SendReply.ar(Impulse.ar(60), '/amp7', amp7);
}).add;

// OSC
OSCdef(\ampt1, { |msg|
	~amp1 = msg[3];
	defer { ~v1.refresh };
}, '/amp1');

OSCdef(\ampt2, { |msg|
	~amp2 = msg[3];
	defer { ~v1.refresh };
}, '/amp2');

OSCdef(\ampt3, { |msg|
	~amp3 = msg[3];
	defer { ~v1.refresh };
}, '/amp3');

OSCdef(\ampt4, { |msg|
	~amp4 = msg[3];
	defer { ~v1.refresh };
}, '/amp4');

/*OSCdef(\ampt5, { |msg|
	~amp5 = msg[3];
	defer { ~v1.refresh };
}, '/amp5');

OSCdef(\ampt6, { |msg|
	~amp6 = msg[3];
	defer { ~v1.refresh };
}, '/amp6');

OSCdef(\ampt7, { |msg|
	~amp7 = msg[3];
	defer { ~v1.refresh };
}, '/amp7');*/

(
~v1.drawFunc = {
    Pen.translate(size/2, size/2);

    10.do {
ofset=0.1.rand;
		xPos =  0+ (~amp5.lag(ofset));
	yPos = 0 + (~amp6.lag(ofset));

		Pen.fillColor = Color(~amp1.lag(ofset),
		~amp2.lag(ofset),
			~amp3.lag(ofset),
			~amp3.lag(ofset*10));

     Pen.fillRect(Rect.aboutPoint(xPos @ yPos,2*size,
			//(size/scale),
			size));
			//(size/scale)));

    };
};
);
win.front;

)
~a = Synth(\painting).register;
~a.set(\gain1,5)
~a.set(\gain2,1000)
~a.set(\lag,0.1)
~a.set(\lag,0.1)
~a.free



