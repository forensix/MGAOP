// -----------------------------------------------------------------------------
//  SimpleSampleClass.m
//  AOPSamples
//
//  Created by Manuel Gebele on 25.04.11.
//  Copyright 2011 TDSoftware GmbH. All rights reserved.
// -----------------------------------------------------------------------------

#import "SimpleSampleClass.h"

@implementation SimpleSampleClass

- (id)initWithString:(NSString *)string
{
    NSLog(@"%@:%@%@", CLASS, SELECT(_cmd), string);
    return [super init];
}


- (id)initWithNumber:(NSNumber *)number
{
    NSLog(@"%@:%@%@", CLASS, SELECT(_cmd), number);
    return [super init];
}


@end
