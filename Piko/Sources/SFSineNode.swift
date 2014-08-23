//
//  SFSineNode.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFSineNode: SFNode {

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
        if let fNode = frequency.source?.owner {
            if fNode.rendersConstantFrame() {
                var freq: Double = 0.0
                if player.render(fNode, index: index, count: 1, to: &freq) == false {
                    return false
                }

                let step = freq * 2.0 * M_PI / player.sampleRate;

                for i in 0..<count {
                    buffer[i] = sin(phase);
                    phase += step;
                }
            } else {
                let freqBufferOperator = player.getSFBufferOperator()
                let freqBufferData = freqBufferOperator.buffer.data

                if player.render(fNode, index: index, count: count, to: freqBufferData) == false {
                    return false
                }

                let sampleRate = player.sampleRate

                for i in 0..<count {
                    buffer[i] = sin(phase);
                    phase += freqBufferData[i] * 2.0 * M_PI / sampleRate;
                }
            }
        } else {
            return false
        }
        return true
    }
}
