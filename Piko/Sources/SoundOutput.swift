//
//  SoundOutput.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SoundOutput: NSObject {
    let name: String
    weak var owner: SoundNode?
    weak var destination: SoundInput?

    class func defaultOutput(owner: SoundNode) -> SoundOutput {
        return SoundOutput(name: "result", owner: owner)
    }

    init(name: String, owner: SoundNode) {
        self.owner = owner
        self.name = name
    }
}
