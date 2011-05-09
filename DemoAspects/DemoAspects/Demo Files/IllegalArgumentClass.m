// -----------------------------------------------------------------------------
//  IllegalArgumentClass.h
//  AOPSamples
//
//  Created by Manuel Gebele on 25.04.11.
//  Copyright 2011 TDSoftware GmbH. All rights reserved.
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
