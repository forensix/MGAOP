// -----------------------------------------------------------------------------
//  AOPInterceptor.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPInterceptor.h"
#import "AOPJoinpoint.h"
#import "AOPAdvice.h"
#import "AOPClass.h"
#import "AOPNilValue.h"

#define INTERCEPTOR_IMPLEMENTATION_KEY @"INTERCEPTOR_IMPLEMENTATION_KEY"
#define INTERCEPTOR_ADVICE_KEY         @"INTERCEPTOR_ADVICE_KEY"

typedef struct  { uint8_t bytes[ 32]; } CallFrame040;
typedef struct  { uint8_t bytes[ 64]; } CallFrame072;
typedef struct  { uint8_t bytes[ 96]; } CallFrame104;
typedef struct  { uint8_t bytes[128]; } CallFrame136;

@implementation AOPInterceptor

// -----------------------------------------------------------------------------
#pragma mark Dealloc/Init
// -----------------------------------------------------------------------------


- (void)dealloc
{
    RELEASE_SAFELY(_storedImplementations);
    
    [super dealloc];
}


- (id)init
{
    if (nil != (self = [super init]))
    {
        [self setupInitialValues];
    }
    
    return self;
}


// -----------------------------------------------------------------------------
#pragma mark Setup
// -----------------------------------------------------------------------------


- (void)setupInitialValues
{
    _storedImplementations = [[NSMutableDictionary alloc] init];
}


// -----------------------------------------------------------------------------
#pragma mark Shared Instance
// -----------------------------------------------------------------------------


+ (AOPInterceptor *)sharedInterceptor
{
    static AOPInterceptor* sharedInstance = nil;
    
    if (nil == sharedInstance)
    {
        sharedInstance = [[super alloc] init];
    }
    
    return sharedInstance;
}


+ (id)alloc {return nil; }
- (id)copyWithZone:(NSZone *)zone { return self; }
- (id)retain { return self; }
- (NSUInteger)retainCount { return NSUIntegerMax; }
- (void)release { }
- (id)autorelease { return self; }


// -----------------------------------------------------------------------------
#pragma mark Argument Catching
// -----------------------------------------------------------------------------


- (NSArray *)catchArgumentsForReceiver:(id)receiver
                          withSelector:(SEL)selector
                            stackFrame:(va_list)stackFrame
{
    NSMethodSignature *signature
    = [receiver methodSignatureForSelector:selector];
    
    NSUInteger count = [signature numberOfArguments];
    
    /*
     * Remark:
     * self and _cmd are located at index 0 and 1.  So when
     * we've a count of only two then there are no arguments
     * besides these two.
     */
    if (count == 2)
    {
        NSLog(@"%@:%@ There are no arguments for method %@",
        NSStringFromClass([self class]),
        NSStringFromSelector(_cmd),
        NSStringFromSelector(selector));
        return nil;
    }
    
    NSMutableArray *arguments = [NSMutableArray array];
    
    NSUInteger index = 2;
    
    for (; index < count; index++)
    {
        const char *argType = [signature getArgumentTypeAtIndex:index];
        
        if ((strlen(argType) > 1)
         && (strchr("{^", argType[0]) == NULL)
         && (strcmp("@?", argType) != 0))
        {
            [NSException raise:NSInvalidArgumentException
                        format:@"Cannot handle argument type '%s'.", argType];
        }
#define IS_EQUAL 0
        if (strcmp(argType, @encode(id)) == IS_EQUAL)
        {
            id value = va_arg(stackFrame, id);
            if (!value)
            {
                value = [AOPNilValue nilValue];
            }
            [arguments addObject:value];
        }
    }
    
    return arguments;
}


// -----------------------------------------------------------------------------
#pragma mark Redirection
// -----------------------------------------------------------------------------


- (NSDictionary *)implementationDictionaryForKey:(NSString *)key
{
    return [_storedImplementations objectForKey:key];
}


