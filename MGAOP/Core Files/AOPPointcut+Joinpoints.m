// -----------------------------------------------------------------------------
//  AOPPointcut+Joinpoints.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPPointcut+Joinpoints.h"
#import "AOPShared.h"
#import "AOPRuntime.h"
#import "AOPClass.h"
#import "AOPJoinpoint.h"
#import "RegexKitLite.h"

#undef SIMPLE_REGEX_TEST

@implementation AOPPointcut (Joinpoints)

+ (NSArray *)componentsForPattern:(NSString *)pattern
{
    // Make this regex more useful!
    NSString *patternMask = @"\\S+[,{1}\\S+]*";
    
    NSArray *matches = [pattern componentsMatchedByRegex:patternMask];
    
    BOOL isValid = ([matches count] == 1);
    if (!isValid)
    {
        return nil;
    }
    
    return [[matches objectAtIndex:0] componentsSeparatedByString:@","];
}


+ (void)simpleRegexTest
{
    NSString *classPattern =  @"MGParentClass,NSObj*,MGParentClass";
    NSString *methodPattern = @"init,initWithName:";
    NSLog(@"class pattern:  %@", [self componentsForPattern:classPattern]);
    NSLog(@"method pattern: %@", [self componentsForPattern:methodPattern]);
}


+ (NSArray *)joinpointsForPointcut:(AOPPointcut *)pointcut
{
#ifdef SIMPLE_REGEX_TEST
    [self simpleRegexTest];
#endif
    
    NSString *classPattern = pointcut.classPattern;
    NSString *methodPattern = pointcut.methodPattern;
    
    NSArray *classPatterns = [self componentsForPattern:classPattern];
    NSArray *methodPatterns = [self componentsForPattern:methodPattern];
    
    BOOL isPatternValid = (classPatterns != nil);
    if (!isPatternValid)
    {
        [self printInvalidClassPatternDetected:classPattern];
        return nil;
    }
    
    isPatternValid = (methodPatterns != nil);
    if (!isPatternValid)
    {
        [self printInvalidMethodPatternDetected:methodPattern];
        return nil;
    }
    
    NSArray *matchingClasses
    = [self classesForPatterns:classPatterns];
        
    NSArray *matchingMethods
    = [self methodsForClasses:matchingClasses andPatterns:methodPatterns];
    
    NSArray *joinpoints = [NSArray arrayWithArray:matchingMethods];
    
    return joinpoints;
}

// -----------------------------------------------------------------------------
#pragma mark Classes
// -----------------------------------------------------------------------------


+ (NSArray *)classesForPatterns:(NSArray *)patterns
{
    NSArray *allClasses = [[AOPRuntime sharedRuntime] allClasses];
    NSMutableArray *matchingClasses = [NSMutableArray array];
    
    /*
     * TODO: Add detection algorithm for duplicates.
     */
    for (AOPClass *class in allClasses)
    {
        NSString *className = class.rtClassName;

        for (NSString *pattern in patterns)
        {
            NSArray *matches = [className componentsMatchedByRegex:pattern];
            
            if (matches && [matches count] > 0)
            {
                [matchingClasses addObject:class];
            }
        }
    }
    
    return matchingClasses;
}


// -----------------------------------------------------------------------------
#pragma mark Methods
// -----------------------------------------------------------------------------


+ (NSArray *)classMethodJoinpointsForClass:(AOPClass *)class
                               andPatterns:(NSArray *)patterns
{
    NSMutableArray *matchingClassMethodJoinpoints = [NSMutableArray array];

    NSDictionary *methods = class.methods;
    
    NSArray *classMethods = [methods objectForKey:CLASS_METHODS_KEY];
    
    for (NSDictionary *classMethod in classMethods)
    {
        NSString *methodName = [classMethod objectForKey:METHOD_NAME_KEY];
        
        for (NSString *pattern in patterns)
        {
            NSArray *matches = [methodName componentsMatchedByRegex:pattern];
            
            if (matches && [matches count] > 0)
            {
                AOPJoinpoint *joinpoint 
                = [AOPJoinpoint joinpointForMethodDictionary:classMethod];
                
                [matchingClassMethodJoinpoints addObject:joinpoint];
            }
        }
    }
    
    return matchingClassMethodJoinpoints;
}


+ (NSArray *)instanceMethodJoinpointsForClass:(AOPClass *)class
                                  andPatterns:(NSArray *)patterns
{
    NSMutableArray *matchingInstanceMethodJoinpoints = [NSMutableArray array];
    
    NSDictionary *methods = class.methods;
    
    NSArray *instanceMethods = [methods objectForKey:INSTANCE_METHODS_KEY];
    
    for (NSDictionary *instanceMethod in instanceMethods)
    {
        NSString *methodName = [instanceMethod objectForKey:METHOD_NAME_KEY];
        
        for (NSString *pattern in patterns)
        {
            NSArray *matches = [methodName componentsMatchedByRegex:pattern];
            
            if (matches && [matches count] > 0)
            {
                AOPJoinpoint *joinpoint 
                = [AOPJoinpoint joinpointForMethodDictionary:instanceMethod];
                
                [matchingInstanceMethodJoinpoints addObject:joinpoint];
            }
        }
    }
    
    return matchingInstanceMethodJoinpoints;
}


+ (NSArray *)methodsForClasses:(NSArray *)classes andPatterns:(NSArray *)patterns
{
    // Fetch all methods for matching classes
    [[AOPRuntime sharedRuntime] fetchRTMethodsForClasses:classes];
    
    NSMutableArray *matchingMethods = [NSMutableArray array];
    
    /*
     * TODO: Add detection algorithm for duplicates.
     */
    for (AOPClass *class in classes)
    {
        NSArray *classMethods
        = [self classMethodJoinpointsForClass:class andPatterns:patterns];
        
        NSArray *instanceMethods
        = [self instanceMethodJoinpointsForClass:class andPatterns:patterns];
        
        if (classMethods)
        {
            [matchingMethods addObjectsFromArray:classMethods];
        }
        
        if (instanceMethods)
        {
            [matchingMethods addObjectsFromArray:instanceMethods];
        }
    }
    
    return matchingMethods;
}


#pragma mark Error Logging


+ (void)printInvalidClassPatternDetected:(NSString *)pattern
{
    NSLog(@"%@:%@ Invalid class pattern (%@) detected!",
          NSStringFromClass([self class]),
          NSStringFromSelector(_cmd),
          pattern);
}


+ (void)printInvalidMethodPatternDetected:(NSString *)pattern
{
    NSLog(@"%@:%@ Invalid method pattern (%@) detected!",
          NSStringFromClass([self class]),
          NSStringFromSelector(_cmd),
          pattern);    
}

@end
