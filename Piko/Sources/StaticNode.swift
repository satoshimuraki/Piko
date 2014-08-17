//
//  StaticNode.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class StaticNode: SoundNode {

    var value: Double

    init(value: Double) {
        self.value = value
        super.init(createsDefaultOutput: true)
    }

    override func rendersConstantFrame() -> Bool {
        return true
    }

    override func audioManager(player: SFPlaybackManager,
                    renderFrameIndex index: UInt64,
                    numberOfFrames frames: Int,
                    toBuffer buffer: UnsafeMutablePointer<Double>) -> Bool {
        for i in 0..<frames {
            buffer[i] = value
        }
        return true
    }
}
