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
