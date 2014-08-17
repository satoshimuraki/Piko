//
//  TriangleNode.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class TriangleNode: SoundNode {

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

        let frequencyNode = frequency.source?.owner

        if frequencyNode == nil {
            return false
        }

        if frequencyNode!.rendersConstantFrame() == false {
            return false
        }

        var freq: Double = 0.0

        if frequencyNode?.audioManager(player,
                renderFrameIndex: index,
                numberOfFrames: 1,
                toBuffer: &freq) == false {
            return false
        }

        let step = freq / player.sampleRate

        for i in 0..<frames {
            buffer[i] = (phase < 0.25) ? phase * 4.0 :
                        (phase < 0.75) ? (0.50 - phase) * 4.0 :
                                         (phase - 1.0) * 4.0
            while 1.0 <= phase {
                phase -= 1.0
            }
        }
        return true
    }
}
