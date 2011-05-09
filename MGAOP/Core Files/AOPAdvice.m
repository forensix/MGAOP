// -----------------------------------------------------------------------------
//  AOPAdvice.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPAdvice.h"

@implementation AOPAdvice

@synthesize delegate = _delegate;
@synthesize identifier = _identifier;
@synthesize arguments = _arguments;

- (void)dealloc
{
    _delegate = nil;

    RELEASE_SAFELY(_arguments);
    RELEASE_SAFELY(_identifier);
    [super dealloc];
}


- (id)initWithDelegate:(id)theDelegate
{
    if (nil != (self = [super init]))
    {
        NSArray *values = [NSArray arrayWithObject:theDelegate];
        [self setupInitialValues:values];
    }
    
    return self;
}


- (void)setupInitialValues:(NSArray *)values
{
    _delegate = [values objectAtIndex:0];
    _arguments = nil;
    _identifier = nil;
}


- (void)performAdviceWithType:(AOPAdviceType)type
                    arguments:(NSArray *)theArguments
                   identifier:(NSString *)identifier
{
    self.arguments = theArguments;
    self.identifier = identifier;
    
    switch (type)
    {
    case kAOPAdviceTypeBeforeExecution:
        [self informDelegateBeforeExecution];
        break;
    case kAOPAdviceTypeInsteadExecution:
        [self informDelegateInsteadExecution];
        break;
    case kAOPAdviceTypeAfterExecution:
        [self informDelegateAfterExecution];
    default:
        break;
    }
}


- (BOOL)shouldPerformInstead
{
    return [self askDelegateAboutInsteadExecution];
}


- (BOOL)askDelegateAboutInsteadExecution
{
    BOOL retval = NO;
    SEL selector = @selector(adviceShouldPerformInstead:);
    
    if (self.delegate)
    {
        BOOL doesRespond = [self.delegate respondsToSelector:selector];
        if (doesRespond)
        {
            retval = [self.delegate adviceShouldPerformInstead:self];
        }
    }
    
    return retval;
}


- (void)informDelegateBeforeExecution
{
    SEL selector = @selector(adviceBeforeExecution:);
    
    if (self.delegate)
    {
        BOOL doesRespond = [self.delegate respondsToSelector:selector];
        if (doesRespond)
        {
            [self.delegate performSelector:selector withObject:self];
        }
    }
}


- (void)informDelegateInsteadExecution
{
    SEL selector = @selector(adviceInsteadExecution:);
    
    if (self.delegate)
    {
        BOOL doesRespond = [self.delegate respondsToSelector:selector];
        if (doesRespond)
        {
            [self.delegate performSelector:selector withObject:self];
        }
    }
}


- (void)informDelegateAfterExecution
{
    SEL selector = @selector(adviceAfterExecution:);
    
    if (self.delegate)
    {
        BOOL doesRespond = [self.delegate respondsToSelector:selector];
        if (doesRespond)
        {
            [self.delegate performSelector:selector withObject:self];
        }
    }
}


@end
