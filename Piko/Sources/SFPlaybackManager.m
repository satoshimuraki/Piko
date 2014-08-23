//
//  SFPlaybackManager.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFPlaybackManager.h"

#import "SFDebug.h"

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#if (PIKO_OBJC)
#import "SFBuffer.h"
#import "SFBufferOperator.h"
#import "SFBufferStorage.h"
#import "SFSketch.h"
#import "SFOutputNode.h"
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#elif defined (PIKO_PREFERS_OBJC)
#import "SFBuffer.h"
#import "SFBufferOperator.h"
#import "SFBufferStorage.h"
#import "SFSketch.h"
#import "SFOutputNode.h"
#import "Piko-Swift.h"
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#else
#import "PikoSwift-Swift.h"
#endif

#define SFAudioOutputBusNumber          0

static SFPlaybackManager *sSharedManager = nil;

@interface SFPlaybackManager ()

@property (nonatomic) BOOL active;

/* Audio Session */
@property (nonatomic) Float64 sampleRate;

@property (nonatomic) BOOL observingInterruption;

/* Audio Route */
@property (nonatomic) BOOL observingAudioRoute;
@property (nonatomic) AVAudioSessionRouteDescription *currentRoute;

/* Output */
@property (nonatomic) AudioUnit outputUnit;
@property (nonatomic) unsigned long long frameIndex;

/* Sound Buffer */
@property (nonatomic, strong) SFBufferStorage *bufferStorage;

/* Play */
@property (nonatomic) BOOL playing;

@end

@implementation SFPlaybackManager

+ (void)initialize
{
    if ([self class] == [SFPlaybackManager class]) {
        sSharedManager = [[SFPlaybackManager alloc] init];
    }
}

+ (SFPlaybackManager *)sharedManager
{
    return sSharedManager;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
    }
    return self;
}

- (void)dealloc
{
    if (self.active)
        [self deactivate];
}

- (BOOL)activate
{
    if (self.active)
        return YES;

    AVAudioSession *session;
    NSError *error;
    BOOL retval;

    session = [AVAudioSession sharedInstance];

    /* Set category */
    retval = [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (!retval)
    {
        SFLog(@"error: %@\n", error);
        goto bail;
    }

    retval = [session setActive:YES error:&error];
    if (!retval)
    {
        SFLog(@"error: %@\n", error);
        goto bail;
    }

    /* Set active */
    self.active = YES;

    /* Begin observing audio route. */
    [self beginObservingAudioRoute];

    [self beginObservingInterruption];

    [session setPreferredSampleRate:44100.0 error:&error];
    [session setPreferredIOBufferDuration:0.1 error:&error];

    /* Get Preferred Hardware Sample Rate */
    _sampleRate = [session preferredSampleRate];
    SFLogRaw(@"sample rate: %f\n", _sampleRate);

    /* Get Buffer Duration */
    NSTimeInterval duration;

    duration = [session preferredIOBufferDuration];
    SFLogRaw(@"preferred IO buffer duration: %f\n", duration);

    /* Get Number of Frames */
    UInt32 numberOfFrames;

    numberOfFrames = round(_sampleRate * duration);
    SFLogRaw(@"frame: %u (%f)\n", numberOfFrames, _sampleRate * (Float64)duration);

    /* Create buffer storage. */
    _bufferStorage = [[SFBufferStorage alloc] initWithNumberOfFrames:numberOfFrames];
    SFGotoIf(_bufferStorage == nil, bail);

    /* Setup Output Unit */
    SFGotoIf(![self openOutputUnit], bail);

    return YES;

bail:
    if (self.active)
        [self deactivate];
    return NO;
}

- (BOOL)deactivate
{
    if (!self.active)
        return YES;

    [self closeOutputUnit];

    [self endObservingAudioRoute];

    NSError *error;
    BOOL retval;

    retval = [[AVAudioSession sharedInstance] setActive:NO
        withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
              error:&error];
    if (!retval)
    {
        SFLog(@"error: %@\n", error);
    }

    self.active = NO;
    return YES;

bail:
    return NO;
}

#pragma mark -

#if (0)
    /* Get number of channels */
    UInt32 numberOfChannels;

    size = sizeof(numberOfChannels);
    err = AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareOutputNumberChannels, &size, &numberOfChannels);
    ReturnIf(err != noErr);
#endif

