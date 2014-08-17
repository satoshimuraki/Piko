//
//  SquareNode.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SquareNode: SoundNode {

    let frequency: SoundInput!

    var phase: Double = 0.0

    init() {
        super.init(createsDefaultOutput: true)
        frequency = SoundInput(name: "frequency", owner: self)
        inputs.append(frequency)
    }

    override func audioManager(player: SFPlaybackManager,
            renderFrameIndex index: UInt64,
            numberOfFrames frames: Int,
            toBuffer buffer: UnsafeMutablePointer<Double>) -> Bool {

        /* frequency: variable */
        let frequencyNode = frequency.source?.owner;

        if frequencyNode == nil {
            return false
        }

        if frequencyNode!.rendersConstantFrame() == false {
            return false
        }

        var value: Double = 0.0

        if (frequencyNode!.audioManager(player,
                renderFrameIndex: index,
                numberOfFrames: 1,
                toBuffer: &value) == false) {
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

        for i in 0..<frames {
            buffer[i] = (phase < 0.5) ? 1.0 : -1.0
            phase += step;
            while (1.0 <= phase) {
                phase -= 1.0;
            }
        }
        return true
    }
}
