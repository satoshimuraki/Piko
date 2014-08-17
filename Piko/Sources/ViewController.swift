//
//  ViewController.swift
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var player: SFPlaybackManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        setupAudio()
    }

    func setupAudio() {

        player = SFPlaybackManager.sharedManager()
        if player?.activate() == false {
            println("error: couldn't activate playback manager.")
            return;
        }

//        let sketch = makeTestSketch()
        let sketch = makeMarioSketch()

        player!.sketch = sketch;
//        self.sketchView.sketch = sketch;

//        [self beginObservingPlaybackManager];

//        self.didSetupAudio = YES;

        player!.start()
    }

    func makeTestSketch() -> SoundSketch {

        let sketch = SoundSketch()

        let sineNode = SineNode()
        sketch.appendNode(sineNode)

        let freqNode = StaticNode(value: 440.0)
        sketch.appendNode(freqNode)

        sketch.connect(freqNode.defaultOutput!, to: sineNode.frequency)

        let bp = [
            SoundBreakpoint(time: 875.0 * 0.0 / 44100.0, value: 1.0),
            SoundBreakpoint(time: 875.0 * 7.0 / 44100.0, value: 1.0),

            SoundBreakpoint(time: 875.0 * 7.0 / 44100.0, value: 0.0),
            SoundBreakpoint(time: 875.0 * 8.0 / 44100.0, value: 0.0),

            SoundBreakpoint(time: 875.0 *  8.0 / 44100.0, value: 1.0),
            SoundBreakpoint(time: 875.0 * 15.0 / 44100.0, value: 1.0),

            SoundBreakpoint(time: 875.0 * 15.0 / 44100.0, value: 0.0),
            SoundBreakpoint(time: 875.0 * 24.0 / 44100.0, value: 0.0),

            SoundBreakpoint(time: 875.0 * 24.0 / 44100.0, value: 1.0),
            SoundBreakpoint(time: 875.0 * 31.0 / 44100.0, value: 1.0),

            SoundBreakpoint(time: 875.0 * 31.0 / 44100.0, value: 0.0),
            SoundBreakpoint(time: SoundTime.infinity, value: 0.0),
        ]

        let sineScaleBpNode = BreakpointNode(breakpoints: bp)
//        let sineScaleBpNode = StaticNode(value: 0.5)
        sketch.appendNode(sineScaleBpNode)

        let sineScaleNode = ScaleNode()
        sketch.appendNode(sineScaleNode)

        sketch.connect(sineNode.defaultOutput!, to: sineScaleNode.input)
        sketch.connect(sineScaleBpNode.defaultOutput!, to: sineScaleNode.scale)

        sketch.connect(sineScaleNode.defaultOutput!, to: sketch.outputNode.input)

        return sketch
    }

    func makeMarioSketch() -> SoundSketch {

        let sketch = SoundSketch()

        let bp = [
            SoundBreakpoint(time: 875.0 * 0.0 / 44100.0, value: 1.0),
            SoundBreakpoint(time: 875.0 * 7.0 / 44100.0, value: 1.0),

            SoundBreakpoint(time: 875.0 * 7.0 / 44100.0, value: 0.0),
            SoundBreakpoint(time: 875.0 * 8.0 / 44100.0, value: 0.0),

            SoundBreakpoint(time: 875.0 *  8.0 / 44100.0, value: 1.0),
            SoundBreakpoint(time: 875.0 * 15.0 / 44100.0, value: 1.0),

            SoundBreakpoint(time: 875.0 * 15.0 / 44100.0, value: 0.0),
            SoundBreakpoint(time: 875.0 * 24.0 / 44100.0, value: 0.0),

            SoundBreakpoint(time: 875.0 * 24.0 / 44100.0, value: 1.0),
            SoundBreakpoint(time: 875.0 * 31.0 / 44100.0, value: 1.0),

            SoundBreakpoint(time: 875.0 * 31.0 / 44100.0, value: 0.0),
            SoundBreakpoint(time: SoundTime.infinity, value: 0.0),
        ]

        let triangleScaleNode = ScaleNode()
        sketch.appendNode(triangleScaleNode)

        let triangleScaleInputNode = BreakpointNode(breakpoints: bp)
        sketch.appendNode(triangleScaleInputNode)

        let triangleNode = TriangleNode()
        sketch.appendNode(triangleNode)

        let triangleFrequencyNode = StaticNode(value: 659.26)
        sketch.appendNode(triangleFrequencyNode)

        sketch.connect(triangleScaleInputNode.defaultOutput!, to: triangleScaleNode.scale)
        sketch.connect(triangleFrequencyNode.defaultOutput!, to: triangleNode.frequency)
        sketch.connect(triangleNode.defaultOutput!, to: triangleScaleNode.input)

        // Square
        let squareScaleNode = ScaleNode()
        sketch.appendNode(squareScaleNode)

        let squareScaleInputNode = BreakpointNode(breakpoints: bp)
        sketch.appendNode(squareScaleInputNode)

        let squareNode = SquareNode()
        sketch.appendNode(squareNode)

        let squareFrequencyNode = StaticNode(value: 659.26)
        sketch.appendNode(squareFrequencyNode)

        sketch.connect(squareScaleInputNode.defaultOutput!, to: squareScaleNode.scale)
        sketch.connect(squareFrequencyNode.defaultOutput!, to: squareNode.frequency)
        sketch.connect(squareNode.defaultOutput!, to: squareScaleNode.input)

        // White Noise
        let wnbp = [
            SoundBreakpoint(time: 875.0 * 0.0 / 44100.0, value: 1.0),
            SoundBreakpoint(time: 875.0 * 5.0 / 44100.0, value: 1.0),

            SoundBreakpoint(time: 875.0 * 5.0 / 44100.0, value: 0.0),
            SoundBreakpoint(time: 875.0 * 8.0 / 44100.0, value: 0.0),

            SoundBreakpoint(time: 875.0 *  8.0 / 44100.0, value: 1.0),
            SoundBreakpoint(time: 875.0 * 13.0 / 44100.0, value: 1.0),

            SoundBreakpoint(time: 875.0 * 13.0 / 44100.0, value: 0.0),
            SoundBreakpoint(time: 875.0 * 24.0 / 44100.0, value: 0.0),

            SoundBreakpoint(time: 875.0 * 24.0 / 44100.0, value: 1.0),
            SoundBreakpoint(time: 875.0 * 29.0 / 44100.0, value: 1.0),

            SoundBreakpoint(time: 875.0 * 29.0 / 44100.0, value: 0.0),
            SoundBreakpoint(time: SoundTime.infinity, value: 0.0),
        ]

        let wnBreakpointNode = BreakpointNode(breakpoints: wnbp)
        sketch.appendNode(wnBreakpointNode)

        let wnNode = WhiteNoiseNode()
        sketch.appendNode(wnNode)

        let wnScaleNode = ScaleNode()
        sketch.appendNode(wnScaleNode)

        sketch.connect(wnNode.defaultOutput!, to: wnScaleNode.input)
        sketch.connect(wnBreakpointNode.defaultOutput!, to: wnScaleNode.scale)

        // Mixer
        let mixerNode = MixerNode()
        sketch.appendNode(mixerNode)

        sketch.connect(triangleScaleNode.defaultOutput!, to: mixerNode.input1)
        sketch.connect(squareScaleNode.defaultOutput!, to: mixerNode.input2)
        sketch.connect(wnScaleNode.defaultOutput!, to: mixerNode.input3)

        sketch.connect(mixerNode.defaultOutput!, to: sketch.outputNode.input)

        return sketch
    }

    func makeSineSketch() -> SoundSketch {

        let sketch = SoundSketch()

        // Sine < Sketch
        let sineNode = SineNode()

        sketch.appendNode(sineNode)
        sketch.connect(sineNode.defaultOutput!, to: sketch.outputNode.input)

        // Freq < Sine < Sketch
        let freqNode = StaticNode(value: 440.0)

        sketch.appendNode(freqNode)
        sketch.connect(freqNode.defaultOutput!, to: sineNode.frequency)

        return sketch;
    }

    func makeNoiseSketch() -> SoundSketch {

        let sketch = SoundSketch()

        // Noise < Sketch
        let noiseNode = WhiteNoiseNode()

        sketch.appendNode(noiseNode)
        sketch.connect(noiseNode.defaultOutput!, to: sketch.outputNode.input)

        return sketch;
    }
}

