/*
 *  AudioEngine.h
 *  IR909
 *
 *  Created by Einar Andersson on 10/19/09.
 *  Copyright 2009 Roventskij. All rights reserved.
 *
 */

#include <MacTypes.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>

#import "CAStreamBasicDescription.h"
#import "CAXException.h"

#include <vector>

class Track;
class SoundSet;
class AudioFile;
class WavInFile;

const Float64 kGraphSampleRate = 44100.0;


class AudioEngine {
	
	
	
	
	
	
public:
	
	UInt32 tpm;
	
	float shuffle;
	
	static AudioEngine* instance() {
		static AudioEngine *singleton = new AudioEngine();
		return singleton;
	}
	
	void setBPM(UInt32 mBpm);
	
	void clearPattern();
	
	UInt8 currentSetIndex;
	SoundSet *currentSoundSet;
	
	
	Boolean isPlaying;
	
	
	float bpm;
	float framesPerDivision;
	float realFramesPerDivision;
	UInt32 cPosition;
	
	UInt8 cDivPos;
	
	std::vector<Track*> tracks;
	std::vector<SoundSet*> soundSets;

	std::vector<AudioFile *> audioFiles;

	AudioFile *audioFile;
	SInt32 *outBuffer;
	
	void loadSet(UInt8 sid);
		
	void prevSet();
	void nextSet();
	void setSong(AudioFile *file);

	AudioEngine();
};