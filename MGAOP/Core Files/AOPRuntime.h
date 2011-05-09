// -----------------------------------------------------------------------------
//  AOPRuntime.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#import "AOPRuntimePrivate.h"

@class AOPClass;
@class AOPAspect;

@interface AOPRuntime : NSObject <AOPRuntimePrivate>
{
    NSMutableDictionary *_rtClasses; // Contains all registered runtime classes.
}

+ (AOPRuntime *)sharedRuntime;
- (AOPClass *)classForName:(NSString *)name;
- (BOOL)declareAspect:(AOPAspect *)aspect;
- (void)fetchRTMethodsForClasses:(NSArray *)classes;
- (void)fetchRTSubclassesOfClasses:(NSArray *)classes;
- (NSArray *)allClasses;

@end
