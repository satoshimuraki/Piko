//
//  SoundUtility.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

extension Array {
    func indexOfObject<T: Equatable>(target: T) -> Int? {
        for (index, object) in enumerate(self) {
            if let obj = object as? T {
                if obj == target {
                    return index
                }
            }
        }
        return nil
    }
}

let SoundRandomInitialized = doSeedRandom()

func doSeedRandom() -> Bool {
    srandom(UInt32(time(UnsafeMutablePointer<time_t>.null())))
    return true
}
