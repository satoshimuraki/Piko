//
//  SFWhiteNoiseNode.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFWhiteNoiseNode: SFNode {

    let output: SFOutput

    init() {
        output = SFOutput(name: "output")
        super.init(inputs: [], outputs: [output])
        SoundRandomInitialized
    }

    override func renderForPlayer(player: SFPlaybackManager,
                                   index: UInt64,
                                   count: Int,
                               to buffer: UnsafeMutablePointer<Double>) -> Bool {

        for i in 0..<count {
            buffer[i] = Double(random()) / Double(RAND_MAX) * 2.0 - 1.0
        }
        return true
    }
}
