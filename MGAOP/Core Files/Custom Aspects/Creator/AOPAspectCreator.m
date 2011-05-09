// -----------------------------------------------------------------------------
//  AOPAspectCreator.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPAspectCreator.h"
#import "AOPAdvice.h"
#import "AOPAspect.h"
#import "AOPLoggingAspect.h"
#import "AOPTimeProfilingAspect.h"

@interface AOPAspectCreator ()

+ (AOPAspect *)createLoggingAspectForClassPattern:(NSString *)classPattern
                                    methodPattern:(NSString *)methodPattern;
+ (AOPAspect *)createTimeProfilingAspectForClassPattern:(NSString *)classPattern
                                          methodPattern:(NSString *)methodPattern;

@end

@implementation AOPAspectCreator

+ (AOPAspect *)aspectOfType:(AOPAspectType)aspectType
               classPattern:(NSString *)classPattern
              methodPattern:(NSString *)methodPattern
{
    AOPAspect *aspect = nil;
    
    switch (aspectType)
    {
    case kAOPAspectTypeLogging:
        aspect = [self createLoggingAspectForClassPattern:classPattern
                                            methodPattern:methodPattern];
        break;
    case kAOPAspectTypeTimeProfiling:
        aspect = [self createTimeProfilingAspectForClassPattern:classPattern
                                                  methodPattern:methodPattern];
            
        break;
    case kAOPAspectTypePrivateApiCall:
        NSLog(@"%@: %@ not implemented yet!",
            NSStringFromClass([self class]),
            @"kAOPAspectTypePrivateApiCall");
        break;
    default:
        break;
    }
    
    return aspect;
}


+ (AOPAspect *)createLoggingAspectForClassPattern:(NSString *)classPattern
                                    methodPattern:(NSString *)methodPattern
{
    AOPLoggingAspect *loggingAspect
    = [AOPLoggingAspect loggingAspectForClassPattern:classPattern
                                       methodPattern:methodPattern];
    
    return loggingAspect;
}


+ (AOPAspect *)createTimeProfilingAspectForClassPattern:(NSString *)classPattern
                                          methodPattern:(NSString *)methodPattern
{
    AOPTimeProfilingAspect *timeProfilingAspect
    = [AOPTimeProfilingAspect timeProfilingAspectForClassPattern:classPattern
                                                   methodPattern:methodPattern];
    
    return timeProfilingAspect;
}

@end
