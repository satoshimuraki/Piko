//
//  SFPlaybackManager.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

@import AVFoundation;
@import Foundation;

@class SoundBufferStorage;
@class SoundSketch;

@interface SFPlaybackManager : NSObject

+ (SFPlaybackManager *)sharedManager;

- (BOOL)activate;
- (BOOL)deactivate;
@property (nonatomic, readonly) BOOL active;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// MARK: Audio Route

@property (nonatomic, readonly) AVAudioSessionRouteDescription *currentRoute;
@property (nonatomic, readonly) Float64 sampleRate;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// MARK: Audio Sketch

@property (nonatomic, strong) SoundSketch *sketch;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// MARK: Audio Buffer Storage

@property (nonatomic, strong) SoundBufferStorage *bufferStorage;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// MARK: Play

@property (nonatomic, readonly) BOOL playing;
- (BOOL)start;
- (BOOL)stop;

@end
