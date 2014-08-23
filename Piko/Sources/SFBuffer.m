//
//  SFBuffer.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFBuffer.h"

#import "SFDebug.h"

@implementation SFBuffer

- (instancetype)initWithNumberOfFrames:(NSInteger)frames
{
    self = [super init];
    if (self != nil) {
        SFAssert(0 < frames);
        _numberOfFrames = frames;
        _data = malloc(sizeof(double) * frames);
        SFAssert(_data != NULL);
    }
    return self;
}

- (void)dealloc
{
    free(_data);
}

@end
