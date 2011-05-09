// -----------------------------------------------------------------------------
//  AOPClass.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>


@interface AOPClass : NSObject
{
    Class         _rtClass;
    NSString     *_rtClassName;
    AOPClass     *_superclass;
    NSArray      *_subclasses;
    NSDictionary *_methods;
}

@property (retain, readwrite) Class         rtClass;
@property (copy,   readwrite) NSString     *rtClassName;
@property (retain, readwrite) AOPClass     *superclass;
@property (retain, readwrite) NSArray      *subclasses;
@property (retain, readwrite) NSDictionary *methods;

+ (AOPClass *)aopClass;

@end
