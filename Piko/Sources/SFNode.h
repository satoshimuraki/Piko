//
//  SFNode.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFPlaybackManager.h"
#import "SFInput.h"
#import "SFOutput.h"

@interface SFNode : NSObject

- (instancetype)initWithInputs:(NSArray *)inputs outputs:(NSArray *)outputs;

@property (nonatomic, readonly) NSArray *inputs;
@property (nonatomic, readonly) NSArray *outputs;

- (BOOL)rendersConstantFrame;

- (BOOL)renderForPlayer:(SFPlaybackManager *)player
                  index:(UInt64)index
                  count:(NSInteger)count
                     to:(double *)buffer;

@end
