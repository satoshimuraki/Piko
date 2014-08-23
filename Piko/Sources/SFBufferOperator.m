//
//  SFBufferOperator.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFBufferOperator.h"

#import "SFBufferStorage.h"

@implementation SFBufferOperator

- (instancetype)initWithStorage:(SFBufferStorage *)storage
{
    self = [super init];
    if (self != nil) {
        _storage = storage;
        _buffer = [storage pull];
    }
    return self;
}

- (void)dealloc
{
    [_storage push:_buffer];
}

@end
