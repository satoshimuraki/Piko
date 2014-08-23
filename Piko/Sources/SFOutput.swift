//
//  SFOutput.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFOutput: NSObject {
    let name: String
    weak var owner: SFNode?
    weak var destination: SFInput?

    init(name: String) {
        self.name = name
    }
}
