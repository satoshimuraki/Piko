//
//  SFBreakpointNode.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import Foundation

typealias SoundTime = Double

struct SoundBreakpoint {
    var time: SoundTime
    var value: Double
}

@objc class SFBreakpointNode: SFNode {

    let output: SFOutput

    let bpCount: Int
    let bpPtr: UnsafeMutablePointer<SoundBreakpoint>!

    init(breakpoints: [AnyObject]) {
        var bps = breakpoints
        var bp: SFBreakpoint?

        if bps.count == 0 {
            bps.append(SFBreakpoint(time: 0.0, value: 0.0))
            bps.append(SFBreakpoint(time: SoundTime.infinity, value: 0.0))
        } else {

            bp = bps[0] as? SFBreakpoint
            var prevTime: SoundTime = bp!.time
            for i in 1..<bps.count {
                bp = bps[i] as? SFBreakpoint
                let nextTime = bp!.time
                if nextTime < prevTime {
                    println("error: invalid time: \(nextTime)")
                    bps[i] = SFBreakpoint(time: prevTime, value: bp!.value)
                } else {
                    prevTime = nextTime
                }
            }

            bp = bps[0] as? SFBreakpoint
            if bp!.time != 0.0 {
                bps.insert(SFBreakpoint(time: 0.0, value: bp!.value), atIndex: 0)
            }
            if let last = bps.last as? SFBreakpoint {
                if last.time != SoundTime.infinity {
                    bps.append(SFBreakpoint(time: SoundTime.infinity, value: last.value))
                }
            }
        }

        bpCount = bps.count
        bpPtr = UnsafeMutablePointer<SoundBreakpoint>.alloc(bpCount)
        for i in 0..<bpCount {
            bp = bps[i] as? SFBreakpoint
            bpPtr[i] = SoundBreakpoint(time: bp!.time, value: bp!.value)
        }

        output = SFOutput(name: "output")
        super.init(inputs: [], outputs: [output])
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

    override func renderForPlayer(player: SFPlaybackManager,
                                   index: UInt64,
                                   count: Int,
                               to buffer: UnsafeMutablePointer<Double>) -> Bool {

        let sampleRate = SoundTime(player.sampleRate)
        let baseTime = SoundTime(index) / sampleRate
        var time = baseTime
        var bi = getBreakpointIndexForTime(time, hint: nil)
        var hint = bi

        for i in 0..<count {
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
