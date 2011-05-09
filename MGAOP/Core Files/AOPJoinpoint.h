// -----------------------------------------------------------------------------
//  AOPJoinpoint.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@class AOPClass;

@interface AOPJoinpoint : NSObject
{
    SEL                _selector;
    Method             _method;
    NSMethodSignature *_signature;
    NSString          *_type;
    NSString          *_name;
    NSString          *_encoding;
    AOPClass          *_class;
}

- (id)initWithMethodDictionary:(NSDictionary *)methodDictionary;

+ (AOPJoinpoint *)joinpointForMethodDictionary:(NSDictionary *)methodDictionary;


- (SEL)selector;
- (Method)method;
- (NSMethodSignature *)signature;
- (NSString *)type;
- (NSString *)name;
- (NSString *)encoding;
- (AOPClass *)class;


@end
