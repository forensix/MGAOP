// -----------------------------------------------------------------------------
//  AOPLoggingAspect.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPLoggingAspect.h"
#import "AOPPointcut.h"
#import "AOPAdvice.h"

@implementation AOPLoggingAspect


- (id)initWithClassPattern:(NSString *)classPattern
             methodPattern:(NSString *)methodPattern
{
    AOPPointcut *pointcut
    = [AOPPointcut pointcutForClassPattern:classPattern
                             methodPattern:methodPattern];
    
    AOPAdvice *advice = [[AOPAdvice alloc] initWithDelegate:self];
    
    return [self initWithPointcut:pointcut andAdvice:advice];
}


+ (AOPLoggingAspect *)loggingAspectForClassPattern:(NSString *)classPattern
                                     methodPattern:(NSString *)methodPattern
{
    return [[[self alloc] initWithClassPattern:classPattern
                                 methodPattern:methodPattern] autorelease];
}


#pragma mark AOPAdviceDelegate


- (void)adviceBeforeExecution:(AOPAdvice *)advice
{
    NSLog(@"\nBefore {\n<%@: identifier: %@ arguments: %@\n}",
          NSStringFromClass([self class]),
          advice.identifier,
          advice.arguments);
}


- (void)adviceAfterExecution:(AOPAdvice *)advice
{
    NSLog(@"\nAfter {\n<%@: identifier: %@ arguments: %@\n}",
          NSStringFromClass([self class]),
          advice.identifier,
          advice.arguments);
}


@end
