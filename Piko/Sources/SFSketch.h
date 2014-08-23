//
//  SFSketch.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFOutputNode.h"

@protocol SFSketchDelegate;

@interface SFSketch : NSObject

@property (nonatomic, readonly) SFOutputNode *outputNode;
@property (nonatomic, weak) id<SFSketchDelegate> delegate;

- (void)appendNode:(SFNode *)node;
- (void)removeNode:(SFNode *)node;

- (void)connect:(SFOutput *)src to:(SFInput *)dst;
- (void)disconnectOutput:(SFOutput *)output;

@end

@protocol SFSketchDelegate <NSObject>

- (void)sketch:(SFSketch *)sketch didAppendNode:(SFNode *)node;
- (void)sketch:(SFSketch *)sketch didRemoveNode:(SFNode *)node;

@end
