//
//  SFBreakpoint.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFBreakpoint: NSObject {

    let time: Double
    let value: Double

    init(time: Double, value: Double) {
        self.time = time
        self.value = value
        super.init()
    }
}
