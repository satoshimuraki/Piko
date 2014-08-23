//
//  SFSquareNode.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFSquareNode.h"

@interface SFSquareNode ()

@property (nonatomic, assign) double phase;

@end

@implementation SFSquareNode

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
    /* frequency: variable */
    SFNode *frequencyNode = _frequency.source.owner;

    if (frequencyNode == nil) {
        return NO;
    }

    if (![frequencyNode rendersConstantFrame]) {
// TODO: 未対応.
        return NO;
    }

    double value;

    if (![frequencyNode renderForPlayer:player index:index count:1 to:&value]) {
        return NO;
    }

    double step = value / player.sampleRate;

    // freq = 385.0 Hz
    // sample rate = 44100 Hz
    // 1 秒間 (44100 sample) に 385 周期
    // 1/385 秒で 1 周期
    // 44100 / 385 = 114.54545454545455
    // 44100 / (385 * 2) = 57.27272727272727
    // 0 <= x < 57 ... round(57.27272727272727)
    // 57 <= x < 115 round(114.54545454545455)
    // 115 <= x <
    // 1 周期 ... 114.54545454545455 サンプル
    // 0.00873015873016 周期 ... 1 サンプル

    for (NSInteger i = 0; i < count; i++) {
        buffer[i] = (_phase < 0.5) ? 1.0 : -1.0;
        _phase += step;
        while (1.0 <= _phase) {
            _phase -= 1.0;
        }
    }
    return YES;
}

@end
