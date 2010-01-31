/*
 *  AudioEngine.h
 *  IR909
 *
 *  Created by Einar Andersson on 10/19/09.
 *  Copyright 2009 Roventskij. All rights reserved.
 *
 */
#ifndef _AUDIOENGINE_
#define _AUDIOENGINE_


#include <MacTypes.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>

#import "CAStreamBasicDescription.h"
#import "CAXException.h"

#include <vector>

class SoundSet;
class AudioFile;
class WavInFile;
class audioData;

const Float64 kGraphSampleRate = 44100.0;


class AudioEngine {
	
public:
	
	UInt32 tpm;
	
	float shuffle;
	
	static AudioEngine* instance() {
		static AudioEngine *singleton = new AudioEngine();
		return singleton;
	}
	
	// TEST
	audioData *audio;
	
	
	UInt8 currentSetIndex;
	SoundSet *currentSoundSet;
	
	double frameSpeed;
	void setSpeed(double);

	double pitch, previousPitch;
	
	void interpolate(double, double);

	void setDragging(Boolean);
	Boolean dragging;
	Boolean pitching;
	double diff;
	float step, defaultStep;
	
	UInt32 fileLength;
	float cue;
	
	void setPitch(double);

	Boolean isPlaying;
	
	AudioUnit outputUnit;
	
	float bpm;
	float framesPerDivision;
	float realFramesPerDivision;
	UInt32 cPosition;
	
	UInt8 cDivPos;
	
	std::vector<SoundSet*> soundSets;

	std::vector<AudioFile *> audioFiles;

	AudioFile *audioFile;
	SInt32 *outBuffer;
	
	void loadSet(UInt8 sid);
		
	void prevSet();
	void nextSet();
	void setSong(AudioFile *file);
	void startAudioEngine();
	void stopAudioEngine();
	void rewind();
	void setCue();
	void go2cue();
	void startFromDrag();
	
	void loadTrack(NSString *);
	AudioEngine();
};

#endif