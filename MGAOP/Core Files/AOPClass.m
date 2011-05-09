// -----------------------------------------------------------------------------
//  AOPClass.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPClass.h"
#import "AOPShared.h"

@implementation AOPClass

@synthesize rtClass     = _rtClass;
@synthesize rtClassName = _rtClassName;
@synthesize superclass  = _superclass;
@synthesize subclasses  = _subclasses;
@synthesize methods     = _methods;

- (void)dealloc
{
    RELEASE_SAFELY(_rtClass);
    RELEASE_SAFELY(_rtClassName);
    RELEASE_SAFELY(_superclass);
    RELEASE_SAFELY(_subclasses);
    RELEASE_SAFELY(_methods);
    [super dealloc];
}

+ (AOPClass *)aopClass
{
    return [[[self alloc] init] autorelease];
}


- (NSArray *)instanceMethods
{
    return [self.methods objectForKey:INSTANCE_METHODS_KEY];
}


- (NSUInteger)numberOfInstanceMethods
{
    return [[self instanceMethods] count];
}


- (NSArray *)classMethods
{
    return [self.methods objectForKey:CLASS_METHODS_KEY];
}


- (NSUInteger)numberOfClassMethods
{
    return [[self classMethods] count];
}


- (NSUInteger)numberOfSubclasses
{
    return [self.subclasses count];
}


- (NSString *)description
{
    NSString *className = self.rtClassName;
    NSString *superclassName = self.superclass.rtClassName;
    NSUInteger numberOfSubclasses = [self numberOfSubclasses];
    NSArray *instanceMethods = [self instanceMethods];
    NSUInteger numberOfInstanceMethods = [self numberOfInstanceMethods];
    NSArray *classMethods = [self classMethods];
    NSUInteger numberOfClassMethods = [self numberOfClassMethods];
    
    NSMutableString *instanceMethodsString = [NSMutableString string];
    for (NSDictionary *instanceMethodDictionary in instanceMethods)
    {
        NSString *methodName
        = [instanceMethodDictionary objectForKey:METHOD_NAME_KEY];
        
        [instanceMethodsString appendFormat:@"\t%@\n", methodName];
    }
    
    NSMutableString *classMethodsString = [NSMutableString string];
    for (NSDictionary *classMethodDictionary in classMethods)
    {
        NSString *methodName
        = [classMethodDictionary objectForKey:METHOD_NAME_KEY];
        
        [classMethodsString appendFormat:@"\t%@\n", methodName];
    }    
    
    NSString *formatString = @"\n"
    "[\n"
    "Class: %@\n"
    "Superclass: %@\n\n"
    "Number of subclasses: %u\n"
    "Number of instance methods: %u\n"
    "Number of class methods: %u\n\n"
    "Instance methods {\n"
    "%@"
    "}\n\n"
    "Class methods {\n"
    "%@"
    "}\n\n"
    "]";
    
    NSString *description
    = [NSString stringWithFormat:formatString,
       className,
       superclassName,
       numberOfSubclasses,
       numberOfInstanceMethods,
       numberOfClassMethods,
       instanceMethodsString,
       classMethodsString
    ];
    
    return description;
}


@end
