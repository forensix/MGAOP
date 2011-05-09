// -----------------------------------------------------------------------------
//  AOPAdvice.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#import "AOPAdvicePrivate.h"
#import "AOPAdviceDelegate.h"

typedef enum {
    kAOPAdviceTypeBeforeExecution,
    kAOPAdviceTypeInsteadExecution,
    kAOPAdviceTypeAfterExecution
} AOPAdviceType;

@interface AOPAdvice : NSObject <AOPAdvicePrivate, AOPAdviceDelegate>
{
    NSArray *_arguments;
    NSString *_identifier;
    id <AOPAdviceDelegate> _delegate;
}

@property (readwrite, retain) NSArray *arguments;
@property (readwrite, copy) NSString *identifier;
@property (assign) id <AOPAdviceDelegate> delegate;

- (id)initWithDelegate:(id)theDelegate;

// Called by the interceptor.
- (void)performAdviceWithType:(AOPAdviceType)type
                    arguments:(NSArray *)theArguments
                   identifier:(NSString *)identifier;
- (BOOL)shouldPerformInstead;

@end
