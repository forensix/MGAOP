// -----------------------------------------------------------------------------
//  AOPTimeProfilingAspect.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPTimeProfilingAspect.h"

#import "AOPPointcut.h"
#import "AOPAdvice.h"

#define CLASS (NSStringFromClass([self class]))

@implementation AOPTimeProfilingAspect

- (id)initWithClassPattern:(NSString *)classPattern
             methodPattern:(NSString *)methodPattern
{
    AOPPointcut *pointcut
    = [AOPPointcut pointcutForClassPattern:classPattern
                             methodPattern:methodPattern];
    
    AOPAdvice *advice = [[AOPAdvice alloc] initWithDelegate:self];
    
    return [self initWithPointcut:pointcut andAdvice:advice];
}


+ (AOPTimeProfilingAspect *)timeProfilingAspectForClassPattern:(NSString *)classPattern
                                                 methodPattern:(NSString *)methodPattern
{
    return [[[self alloc] initWithClassPattern:classPattern
                                 methodPattern:methodPattern] autorelease];
}


#pragma mark AOPAdviceDelegate


- (void)adviceBeforeExecution:(AOPAdvice *)advice
{
    _timeTook = [NSDate date];
}


- (void)adviceAfterExecution:(AOPAdvice *)advice
{
    NSLog(@"%@: Needed %f seconds to execute method. [identifier: %@]",
          CLASS,
          -[_timeTook timeIntervalSinceNow],
          advice.identifier);
    
    // Reset…
    _timeTook = nil;
}


@end
