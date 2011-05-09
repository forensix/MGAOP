// -----------------------------------------------------------------------------
//  DemoAspectsAppDelegate.m
//  MGAOP
//
//  MGAOP is available under *either* the terms of the modified BSD license
//  *or* the MIT License (2008). See http://opensource.org/licenses/alphabetical
//  for full text.
// 
//  Copyright (c) 2011, Manuel Gebele.
// -----------------------------------------------------------------------------

#import "DemoAspectsAppDelegate.h"

#import "SimpleSampleClass.h"
#import "TimeSampleClass.h"
#import "IllegalArgumentClass.h"
#import "IllegalArgumentAspect.h"

#undef  SAMPLE1
#undef  SAMPLE2
#define SAMPLE3

@implementation DemoAspectsAppDelegate

@synthesize window = _window;

- (AOPRuntime *)initAOPRuntime
{
    return [AOPRuntime sharedRuntime];
}


- (void)sample1
{
    AOPRuntime *runtime = [self initAOPRuntime];
    
    NSString *classPattern = @"SimpleSampleClass";
    NSString *methodPattern = @"initWith.+:";
    
    AOPAspect *loggingAspect
    = [AOPAspectCreator
       aspectOfType:kAOPAspectTypeLogging
       classPattern:classPattern
       methodPattern:methodPattern];
    
    [runtime declareAspect:loggingAspect];
}


- (void)sample2
{
    AOPRuntime *runtime = [self initAOPRuntime];
    
    NSString *classPattern = @"TimeSampleClass";
    NSString *methodPattern = @"timeSampleMethod.*";
    
    AOPAspect *timeProfilingAspect
    = [AOPAspectCreator
       aspectOfType:kAOPAspectTypeTimeProfiling
       classPattern:classPattern
       methodPattern:methodPattern];
    
    [runtime declareAspect:timeProfilingAspect];
}


- (void)sample3
{
    AOPRuntime *runtime = [self initAOPRuntime];
    
    NSString *classPattern = @"IllegalArgumentClass";
    NSString *methodPattern = @".*"; // All methods
    
    IllegalArgumentAspect *illegalArgumentAspect
    = [IllegalArgumentAspect
       illegalArgumentAspectForClassPattern:classPattern
       methodPattern:methodPattern];
    
    [runtime declareAspect:illegalArgumentAspect];
}


- (void)initAOPSamples
{
#ifdef SAMPLE1
    [self sample1];
    
    (void)[[[SimpleSampleClass alloc] initWithString:@"SAMPLE1"]
           autorelease];
    (void)[[[SimpleSampleClass alloc] initWithNumber:[NSNumber numberWithInt:12]]
           autorelease];
#endif
    
#ifdef SAMPLE2
    [self sample2];
    
    TimeSampleClass *timeSampleClass
    = [[[TimeSampleClass alloc] init] autorelease];
    
    [timeSampleClass timeSampleMethod1];
    [timeSampleClass timeSampleMethod2];
#endif
    
#ifdef SAMPLE3
    [self sample3];
    
    IllegalArgumentClass *illegalArgumentClass
    = [[[IllegalArgumentClass alloc] init] autorelease];
    
    [illegalArgumentClass addArgument:@"LegalArgument"];
    
    id illegalArgument = nil;
    [illegalArgumentClass addArgument:illegalArgument];
    
    NSArray *legalArguments = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    [illegalArgumentClass addArguments:legalArguments];
    
    NSArray *illegalArguments = nil;
    [illegalArgumentClass addArguments:illegalArguments];
    
    [illegalArgumentClass convertArgumentsBeforeAdding:illegalArguments];
    
#endif
    
}


- (BOOL)              application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initAOPSamples];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
