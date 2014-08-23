//
//  SFSketch.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc protocol SFSketchDelegate {
    func sketch(sketch: SFSketch, didAppendNode node: SFNode)
    func sketch(sketch: SFSketch, didRemoveNode node: SFNode)
}

@objc class SFSketch: NSObject {

    let outputNode: SFOutputNode
    var nodes: [SFNode]
    weak var delegate: SFSketchDelegate?

    override init() {
        outputNode = SFOutputNode()
        nodes = [outputNode]
        super.init()
    }

    func appendNode(node: SFNode) {
        nodes.append(node)
        delegate?.sketch(self, didAppendNode: node)
    }

    func removeNode(node: SFNode) {
        let index = nodes.indexOfObject(node)
        if let i = index {
            nodes.removeAtIndex(i)
            delegate?.sketch(self, didRemoveNode: node)
        }
    }

    func connect(src: SFOutput, to dst: SFInput) {

        if let currentSrc = dst.source {
            if currentSrc == src {
                return
            } else {
                self.disconnectOutput(currentSrc)
            }
        }

        if let oldDst = src.destination {
            self.disconnectOutput(src)
        }

        src.destination = dst;
        dst.source = src;
    }

    func disconnectOutput(output: SFOutput) {
        if let input = output.destination {
            output.destination = nil
            input.source = nil
        } else {
            assert(false)
        }
    }
}
