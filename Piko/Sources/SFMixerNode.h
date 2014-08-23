//
//  SFMixerNode.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFNode.h"

@interface SFMixerNode : SFNode

@property (nonatomic, readonly) SFInput *input1;
@property (nonatomic, readonly) SFInput *input2;
@property (nonatomic, readonly) SFInput *input3;
@property (nonatomic, readonly) SFInput *input4;
@property (nonatomic, readonly) SFOutput *output;

@end
