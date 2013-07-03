//
//  AppDelegate.m
//  Reddit Reader
//
//  Created by Coby Plain on 20/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#import "AppDelegate.h"

#import "MainPageViewController.h"
#import "CommentsPageViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainPageViewController *viewController = [[MainPageViewController alloc] initWithNibName:@"MainPageViewController" bundle:nil];
    UINavigationController *navigController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    navigController.navigationBar.tintColor = [UIColor colorWithRed:(220.0f/255.0f) green:(220.0f/255.0f) blue:(220.0f/255.0f) alpha:1.0f];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], UITextAttributeTextColor,
                                                           [UIColor clearColor],UITextAttributeTextShadowColor,
                                                           nil]];

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        self.window.rootViewController = navigController;
    }
    else
    {
        UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
        CommentsPageViewController *rightViewController = [[CommentsPageViewController alloc] initWithNibName:@"CommentsPageViewController" bundle:nil];
        UINavigationController *rightNavigController = [[UINavigationController alloc] initWithRootViewController:rightViewController];
        
        rightNavigController.navigationBar.tintColor = [UIColor colorWithRed:(220.0f/255.0f) green:(220.0f/255.0f) blue:(220.0f/255.0f) alpha:1.0f];

        splitViewController.viewControllers = [NSArray arrayWithObjects:navigController, rightNavigController, nil];
        splitViewController.delegate = rightViewController;
        viewController.delegate = rightViewController;
        
        self.window.rootViewController = splitViewController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