void voidEntryPoint(id self, SEL _cmd, ...)
{
    /*
     * Note:
     * self -> receiver _cmd -> receiver selector
     */
    id receiver = self;
    SEL receiverSelector = _cmd;

    /*
     * Note:
     * self -> self _cmd -> newEntryPoint
     */
    self = [AOPInterceptor sharedInterceptor];
    _cmd = @selector(newEntryPoint);
    
    va_list stackFrame;
	va_start(stackFrame, _cmd );
    
    NSArray *arguments =
    [self catchArgumentsForReceiver:receiver
                       withSelector:receiverSelector
                         stackFrame:stackFrame];
    
    NSString *identifier // Implicit dependency!
    = [NSString stringWithFormat:@"%@:%@",
       NSStringFromClass([receiver class]),
       NSStringFromSelector(receiverSelector)];
    
    NSDictionary *implementationDictionary
    = [self implementationDictionaryForKey:identifier];
    
    NSValue *implementationAsValue
    = [implementationDictionary objectForKey:INTERCEPTOR_IMPLEMENTATION_KEY];
    
    IMP implementation;
    [implementationAsValue getValue:&implementation];
    
    AOPAdvice *advice
    = [implementationDictionary objectForKey:INTERCEPTOR_ADVICE_KEY];

// -----------------------------------------------------------------------------
#pragma mark Before
    [advice performAdviceWithType:kAOPAdviceTypeBeforeExecution
                     arguments:arguments identifier:identifier];
// -----------------------------------------------------------------------------

    NSMethodSignature *signature
    = [receiver methodSignatureForSelector:receiverSelector];

    NSUInteger frameLength = [signature frameLength];

// -----------------------------------------------------------------------------
#pragma mark Instead
    BOOL shouldPerformInstead
    = [advice shouldPerformInstead];
    
    if (shouldPerformInstead)
    {
        [advice performAdviceWithType:kAOPAdviceTypeInsteadExecution
                            arguments:arguments identifier:identifier];
        goto after;
    }
    
// -----------------------------------------------------------------------------
    
// -----------------------------------------------------------------------------
#pragma mark Original
    /*
     * Note:
     * Borrowed by Amin =)
     */
    if (frameLength == 8)
    {
        implementation(receiver, receiverSelector);
    }
    else if (frameLength <= 40)
    {
        CallFrame040 frame = va_arg(stackFrame, CallFrame040);
        va_end(stackFrame);
        implementation(receiver, receiverSelector, frame); 
    }
    else if (frameLength <= 72)
    {
        CallFrame072 frame = va_arg(stackFrame, CallFrame072);
        va_end(stackFrame);
        implementation(receiver, receiverSelector, frame); 
    }
    else if (frameLength <= 104)
    {
        CallFrame104 frame = va_arg(stackFrame, CallFrame104);
        va_end(stackFrame);
        implementation(receiver, receiverSelector, frame); 
    }
    else if (frameLength <= 136)
    {
        CallFrame136 frame = va_arg(stackFrame, CallFrame136);
        va_end(stackFrame);
        implementation(receiver, receiverSelector, frame); 
    }
    else
    {
        [self printErrorThatIllegalFrameLengthWasFoundForIdentifier:identifier];
    }
// -----------------------------------------------------------------------------

after:
// -----------------------------------------------------------------------------
#pragma mark After    
    [advice performAdviceWithType:kAOPAdviceTypeAfterExecution
                        arguments:arguments identifier:identifier];
// -----------------------------------------------------------------------------
}


