//
//  SFSquareNode.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFSquareNode: SFNode {

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
        /* frequency: variable */
        let frequencyNode = frequency.source?.owner;

        if frequencyNode == nil {
            return false
        }

        if frequencyNode!.rendersConstantFrame() == false {
            return false
        }

        var value: Double = 0.0

        if player.render(frequencyNode!, index: index, count: 1, to: &value) == false {
            return false
        }

        let step = value / player.sampleRate;

        // freq = 385.0 Hz
        // sample rate = 44100 Hz
        // 1 秒間 (44100 sample) に 385 周期
        // 1/385 秒で 1 周期
        // 44100 / 385 = 114.54545454545455
        // 44100 / (385 * 2) = 57.27272727272727
        // 0 <= x < 57 ... round(57.27272727272727)
        // 57 <= x < 115 round(114.54545454545455)
        // 115 <= x <
        // 1 周期 ... 114.54545454545455 サンプル
        // 0.00873015873016 周期 ... 1 サンプル

        for i in 0..<count {
            buffer[i] = (phase < 0.5) ? 1.0 : -1.0
            phase += step;
            while (1.0 <= phase) {
                phase -= 1.0;
            }
        }
        return true
    }
}
