//
//  SFOutput.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFInput;
@class SFNode;

@interface SFOutput : NSObject

- (instancetype)initWithName:(NSString *)name;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, weak) SFNode *owner;
@property (nonatomic, weak) SFInput *destination;

@end
