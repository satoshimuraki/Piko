//
//  SFTriangleNode.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFTriangleNode: SFNode {

    let frequency: SFInput
    let output: SFOutput

    var phase: Double = 0.0

    init() {
        frequency = SFInput(name: "frequency")
        output = SFOutput(name: "output")
        super.init(inputs: [frequency], outputs: [output])
    }

    override func renderForPlayer(player: SFPlaybackManager,
                                   index: UInt64,
                                   count: Int,
                               to buffer: UnsafeMutablePointer<Double>) -> Bool {

        let frequencyNode = frequency.source?.owner!

        if frequencyNode == nil {
            return false
        }

        if frequencyNode!.rendersConstantFrame() == false {
            return false
        }

        var freq: Double = 0.0

        if player.render(frequencyNode, index: index, count: 1, to: &freq) == false {
            return false
        }

        let step = freq / player.sampleRate

        for i in 0..<count {
            buffer[i] = (phase < 0.25) ? phase * 4.0 :
                        (phase < 0.75) ? (0.50 - phase) * 4.0 :
                                         (phase - 1.0) * 4.0
            phase += step;
            while 1.0 <= phase {
                phase -= 1.0
            }
        }
        return true
    }
}
