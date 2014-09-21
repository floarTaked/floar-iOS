//
//  MainViewController.m
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "MainViewController.h"
#import "PhoneBookInfo.h"
#import "HeartBeatManager.h"
@interface MainViewController ()
{
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBarback"]];
    cardHolderViewController = [[CardHolderViewController alloc]initWithNibName:@"CardHolderViewController" bundle:nil];
    messageListViewController= [[MessageListViewController alloc]initWithNibName:@"MessageListViewController" bundle:nil];
    scanningViewController= [[ScanningViewController alloc]initWithNibName:@"ScanningViewController" bundle:nil];
    feedsViewController= [[FriendCircleViewController alloc]initWithNibName:@"FriendCircleViewController" bundle:nil];
    mineProfileViewController= [[MineProfileViewController alloc]initWithNibName:@"MineProfileViewController" bundle:nil];
    
    NSMutableArray* viewarray = [[NSMutableArray alloc]init];
    
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:cardHolderViewController];
    [viewarray addObject:nav];
    
    nav = [[UINavigationController alloc]initWithRootViewController:messageListViewController];
    [viewarray addObject:nav];
    
    nav = [[UINavigationController alloc]initWithRootViewController:scanningViewController];
    [viewarray addObject:nav];
    
    nav = [[UINavigationController alloc]initWithRootViewController:feedsViewController];
    [viewarray addObject:nav];
    
    nav = [[UINavigationController alloc]initWithRootViewController:mineProfileViewController];
    [viewarray addObject:nav];
    
    self.viewControllers = viewarray;
    self.hidesBottomBarWhenPushed = YES;
    runOnAsynQueue(^{
        //上传通讯录
        [[LogicManager sharedInstance] getContactFriends:^(int event, id object)
         {
             if (event == 1 && object != nil)
             {
                 NSString* json = [[LogicManager sharedInstance] objectToJsonString:[(NSDictionary*)object objectForKey:@"dic"]];
                 [[NetworkEngine sharedInstance] savePhoneFriends:json block:^(int event, id object){}];
             }
         }];
    });
    [[NetworkEngine sharedInstance] getFriends:^(int event, id object){}];
//    [self startLoadingData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitleString:self.selectedViewController.tabBarItem.title];
    if(self.selectedIndex == 2)
    {
        [self setSelectedIndex:0];
    }
    //newfriend:新的联系人 friends:联系人列表 msg:消息 feeds:职脉圈
//    static int msgCount = 0;
//    static int newFriendCount = 0;
//    [[HeartBeatManager sharedInstane] registerInvokeMethod:@"msg" callback:^(int event, id object)
//     {
//         int newMsg = [(NSNumber*)object intValue];
//         if(newMsg > 0)
//         {
//             [[NetworkEngine sharedInstance] receiveUnreadMessage:^(int event, id object)
//             {
//                 if(event == 1)
//                 {
//                     msgCount = [[LogicManager sharedInstance] getUnReadMessageCountWithOtherUser:nil];
//                     if(msgCount+newFriendCount > 0)
//                     {
//                         profileViewContrller.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",msgCount+newFriendCount];
//                     }
//                     else
//                     {
//                         profileViewContrller.tabBarItem.badgeValue = nil;
//                     }
//                 }
//             }];
//         }
//         else
//         {
//             msgCount = [[LogicManager sharedInstance] getUnReadMessageCountWithOtherUser:nil];
//             if(msgCount+newFriendCount > 0)
//             {
//                 profileViewContrller.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",msgCount+newFriendCount];
//             }
//             else
//             {
//                 profileViewContrller.tabBarItem.badgeValue = nil;
//             }
//         }
//     }];
//    [[HeartBeatManager sharedInstane] registerInvokeMethod:@"newfriend" callback:^(int event, id object)
//     {
//         newFriendCount = [(NSNumber*)object intValue];
//         if(msgCount+newFriendCount > 0)
//         {
//             profileViewContrller.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",msgCount+newFriendCount];
//         }
//         else
//         {
//             profileViewContrller.tabBarItem.badgeValue = nil;
//         }
//     }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController*)viewController
{
    return YES;
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController*)viewController
{
    if(self.selectedIndex == 2)
    {
        [scanningViewController loadCamera];
    }
    if(self.selectedIndex == 4)
    {
        //        [[HeartBeatManager sharedInstane] setDataWithKey:@"newfriend" value:[NSNumber numberWithInt:0]];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
+(MainViewController*)sharedInstance
{
    static MainViewController* m_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_instance = [[MainViewController alloc]init];
    });
    return m_instance;
}
@end
