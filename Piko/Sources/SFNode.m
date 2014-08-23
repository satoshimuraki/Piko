//
//  SFNode.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFNode.h"

#import "SFDebug.h"

@implementation SFNode

- (instancetype)initWithInputs:(NSArray *)inputs outputs:(NSArray *)outputs
{
    self = [super init];
    if (self != nil) {
        SFAssert(inputs != nil);
        SFAssert(outputs != nil);
        _inputs = [inputs copy];
        _outputs = [outputs copy];
        for (SFInput *input in inputs) {
            input.owner = self;
        }
        for (SFOutput *output in outputs) {
            output.owner = self;
        }
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
    return NO;
}

@end
