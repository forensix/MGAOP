// -----------------------------------------------------------------------------
//  AOPRuntimePrivate.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <UIKit/UIKit.h>

@class AOPAdvice;

@protocol AOPRuntimePrivate

- (void)setupInitialValues;
- (void)inspectObjRuntime;
- (void)showIntro;

- (void)fetchRTClasses;
- (void)fetchRTMethods;
- (void)fetchRTSubclasses;

- (void)printFetchClassesError;
- (void)printFetchedClassCouldNotBeAddedError:(NSString *)className;
- (void)printFetchSubclassesError:(NSString *)className;
- (void)printFetchInstanceMethodsError:(NSString *)className;
- (void)printFetchClassMethodsError:(NSString *)className;
- (void)printFetchJoinpointsError;
- (void)printFetchedJoinpointNames:(NSArray *)joinpoints;

- (void)redirectJoinpoints:(NSArray *)joinpoints withAdvice:(AOPAdvice *)advice;

@end
