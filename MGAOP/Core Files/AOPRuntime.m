// -----------------------------------------------------------------------------
//  AOPRuntime.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "AOPRuntime.h"
#import "AOPShared.h"
#import "AOPClass.h"
#import "AOPAspect.h"
#import "AOPPointcut+Joinpoints.h"
#import "AOPJoinpoint.h"
#import "AOPInterceptor.h"
#import "AOPAdvice.h"

@implementation AOPRuntime


// -----------------------------------------------------------------------------
#pragma mark Dealloc & Init
// -----------------------------------------------------------------------------


- (void)dealloc
{
    RELEASE_SAFELY(_rtClasses);
    [super dealloc];
}


- (id)init
{
    if (nil != (self = [super init]))
    {
        [self setupInitialValues];
        [self inspectObjRuntime];
        [self showIntro];
    }
    
    return self;
}


// -----------------------------------------------------------------------------
#pragma mark Shared Instance
// -----------------------------------------------------------------------------


+ (AOPRuntime *)sharedRuntime
{
    static AOPRuntime* sharedInstance = nil;
    
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
#pragma mark Overriden
// -----------------------------------------------------------------------------


- (NSString *)description
{
    NSString *libName = @"\n\n- libAOP.a -\n\n";
    
    NSString *copyright
    = @"Created by Manuel Gebele on 21.04.11.\n"
       "Copyright 2011 TDSoftware. All rights reserved.\n\n";
    
    NSString *initialized
    = @"AOP Runtime was first initialized…\n\n";
    
    NSString *description
    = [NSString stringWithFormat:@"%@%@%@", libName, copyright, initialized];
    
    return description;
}


// -----------------------------------------------------------------------------
#pragma mark Initial Setup
// -----------------------------------------------------------------------------


- (void)setupInitialValues
{
    _rtClasses = [[NSMutableDictionary alloc] init];
}


- (void)showIntro
{
    NSLog(@"%@", self);
}


- (void)inspectObjRuntime
{
    [self fetchRTClasses];
#ifdef FETCH_ALL_SUBCLASSES
    [self fetchRTSubclasses];
#endif
#ifdef RUNTIME_REPORT
 #if (TARGET_IPHONE_SIMULATOR) // Don't use on device this takes to loooong!
    [self fetchRTMethods];
 #endif
#endif
}


// -----------------------------------------------------------------------------
#pragma mark Classes
// -----------------------------------------------------------------------------


- (int)numberOfRTClasses
{
    return objc_getClassList(NULL, 0);
}


- (Class *)allocRTClasses:(int)number
{
    if (number <= 0)
    {
        return NULL;
    }
    Class *classes = malloc(sizeof(Class) * number);
    (void)objc_getClassList(classes, number);
    return classes;
}


- (NSString *)nameAsString:(const char *)charArray
{
    return
    [[[NSString alloc]
      initWithBytes:charArray
      length:strlen(charArray)
      encoding:NSASCIIStringEncoding] autorelease];
}


- (BOOL)isClassKindOfNSProxy:(Class)class
{
    BOOL isKindOfNSProxy = NO;
    
    while (class)
    {
        NSString *name = [NSString stringWithUTF8String:class_getName(class)];
        
        if ([name isEqualToString:@"NSProxy"])
        {
            isKindOfNSProxy = YES;
        }
        
        class = class_getSuperclass(class);
    }
    
    return isKindOfNSProxy;
}


- (BOOL)isSuperclassOfTypeObject:(Class)class
{
    BOOL isSuperclassOfTypeObject = NO;
    
    Class superclass = class_getSuperclass(class);
    
    const char *class_name = class_getName(superclass);
    NSString *className = [self nameAsString:class_name];
    
    if ([className isEqualToString:@"Object"])
    {
        isSuperclassOfTypeObject = YES;
    }

    return isSuperclassOfTypeObject;
}


- (BOOL)isClassArrayCompatible:(NSString *)className
{
    BOOL isClassArrayCompatible = YES;
    
    if ([className hasPrefix:@"_NSZombie_"] 
     || [className isEqualToString:@"Object"]
     ||	[className isEqualToString:@"NSMessageBuilder"]
     ||	[className isEqualToString:@"NSLeafProxy"]
     ||	[className isEqualToString:@"__NSGenericDeallocHandler"]
     ||	[className isEqualToString:@"__IncompleteProtocol"])
    {
        isClassArrayCompatible = NO;
    }
    
    return isClassArrayCompatible;
}


- (void)fetchRTClasses
{
    int number = [self numberOfRTClasses];
    Class *classes = [self allocRTClasses:number];
    
    if (!classes)
    {
        [self printFetchClassesError];
        return;
    }
    
    // Clean up. Just in case the user refreshes the AOP runtime.
    [_rtClasses removeAllObjects];
    
    // Start fetching all registered RT classes.
    for (int index = 0; index < number; index++)
    {
        Class class = *(classes + index);
        const char *class_name = class_getName(class);
        NSString *className = [self nameAsString:class_name];
        
        /*
         * Remark:
         * Skip classes which are not 'introspection-compatible'.
         */
        if ([self isClassKindOfNSProxy:class])
        {
            goto next;
        }
        
        if ([self isSuperclassOfTypeObject:class])
        {
            goto next;
        }
        
        if (![self isClassArrayCompatible:className])
        {
            goto next;
        }
        
        AOPClass *aopClass = [AOPClass aopClass];
        
        aopClass.rtClass = class;
        aopClass.rtClassName = className;
        
        [_rtClasses setObject:aopClass forKey:aopClass.rtClassName];
        
        continue;
next:
        [self printFetchedClassCouldNotBeAddedError:className];
    }
    free(classes);
}


- (NSArray *)subclassesOfParentClass:(AOPClass *)parentClass
{
    NSMutableArray *subclasses = [NSMutableArray array];
    
    for (AOPClass *class in [_rtClasses allValues])
    {
        Class superClass = class.rtClass;
        
        do
        {
            superClass = class_getSuperclass(superClass);
        } while (superClass && superClass != parentClass.rtClass);
        
        if (superClass == nil)
        {
            continue;
        }
        
        /*
         * Remark:
         * Here we set the superclass.  This is quasi a
         * side effect of this method.
         */
        class.superclass = parentClass;
        
        [subclasses addObject:class];
    }
    
    return subclasses;
}


- (void)fetchRTSubclasses
{
    for (AOPClass *class in [_rtClasses allValues])
    {
        NSArray *subclasses = [self subclassesOfParentClass:class];
        
        if (!subclasses
         || [subclasses count] <= 0)
        {
            [self printFetchSubclassesError:class.rtClassName];
            continue;
        }
        
        class.subclasses = subclasses;
    }
}


// -----------------------------------------------------------------------------
#pragma mark Methods
// -----------------------------------------------------------------------------


/*
 * Deprecated:
 * Performance is just to slow!
 */
- (NSArray *)dictionaryObjectsForMethod:(Method)method
                                 ofType:(NSString *)type
                               andClass:(AOPClass *)class
{
    NSString *methodType = type;
    
    SEL methodSelector
    = method_getName(method);
    
    NSString *methodName
    = NSStringFromSelector(methodSelector);
    
    const char *method_encoding
    = method_getTypeEncoding(method);
    
    NSString *methodEncoding
    = [self nameAsString:method_encoding];
    
    NSValue *methodValue
    = [NSValue value:&method withObjCType:@encode(Method)];
    
    NSValue *methodSelectorValue
    = [NSValue value:&methodSelector withObjCType:@encode(SEL)];

    NSArray *dictionaryKeys
    = [NSArray arrayWithObjects:
       methodSelectorValue,
       methodValue,
       methodType,
       methodName,
       methodEncoding,
       class,
       nil];
    
    return dictionaryKeys;
}


/*
 * Deprecated:
 * Performance is just to slow!
 */
- (NSArray *)dictionaryMethodKeys
{
    return
    [NSArray arrayWithObjects:
     METHOD_SELECTOR_KEY,
     METHOD_KEY,
     METHOD_SIGNATURE_KEY,
     METHOD_TYPE_KEY,
     METHOD_NAME_KEY,
     METHOD_ENCODING_KEY,
     METHOD_CLASS_KEY,
     nil
    ];
}


- (NSArray *)instanceMethodsOfClass:(AOPClass *)class
{    
    Class rtClass = class.rtClass;
    unsigned int count;
    
    Method *methods = class_copyMethodList(rtClass, &count);
    
    if (!methods && count == 0)
    {
        [self printFetchInstanceMethodsError:class.rtClassName];
        return nil;
    }

    NSMutableArray *instanceMethods = [NSMutableArray array];

    for (int index = 0; index < count; index++)
    {
        Method method = *(methods + index);
        
        if (method == NULL)
        {
            continue;
        }
        
        NSArray *keys
        =  [NSArray arrayWithObjects:
            METHOD_SELECTOR_KEY,
            METHOD_KEY,
            METHOD_SIGNATURE_KEY,
            METHOD_TYPE_KEY,
            METHOD_NAME_KEY,
            METHOD_ENCODING_KEY,
            METHOD_CLASS_KEY,
            nil
        ];
                
        SEL methodSelector
        = method_getName(method);
        
        NSString *methodName
        = NSStringFromSelector(methodSelector);
        
        const char *rtSignature = method_getTypeEncoding(method);
        NSMethodSignature *methodSignature
        = [NSMethodSignature signatureWithObjCTypes:rtSignature];
        
        NSString *methodType = @"instance";
        
        const char *method_encoding
        = method_getTypeEncoding(method);
        
        NSString *methodEncoding
        = [self nameAsString:method_encoding];
        
        NSValue *methodValue
        = [NSValue value:&method withObjCType:@encode(Method)];
        
        NSValue *methodSelectorValue
        = [NSValue value:&methodSelector withObjCType:@encode(SEL)];
        
        NSArray *objects
        = [NSArray arrayWithObjects:
           methodSelectorValue,
           methodValue,
           methodSignature,
           methodType,
           methodName,
           methodEncoding,
           class,
           nil];
        
        if (keys && objects)
        {
            NSDictionary *methodDictionary
            = [NSDictionary dictionaryWithObjects:objects forKeys:keys]; 
            
            [instanceMethods addObject:methodDictionary];
        }
    }
    
    free(methods);
    
    return instanceMethods;
}


/*
 * Deprecated:
 * Performance is just to slow!
 */
- (BOOL)isMethodDuplicate:(NSString *)theMethodName class:(AOPClass *)class
          instanceMethods:(NSArray *)instanceMethods
{
    return NO;
    BOOL isDuplicate = NO;
    
    for (NSDictionary *methodDictionary in instanceMethods)
    {
        NSString *methodName
        = [methodDictionary objectForKey:METHOD_NAME_KEY];
        
        NSString *className
        = [[methodDictionary objectForKey:METHOD_CLASS_KEY] rtClassName];
        
        if ([theMethodName isEqualToString:methodName]
            && [class.rtClassName isEqualToString:className])
        {
            isDuplicate = YES;
            break;
        }
    }
    
    return isDuplicate;
}


- (NSArray *)classMethodsOfClass:(AOPClass *)class
                 instanceMethods:(NSArray *)instanceMethods
{
    Class rtClass = class.rtClass;
    Class metaClass = objc_getMetaClass(class_getName(rtClass));
    unsigned int count;

    Method *methods = class_copyMethodList(metaClass, &count);
    
    if (!methods && count == 0)
    {
        [self printFetchClassMethodsError:class.rtClassName];
        return nil;
    }
    
    NSMutableArray *classMethods = [NSMutableArray array];
    
    for (int index = 0; index < count; index++)
    {
        Method method = *(methods + index);
        
        if (method == NULL)
        {
            continue;
        }
        
        NSArray *keys
        =  [NSArray arrayWithObjects:
            METHOD_SELECTOR_KEY,
            METHOD_KEY,
            METHOD_SIGNATURE_KEY,
            METHOD_TYPE_KEY,
            METHOD_NAME_KEY,
            METHOD_ENCODING_KEY,
            METHOD_CLASS_KEY,
            nil
        ];
        
        SEL methodSelector
        = method_getName(method);
        
        NSString *methodName
        = NSStringFromSelector(methodSelector);
        
        const char *rtSignature = method_getTypeEncoding(method);
        NSMethodSignature *methodSignature
        = [NSMethodSignature signatureWithObjCTypes:rtSignature];
        
        NSString *methodType = @"class";
        
        const char *method_encoding
        = method_getTypeEncoding(method);
        
        NSString *methodEncoding
        = [self nameAsString:method_encoding];
        
        NSValue *methodValue
        = [NSValue value:&method withObjCType:@encode(Method)];
        
        NSValue *methodSelectorValue
        = [NSValue value:&methodSelector withObjCType:@encode(SEL)];
        
        NSArray *objects
        = [NSArray arrayWithObjects:
           methodSelectorValue,
           methodValue,
           methodSignature,
           methodType,
           methodName,
           methodEncoding,
           class,
           nil];
        
        /*
         * Remark:
         * In some cases it could happen that we've both, an instance and
         * class method.  In such cases I'll give the instance method the
         * highest priority in order to prevent duplicates.
         *
         * Needs to be tested carefully to get max stability.
         */
        BOOL shouldBeAdded = YES;
        
        for (NSDictionary *methodDictionary in instanceMethods)
        {
            NSString *instanceMethodName
            = [methodDictionary objectForKey:METHOD_NAME_KEY];
            
            NSString *className
            = [[methodDictionary objectForKey:METHOD_CLASS_KEY] rtClassName];
            
            if ([methodName isEqualToString:instanceMethodName]
                && [class.rtClassName isEqualToString:className])
            {
                shouldBeAdded = NO;
                break;
            }
        }
        
        NSDictionary *methodDictionary
        = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                
        if (keys && objects && shouldBeAdded)
        {
            [classMethods addObject:methodDictionary];
        }
    }
    
    free(methods);
    
    return classMethods;
}


- (void)getValidatedInstanceMethods:(NSArray **)instanceMethods
{
    if (!*instanceMethods)
    {
        *instanceMethods = [NSArray array];
    }
}


- (void)getValidatedClassMethods:(NSArray **)classMethods
{
    if (!*classMethods)
    {
        *classMethods = [NSArray array];
    }    
}


- (NSDictionary *)methodDictionaryOfClass:(AOPClass *)class
{
    NSArray *instanceMethods = [self instanceMethodsOfClass:class];
    NSArray *classMethods = [self classMethodsOfClass:class instanceMethods:instanceMethods];

    // Validate if needed.
    [self getValidatedInstanceMethods:&instanceMethods];
    [self getValidatedClassMethods:&classMethods];
    
    // Build the dictionary.
    NSArray *keys
    = [NSArray arrayWithObjects:INSTANCE_METHODS_KEY, CLASS_METHODS_KEY, nil];
    
    NSArray *objects
    = [NSArray arrayWithObjects:instanceMethods, classMethods, nil];
    
    NSDictionary *methodDictionary
    = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    return methodDictionary;
}

- (void)fetchRTMethods
{
    // Remark: To slow on devices.
    [self fetchRTMethodsForClasses:[_rtClasses allValues]];
}


// -----------------------------------------------------------------------------
#pragma mark Public API
// -----------------------------------------------------------------------------


- (AOPClass *)classForName:(NSString *)name
{
    return [_rtClasses objectForKey:name];
}


- (void)fetchRTMethodsForClasses:(NSArray *)classes
{
    for (AOPClass *class in classes)
    {
#ifdef WALK_THROUGH_PARENT_CLASSES // This will fetch all
                                   // inherited methods as well.
        NSMutableArray *instanceMethods
        = [NSMutableArray array];
        
        NSMutableArray *classMethods
        = [NSMutableArray array];
        
        AOPClass *superclass = class;
        
        do
        {
            NSDictionary *methodDicionary = [self methodDictionaryOfClass:superclass];
            
            if (methodDicionary)
            {
                NSArray *instanceMethodsArray
                = [methodDicionary objectForKey:INSTANCE_METHODS_KEY];

                NSArray *classMethodsArray
                = [methodDicionary objectForKey:CLASS_METHODS_KEY];
                
                [instanceMethods addObjectsFromArray:instanceMethodsArray];
                [classMethods addObjectsFromArray:classMethodsArray];
            }
            
            superclass = superclass.superclass;
        } while (superclass);
        
        NSDictionary *methodDictionary
        = [NSDictionary dictionaryWithObjects:
           [NSArray arrayWithObjects:
            instanceMethods, classMethods, nil]
            forKeys:
           [NSArray arrayWithObjects:
            INSTANCE_METHODS_KEY, CLASS_METHODS_KEY, nil]
        ];
        
        class.methods = methodDictionary;
#else
        NSDictionary *methodDicionary
        = [self methodDictionaryOfClass:class];
        class.methods = methodDicionary;
#endif
    }
}


- (NSArray *)allClasses
{
    return [_rtClasses allValues];
}


- (BOOL)declareAspect:(AOPAspect *)aspect
{
    BOOL success = YES;
    
    // Get possible joinpoints (only methods, no properties or other
    // meta informations).
    NSArray *joinpoints
    = [AOPPointcut joinpointsForPointcut:aspect.pointcut];
    
    success = (joinpoints != nil);
    
    if (joinpoints)
    {
        [self printFetchedJoinpointNames:joinpoints];
        [self redirectJoinpoints:joinpoints withAdvice:aspect.advice];
    }
    
    return success;
}


- (void)fetchRTSubclassesOfClasses:(NSArray *)classes
{
    for (AOPClass *class in classes)
    {
        NSArray *subclasses = [self subclassesOfParentClass:class];
        
        if (!subclasses
            || [subclasses count] <= 0)
        {
            [self printFetchSubclassesError:class.rtClassName];
            continue;
        }
        
        class.subclasses = subclasses;
    }
}


// -----------------------------------------------------------------------------
#pragma mark Method Redirection
// -----------------------------------------------------------------------------


- (void)redirectJoinpoints:(NSArray *)joinpoints withAdvice:(AOPAdvice *)advice
{
    AOPInterceptor *interceptor = [AOPInterceptor sharedInterceptor];
    
    for (AOPJoinpoint *joinpoint in joinpoints)
    {
        [interceptor registerJoinpoint:joinpoint withAdvice:advice];
    }
}


// -----------------------------------------------------------------------------
#pragma mark Logging
// -----------------------------------------------------------------------------


- (void)printFetchClassesError
{
#ifdef RUNTIME_REPORT
    NSLog(@"%@:%@: No registered RT classes found!",
          NSStringFromClass([self class]),
          NSStringFromSelector(_cmd));
#endif
}


- (void)printFetchedClassCouldNotBeAddedError:(NSString *)className
{
#ifdef RUNTIME_REPORT
    NSLog(@"%@:%@ RT class %@ couldn't be added!",
          NSStringFromClass([self class]),
          NSStringFromSelector(_cmd),
          className);
#endif
}


- (void)printFetchSubclassesError:(NSString *)className
{
#ifdef RUNTIME_REPORT
    NSLog(@"%@:%@ No subclasses found for RT class %@!",
          NSStringFromClass([self class]),
          NSStringFromSelector(_cmd),
          className);    
#endif
}


- (void)printFetchInstanceMethodsError:(NSString *)className
{
#ifdef RUNTIME_REPORT
    NSLog(@"%@:%@ No instance methods found for RT class %@!",
          NSStringFromClass([self class]),
          NSStringFromSelector(_cmd),
          className);    
#endif
}


- (void)printFetchClassMethodsError:(NSString *)className
{
#ifdef RUNTIME_REPORT
    NSLog(@"%@:%@ No class methods found for RT class %@!",
          NSStringFromClass([self class]),
          NSStringFromSelector(_cmd),
          className);
#endif
}


- (void)printFetchJoinpointsError
{
#ifdef RUNTIME_REPORT
    NSLog(@"%@:%@ Couldn't fetch joinpoints!",
          NSStringFromClass([self class]),
          NSStringFromSelector(_cmd));    
#endif
}


- (void)printFetchedJoinpointNames:(NSArray *)joinpoints
{
#ifdef RUNTIME_REPORT
    for (AOPJoinpoint *joinpoint in joinpoints)
    {
        NSLog(@"%@:%@ Joinpoint name: %@ associated class: %@",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              [joinpoint name],
              [[joinpoint class] rtClassName]);
    }
#endif
}


@end
