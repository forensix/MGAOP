// -----------------------------------------------------------------------------
//  AOPNilValue.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPNilValue.h"

@implementation AOPNilValue

+ (AOPNilValue *)nilValue
{
    return [[[self alloc] init] autorelease];
}

@end
