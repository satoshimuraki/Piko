//
//  PKViewController.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "PKViewController.h"

#import "SFPlaybackManager.h"
#import "SFSketch.h"

// Node
#import "SFBreakpoint.h"
#import "SFBreakpointNode.h"
#import "SFMixerNode.h"
#import "SFScaleNode.h"
#import "SFSquareNode.h"
#import "SFStaticNode.h"
#import "SFTriangleNode.h"
#import "SFWhiteNoiseNode.h"

@interface PKViewController ()

@property (nonatomic, strong) SFPlaybackManager *player;
@property (nonatomic, strong) SFSketch *sketch;

@end

@implementation PKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view viewWithTag:1].alpha = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupAudio];
}

- (void)setupAudio
{
    _player = [SFPlaybackManager sharedManager];
    if (![_player activate]) {
        NSLog(@"error: couldn't activate playback manager.");
        return;
    }

    SFSketch *sketch = [self makeMarioSketch];

    _player.sketch = sketch;
//        self.sketchView.sketch = sketch;

//        [self beginObservingPlaybackManager];

//        self.didSetupAudio = YES;

    [_player start];
}

- (SFSketch *)makeMarioSketch
{
    SFSketch *sketch;

    sketch = [[SFSketch alloc] init];

    NSArray *bps = @[
        [[SFBreakpoint alloc] initWithTime:875.0 * 0.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 7.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 7.0 / 44100.0 value:0.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 8.0 / 44100.0 value:0.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 8.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 15.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 15.0 / 44100.0 value:0.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 24.0 / 44100.0 value:0.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 24.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 31.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 31.0 / 44100.0 value:0.0],
        [[SFBreakpoint alloc] initWithTime:DBL_MAX value:0.0]
    ];

    SFScaleNode *triangleScaleNode = [[SFScaleNode alloc] init];
    [sketch appendNode:triangleScaleNode];

    SFBreakpointNode *triangleScaleInputNode = [[SFBreakpointNode alloc] initWithBreakpoints:bps];
    [sketch appendNode:triangleScaleInputNode];

    SFTriangleNode *triangleNode = [[SFTriangleNode alloc] init];
    [sketch appendNode:triangleNode];

    SFStaticNode *triangleFrequencyNode = [[SFStaticNode alloc] initWithValue:659.26];
    [sketch appendNode:triangleFrequencyNode];

    [sketch connect:triangleScaleInputNode.output to:triangleScaleNode.scale];
    [sketch connect:triangleFrequencyNode.output to:triangleNode.frequency];
    [sketch connect:triangleNode.output to:triangleScaleNode.input];

    // Square
    SFScaleNode *squareScaleNode = [[SFScaleNode alloc] init];
    [sketch appendNode:squareScaleNode];

    SFBreakpointNode *squareScaleInputNode = [[SFBreakpointNode alloc] initWithBreakpoints:bps];
    [sketch appendNode:squareScaleInputNode];

    SFSquareNode *squareNode = [[SFSquareNode alloc] init];
    [sketch appendNode:squareNode];

    SFStaticNode *squareFrequencyNode = [[SFStaticNode alloc] initWithValue:659.26];
    [sketch appendNode:squareFrequencyNode];

    [sketch connect:squareScaleInputNode.output to:squareScaleNode.scale];
    [sketch connect:squareFrequencyNode.output to:squareNode.frequency];
    [sketch connect:squareNode.output to:squareScaleNode.input];

    // White Noise
    NSArray *wnbps = @[
        [[SFBreakpoint alloc] initWithTime:875.0 * 0.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 5.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 5.0 / 44100.0 value:0.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 8.0 / 44100.0 value:0.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 8.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 13.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 13.0 / 44100.0 value:0.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 24.0 / 44100.0 value:0.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 24.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 29.0 / 44100.0 value:1.0],
        [[SFBreakpoint alloc] initWithTime:875.0 * 29.0 / 44100.0 value:0.0],
        [[SFBreakpoint alloc] initWithTime:DBL_MAX value:0.0]
    ];

    SFBreakpointNode *wnSFBreakpointNode = [[SFBreakpointNode alloc] initWithBreakpoints:wnbps];
    [sketch appendNode:wnSFBreakpointNode];

    SFWhiteNoiseNode *wnNode = [[SFWhiteNoiseNode alloc] init];
    [sketch appendNode:wnNode];

    SFScaleNode *wnScaleNode = [[SFScaleNode alloc] init];
    [sketch appendNode:wnScaleNode];

    [sketch connect:wnNode.output to:wnScaleNode.input];
    [sketch connect:wnSFBreakpointNode.output to:wnScaleNode.scale];

    // Mixer
    SFMixerNode *mixerNode = [[SFMixerNode alloc] init];
    [sketch appendNode:mixerNode];

    [sketch connect:triangleScaleNode.output to:mixerNode.input1];
    [sketch connect:squareScaleNode.output to:mixerNode.input2];
    [sketch connect:wnScaleNode.output to:mixerNode.input3];

    [sketch connect:mixerNode.output to:sketch.outputNode.input];

    return sketch;
}

- (SFSketch *)makeNoiseSketch
{
    SFSketch *sketch = [[SFSketch alloc] init];

    // Noise < Sketch
    SFWhiteNoiseNode *noiseNode = [[SFWhiteNoiseNode alloc] init];

    [sketch appendNode:noiseNode];
    [sketch connect:noiseNode.output to:sketch.outputNode.input];

    return sketch;
}

@end