void *returnEntryPoint(id self, SEL _cmd, ...)
{
    void *retVal = NULL;
    /*
     * Note:
     * self -> receiver _cmd -> receiver selector
     */
    id receiver = self;
    SEL receiverSelector = _cmd;
    
    /*
     * Note:
     * self -> self _cmd -> newEntryPoint
     */
    self = [AOPInterceptor sharedInterceptor];
    _cmd = @selector(newEntryPoint);
    
    va_list stackFrame;
	va_start(stackFrame, _cmd );
    
    NSArray *arguments =
    [self catchArgumentsForReceiver:receiver
                       withSelector:receiverSelector
                         stackFrame:stackFrame];
    
    NSString *identifier
    = [NSString stringWithFormat:@"%@:%@",
       NSStringFromClass([receiver class]),
       NSStringFromSelector(receiverSelector)];
    
    NSDictionary *implementationDictionary
    = [self implementationDictionaryForKey:identifier];
    
    NSValue *implementationAsValue
    = [implementationDictionary objectForKey:INTERCEPTOR_IMPLEMENTATION_KEY];
    
    IMP implementation;
    [implementationAsValue getValue:&implementation];
    
    AOPAdvice *advice
    = [implementationDictionary objectForKey:INTERCEPTOR_ADVICE_KEY];
    
// -----------------------------------------------------------------------------
#pragma mark Before
    [advice performAdviceWithType:kAOPAdviceTypeBeforeExecution
                        arguments:arguments identifier:identifier];
// -----------------------------------------------------------------------------
    
    NSMethodSignature *signature
    = [receiver methodSignatureForSelector:receiverSelector];
    
    NSUInteger frameLength = [signature frameLength];
    
// -----------------------------------------------------------------------------
#pragma mark Instead
    BOOL shouldPerformInstead
    = [advice shouldPerformInstead];
    
    if (shouldPerformInstead)
    {
        /*
         * Remark:
         * The design motivation therefor was to catch nil arguments.  When
         * the advice detects such arguments it typically wants to return
         * nil with a errorn indication message.
         *
         * TODO:
         * Add support to return other data types as well - int, char,
         * struct (non object types).
         */
        [advice performAdviceWithType:kAOPAdviceTypeInsteadExecution
                            arguments:arguments identifier:identifier];
        goto after;
    }
// -----------------------------------------------------------------------------
    
// -----------------------------------------------------------------------------
#pragma mark Original
    if (frameLength == 8)
    {
        retVal = (void*)implementation(receiver, receiverSelector);
    }
    else if (frameLength <= 40)
    {
        CallFrame040 frame = va_arg(stackFrame, CallFrame040);
        va_end(stackFrame);
        retVal = (void*)implementation(receiver, receiverSelector, frame); 
    }
    else if (frameLength <= 72)
    {
        CallFrame072 frame = va_arg(stackFrame, CallFrame072);
        va_end(stackFrame);
        retVal = (void*)implementation(receiver, receiverSelector, frame); 
    }
    else if (frameLength <= 104)
    {
        CallFrame104 frame = va_arg(stackFrame, CallFrame104);
        va_end(stackFrame);
        retVal = (void*)implementation(receiver, receiverSelector, frame); 
    }
    else if (frameLength <= 136)
    {
        CallFrame136 frame = va_arg(stackFrame, CallFrame136);
        va_end(stackFrame);
        retVal = (void*)implementation(receiver, receiverSelector, frame); 
    }
    else
    {
        [self printErrorThatIllegalFrameLengthWasFoundForIdentifier:identifier];
    }
// -----------------------------------------------------------------------------

after:
// -----------------------------------------------------------------------------
#pragma mark After    
    [advice performAdviceWithType:kAOPAdviceTypeAfterExecution
                        arguments:arguments identifier:identifier];
// -----------------------------------------------------------------------------
    
    return retVal;
}


// -----------------------------------------------------------------------------
#pragma mark Public API
// -----------------------------------------------------------------------------


- (void)registerJoinpoint:(AOPJoinpoint *)joinpoint
               withAdvice:(AOPAdvice *)advice
{
    NSString *identifier
    = [NSString stringWithFormat:@"%@:%@",
       [[joinpoint class] rtClassName],
       [joinpoint name]];
    
    // Already stored?
    if ([_storedImplementations objectForKey:identifier])
    {
        [self printWarningThatImplementationWasAlreadyStoredForIdentifier:identifier];
        return;
    }
    
    Method rtMethod = [joinpoint method];
    
    // Store old implementation.
    IMP oldEntryPoint = method_getImplementation(rtMethod);
    
    NSValue *implementationAsValue
    = [NSValue value:&oldEntryPoint withObjCType:@encode(IMP)];
    
    NSArray *objects
    = [NSArray arrayWithObjects:implementationAsValue, advice, nil];
    
    NSArray *keys
    = [NSArray arrayWithObjects:INTERCEPTOR_IMPLEMENTATION_KEY,
       INTERCEPTOR_ADVICE_KEY, nil];
    
    NSDictionary *implementationDictionary
    = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [_storedImplementations setObject:implementationDictionary forKey:identifier];
  
    IMP newEntryPoint;
    switch ([[joinpoint signature] methodReturnLength])
    {
    case 0:
        newEntryPoint = (IMP)voidEntryPoint;
        break;
    case 4:
        newEntryPoint = (IMP)returnEntryPoint;
        break;
    default:
            
        break;
    }

    // Store new implementation.
    method_setImplementation(rtMethod, newEntryPoint);
}


// -----------------------------------------------------------------------------
#pragma mark Logging
// -----------------------------------------------------------------------------


- (void)printWarningThatImplementationWasAlreadyStoredForIdentifier:(NSString *)identifier
{
    NSLog(@"%@:%@: Detected possibly duplicate (%@)!",
          NSStringFromClass([self class]),
          NSStringFromSelector(_cmd),
          identifier);
}


- (void)printErrorThatIllegalFrameLengthWasFoundForIdentifier:(NSString *)identifier
{
    NSLog(@"%@:%@: Illegal frame length found for identifier %@!",
          NSStringFromClass([self class]),
          NSStringFromSelector(_cmd),
          identifier);
}

- (void)printErrorThatIllegalReturnValueSizeWasFoundForIdentifier:(NSString *)identifier
{
    NSLog(@"%@:%@: Illegal return value size found for identifier %@!",
          NSStringFromClass([self class]),
          NSStringFromSelector(_cmd),
          identifier);    
}

@end
