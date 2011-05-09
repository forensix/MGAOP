// -----------------------------------------------------------------------------
//  AOPAdvicePrivate.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@protocol AOPAdvicePrivate

- (void)setupInitialValues:(NSArray *)values;

- (void)informDelegateBeforeExecution;
- (void)informDelegateInsteadExecution;
- (void)informDelegateAfterExecution;
- (BOOL)askDelegateAboutInsteadExecution;

@end
