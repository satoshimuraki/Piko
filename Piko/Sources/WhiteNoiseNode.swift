//
//  WhiteNoiseNode.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class WhiteNoiseNode: SoundNode {

    init() {
        super.init(createsDefaultOutput: true)
        SoundRandomInitialized
    }

    override func audioManager(player: SFPlaybackManager,
            renderFrameIndex index: UInt64,
            numberOfFrames frames: Int,
            toBuffer buffer: UnsafeMutablePointer<Double>) -> Bool {

        for i in 0..<frames {
            buffer[i] = Double(random()) / Double(RAND_MAX) * 2.0 - 1.0
        }
        return true
    }
}
