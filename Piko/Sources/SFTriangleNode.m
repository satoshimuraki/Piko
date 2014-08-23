//
//  SFTriangleNode.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFTriangleNode.h"

@interface SFTriangleNode ()

@property (nonatomic, assign) double phase;

@end

@implementation SFTriangleNode

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

- (BOOL)rendersConstantFrame
{
    return NO;
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

    if (![frequencyNode rendersConstantFrame]) {
// TODO: 未対応
        return NO;
    }

    double freq = 0.0;

    if (![frequencyNode renderForPlayer:player index:index count:1 to:&freq]) {
        return NO;
    }

    double step = freq / player.sampleRate;

    for (NSInteger i = 0; i < count; i++) {
        buffer[i] = (_phase < 0.25) ? _phase * 4.0 :
                    (_phase < 0.75) ? (0.50 - _phase) * 4.0 :
                                     (_phase - 1.0) * 4.0;
        _phase += step;
        while (1.0 <= _phase) {
            _phase -= 1.0;
        }
    }
    return YES;
}

@end
