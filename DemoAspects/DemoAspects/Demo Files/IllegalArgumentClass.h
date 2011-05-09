// -----------------------------------------------------------------------------
//  IllegalArgumentClass.h
//  AOPSamples
//
//  Created by Manuel Gebele on 25.04.11.
//  Copyright 2011 TDSoftware GmbH. All rights reserved.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>


@interface IllegalArgumentClass : NSObject
{
@private
    NSMutableArray *_fetchedArguments;
}

- (void)addArgument:(id)argument;
- (void)addArguments:(NSArray *)arguments;
- (void)convertArgumentsBeforeAdding:(NSArray *)arguments;

@end
