//
//  MixerNode.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class MixerNode: SoundNode {
    let input1: SoundInput!
    let input2: SoundInput!
    let input3: SoundInput!
    let input4: SoundInput!

    var reusableBuffer: SoundBuffer?

    init() {
        super.init(createsDefaultOutput: true)
        input1 = SoundInput(name: "1", owner: self)
        self.inputs.append(input1)
        input2 = SoundInput(name: "2", owner: self)
        self.inputs.append(input2)
        input3 = SoundInput(name: "3", owner: self)
        self.inputs.append(input3)
        input4 = SoundInput(name: "4", owner: self)
        self.inputs.append(input4)
    }

    override func audioManager(player: SFPlaybackManager,
            renderFrameIndex index: UInt64,
            numberOfFrames frames: Int,
            toBuffer buffer: UnsafeMutablePointer<Double>) -> Bool {

        var didRender: Bool = false

        if reusableBuffer != nil {
            if reusableBuffer!.numberOfFrames < frames {
                reusableBuffer = nil
            }
        }
        if reusableBuffer == nil {
            reusableBuffer = SoundBuffer(numberOfFrames: frames)
        }

        for input in inputs {
            if input.source == nil {
                continue
            }

            if input.source!.owner!.rendersConstantFrame() {
                var sample: Double = 0.0
                if input.source!.owner!.audioManager(player,
                        renderFrameIndex: index,
                        numberOfFrames: 1,
                        toBuffer: &sample) == false {
                    return false
                }
                if didRender {
                    for i in 0..<frames {
                        buffer[i] += sample
                    }
                } else {
                    for i in 0..<frames {
                        buffer[i] = sample
                    }
                }
            } else {
                if didRender {
//                    var temp = player.bufferStorage.pull()

                    if input.source!.owner!.audioManager(player,
                            renderFrameIndex: index,
                            numberOfFrames: frames,
                            toBuffer: reusableBuffer!.data) == false {
//                        player.bufferStorage.push(temp)
                        return false
                    }

                    incrementBuffer(frames, src: reusableBuffer!.data, dst: buffer)
//                    for i in 0..<frames {
//                        buffer[i] += reusableBuffer!.data[i]
//                    }

//                    player.bufferStorage.push(temp)
                } else {
                    if input.source!.owner!.audioManager(player,
                            renderFrameIndex: index,
                            numberOfFrames: frames,
                            toBuffer: buffer) == false {
                        return false
                    }
                }
            }
            didRender = true
        }
        return didRender
    }

    func incrementBuffer(frames: Int, src: UnsafeMutablePointer<Double>, dst: UnsafeMutablePointer<Double>) {
        for i in 0..<frames {
            dst[i] += src[i]
        }
    }
}
