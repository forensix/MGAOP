// -----------------------------------------------------------------------------
//  AOPInterceptor.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#import "AOPInterceptorPrivate.h"

@class AOPJoinpoint;
@class AOPAdvice;

@interface AOPInterceptor : NSObject <AOPInterceptorPrivate>
{
    NSMutableDictionary *_storedImplementations;
}

+ (AOPInterceptor *)sharedInterceptor;

- (void)registerJoinpoint:(AOPJoinpoint *)joinpoint
               withAdvice:(AOPAdvice *)advice;

@end
