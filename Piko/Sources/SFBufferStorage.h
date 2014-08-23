//
//  SFBufferStorage.h
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFBuffer;

@interface SFBufferStorage : NSObject

- (instancetype)initWithNumberOfFrames:(NSInteger)frames;

/*!
    保持する SFBuffer の numberOfFrames.
*/
@property (nonatomic, readonly) NSInteger numberOfFrames;

/*!
    ストレージ内に保持する SFBuffer の数. デフォルトは 0.
    指定した数より多くなった場合は自動的に削除する.
    0 を指定した場合は, 制限を設けず pull() の呼び出しによって SFBuffer が増える.
*/
@property (nonatomic, assign) NSInteger maxStoredBufferCount;

/*!
    指定した数まで SFBuffer を作成する.
    maxCount が maxStoredBufferCount よりも大きい場合は,
    maxStoredBufferCount の数まで作成する.
*/
- (void)populate:(NSInteger)maxCount;

/*!
    保持している SFBuffer が空の場合は, 新しく SFBuffer を生成する.
*/
- (SFBuffer *)pull;

/*!
    SFBuffer を返却する.
    保持する SFBuffer の数が maxStoredBufferCount を超えた場合は削除される.
*/
- (void)push:(SFBuffer *)buffer;

@end
