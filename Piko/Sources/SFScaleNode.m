//
//  SFScaleNode.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFScaleNode.h"

#import "SFBuffer.h"
#import "SFBufferOperator.h"
#import "SFBufferStorage.h"

@implementation SFScaleNode

- (instancetype)init
{
    SFInput *input = [[SFInput alloc] initWithName:@"input"];
    SFInput *scale = [[SFInput alloc] initWithName:@"scale"];
    SFOutput *output = [[SFOutput alloc] initWithName:@"output"];
    self = [super initWithInputs:@[input, scale] outputs:@[output]];
    if (self != nil) {
        _input = input;
        _scale = scale;
        _output = output;
    }
    return self;
}

- (BOOL)rendersConstantFrame
{
    SFNode *inputNode = _input.source.owner;
    SFNode *scaleNode = _scale.source.owner;
    if (inputNode == nil || scaleNode == nil) {
        return NO;
    }
    return ([inputNode rendersConstantFrame] &&
            [scaleNode rendersConstantFrame]);
}

- (BOOL)renderForPlayer:(SFPlaybackManager *)player
                  index:(UInt64)index
                  count:(NSInteger)count
                     to:(double *)buffer
{
    SFNode *iNode = _input.source.owner;
    if (iNode == nil) {
        return NO;
    }

    SFNode *sNode = _scale.source.owner;
    if (sNode == nil) {
        return NO;
    }

    BOOL inputIsConstant = [iNode rendersConstantFrame];
    BOOL scaleIsConstant = [sNode rendersConstantFrame];

    double sampleValue = 0.0;
    double scaleValue = 1.0;

    if (inputIsConstant) {
        if (![iNode renderForPlayer:player index:index count:1 to:&sampleValue]) {
            return NO;
        }
    }

    if (scaleIsConstant) {
        if (![sNode renderForPlayer:player index:index count:1 to:&scaleValue]) {
            return NO;
        }
    }

    if (inputIsConstant && scaleIsConstant) {
        double value = sampleValue * scaleValue;
        for (NSInteger i; i < count; i++) {
            buffer[i] = value;
        }
        return YES;
    }

    if (inputIsConstant) {
        SFBufferOperator *scaleBufferOperator = [player getSFBufferOperator];
        double *scaleBufferData = scaleBufferOperator.buffer.data;

        if (![sNode renderForPlayer:player index:index count:count to:scaleBufferData]) {
            return NO;
        }
        for (NSInteger i = 0; i < count; i++) {
            buffer[i] = sampleValue * scaleBufferData[i];
        }
        return YES;
    }

    if (scaleIsConstant) {
        SFBufferOperator *inputBufferOperator = [player getSFBufferOperator];
        double *inputBufferData = inputBufferOperator.buffer.data;

        if (![iNode renderForPlayer:player index:index count:count to:inputBufferData]) {
            return NO;
        }
        for (NSInteger i = 0; i < count; i++) {
            buffer[i] = scaleValue * inputBufferData[i];
        }
        return YES;
    }

    SFBufferOperator *inputBufferOperator = [player getSFBufferOperator];
    double *inputBufferData = inputBufferOperator.buffer.data;

    if (![iNode renderForPlayer:player index:index count:count to:inputBufferData]) {
        return NO;
    }

    SFBufferOperator *scaleBufferOperator = [player getSFBufferOperator];
    double *scaleBufferData = scaleBufferOperator.buffer.data;

    if (![sNode renderForPlayer:player index:index count:count to:scaleBufferData]) {
        return NO;
    }

    for (NSInteger i = 0; i < count; i++) {
        buffer[i] = inputBufferData[i] * scaleBufferData[i];
    }
    return YES;
}

@end
