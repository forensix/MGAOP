// -----------------------------------------------------------------------------
//  AOPAspect.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@class AOPPointcut;
@class AOPAdvice;

@interface AOPAspect : NSObject
{
    AOPAdvice   *_advice;
    AOPPointcut *_pointcut;
}

@property (retain, readwrite) AOPAdvice   *advice;
@property (retain, readwrite) AOPPointcut *pointcut;

- (id)initWithPointcut:(AOPPointcut *)thePointcut
             andAdvice:(AOPAdvice *)theAdvice;

+ (AOPAspect *)aspectForPointcut:(AOPPointcut *)thePointcut
                       andAdvice:(AOPAdvice *)theAdvice;

@end
