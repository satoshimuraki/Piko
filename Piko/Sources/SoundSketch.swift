//
//  SoundSketch.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/13/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc protocol SoundSketchDelegate {
    func sketch(sketch: SoundSketch, didAppendNode node: SoundNode)
    func sketch(sketch: SoundSketch, didRemoveNode node: SoundNode)
}

@objc class SoundSketch: NSObject {

    let outputNode: OutputNode
    var nodes: [SoundNode]
    weak var delegate: SoundSketchDelegate?

    override init() {
        outputNode = OutputNode()
        nodes = [outputNode]
        super.init()
    }

    func appendNode(node: SoundNode) {
        nodes.append(node)
        delegate?.sketch(self, didAppendNode: node)
    }

    func removeNode(node: SoundNode) {
        let index = nodes.indexOfObject(node)
        if let i = index {
            nodes.removeAtIndex(i)
            delegate?.sketch(self, didRemoveNode: node)
        }
    }

    func connect(src: SoundOutput, to dst: SoundInput) {
        if (dst.source == src) {
            return;
        }

        if let oldSrc = dst.source {
            self.disconnectOutput(oldSrc)
        }

        if let oldDst = src.destination {
            self.disconnectOutput(src)
        }

        src.destination = dst;
        dst.source = src;
    }

    func disconnectOutput(output: SoundOutput) {
        if let input = output.destination {
            output.destination = nil
            input.source = nil
        } else {
            assert(false)
        }
    }
}
