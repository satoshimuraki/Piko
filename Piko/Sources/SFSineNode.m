//
//  SFSineNode.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFSineNode.h"

#import "SFBuffer.h"
#import "SFBufferOperator.h"

@interface SFSineNode ()

@property (nonatomic, assign) double phase;

@end

@implementation SFSineNode

- (instancetype)init
{
    SFInput *frequency = [[SFInput alloc] initWithName:@"frequency"];
    SFOutput *output = [[SFOutput alloc] initWithName:@"output"];
    self = [super initWithInputs:@[frequency] outputs:@[output]];
    if (self != nil) {
        _frequency = frequency;
        _output = output;
    }
    return self;
}

- (BOOL)renderForPlayer:(SFPlaybackManager *)player
                  index:(UInt64)index
                  count:(NSInteger)count
                     to:(double *)buffer
{
    SFNode *frequencyNode = _frequency.source.owner;
    if (frequencyNode == nil) {
        return NO;
    }

    if ([frequencyNode rendersConstantFrame]) {
        double freq;
        if (![frequencyNode renderForPlayer: player
                                      index: index
                                      count: 1
                                         to: &freq]) {
            return NO;
        }

        double step = freq * 2.0 * M_PI / player.sampleRate;

        for (NSInteger i = 0; i < count; i++) {
            buffer[i] = sin(_phase);
            _phase += step;
        }
    } else {
        SFBufferOperator *freqBufferOperator = [player getSFBufferOperator];
        double *freqBufferData = freqBufferOperator.buffer.data;

        if (![frequencyNode renderForPlayer: player index: index count: count to: freqBufferData]) {
            return NO;
        }

        double sampleRate = player.sampleRate;

        for (NSInteger i; i < count; i++) {
            buffer[i] = sin(_phase);
            _phase += freqBufferData[i] * 2.0 * M_PI / sampleRate;
        }
    }
    return YES;
}

@end
