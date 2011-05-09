// -----------------------------------------------------------------------------
//  AOPLoggingAspect.h
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
#import "AOPAdviceDelegate.h"

@interface AOPLoggingAspect : AOPAspect <AOPAdviceDelegate>
{

}

+ (AOPLoggingAspect *)loggingAspectForClassPattern:(NSString *)classPattern
                                     methodPattern:(NSString *)methodPattern;


@end
