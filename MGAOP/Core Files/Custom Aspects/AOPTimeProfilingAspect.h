// -----------------------------------------------------------------------------
//  AOPTimeProfilingAspect.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#import "AOPAspect.h"

@interface AOPTimeProfilingAspect : AOPAspect
{
    NSDate *_timeTook;
}


+ (AOPTimeProfilingAspect *)timeProfilingAspectForClassPattern:(NSString *)classPattern
                                                 methodPattern:(NSString *)methodPattern;

@end
