// -----------------------------------------------------------------------------
//  IllegalArgumentAspect.h
//  AOPSamples
//
//  Created by Manuel Gebele on 25.04.11.
//  Copyright 2011 TDSoftware GmbH. All rights reserved.
// -----------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface IllegalArgumentAspect : AOPAspect
<AOPAdviceDelegate>
{
@private
    BOOL _hasDetectIllegalArgument;
    id   _illegalArgument;
}


+ (IllegalArgumentAspect *)illegalArgumentAspectForClassPattern:(NSString *)classPattern
                                                  methodPattern:(NSString *)methodPattern;

@end
