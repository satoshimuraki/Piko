//
//  SFBufferOperator.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFBuffer;
@class SFBufferStorage;

@interface SFBufferOperator : NSObject

- (instancetype)initWithStorage:(SFBufferStorage *)storage;

@property (nonatomic, readonly) SFBuffer *buffer;
@property (nonatomic, readonly) SFBufferStorage *storage;

@end
