//
//  SFSketch.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFSketch.h"

@interface SFSketch ()

@property (nonatomic, readonly) NSMutableArray *nodes;

@end

@implementation SFSketch

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _outputNode = [[SFOutputNode alloc] init];
        _nodes = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)appendNode:(SFNode *)node
{
    [_nodes addObject:node];
    [_delegate sketch:self didAppendNode:node];
}

- (void)removeNode:(SFNode *)node
{
    NSUInteger index = [_nodes indexOfObject:node];
    if (index == NSNotFound) {
        return;
    }

    for (SFInput *input in node.inputs) {
        SFOutput *output = input.source;
        if (output != nil) {
            [self disconnectOutput:output];
        }
    }

    for (SFOutput *output in node.outputs) {
        [self disconnectOutput:output];
    }

    [_nodes removeObjectAtIndex:index];
    [_delegate sketch:self didRemoveNode:node];
}

- (void)connect:(SFOutput *)src to:(SFInput *)dst
{
    SFOutput *currentSrc = dst.source;
    if (currentSrc != nil) {
        if (currentSrc == src) {
            return;
        } else {
            [self disconnectOutput:currentSrc];
        }
    }

    SFInput *currentDst = src.destination;
    if (currentDst != nil) {
        [self disconnectOutput:src];
    }

    src.destination = dst;
    dst.source = src;
}

- (void)disconnectOutput:(SFOutput *)output
{
    SFInput *input = output.destination;
    if (input != nil) {
        output.destination = nil;
        input.source = nil;
    }
}

@end
