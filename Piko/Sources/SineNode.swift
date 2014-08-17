//
//  SineNode.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SineNode: SoundNode {

    let frequency: SoundInput!

    var phase: Double = 0.0

    init() {
        super.init(createsDefaultOutput: true)
        frequency = SoundInput(name: "frequency", owner: self)
        self.inputs.append(frequency)
    }

    override func audioManager(player: SFPlaybackManager,
                    renderFrameIndex index: UInt64,
                    numberOfFrames frames: Int,
                    toBuffer buffer: UnsafeMutablePointer<Double>) -> Bool {

        if let fNode = frequency.source?.owner {
            if fNode.rendersConstantFrame() {
                var freq: Double = 0.0
                if fNode.audioManager(player,
                        renderFrameIndex: index,
                        numberOfFrames: 1,
                        toBuffer: &freq) == false {
                    return false
                }

                let step = freq * 2.0 * M_PI / player.sampleRate;

                for i in 0..<frames {
                    buffer[i] = sin(phase);
                    phase += step;
                }
            } else {
                let freqBuffer = player.bufferStorage.pull()

                if fNode.audioManager(player,
                        renderFrameIndex: index,
                        numberOfFrames: frames,
                        toBuffer: freqBuffer.data) == false {
                    player.bufferStorage.push(freqBuffer)
                    return false
                }

                let sampleRate = player.sampleRate

                for i in 0..<frames {
                    buffer[i] = sin(phase);
                    phase += freqBuffer.data[i] * 2.0 * M_PI / sampleRate;
                }

                player.bufferStorage.push(freqBuffer)
            }
        } else {
            return false
        }
        return true
    }
}
