//
//  AppDelegate.m
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "AppDelegate.h"
#import "LogicManager.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "BindPhoneViewController.h"
#import "FillInformationViewController.h"
#import "SplashViewController.h"
#import "NetworkEngine.h"

@implementation AppDelegate
@synthesize window;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[LogicManager sharedInstance] upgradeDataBase];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound];
    [self login];
    [self.window makeKeyAndVisible];
    if(!isSystemVersionIOS7())
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self initApplication];
    return YES;
}
-(void)initApplication
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
        [MobClick updateOnlineConfig];
        [WeiboSDK enableDebugMode:YES];
        [WeiboSDK registerApp:kAppKey];
        [WXApi registerApp:@"wxe394ac1a2cda0b0e"];
        NSString* uid = [[LogicManager sharedInstance] getPersistenceStringWithKey:USERID];
        if(uid != nil && [uid length]>0)
        {
            [[NetworkEngine sharedInstance] saveDeviceToken];
        }
        [[HeartBeatManager sharedInstane] start];
    });
}
-(void)login
{
    NSString* uid = [[LogicManager sharedInstance] getPersistenceStringWithKey:USERID];
    NSDate* expirationDate = [[LogicManager sharedInstance] getPersistenceDataWithKey:kExpirationDate];
    NSTimeInterval e = expirationDate == nil?0:[expirationDate timeIntervalSince1970];
    if(uid == nil || [uid length]<=0 || e < [[NSDate date] timeIntervalSince1970])
    {
        //UID为空 或者 时间已过期 需要先登录
        int first = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:FirstInstall];
        if(first == 1)
        {
            //不是第一次安装
            LoginViewController* login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:login];
        }
        else
        {
            //第一次安装
            SplashViewController* splash = [SplashViewController sharedInstance];
            [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:splash];
        }
    }
    else
    {
        UserInfo* myself = [UserInfo myselfInstance];
        /*if(myself.infoStep == 0)
        {
            //绑定手机
            BindPhoneViewController* bind = [[BindPhoneViewController alloc]initWithNibName:@"BindPhoneViewController" bundle:nil];
            [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:bind];
        }
        else if(myself.infoStep == 1)
        {
            //已绑定手机 填充资料
            FillInformationViewController* fill = [[FillInformationViewController alloc]initWithNibName:@"FillInformationViewController" bundle:nil];
            [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:fill];
        }
        else*/
        if (myself.infoStep == 2)
        {
            //已完善资料 进入主页
            MainViewController* main = [[MainViewController alloc]init];
            [[LogicManager sharedInstance] setRootViewContrller:main];
        }
        else
        {
            LoginViewController* login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:login];
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[HeartBeatManager sharedInstane] end];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[HeartBeatManager sharedInstane] end];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[HeartBeatManager sharedInstane] end];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[HeartBeatManager sharedInstane] start];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[HeartBeatManager sharedInstane] end];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString* path = [url absoluteString];
    if([[path substringToIndex:2] isEqualToString:@"wb"])
    {
        return [WeiboSDK handleOpenURL:url delegate:[LogicManager sharedInstance]];
    }
    else
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
}
#pragma --mark push notification
//向APNS申请token成功
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    if(pushToken != nil && [pushToken length]>0)
    {
        [UserInfo myselfInstance].token = pushToken;
        [[NetworkEngine sharedInstance] savePhoneToken:pushToken block:^(int event, id object) {}];
    }
}
//向APNS申请token失败
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *str = [NSString stringWithFormat: @"%@", err];
    NSLog(@"Failed to get token,err %@",str);
}
//获取到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge++;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    for (id key in userInfo)
    {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
}

//微信分享
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

//微信返回第三方应用的回调：返回微信处理第三方应用结果
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXHandleResult" object:resp];
//        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
    }
//    else if([resp isKindOfClass:[ class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}




@end
