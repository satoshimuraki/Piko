//
//  SFBreakpointNode.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFNode.h"

@interface SFBreakpointNode : SFNode

- (instancetype)initWithBreakpoints:(NSArray *)breakpoints;

@property (nonatomic, readonly) SFOutput *output;

@end
