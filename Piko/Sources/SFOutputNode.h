//
//  SFOutputNode.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFNode.h"

@class SFInput;

@interface SFOutputNode : SFNode

@property (nonatomic, readonly) SFInput *input;
@property (nonatomic, readonly) SFOutput *output;

@end
