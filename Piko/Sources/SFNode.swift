//
//  SFNode.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFNode: NSObject {

    var inputs: [SFInput]
    var outputs: [SFOutput]

    init(inputs: [SFInput], outputs: [SFOutput]) {
        self.inputs = inputs
        self.outputs = outputs
        super.init()
        for input in inputs {
            input.owner = self
        }
        for output in outputs {
            output.owner = self
        }
    }

    func rendersConstantFrame() -> Bool {
        return false
    }

    func renderForPlayer(player: SFPlaybackManager,
                          index: UInt64,
                          count: Int,
                      to buffer: UnsafeMutablePointer<Double>) -> Bool {
        return false
    }
}
