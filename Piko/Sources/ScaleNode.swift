//
//  ScaleNode.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class ScaleNode: SoundNode {
    var input: SoundInput!
    var scale: SoundInput!

    var tempBuffer: SoundBuffer?

    var inputBuffer: SoundBuffer!
    var scaleBuffer: SoundBuffer!

    init() {
        super.init(createsDefaultOutput: true)
        input = SoundInput(name: "input", owner: self)
        self.inputs.append(input)
        scale = SoundInput(name: "scale", owner: self)
        self.inputs.append(scale)
    }

    override func rendersConstantFrame() -> Bool {
        if let iNode = input.source?.owner {
            if let sNode = scale.source?.owner {
                return iNode.rendersConstantFrame() &&
                       sNode.rendersConstantFrame()
            }
        }
        return false
    }

    override func audioManager(player: SFPlaybackManager,
            renderFrameIndex index: UInt64,
            numberOfFrames frames: Int,
            toBuffer buffer: UnsafeMutablePointer<Double>) -> Bool {

        let iNode = input.source?.owner
        if iNode == nil {
            return false
        }

        let sNode = scale.source?.owner
        if sNode == nil {
            return false
        }

//        let inputIsConstant = iNode!.rendersConstantFrame()
//        let scaleIsConstant = sNode!.rendersConstantFrame()
//
//        var sampleValue: Double = 0.0
//        var scaleValue: Double = 1.0
//
//        if inputIsConstant {
//            if iNode!.audioManager(player,
//                    renderFrameIndex: index,
//                    numberOfFrames: 1,
//                    toBuffer: &sampleValue) == false {
//                return false
//            }
//        }
//
//        if scaleIsConstant {
//            if sNode!.audioManager(player,
//                    renderFrameIndex: index,
//                    numberOfFrames: 1,
//                    toBuffer: &scaleValue) == false {
//                return false
//            }
//        }
//
//        if inputIsConstant && scaleIsConstant {
//            var value = sampleValue * scaleValue
//            for i in 0..<frames {
//                buffer[i] = value
//            }
//            return true
//        }
//
//        if inputIsConstant {
//            let scaleBuffer = player.bufferStorage.pull()
//
//            if sNode!.audioManager(player,
//                    renderFrameIndex: index,
//                    numberOfFrames: frames,
//                    toBuffer: scaleBuffer.data) == false {
//                player.bufferStorage.push(scaleBuffer)
//                return false
//            }
//
//            for i in 0..<frames {
//                buffer[i] = sampleValue * scaleBuffer.data[i]
//            }
//
//            player.bufferStorage.push(scaleBuffer)
//            return true
//        }
//
//        if scaleIsConstant {
//            let inputBuffer = player.bufferStorage.pull()
//
//            if iNode!.audioManager(player,
//                    renderFrameIndex: index,
//                    numberOfFrames: frames,
//                    toBuffer: inputBuffer.data) == false {
//                player.bufferStorage.push(inputBuffer)
//                return false
//            }
//
//            for i in 0..<frames {
//                buffer[i] = inputBuffer.data[i] * scaleValue
//            }
//
//            player.bufferStorage.push(inputBuffer)
//            return true
//        }

        if inputBuffer == nil {
            inputBuffer = player.bufferStorage.pull()
        }
        if scaleBuffer == nil {
            scaleBuffer = player.bufferStorage.pull()
        }

//        let inputBuffer = player.bufferStorage.pull()
//        let scaleBuffer = player.bufferStorage.pull()

        if input.source!.owner!.audioManager(player,
                renderFrameIndex: index,
                numberOfFrames: frames,
                toBuffer: inputBuffer.data) == false {
//            player.bufferStorage.push(inputBuffer)
//            player.bufferStorage.push(scaleBuffer)
            return false
        }

        if scale.source!.owner!.audioManager(player,
                renderFrameIndex: index,
                numberOfFrames: frames,
                toBuffer: scaleBuffer.data) == false {
//            player.bufferStorage.push(inputBuffer)
//            player.bufferStorage.push(scaleBuffer)
            return false
        }

        multiply(frames, ptr1: inputBuffer.data, ptr2: scaleBuffer.data, result: buffer)

//        for i in 0..<frames {
//            buffer[i] = 0.0//inputBuffer.data[i] * scaleBuffer.data[i]
//        }

//        player.bufferStorage.push(inputBuffer)
//        player.bufferStorage.push(scaleBuffer)
        return true
    }

    func multiply(frames: Int, ptr1: UnsafeMutablePointer<Double>, ptr2: UnsafeMutablePointer<Double>, result: UnsafeMutablePointer<Double>) {
        for i in 0..<frames {
            result[i] = ptr1[i] * ptr2[i]
        }
    }
}