- (BOOL)beginObservingAudioRoute
{
    SFAssert(self.active);

    if (self.observingAudioRoute)
        return YES;

    AVAudioSession *session;
    NSNotificationCenter *nc;

    session = [AVAudioSession sharedInstance];
    nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(audioSessionRouteChange:)
               name:AVAudioSessionRouteChangeNotification
             object:session];

    self.currentRoute = [session currentRoute];

    self.observingAudioRoute = YES;

    return YES;
}

- (BOOL)endObservingAudioRoute
{
    SFAssert(self.active);

    if (!self.observingAudioRoute)
        return YES;

    AVAudioSession *session;
    NSNotificationCenter *nc;

    session = [AVAudioSession sharedInstance];
    nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:AVAudioSessionRouteChangeNotification object:session];

    self.currentRoute = nil;

    self.observingAudioRoute = NO;

    return YES;
}

- (void)audioSessionRouteChange:(NSNotification *)notif
{
    SFLog(@"userInfo: %@\n", notif.userInfo);

    AVAudioSession *session;

    session = notif.object;
    self.currentRoute = session.currentRoute;
}

- (OSStatus)outputUnitRender:(AudioUnitRenderActionFlags *)ioActionFlags
                   timestamp:(const AudioTimeStamp *)inTimeStamp
                   busNumber:(UInt32)inBusNumber
                numberFrames:(UInt32)inNumberFrames
             audioBufferList:(AudioBufferList *)ioData
{
    SFAssert(ioData->mNumberBuffers == 2);

#if (0)
    NSLog(@"abs: %lld\n", mach_absolute_time());
    NSLog(@"AudioTimeStamp: {\n"
           "  mSampleTime: %f,\n"
           "  mHostTime: %llu,\n"
           "  mRateScalar: %f,\n"
           "  mWordClockTime: %llu,\n"
           "  mSMTPETime: ...,\n"
           "  mFlags: %#x,\n"
           "  mReserved: %#x,\n"
           "}\n",
           inTimeStamp->mSampleTime,
           inTimeStamp->mHostTime,
           inTimeStamp->mRateScalar,
           inTimeStamp->mWordClockTime,
           (unsigned)inTimeStamp->mFlags,
           (unsigned)inTimeStamp->mReserved);
#endif

    Float64 *outL, *outR;

    outL = ioData->mBuffers[0].mData;
    outR = ioData->mBuffers[1].mData;

    SFBuffer *buffer;

    buffer = [self.bufferStorage pull];
    SFReturnValueIf(buffer == nil, noErr);

    OSStatus err = noErr;
    UInt32 i, readFrames, targetFrames;
    Float64 sample;
//    Float64 *dataPtr;
    SFNode *node;

//    dataPtr = malloc(sizeof(Float64) * buffer.numberOfFrames);

    node = _sketch.outputNode;
    targetFrames = MIN((UInt32)buffer.numberOfFrames, inNumberFrames);
    readFrames = 0;
    while (readFrames < inNumberFrames)
    {
#if (0)
        SFTime t = (Float64)_frameIndex / (Float64)_sampleRate;
        NSLog(@"time: %f\n", t);
#endif

        BOOL ret = [self render:node index:_frameIndex count:targetFrames to:buffer.data];
        if (ret == NO) {
            NSLog(@"ummm...");
        }

        i = 0;
        while (i < targetFrames)
        {
            sample = buffer.data[i];
//            sample = ((Float32)dataPtr[i]) * (1 << kAudioUnitSampleFractionBits);
            *outL++ = sample;
            *outR++ = sample;
            i ++;
        }

        _frameIndex += targetFrames;
        readFrames += targetFrames;
    }

    [self.bufferStorage push:buffer];

    return err;
}

static OSStatus
outputUnitRenderCallback(
    void *                          inRefCon,
    AudioUnitRenderActionFlags *    ioActionFlags,
    const AudioTimeStamp *          inTimeStamp,
    UInt32                          inBusNumber,
    UInt32                          inNumberFrames,
    AudioBufferList *               ioData)
{
    @autoreleasepool
    {
        SFPlaybackManager *manager = (__bridge SFPlaybackManager *)inRefCon;
        return [manager outputUnitRender:ioActionFlags
                               timestamp:inTimeStamp
                               busNumber:inBusNumber
                            numberFrames:inNumberFrames
                         audioBufferList:ioData];
    }
}

