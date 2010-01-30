/*
 *  AudioFile.cpp
 *  DF666
 *
 *  Created by Einar Andersson on 12/23/09.
 *  Copyright 2009 Roventskij. All rights reserved.
 *
 */

#include "AudioFile.h"

#include "WavFile.h"


AudioFile::AudioFile(WavInFile *inFile) {
	
	fileLength = inFile->getNumSamples();
	
	buffer = new short[fileLength];
	
	inFile->read(buffer, fileLength);

	delete inFile;
	
}