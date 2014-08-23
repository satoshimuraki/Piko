//
//  SFBreakpoint.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFBreakpoint.h"

@implementation SFBreakpoint

+ (instancetype)breakpointWithTime:(double)time value:(double)value
{
    return [[SFBreakpoint alloc] initWithTime:time value:value];
}

- (instancetype)initWithTime:(double)time value:(double)value
{
    self = [super init];
    if (self != nil) {
        _time = time;
        _value = value;
    }
    return self;
}

@end
