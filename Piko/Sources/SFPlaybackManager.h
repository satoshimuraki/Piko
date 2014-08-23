//
//  SFPlaybackManager.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

@import AVFoundation;
@import Foundation;

@class SFBufferOperator;
@class SFBufferStorage;
@class SFNode;
@class SFSketch;

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

@property (nonatomic, strong) SFSketch *sketch;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// MARK: Rendering

- (SFBufferOperator *)getSFBufferOperator;
- (BOOL)render:(SFNode *)node index:(UInt64)index count:(NSInteger)count to:(double *)buffer;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// MARK: Play

@property (nonatomic, readonly) BOOL playing;
- (BOOL)start;
- (BOOL)stop;

@end
