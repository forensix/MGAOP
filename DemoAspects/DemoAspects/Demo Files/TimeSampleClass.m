// -----------------------------------------------------------------------------
//  TimeSampleClass.m
//  AOPSamples
//
//  Created by Manuel Gebele on 25.04.11.
//  Copyright 2011 TDSoftware GmbH. All rights reserved.
// -----------------------------------------------------------------------------

#import "TimeSampleClass.h"

@implementation TimeSampleClass

- (void)timeSampleMethod1
{
    for (int i = 0; i < 1000; ++i) ;
}


- (void)timeSampleMethod2
{
    for (int i = 0; i < 1000000; ++i) ;
}


@end
