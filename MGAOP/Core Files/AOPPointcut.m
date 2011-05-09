// -----------------------------------------------------------------------------
//  AOPPointcut.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPPointcut.h"

@implementation AOPPointcut

@synthesize classPattern  = _classPattern;
@synthesize methodPattern = _methodPattern;

- (void)dealloc
{
    RELEASE_SAFELY(_classPattern);
    RELEASE_SAFELY(_methodPattern);
    
    [super dealloc];
}


- (id)initWithClassPattern:(NSString *)theClassPattern
             methodPattern:(NSString *)theMethodPattern
{
    if (theClassPattern && theMethodPattern && nil != (self = [self init]))
    {
        _classPattern = [theClassPattern copy];
        _methodPattern = [theMethodPattern copy];
    }
    return self;
}


+ (AOPPointcut *)pointcutForClassPattern:(NSString *)theClassPattern
                           methodPattern:(NSString *)theMethodPattern
{
    return [[[self alloc] initWithClassPattern:theClassPattern
                                 methodPattern:theMethodPattern] autorelease];
}


@end
