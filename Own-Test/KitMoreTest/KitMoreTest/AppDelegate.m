//
//  AppDelegate.m
//  KitMoreTest
//
//  Created by floar on 14-6-12.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    MainViewController *mainCtl = [[MainViewController alloc] init];
    [self setRootViewController:mainCtl];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


-(void)setRootViewController:(UIViewController *)viewController
{
    UIColor *color = [UIColor colorWithRed:150.0/255.0 green:202.0/255.0 blue:174.0/255.0 alpha:0.12];
    [[UINavigationBar appearance] setTintColor:color];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *navBarTextAttributes = [[NSMutableDictionary alloc] init];
    [navBarTextAttributes setObject:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0] forKey:NSForegroundColorAttributeName];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [navBarTextAttributes setObject:shadow forKey:NSShadowAttributeName];
    [navBarTextAttributes setObject:[NSNumber numberWithDouble:[UIFont systemFontSize]] forKey:NSFontAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTextAttributes];
    
    NSMutableDictionary *navBarItemTextAttributes = [[NSMutableDictionary alloc] init];
    [navBarItemTextAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    NSShadow *navBarItemShadow = [[NSShadow alloc] init];
    navBarItemShadow.shadowColor =[UIColor whiteColor];
    navBarItemShadow.shadowOffset = CGSizeMake(0, 0);
//    [textAttributes setObject:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)] forKey:UITextAttributeTextShadowOffset];
    [navBarItemTextAttributes setObject:navBarItemShadow forKey:NSShadowAttributeName];
    [[UIBarButtonItem appearance] setTitleTextAttributes:navBarItemTextAttributes forState:UIControlStateSelected];
    
    self.window.rootViewController = viewController;
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
