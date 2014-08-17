//
//  BreakpointNode.swift
//  Piko
//
//  Created by Satoshi Muraki on 8/14/14.
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

typealias SoundTime = Double

struct SoundBreakpoint {
    var time: SoundTime
    var value: Double
}

@objc class BreakpointNode: SoundNode {

    let bpCount: Int
    let bpPtr: UnsafeMutablePointer<SoundBreakpoint>

    init(breakpoints: [SoundBreakpoint]) {
        var bp = breakpoints
        if bp.count == 0 {
            bp.append(SoundBreakpoint(time: 0.0, value: 0.0))
            bp.append(SoundBreakpoint(time: SoundTime.infinity, value: 0.0))
        } else {

            var prevTime: SoundTime = bp[0].time
            for i in 1..<bp.count {
                let nextTime = bp[i].time
                if nextTime < prevTime {
                    println("error: invalid time: \(nextTime)")
                    bp[i].time = prevTime
                } else {
                    prevTime = nextTime
                }
            }

            if bp[0].time != 0.0 {
                bp.insert(SoundBreakpoint(time: 0.0, value: bp[0].value), atIndex: 0)
            }
            if let last = bp.last {
                if last.time != SoundTime.infinity {
                    bp.append(SoundBreakpoint(time: SoundTime.infinity, value: last.value))
                }
            }
        }

        bpCount = bp.count
        bpPtr = UnsafeMutablePointer<SoundBreakpoint>.alloc(bpCount)
        for i in 0..<bpCount {
            bpPtr[i] = bp[i]
        }
        super.init(createsDefaultOutput: true)
    }

    deinit {
        bpPtr.dealloc(bpCount)
    }

    func getBreakpointIndexForTime(time: SoundTime, hint: Int?) -> Int {
        var i: Int
        var min: Int = 0
        var max: Int = bpCount - 2

        if hint != nil {
            i = hint!
        } else {
            i = (min + max) / 2;
        }

        while (true) {
            if (time < bpPtr[i].time) {
                max = i - 1;
            } else if (bpPtr[i+1].time < time) {
                min = i + 1;
            } else {
                return i
            }
            i = (min + max) / 2;
        }
    }

    override func audioManager(player: SFPlaybackManager,
            renderFrameIndex index: UInt64,
            numberOfFrames frames: Int,
            toBuffer buffer: UnsafeMutablePointer<Double>) -> Bool {

        let sampleRate = SoundTime(player.sampleRate)
        let baseTime = SoundTime(index) / sampleRate
        var time = baseTime
        var bi = getBreakpointIndexForTime(time, hint: nil)
        var hint = bi

        for i in 0..<frames {
            if (time < bpPtr[bi].time || bpPtr[bi+1].time < time) {
                bi = getBreakpointIndexForTime(time, hint: hint)
                hint = bi;
            }

            let position = (time - bpPtr[bi].time) /
                           (bpPtr[bi+1].time - bpPtr[bi].time)
            let value = bpPtr[bi].value +
                        (bpPtr[bi+1].value - bpPtr[bi].value) * position
            buffer[i] = value;

            time = baseTime + (SoundTime(i + 1) / sampleRate)
        }

        return true
    }
}
