//
//  SFBreakpointNode.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFBreakpointNode.h"

#import "SFDebug.h"

#import "SFBreakpoint.h"

typedef double SoundTime;

extern const SoundTime SoundTimeInfinity;

struct SoundBreakpoint {
    SoundTime time;
    double value;
};
typedef struct SoundBreakpoint SoundBreakpoint;

static inline SoundBreakpoint
SoundBreakpointMake(SoundTime time, double value) {
    SoundBreakpoint breakpoint = { time, value };
    return breakpoint;
}

const SoundTime SoundTimeInfinity = DBL_MAX;

@interface SFBreakpointNode ()

@property (nonatomic, readonly) NSInteger bpCount;
@property (nonatomic, readonly) SoundBreakpoint *bpPtr;

@end

@implementation SFBreakpointNode

- (instancetype)initWithBreakpoints:(NSArray *)breakpoints
{
    NSMutableArray *bps;
    NSInteger count;
    SFBreakpoint *bp;

    bps = [breakpoints mutableCopy];
    count = bps.count;
    if (count == 0) {
        [bps addObject:[SFBreakpoint breakpointWithTime:0.0 value:0.0]];
        [bps addObject:[SFBreakpoint breakpointWithTime:SoundTimeInfinity value:0.0]];
    } else {
        bp = bps[0];
        SoundTime prevTime = bp.time;

        for (NSInteger i = 1; i < count; i++) {
            bp = bps[i];
            SoundTime nextTime = bp.time;
            if (nextTime < prevTime) {
                SFLog(@"error: invalid time: %f\n", nextTime);
                bp = [SFBreakpoint breakpointWithTime:prevTime value:bp.value];
                [bps replaceObjectAtIndex:i withObject:bp];
            } else {
                prevTime = nextTime;
            }
        }

        bp = bps[0];
        if (bp.time != 0.0) {
            bp = [SFBreakpoint breakpointWithTime:0.0 value:0.0];
            [bps insertObject:bp atIndex:0];
        }

        bp = bps.lastObject;
        if (bp != nil) {
            if (bp.time != SoundTimeInfinity) {
                bp = [SFBreakpoint breakpointWithTime:SoundTimeInfinity value:bp.value];;
                [bps addObject:bp];
            }
        }
    }

    SoundBreakpoint *bpPtr = NULL;

    count = bps.count;
    bpPtr = malloc(sizeof(SoundBreakpoint) * count);
    for (NSInteger i = 0; i < count; i++) {
        bp = bps[i];
        bpPtr[i] = SoundBreakpointMake(bp.time, bp.value);
    }

    SFOutput *output = [[SFOutput alloc] initWithName:@"output"];

    self = [super initWithInputs:@[] outputs:@[output]];
    if (self != nil) {
        _bpCount = count;
        _bpPtr = bpPtr;
        _output = output;
    }
    return self;
}

- (void)dealloc
{
    if (_bpPtr != NULL) {
        free(_bpPtr);
    }
}

- (NSInteger)getBreakpointIndexForTime:(SoundTime)time hint:(NSInteger)hint {
    NSInteger i;
    NSInteger min = 0;
    NSInteger max = _bpCount - 2;

    if (0 <= hint && hint < max) {
        i = hint;
    } else {
        i = (min + max) / 2;
    }

    while (true) {
        if (time < _bpPtr[i].time) {
            max = i - 1;
        } else if (_bpPtr[i+1].time < time) {
            min = i + 1;
        } else {
            return i;
        }
        i = (min + max) / 2;
    }
}

- (BOOL)rendersConstantFrame
{
    return NO;
}

- (BOOL)renderForPlayer:(SFPlaybackManager *)player
                  index:(UInt64)index
                  count:(NSInteger)count
                     to:(double *)buffer
{
    const SoundTime sampleRate = player.sampleRate;
    const SoundTime baseTime = (SoundTime)index / sampleRate;
    SoundTime time = baseTime;
    NSInteger bi = [self getBreakpointIndexForTime:time hint:NSNotFound];
    NSInteger hint = bi;

    for (NSInteger i = 0; i < count; i++) {
        if (time < _bpPtr[bi].time || _bpPtr[bi+1].time < time) {
            bi = [self getBreakpointIndexForTime:time hint:hint];
            hint = bi;
        }

        SoundTime position = (time - _bpPtr[bi].time) / (_bpPtr[bi+1].time - _bpPtr[bi].time);
        double value = _bpPtr[bi].value + (_bpPtr[bi+1].value - _bpPtr[bi].value) * position;
        buffer[i] = value;

        time = baseTime + (SoundTime)(i + 1) / sampleRate;
    }
    return YES;
}

@end
