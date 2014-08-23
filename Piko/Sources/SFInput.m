//
//  SFInput.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFInput.h"

@implementation SFInput

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self != nil) {
        _name = [name copy];
    }
    return self;
}

@end
