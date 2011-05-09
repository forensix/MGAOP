// -----------------------------------------------------------------------------
//  IllegalArgumentAspect.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "IllegalArgumentAspect.h"

@implementation IllegalArgumentAspect


- (void)dealloc
{
    if (_illegalArgument)
    {
        RELEASE_SAFELY(_illegalArgument);
    }
    [super dealloc];
}


- (id)initWithClassPattern:(NSString *)classPattern
             methodPattern:(NSString *)methodPattern
{
    AOPPointcut *pointcut
    = [AOPPointcut pointcutForClassPattern:classPattern
                             methodPattern:methodPattern];
    
    AOPAdvice *advice = [[AOPAdvice alloc] initWithDelegate:self];
    
    _illegalArgument = nil;
    _hasDetectIllegalArgument = NO;
    
    return [super initWithPointcut:pointcut andAdvice:advice];
}


+ (IllegalArgumentAspect *)illegalArgumentAspectForClassPattern:(NSString *)classPattern
                                                  methodPattern:(NSString *)methodPattern
{
    return [[[self alloc] initWithClassPattern:classPattern
                                 methodPattern:methodPattern] autorelease];
}


#pragma mark AOPAdviceDelegate


- (void)adviceBeforeExecution:(AOPAdvice *)advice
{
    NSArray *arguments = advice.arguments;
    
    // Loop through all arguments to detect illegal values.
    for (id argument in arguments)
    {
        BOOL illegalArgument
        = [argument isKindOfClass:[AOPNilValue class]];
        if (illegalArgument)
        {
            if (_illegalArgument)
            {
                RELEASE_SAFELY(_illegalArgument);
            }
            
            _hasDetectIllegalArgument = YES;
            _illegalArgument = [argument retain];
            // Break after the first detection.
            break;
        }
    }
}


- (void)adviceInsteadExecution:(AOPAdvice *)advice
{
    NSLog(@"[ERROR] %@: Detected illegal argument [%@] for identifier %@",
          CLASS,
          _illegalArgument,
          advice.identifier);
}


- (void)adviceAfterExecution:(AOPAdvice *)advice
{
    return;
}


- (BOOL)adviceShouldPerformInstead:(AOPAdvice *)advice
{
    BOOL retval = NO;
    
    if (_hasDetectIllegalArgument)
    {
        retval = YES;
    }
    _hasDetectIllegalArgument = NO;
    
    return retval;
}


@end
