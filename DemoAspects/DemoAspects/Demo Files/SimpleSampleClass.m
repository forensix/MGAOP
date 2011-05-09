// -----------------------------------------------------------------------------
//  SimpleSampleClass.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
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
