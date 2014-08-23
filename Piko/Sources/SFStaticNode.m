//
//  SFStaticNode.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFStaticNode.h"

@implementation SFStaticNode

- (instancetype)initWithValue:(double)value
{
    SFOutput *output = [[SFOutput alloc] initWithName:@"output"];
    self = [super initWithInputs:@[] outputs:@[output]];
    if (self != nil) {
        _output = output;
        _value = value;
    }
    return self;
}

- (BOOL)rendersConstantFrame
{
    return YES;
}

- (BOOL)renderForPlayer:(SFPlaybackManager *)player
                  index:(UInt64)index
                  count:(NSInteger)count
                     to:(double *)buffer
{
    for (NSInteger i = 0; i < count; i++) {
        buffer[i] = _value;
    }
    return YES;
}

@end
