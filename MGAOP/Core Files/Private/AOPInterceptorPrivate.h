// -----------------------------------------------------------------------------
//  AOPInterceptorPrivate.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@protocol AOPInterceptorPrivate

- (void)setupInitialValues;

- (void)printWarningThatImplementationWasAlreadyStoredForIdentifier:(NSString *)identifier;
- (void)printErrorThatIllegalFrameLengthWasFoundForIdentifier:(NSString *)identifier;
- (void)printErrorThatIllegalReturnValueSizeWasFoundForIdentifier:(NSString *)identifier;

@end
