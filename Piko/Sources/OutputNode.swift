//
//  OutputNode.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class OutputNode: SoundNode {

    let input: SoundInput!

    init() {
        super.init(createsDefaultOutput: false)
        input = SoundInput(name: "input", owner: self)
        inputs.append(input)
    }

    override func audioManager(player: SFPlaybackManager,
                    renderFrameIndex index: UInt64,
                    numberOfFrames frames: Int,
                    toBuffer buffer: UnsafeMutablePointer<Double>) -> Bool {
        if input.source == nil {
            for i in 0..<frames {
                buffer[i] = 0.0
            }
            return true
        }
        return input.source!.owner!.audioManager(player,
                            renderFrameIndex: index,
                            numberOfFrames: frames,
                            toBuffer: buffer)
    }
}
