//
//  SFBuffer.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFBuffer: NSObject {

    let numberOfFrames: Int
    let data: UnsafeMutablePointer<Double>

    init(numberOfFrames: Int) {
        self.numberOfFrames = numberOfFrames
        data = UnsafeMutablePointer<Double>.alloc(numberOfFrames)
    }

    deinit {
        data.dealloc(numberOfFrames)
    }
}
