//
//  SFSquareNode.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFNode.h"

@interface SFSquareNode : SFNode

@property (nonatomic, readonly) SFInput *frequency;
@property (nonatomic, readonly) SFOutput *output;

@end
