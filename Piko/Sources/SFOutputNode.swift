//
//  SFOutputNode.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFOutputNode: SFNode {

    let input: SFInput
    let output: SFOutput

    init() {
        input = SFInput(name: "input")
        output = SFOutput(name: "output")
        super.init(inputs: [input], outputs: [output])
    }

    override func renderForPlayer(player: SFPlaybackManager,
                                   index: UInt64,
                                   count: Int,
                               to buffer: UnsafeMutablePointer<Double>) -> Bool {
        if let node = input.source?.owner! {
            return player.render(node, index: index, count: count, to: buffer)
        } else {
            for i in 0..<count {
                buffer[i] = 0.0
            }
            return true
        }
    }
}
