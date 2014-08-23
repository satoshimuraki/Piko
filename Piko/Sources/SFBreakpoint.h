//
//  SFBreakpoint.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFBreakpoint : NSObject

+ (instancetype)breakpointWithTime:(double)time value:(double)value;
- (instancetype)initWithTime:(double)time value:(double)value;

@property (nonatomic, readonly) double time;
@property (nonatomic, readonly) double value;

@end
