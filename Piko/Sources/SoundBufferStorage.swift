//
//  SoundBufferStorage.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SoundBufferStorage: NSObject {

    /*!
        保持する SoundBuffer の numberOfFrames.
    */
    let numberOfFrames: Int
    let queue = dispatch_queue_create("", nil)
    var buffers = [SoundBuffer]()

    init(numberOfFrames: Int) {
        self.numberOfFrames = numberOfFrames
    }

    /*!
        ストレージ内に保持する SoundBuffer の数. デフォルトは 0.
        指定した数より多くなった場合は自動的に削除する.
        0 を指定した場合は, 制限を設けず pull() の呼び出しによって SoundBuffer が増える.
    */
    var maxStoredBufferCount: Int = 0

    /*!
        指定した数まで SFBuffer を作成する.
        maxCount が maxStoredBufferCount よりも大きい場合は,
        maxStoredBufferCount の数まで作成する.
    */
    func populate(maxCount: Int) {
        dispatch_sync(queue) {
            var count: Int
            if 0 < self.maxStoredBufferCount {
                count = min(self.maxStoredBufferCount, maxCount)
            } else {
                count = maxCount
            }

            while self.buffers.count < count {
                self.buffers.append(SoundBuffer(numberOfFrames: self.numberOfFrames))
            }
        }
    }

    /*!
        保持している SFBuffer が空の場合は, 新しく SFBuffer を生成する.
    */
    func pull() -> SoundBuffer {
        var buffer: SoundBuffer?

        dispatch_sync(self.queue) {
            if 0 < self.buffers.count {
                buffer = self.buffers.removeLast()
            } else {
                buffer = SoundBuffer(numberOfFrames: self.numberOfFrames)
            }
        }
        return buffer!
    }

    /*!
        SFBuffer を返却する.
        保持する SFBuffer の数が maxStoredBufferCount を超えた場合は削除される.
    */
    func push(buffer: SoundBuffer) {
        dispatch_sync(queue) {
            if self.maxStoredBufferCount <= 0 ||
               self.buffers.count < self.maxStoredBufferCount {
                self.buffers.append(buffer)
            }
        }
    }
}
