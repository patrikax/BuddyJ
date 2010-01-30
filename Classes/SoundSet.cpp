/*
 *  SoundSet.cpp
 *  DF666
 *
 *  Created by Einar Andersson on 12/25/09.
 *  Copyright 2009 Roventskij. All rights reserved.
 *
 */

#include "SoundSet.h"

#include "AudioFile.h"

#include "WavFile.h"

SoundSet::SoundSet(const char *path, const char *nName) {
	name = nName;
	
	char *fileName = new char[255];
	
	for (UInt8 i=0; i<8; i++) {
		sprintf(fileName, "%s%s.wav", path, name);
		files.push_back(new AudioFile(new WavInFile(fileName)));
	}
	
}