//
//  SFStaticNode.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFStaticNode: SFNode {

    let output: SFOutput

    var value: Double

    init(value: Double) {
        self.value = value
        output = SFOutput(name: "output")
        super.init(inputs: [], outputs: [output])
    }

    override func rendersConstantFrame() -> Bool {
        return true
    }

    override func renderForPlayer(player: SFPlaybackManager,
                                   index: UInt64,
                                   count: Int,
                               to buffer: UnsafeMutablePointer<Double>) -> Bool {
        for i in 0..<count {
            buffer[i] = value
        }
        return true
    }
}
