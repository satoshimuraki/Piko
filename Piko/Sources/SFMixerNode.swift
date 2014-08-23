//
//  SFMixerNode.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFMixerNode: SFNode {

    let input1: SFInput
    let input2: SFInput
    let input3: SFInput
    let input4: SFInput
    let output: SFOutput

    init() {
        input1 = SFInput(name: "1")
        input2 = SFInput(name: "2")
        input3 = SFInput(name: "3")
        input4 = SFInput(name: "4")
        output = SFOutput(name: "output")
        super.init(inputs: [input1, input2, input3, input4], outputs: [output])
    }

    override func renderForPlayer(player: SFPlaybackManager,
                                   index: UInt64,
                                   count: Int,
                               to buffer: UnsafeMutablePointer<Double>) -> Bool {

        var didRender: Bool = false
        var tempBufferOperator: SFBufferOperator?

        for input in inputs {
            if input.source == nil {
                continue
            }

            let node = input.source!.owner!

            if node.rendersConstantFrame() {
                var sample: Double = 0.0
                if node.renderForPlayer(player, index: index, count: 1, to: &sample) == false {
                    return false
                }
                if didRender {
                    for i in 0..<count {
                        buffer[i] += sample
                    }
                } else {
                    for i in 0..<count {
                        buffer[i] = sample
                    }
                }
            } else {
                if didRender {
                    if tempBufferOperator == nil {
                        tempBufferOperator = player.getSFBufferOperator()
                    }
                    let tempBufferData = tempBufferOperator!.buffer.data

                    if node.renderForPlayer(player, index: index, count: count, to: tempBufferData) == false {
                        return false
                    }
                    for i in 0..<count {
                        buffer[i] += tempBufferData[i]
                    }
                } else {
                    if node.renderForPlayer(player, index: index, count: count, to: buffer) == false {
                        return false
                    }
                }
            }
            didRender = true
        }
        return didRender
    }
}
