// -----------------------------------------------------------------------------
//  AOPJoinpoint.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPJoinpoint.h"
#import "AOPShared.h"

@implementation AOPJoinpoint

// -----------------------------------------------------------------------------
#pragma mark Dealloc/Init
// -----------------------------------------------------------------------------


- (void)dealloc
{
    _selector = NULL;
    _method = NULL;
    RELEASE_SAFELY(_signature);
    RELEASE_SAFELY(_type);
    RELEASE_SAFELY(_name);
    RELEASE_SAFELY(_encoding);
    RELEASE_SAFELY(_class);
    [super dealloc];
}


- (void)setupInitialValuesForDictionary:(NSDictionary *)dictionary
{
    NSValue *selectorValue = [dictionary objectForKey:METHOD_SELECTOR_KEY];
    [selectorValue getValue:&_selector];
    
    NSValue *methodValue = [dictionary objectForKey:METHOD_KEY];
    [methodValue getValue:&_method];
    
    _signature = [[dictionary objectForKey:METHOD_SIGNATURE_KEY] retain];
    _type = [[dictionary objectForKey:METHOD_TYPE_KEY] copy];
    _name = [[dictionary objectForKey:METHOD_NAME_KEY] copy];
    _encoding = [[dictionary objectForKey:METHOD_ENCODING_KEY] copy];
    _class = [[dictionary objectForKey:METHOD_CLASS_KEY] retain];
}


- (id)initWithMethodDictionary:(NSDictionary *)methodDictionary
{
    if (methodDictionary && nil != (self = [self init]))
    {
        [self setupInitialValuesForDictionary:methodDictionary];
    }
    
    return self;
}


+ (AOPJoinpoint *)joinpointForMethodDictionary:(NSDictionary *)methodDictionary
{
    return [[[self alloc] initWithMethodDictionary:methodDictionary] autorelease];
}


// -----------------------------------------------------------------------------
#pragma mark Getters
// -----------------------------------------------------------------------------


- (SEL)selector
{
    return _selector;
}


- (Method)method
{
    return _method;
}


- (NSMethodSignature *)signature
{
    return _signature;
}


- (NSString *)type
{
    return _type;
}


- (NSString *)name
{
    return _name;
}


- (NSString *)encoding
{
    return _encoding;
}


- (AOPClass *)class
{
    return _class;
}


@end
