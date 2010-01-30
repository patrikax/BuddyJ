/*
 *  Track.cpp
 *  DF666
 *
 *  Created by Einar Andersson on 12/23/09.
 *  Copyright 2009 Roventskij. All rights reserved.
 *
 */

#include "Track.h"
#include "AudioEngine.h"
#include "WavFile.h"
#include "AudioFile.h"

Track::Track() {
	
	for (int i=0; i<16; i++) {
		pattern.push_back(false);
	}
	
}

void Track::setAudioFile(AudioFile *f) {
	file = f;
}

