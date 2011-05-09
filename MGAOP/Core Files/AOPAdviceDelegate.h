// -----------------------------------------------------------------------------
//  AOPAdviceDelegate.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@class AOPAdvice;

@protocol AOPAdviceDelegate <NSObject>

@optional

- (void)adviceBeforeExecution:(AOPAdvice *)advice;
- (void)adviceInsteadExecution:(AOPAdvice *)advice;
- (void)adviceAfterExecution:(AOPAdvice *)advice;

- (BOOL)adviceShouldPerformInstead:(AOPAdvice *)advice;

@end
