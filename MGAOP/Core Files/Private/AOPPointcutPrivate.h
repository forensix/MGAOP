// -----------------------------------------------------------------------------
//  AOPPointcutPrivate.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@protocol AOPPointcutPrivate

+ (void)printInvalidClassPatternDetected:(NSString *)pattern;
+ (void)printInvalidMethodPatternDetected:(NSString *)pattern;

+ (NSArray *)classesForPatterns:(NSArray *)patterns;
+ (NSArray *)methodsForClasses:(NSArray *)classes andPatterns:(NSArray *)patterns;

@end
