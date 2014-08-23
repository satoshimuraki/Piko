//
//  SFOutputNode.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFOutputNode.h"

#import "SFInput.h"
#import "SFOutput.h"

@implementation SFOutputNode

- (instancetype)init
{
    SFInput *input = [[SFInput alloc] initWithName:@"input"];
    SFOutput *output = [[SFOutput alloc] initWithName:@"output"];
    self = [super initWithInputs:@[input] outputs:@[output]];
    if (self != nil) {
        _input = input;
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
    SFNode *inputNode = _input.source.owner;
    if (inputNode != nil) {
        return [inputNode renderForPlayer:player
                                    index:index
                                    count:count
                                       to:buffer];
    }

    for (NSInteger i = 0; i < count; i++) {
        buffer[i] = 0.0;
    }
    return YES;
}

@end
