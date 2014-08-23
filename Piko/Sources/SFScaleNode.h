//
//  SFScaleNode.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFNode.h"

@interface SFScaleNode : SFNode

@property (nonatomic, readonly) SFInput *input;
@property (nonatomic, readonly) SFInput *scale;
@property (nonatomic, readonly) SFOutput *output;

@end
