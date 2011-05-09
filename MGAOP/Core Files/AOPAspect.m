// -----------------------------------------------------------------------------
//  AOPAspect.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPAspect.h"

@implementation AOPAspect

@synthesize advice  = _advice;
@synthesize pointcut = _pointcut;


- (void)dealloc
{
    RELEASE_SAFELY(_advice);
    RELEASE_SAFELY(_pointcut);
    
    [super dealloc];
}


- (id)initWithPointcut:(AOPPointcut *)thePointcut andAdvice:(AOPAdvice *)theAdvice
{
    if (thePointcut && theAdvice && nil != (self = [self init]))
    {
        _pointcut = [thePointcut retain];
        _advice = [theAdvice retain];
    }
    
    return self;
}

+ (AOPAspect *)aspectForPointcut:(AOPPointcut *)thePointcut andAdvice:(AOPAdvice *)theAdvice
{
    return [[[self alloc] initWithPointcut:thePointcut
                                andAdvice:theAdvice] autorelease];
}


@end
