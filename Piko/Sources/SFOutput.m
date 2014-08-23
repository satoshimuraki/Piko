//
//  SFOutput.m
//
//  Copyright (c) 2014 Satoshi Muraki. All rights reserved.
//

#import "SFOutput.h"

@implementation SFOutput

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self != nil) {
        _name = [name copy];
    }
    return self;
}

@end