- (BOOL)openOutputUnit
{
    SFAssert(_outputUnit == NULL);

    AudioComponentDescription acd;
    AudioComponent comp;
    OSStatus err;

    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_RemoteIO;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    comp = AudioComponentFindNext(NULL, &acd);
    SFReturnValueIf(comp == NULL, NO);

    err = AudioComponentInstanceNew(comp, &_outputUnit);
    SFGotoIf(err != noErr, bail);

    err = AudioUnitInitialize(_outputUnit);
    SFGotoIf(err != noErr, bail);

    AURenderCallbackStruct callbackStruct = { 0 };
    callbackStruct.inputProc = outputUnitRenderCallback;
    callbackStruct.inputProcRefCon = (__bridge void *)self;

    err = AudioUnitSetProperty(
        _outputUnit,
        kAudioUnitProperty_SetRenderCallback,
        kAudioUnitScope_Input,
        SFAudioOutputBusNumber,
        &callbackStruct,
        sizeof(callbackStruct));
    SFGotoIf(err != noErr, bail);

    /* ASBD */
    AudioStreamBasicDescription asbd;

    asbd.mSampleRate = _sampleRate;
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagsNativeFloatPacked |
                        kAudioFormatFlagIsNonInterleaved;
    asbd.mBytesPerPacket = sizeof(Float64);
    asbd.mFramesPerPacket = 1;
    asbd.mBytesPerFrame = sizeof(Float64);
    asbd.mChannelsPerFrame = 2;
    asbd.mBitsPerChannel = 8 * sizeof(Float64);
    asbd.mReserved = 0;

    err = AudioUnitSetProperty(
        _outputUnit,
        kAudioUnitProperty_StreamFormat,
        kAudioUnitScope_Input,
        SFAudioOutputBusNumber,
        &asbd,
        sizeof(asbd));
    SFGotoIf(err != noErr, bail);

    return YES;

bail:
    if (_outputUnit != NULL)
    {
        err = AudioComponentInstanceDispose(_outputUnit);
        SFCheck(err != noErr);
        _outputUnit = NULL;
    }
    return NO;
}

- (void)closeOutputUnit
{
    if (_outputUnit == NULL)
        return;

    OSStatus err;

    err = AudioUnitUninitialize(_outputUnit);
    SFCheck(err == noErr);

    err = AudioComponentInstanceDispose(_outputUnit);
    SFCheck(err == noErr);

    _outputUnit = NULL;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// MARK: Sound Buffer

- (SFBufferOperator *)getSFBufferOperator
{
    return [[SFBufferOperator alloc] initWithStorage:self.bufferStorage];
}

- (BOOL)render:(SFNode *)node index:(UInt64)index count:(NSInteger)count to:(double *)buffer
{
    @autoreleasepool {
        return [node renderForPlayer:self index:index count:count to:buffer];
    }
}

#pragma mark -
#pragma mark Play

- (BOOL)start
{
    if (self.playing)
        return YES;

    SFReturnValueIf(!self.active, NO);
    SFReturnValueIf(_sketch == nil, NO);

    self.frameIndex = 0;

    OSStatus err;

    err = AudioOutputUnitStart(_outputUnit);
    SFReturnValueIf(err != noErr, NO);

    self.playing = YES;
    return YES;
}

- (BOOL)stop
{
    if (!self.playing)
        return YES;

    SFAssert(_outputUnit != NULL);

    OSStatus err;

    err = AudioOutputUnitStop(_outputUnit);
    SFReturnValueIf(err != noErr, NO);

    self.playing = NO;
    return YES;
}

#pragma mark -
#pragma mark Audio Session Interruption

- (void)beginObservingInterruption
{
    if (self.observingInterruption)
        return;

    AVAudioSession *session;

    session = [AVAudioSession sharedInstance];

    NSNotificationCenter *nc;

    nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(audioSessionInterruption:)
               name:AVAudioSessionInterruptionNotification
             object:session];

    self.observingInterruption = YES;
}

- (void)endObservingInterruption
{
    if (!self.observingInterruption)
        return;

    AVAudioSession *session;

    session = [AVAudioSession sharedInstance];

    NSNotificationCenter *nc;

    nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self
                  name:AVAudioSessionInterruptionNotification
                object:session];

    self.observingInterruption = NO;
}

- (void)audioSessionInterruption:(NSNotification *)notif
{
}

@end
