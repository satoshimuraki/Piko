//
//  SFInput.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

@objc class SFInput: NSObject {
    let name: String
    weak var owner: SFNode?
    weak var source: SFOutput?

    init(name: String) {
        self.name = name
    }
}
