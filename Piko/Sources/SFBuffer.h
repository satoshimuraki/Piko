//
//  SFBuffer.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFBuffer : NSObject

- (instancetype)initWithNumberOfFrames:(NSInteger)frames;

@property (nonatomic, readonly) NSInteger numberOfFrames;
@property (nonatomic, readonly) double *data;

@end
