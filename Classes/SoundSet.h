/*
 *  SoundSet.h
 *  DF666
 *
 *  Created by Einar Andersson on 12/25/09.
 *  Copyright 2009 Roventskij. All rights reserved.
 *
 */

#include <vector>

#include <MacTypes.h>

class AudioFile;

class SoundSet {
public:
	const char *name;
	std::vector<AudioFile*> files;
	SoundSet(const char *path, const char *nName);
};