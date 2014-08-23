//
//  SFInput.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFNode;
@class SFOutput;

@interface SFInput : NSObject

- (instancetype)initWithName:(NSString *)name;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, weak) SFNode *owner;
@property (nonatomic, weak) SFOutput *source;

@end
