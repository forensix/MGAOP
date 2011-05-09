// -----------------------------------------------------------------------------
//  AOPPointcut.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface AOPPointcut : NSObject
{
    NSString *_classPattern;
    NSString *_methodPattern;
}

@property (copy, readwrite) NSString *classPattern;
@property (copy, readwrite) NSString *methodPattern;


- (id)initWithClassPattern:(NSString *)theClassPattern
             methodPattern:(NSString *)theMethodPattern;

+ (AOPPointcut *)pointcutForClassPattern:(NSString *)theClassPattern
                           methodPattern:(NSString *)theMethodPattern;


@end
