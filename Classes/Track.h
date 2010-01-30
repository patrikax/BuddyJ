/*
 *  Track.h
 *  DF666
 *
 *  Created by Einar Andersson on 12/23/09.
 *  Copyright 2009 Roventskij. All rights reserved.
 *
 */

#include <vector>

#include <MacTypes.h>

class AudioEngine;
class AudioFile;

class Track {
	
	
	
	AudioFile *file;
	
public:
	Track();
	~Track();
	
	std::vector<unsigned char> pattern;
	
	void setAudioFile(AudioFile *f);
	
	void lookForNotes(AudioEngine *ae, UInt32 framesToNextDivision,UInt32 divPos);
	
	
	//void render(short *buffer, unsigned int inNumFrames);
	
	
};