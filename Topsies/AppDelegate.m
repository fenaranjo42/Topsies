//
//  AppDelegate.m
//  Topsies
//
//  Created by Felipe on 10/28/15.
//  Copyright © 2015 Felipe's Apps. All rights reserved.
//

#import "AppDelegate.h"

#import "TOPItemsViewController.h"
#import "TOPItemStore.h"
#import "TOPHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create an ItemsViewController
    //TOPItemsViewController *itemsViewController = //[[TOPItemsViewController alloc] init];
    
    TOPHomeViewController *home = [[TOPHomeViewController alloc] init];
    
    // Create an instance of UINavigationController; its stack contains only itemsViewController
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:home];
    
    navController.navigationBar.barTintColor = [UIColor colorWithRed:0.119f green:0.161f blue:0.225f alpha:1.00f];
    navController.toolbar.barTintColor = [UIColor colorWithRed:0.119f green:0.161f blue:0.225f alpha:1.00f];

                                                
    // Place navigation controller's view in the window hierarchy
    self.window.rootViewController = navController;
    
    self.window.backgroundColor = [UIColor colorWithRed:0.212f green:0.275f blue:0.365f alpha:1.00f];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL success = [[TOPItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the TOPItems");
    } else {
        NSLog(@"Could not save any of the TOPItems");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
