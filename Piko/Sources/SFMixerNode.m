//
//  SFMixerNode.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFMixerNode.h"

#import "SFBuffer.h"
#import "SFBufferOperator.h"

@implementation SFMixerNode

- (instancetype)init
{
    SFInput *i1 = [[SFInput alloc] initWithName:@"1"];
    SFInput *i2 = [[SFInput alloc] initWithName:@"2"];
    SFInput *i3 = [[SFInput alloc] initWithName:@"3"];
    SFInput *i4 = [[SFInput alloc] initWithName:@"4"];
    SFOutput *output = [[SFOutput alloc] initWithName:@"output"];
    self = [super initWithInputs:@[i1, i2, i3, i4] outputs:@[output]];
    if (self != nil) {
        _input1 = i1;
        _input2 = i2;
        _input3 = i3;
        _input4 = i4;
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
    BOOL didRender = NO;
    SFBufferOperator *tempBufferOperator;

    for (SFInput *input in self.inputs) {
        SFNode *node = input.source.owner;
        if (node == nil) {
            continue;
        }

        if ([node rendersConstantFrame]) {
            double sample;
            if (![node renderForPlayer:player index: index count: 1 to: &sample]) {
                return NO;
            }
            if (didRender) {
                for (NSInteger i = 0; i < count; i++) {
                    buffer[i] += sample;
                }
            } else {
                for (NSInteger i = 0; i < count; i++) {
                    buffer[i] = sample;
                }
            }
        } else {
            if (didRender) {
                if (tempBufferOperator == nil) {
                    tempBufferOperator = [player getSFBufferOperator];
                }
                double *tempBufferData = tempBufferOperator.buffer.data;

                if (![node renderForPlayer:player index:index count:count to:tempBufferData]) {
                    return NO;
                }
                for (NSInteger i = 0; i < count; i++) {
                    buffer[i] += tempBufferData[i];
                }
            } else {
                if (![node renderForPlayer:player index:index count:count to:buffer]) {
                    return NO;
                }
            }
        }
        didRender = YES;
    }
    return didRender;
}

@end
