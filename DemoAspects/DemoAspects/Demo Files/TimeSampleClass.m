// -----------------------------------------------------------------------------
//  TimeSampleClass.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
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
