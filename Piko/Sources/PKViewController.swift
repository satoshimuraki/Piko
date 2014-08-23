//
//  PKViewController.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import UIKit

class PKViewController: UIViewController {

    var player: SFPlaybackManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.viewWithTag(1)?.alpha = 0.0
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupAudio()
    }

    func setupAudio() {

        player = SFPlaybackManager.sharedManager()
        if player?.activate() == false {
            println("error: couldn't activate playback manager.")
            return;
        }

        let sketch = makeMarioSketch()
//        let sketch = makeNoiseSketch()
//        let sketch = makeSineSketch()

        player!.sketch = sketch;
//        self.sketchView.sketch = sketch;

//        [self beginObservingPlaybackManager];

//        self.didSetupAudio = YES;

        player!.start()
    }

    func makeMarioSketch() -> SFSketch {

        let sketch = SFSketch()

        let bps: Array<AnyObject> = [
            SFBreakpoint(time: 875.0 * 0.0 / 44100.0, value: 1.0),
            SFBreakpoint(time: 875.0 * 7.0 / 44100.0, value: 1.0),

            SFBreakpoint(time: 875.0 * 7.0 / 44100.0, value: 0.0),
            SFBreakpoint(time: 875.0 * 8.0 / 44100.0, value: 0.0),

            SFBreakpoint(time: 875.0 *  8.0 / 44100.0, value: 1.0),
            SFBreakpoint(time: 875.0 * 15.0 / 44100.0, value: 1.0),

            SFBreakpoint(time: 875.0 * 15.0 / 44100.0, value: 0.0),
            SFBreakpoint(time: 875.0 * 24.0 / 44100.0, value: 0.0),

            SFBreakpoint(time: 875.0 * 24.0 / 44100.0, value: 1.0),
            SFBreakpoint(time: 875.0 * 31.0 / 44100.0, value: 1.0),

            SFBreakpoint(time: 875.0 * 31.0 / 44100.0, value: 0.0),
            SFBreakpoint(time: DBL_MAX, value: 0.0)
        ]

        let triangleScaleNode = SFScaleNode()
        sketch.appendNode(triangleScaleNode)

        let triangleScaleInputNode = SFBreakpointNode(breakpoints: bps)
        sketch.appendNode(triangleScaleInputNode)

        let triangleNode = SFTriangleNode()
        sketch.appendNode(triangleNode)

        let triangleFrequencyNode = SFStaticNode(value: 659.26)
        sketch.appendNode(triangleFrequencyNode)

        sketch.connect(triangleScaleInputNode.output, to: triangleScaleNode.scale)
        sketch.connect(triangleFrequencyNode.output, to: triangleNode.frequency)
        sketch.connect(triangleNode.output, to: triangleScaleNode.input)

        // Square
        let squareScaleNode = SFScaleNode()
        sketch.appendNode(squareScaleNode)

        let squareScaleInputNode = SFBreakpointNode(breakpoints: bps)
        sketch.appendNode(squareScaleInputNode)

        let squareNode = SFSquareNode()
        sketch.appendNode(squareNode)

        let squareFrequencyNode = SFStaticNode(value: 659.26)
        sketch.appendNode(squareFrequencyNode)

        sketch.connect(squareScaleInputNode.output, to: squareScaleNode.scale)
        sketch.connect(squareFrequencyNode.output, to: squareNode.frequency)
        sketch.connect(squareNode.output, to: squareScaleNode.input)

        // White Noise
        let wnbp: Array<AnyObject> = [
            SFBreakpoint(time: 875.0 * 0.0 / 44100.0, value: 1.0),
            SFBreakpoint(time: 875.0 * 5.0 / 44100.0, value: 1.0),

            SFBreakpoint(time: 875.0 * 5.0 / 44100.0, value: 0.0),
            SFBreakpoint(time: 875.0 * 8.0 / 44100.0, value: 0.0),

            SFBreakpoint(time: 875.0 *  8.0 / 44100.0, value: 1.0),
            SFBreakpoint(time: 875.0 * 13.0 / 44100.0, value: 1.0),

            SFBreakpoint(time: 875.0 * 13.0 / 44100.0, value: 0.0),
            SFBreakpoint(time: 875.0 * 24.0 / 44100.0, value: 0.0),

            SFBreakpoint(time: 875.0 * 24.0 / 44100.0, value: 1.0),
            SFBreakpoint(time: 875.0 * 29.0 / 44100.0, value: 1.0),

            SFBreakpoint(time: 875.0 * 29.0 / 44100.0, value: 0.0),
            SFBreakpoint(time: DBL_MAX, value: 0.0),
        ]

        let wnSFBreakpointNode = SFBreakpointNode(breakpoints: wnbp)
        sketch.appendNode(wnSFBreakpointNode)

        let wnNode = SFWhiteNoiseNode()
        sketch.appendNode(wnNode)

        let wnScaleNode = SFScaleNode()
        sketch.appendNode(wnScaleNode)

        sketch.connect(wnNode.output, to: wnScaleNode.input)
        sketch.connect(wnSFBreakpointNode.output, to: wnScaleNode.scale)

        // Mixer
        let mixerNode = SFMixerNode()
        sketch.appendNode(mixerNode)

        sketch.connect(triangleScaleNode.output, to: mixerNode.input1)
        sketch.connect(squareScaleNode.output, to: mixerNode.input2)
        sketch.connect(wnScaleNode.output, to: mixerNode.input3)

        sketch.connect(mixerNode.output, to: sketch.outputNode.input)

        return sketch
    }

    func makeSineSketch() -> SFSketch {

        let sketch = SFSketch()

        // Sine < Sketch
        let sineNode = SFSineNode()

        sketch.appendNode(sineNode)
        sketch.connect(sineNode.output, to: sketch.outputNode.input)

        // Freq < Sine < Sketch
        let freqNode = SFStaticNode(value: 440.0)

        sketch.appendNode(freqNode)
        sketch.connect(freqNode.output, to: sineNode.frequency)

        return sketch;
    }

    func makeNoiseSketch() -> SFSketch {

        let sketch = SFSketch()

        // Noise < Sketch
        let noiseNode = SFWhiteNoiseNode()

        sketch.appendNode(noiseNode)
        sketch.connect(noiseNode.output, to: sketch.outputNode.input)

        return sketch;
    }
}

