//
//  SoundNode.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SoundNode: NSObject {

    var inputs: [SoundInput]
    var outputs: [SoundOutput]
    var defaultOutput: SoundOutput?

    init(createsDefaultOutput: Bool) {
        inputs = []
        outputs = []
        super.init()
        if (createsDefaultOutput) {
            defaultOutput = SoundOutput.defaultOutput(self)
            outputs.append(defaultOutput!)
        }
    }

    func rendersConstantFrame() -> Bool {
        return false
    }

    func audioManager(player: SFPlaybackManager,
            renderFrameIndex index: UInt64,
            numberOfFrames frames: Int,
            toBuffer buffer: UnsafeMutablePointer<Double>) -> Bool {
        return false
    }
}


