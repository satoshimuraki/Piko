//
//  SFBufferOperator.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFBufferOperator: NSObject {

    let buffer: SFBuffer
    let storage: SFBufferStorage

    init(storage: SFBufferStorage) {
        self.storage = storage
        self.buffer = storage.pull()
        super.init()
    }

    deinit {
        storage.push(buffer)
    }
}
