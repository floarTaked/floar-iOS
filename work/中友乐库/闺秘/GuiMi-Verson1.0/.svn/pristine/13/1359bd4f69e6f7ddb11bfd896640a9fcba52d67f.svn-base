//
//  AppDelegate.m
//  闺秘
//
//  Created by jonas on 6/23/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "AppDelegate.h"
#import "LogicManager.h"
#import "NetWorkEngine.h"
#import "LoginViewController.h"
#import "SplashViewController.h"
#import "MainViewController.h"
#import "UserInfo.h"

@implementation AppDelegate

-(void)login
{
    NSString* uid = [[LogicManager sharedInstance] getPersistenceStringWithKey:USERID];
    if(uid == nil || [uid length]<=0)
    {
//        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithUnsignedLongLong:23] withKey:USERID];
        //UID为空 需要先登录
//        int first = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:FirstInstall];
//        if(first == 1)
//        {
//            //不是第一次安装
//            LoginViewController* login = [[LoginViewController alloc]init];
//            [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:login];
//        }
//        else
//        {
            //第一次安装
            SplashViewController* splash = [SplashViewController sharedInstance];
            [[LogicManager sharedInstance] setRootViewContrller:splash];
//        }
    }
    else
    {
//        UserInfo* myself = [UserInfo myselfInstance];
//        if(myself.userId != 0)
//        {
            //进入主界面
            [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:[MainViewController sharedInstance]];
//        }
//        else if (myself.userId == 0)
//        {
//            [[LogicManager sharedInstance] setRootViewContrller:[SplashViewController sharedInstance]];
//        }
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert |
                                                    UIRemoteNotificationTypeBadge |
                                                    UIRemoteNotificationTypeSound];
    
    [[NetWorkEngine shareInstance] connectToServer];
    [self login];
    
    [self initApplication];
    [WXApi registerApp:@"wxa01fe5b6c263680a"];
    [WeiboSDK registerApp:@"3547924220"];
//    NSLog(@"%@",NSHomeDirectory());
    DLog(@"%@",NSHomeDirectory());
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)initApplication
{
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
//    {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//    }
//    else
//    {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
//    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WeiboSDK enableDebugMode:YES];
        [WeiboSDK registerApp:kAppKey];
        
    });
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

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *path = [url absoluteString];
    if([[path substringToIndex:2] isEqualToString:@"wb"])
    {
        return [WeiboSDK handleOpenURL:url delegate:[LogicManager sharedInstance]];
    }
    else
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *path = [url absoluteString];
    if([[path substringToIndex:2] isEqualToString:@"wb"])
    {
        return [WeiboSDK handleOpenURL:url delegate:[LogicManager sharedInstance]];
    }
    else
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
}

-(void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXHandleResult" object:resp];
    }
}

//-(void)onReq:(BaseReq *)req
//{
//    if([req isKindOfClass:[GetMessageFromWXReq class]])
//    {
//        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
//        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
//        NSLog(@"%@",strTitle);
//    }
//
//}

@end
