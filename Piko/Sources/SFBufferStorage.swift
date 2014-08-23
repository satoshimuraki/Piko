//
//  SFBufferStorage.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFBufferStorage: NSObject {

    /*!
        保持する SFBuffer の numberOfFrames.
    */
    let numberOfFrames: Int
    var buffers = [SFBuffer]()

    init(numberOfFrames: Int) {
        self.numberOfFrames = numberOfFrames
    }

    /*!
        ストレージ内に保持する SFBuffer の数. デフォルトは 0.
        指定した数より多くなった場合は自動的に削除する.
        0 を指定した場合は, 制限を設けず pull() の呼び出しによって SFBuffer が増える.
    */
    var maxStoredBufferCount: Int = 0

    /*!
        指定した数まで SFBuffer を作成する.
        maxCount が maxStoredBufferCount よりも大きい場合は,
        maxStoredBufferCount の数まで作成する.
    */
    func populate(maxCount: Int) {
        var count: Int
        if 0 < self.maxStoredBufferCount {
            count = min(self.maxStoredBufferCount, maxCount)
        } else {
            count = maxCount
        }

        while self.buffers.count < count {
            self.buffers.append(SFBuffer(numberOfFrames: self.numberOfFrames))
        }
    }

    /*!
        保持している SFBuffer が空の場合は, 新しく SFBuffer を生成する.
    */
    func pull() -> SFBuffer {
        var buffer: SFBuffer?

        if 0 < self.buffers.count {
            buffer = self.buffers.removeLast()
        } else {
            buffer = SFBuffer(numberOfFrames: self.numberOfFrames)
        }
        return buffer!
    }

    /*!
        SFBuffer を返却する.
        保持する SFBuffer の数が maxStoredBufferCount を超えた場合は削除される.
    */
    func push(buffer: SFBuffer) {
        if maxStoredBufferCount <= 0 ||
           buffers.count < maxStoredBufferCount {
            buffers.append(buffer)
        }
    }
}
