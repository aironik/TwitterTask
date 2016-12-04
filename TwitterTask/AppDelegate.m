//
//  AppDelegate.m
//  TwitterTask
//
//  Created by Oleg Lobachev on 22/11/2016.
//  Copyright © 2016 aironik. All rights reserved.
//

#import "AppDelegate.h"

#if HAVE_DEBUG_REVEAL_FEATURE
    #import <dlfcn.h>
#endif // HAVE_DEBUG_REVEAL_FEATURE

#import "ATTDataManager.h"
#import "ATTSearchViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self startDebugFeatures];
    
    self.dataManager = [[ATTDataManager alloc] init];
    [self.dataManager start];

    UITabBarController *tcb = (UITabBarController *)self.window.rootViewController;
    ATTSearchViewController *searchViewController = (ATTSearchViewController *)tcb.viewControllers[0];
    searchViewController.dataManager = self.dataManager;

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)startDebugFeatures {
#if HAVE_DEBUG_REVEAL_FEATURE
    [self startDebugReveal];
#endif // HAVE_DEBUG_REVEAL_FEATURE
}


#if HAVE_DEBUG_REVEAL_FEATURE
- (void)startDebugReveal {
    NSString *dyLibPath = @"/Applications/Reveal_1_6_3.app/Contents/SharedSupport/iOS-Libraries/libReveal.dylib";
    NSLog(@"Loading dynamic library: %@", dyLibPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:dyLibPath]) {
        NSLog(@"Cannot find Reveal library. Reveal didn't loaded.");
    }
    else {
        void *revealLib = NULL;
        revealLib = dlopen([dyLibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);

        if (revealLib == NULL) {
            char *error = dlerror();
            NSLog(@"Reveal dlopen error: %s", error);
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IBARevealRequestStart" object:self];
        }
    }
}
#endif // HAVE_DEBUG_REVEAL_FEATURE


@end
