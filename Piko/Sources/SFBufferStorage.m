//
//  SFBufferStorage.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFBufferStorage.h"

#import "SFDebug.h"
#import "SFBuffer.h"

@interface SFBufferStorage ()

@property (nonatomic, readonly) NSMutableArray *buffers;

@end

@implementation SFBufferStorage

- (instancetype)initWithNumberOfFrames:(NSInteger)frames
{
    self = [super init];
    if (self != nil) {
        SFAssert(0 < frames);
        _numberOfFrames = frames;
        _buffers = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)populate:(NSInteger)maxCount
{
    if (maxCount <= 0) {
        return;
    }

    if (0 < _maxStoredBufferCount && _maxStoredBufferCount < maxCount) {
        maxCount = _maxStoredBufferCount;
    }

    while (_buffers.count < maxCount) {
        SFBuffer *buffer;
        buffer = [[SFBuffer alloc] initWithNumberOfFrames:_numberOfFrames];
        SFAssert(buffer != nil);
        [_buffers addObject:buffer];
    }
}

- (SFBuffer *)pull
{
    SFBuffer *buffer = [_buffers lastObject];
    if (buffer != nil) {
        [_buffers removeLastObject];
    } else {
        buffer = [[SFBuffer alloc] initWithNumberOfFrames:_numberOfFrames];
    }
    return buffer;
}

- (void)push:(SFBuffer *)buffer
{
    if (_maxStoredBufferCount <= 0 || _buffers.count < _maxStoredBufferCount) {
        [_buffers addObject:buffer];
    }
}

@end
