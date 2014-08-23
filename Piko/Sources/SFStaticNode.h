//
//  SFStaticNode.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFNode.h"

@interface SFStaticNode : SFNode

- (instancetype)initWithValue:(double)value;

@property (nonatomic, readonly) double value;
@property (nonatomic, readonly) SFOutput *output;

@end
