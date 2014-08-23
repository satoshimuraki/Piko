//
//  SFWhiteNoiseNode.m
//  Piko
//
//  Created by Satoshi Muraki on 8/20/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFWhiteNoiseNode.h"

#import "SFPlaybackManager.h"

@implementation SFWhiteNoiseNode

- (instancetype)init
{
    SFOutput *output = [[SFOutput alloc] initWithName:@"output"];
    self = [super initWithInputs:@[] outputs:@[output]];
    if (self != nil) {
        _output = output;
    }
    return self;
}

- (BOOL)renderForPlayer:(SFPlaybackManager *)player
                  index:(UInt64)index
                  count:(NSInteger)count
                     to:(double *)buffer
{
    for (NSInteger i = 0; i < count; i++) {
        buffer[i] = (double)random() / (double)RAND_MAX * 2.0 - 1.0;
    }
    return YES;
}

@end
