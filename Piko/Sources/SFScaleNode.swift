//
//  SFScaleNode.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFScaleNode: SFNode {

    var input: SFInput
    var scale: SFInput
    var output: SFOutput

    init() {
        input = SFInput(name: "input")
        scale = SFInput(name: "scale")
        output = SFOutput(name: "output")
        super.init(inputs: [input, scale], outputs: [output])
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

    override func renderForPlayer(player: SFPlaybackManager,
                                   index: UInt64,
                                   count: Int,
                               to buffer: UnsafeMutablePointer<Double>) -> Bool {
        let iNode = input.source?.owner
        if iNode == nil {
            return false
        }

        let sNode = scale.source?.owner
        if sNode == nil {
            return false
        }

        let inputIsConstant = iNode!.rendersConstantFrame()
        let scaleIsConstant = sNode!.rendersConstantFrame()

        var sampleValue: Double = 0.0
        var scaleValue: Double = 1.0

        if inputIsConstant {
            if player.render(iNode!, index: index, count: 1, to: &sampleValue) == false {
                return false
            }
        }

        if scaleIsConstant {
            if player.render(sNode!, index: index, count: 1, to: &scaleValue) == false {
                return false
            }
        }

        if inputIsConstant && scaleIsConstant {
            var value = sampleValue * scaleValue
            for i in 0..<count {
                buffer[i] = value
            }
            return true
        }

        if inputIsConstant {
            let scaleBufferOperator = player.getSFBufferOperator()
            let scaleBufferData = scaleBufferOperator.buffer.data

            if player.render(sNode!, index: index, count: count, to: scaleBufferData) == false {
                return false
            }
            for i in 0..<count {
                buffer[i] = sampleValue * scaleBufferData[i]
            }
            return true
        }

        if scaleIsConstant {
            let inputBufferOperator = player.getSFBufferOperator()
            let inputBufferData = inputBufferOperator.buffer.data

            if player.render(iNode!, index: index, count: count, to: inputBufferData) == false {
                return false
            }
            for i in 0..<count {
                buffer[i] = scaleValue * inputBufferData[i]
            }
            return true
        }

        let inputBufferOperator = player.getSFBufferOperator()
        let inputBufferData = inputBufferOperator.buffer.data

        if player.render(input.source!.owner!, index: index, count: count, to: inputBufferData) == false {
            return false
        }

        let scaleBufferOperator = player.getSFBufferOperator()
        let scaleBufferData = scaleBufferOperator.buffer.data

        if player.render(scale.source!.owner!, index: index, count: count, to: scaleBufferData) == false {
            return false
        }
        for i in 0..<count {
            buffer[i] = inputBufferData[i] * scaleBufferData[i]
        }
        return true
    }
}
