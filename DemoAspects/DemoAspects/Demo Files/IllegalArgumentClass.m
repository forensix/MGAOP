// -----------------------------------------------------------------------------
//  IllegalArgumentClass.h
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "IllegalArgumentClass.h"

@implementation IllegalArgumentClass


- (void)dealloc
{
    RELEASE_SAFELY(_fetchedArguments);
    [super dealloc];
}


// -----------------------------------------------------------------------------
#pragma mark Business Logic
// -----------------------------------------------------------------------------


- (void)addArgument:(id)argument
{
    [_fetchedArguments addObject:argument];
}


- (void)addArguments:(NSArray *)arguments
{
    [_fetchedArguments addObjectsFromArray:arguments];
}


- (NSArray *)convertArguments:(NSArray *)arguments
{
    // Do something useful.
    return arguments;
}


- (void)convertArgumentsBeforeAdding:(NSArray *)arguments
{
    NSArray *convertedArguments
    = [self convertArguments:arguments];
    [_fetchedArguments addObjectsFromArray:convertedArguments];
}


@end
