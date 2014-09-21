//
//  MainViewController.m
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "MainViewController.h"
#import "TipCountView.h"
#import "PhoneBookInfo.h"
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
    UIImage* img = [[UIImage alloc]init];
    self.tabBar.selectionIndicatorImage = img;
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        }
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor grayColor]
                                                        }
                                             forState:UIControlStateNormal];
    myFriendsViewController = [[FriendsViewController alloc]initWithNibName:@"FriendsViewController" bundle:nil];
    jobViewController= [[JobViewController alloc]initWithNibName:@"JobViewController" bundle:nil];
    informationViewController= [[InformarionViewController alloc]initWithNibName:@"InformarionViewController" bundle:nil];
    messageViewController= [[FeedsViewController alloc]initWithNibName:@"FeedsViewController" bundle:nil];
    profileViewContrller= [[MineProfileViewController alloc]initWithNibName:@"MineProfileViewController" bundle:nil];
    
    NSMutableArray* viewarray = [[NSMutableArray alloc]init];
    
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:myFriendsViewController];
    [viewarray addObject:nav];
    
    nav = [[UINavigationController alloc]initWithRootViewController:jobViewController];
    [viewarray addObject:nav];
    
    nav = [[UINavigationController alloc]initWithRootViewController:informationViewController];
    [viewarray addObject:nav];
    
    nav = [[UINavigationController alloc]initWithRootViewController:messageViewController];
    [viewarray addObject:nav];
    
    nav = [[UINavigationController alloc]initWithRootViewController:profileViewContrller];
    [viewarray addObject:nav];
    
    self.viewControllers = viewarray;
    self.hidesBottomBarWhenPushed = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self uploadPhoneBook];
    });
    [[NetworkEngine sharedInstance] getMyFriends:^(int event, id object){}];
//    [self startLoadingData];
}
-(void)uploadPhoneBook
{
    //上传通讯录
    [[LogicManager sharedInstance] getContactFriends:^(int event, id object)
     {
         if (event == 1)
         {
             NSMutableArray* contactsDataSource = [[NSMutableArray alloc]init];
             NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[PhoneBookInfo class] tableName:nil condition:nil];
             if(arr != nil && [arr count]>0)
             {
                 for (PhoneBookInfo* book in arr)
                 {
                     NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:book.name,@"name",book.phone,@"phone", nil];
                     [contactsDataSource addObject:dic];
                 }
                 NSString* json = [[LogicManager sharedInstance] objectToJsonString:contactsDataSource];
                 [[NetworkEngine sharedInstance] uploadContact:json block:^(int event, id object){}];
             }
         }
     }];
}
//-(void)stopLoadingData
//{
//    if(loadingBackView != nil)
//    {
//        [loadingBackView removeFromSuperview];
//    }
//    if(HUD != nil)
//    {
//        [HUD hide:YES];
//        [HUD removeFromSuperview];
//    }
//}
//-(void)updataProgressUI
//{
//    HUD.labelText = [NSString stringWithFormat:@"  %d%%        ",progress];
//    HUD.progress = ((float)progress)/100.0;
//    if(progress >= 100)
//    {
//        [self stopLoadingData];
//    }
//}
//-(void)startLoadingData
//{
//    if(![LogicManager sharedInstance].needLoadData)
//    {
//        return;
//    }
//    loadingBackView = [self.view viewWithTag:10000];
//    if(loadingBackView == nil)
//    {
//        loadingBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        loadingBackView.backgroundColor = [UIColor blackColor];
//        loadingBackView.alpha = 0.5;
//        [self.view addSubview:loadingBackView];
//        loadingBackView.tag = 10000;
//    }
//    HUD = (MBProgressHUD*)[self.view viewWithTag:20000];
//    if(HUD == nil)
//    {
//        HUD = [[MBProgressHUD alloc] initWithView:self.view];
//        HUD.mode = MBProgressHUDModeIndeterminate;
//        HUD.tag = 20000;
//        [self.view addSubview:HUD];
//        [HUD show:YES];
//    }
//    [self updataProgressUI];
//
//[[NetworkEngine sharedInstance] getMyFriends:^(int event, id object)
// {
//     progress += 50;
//     [self updataProgressUI];
// }];
//static int count = 0;
//[[LogicManager sharedInstance] getHomeTimeline:^(int event, id object)
//{
//    if(event == 0)
//    {
//        progress += 50-count;
//    }
//    else if (event == 1)
//    {
//        int page = [(NSNumber*)object intValue];
//        count += page;
//        if(count <= 50)
//        {
//            progress += page;
//        }
//        else
//        {
//            count = 50;
//        }
//    }
//    [self updataProgressUI];
//}];
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitleViewWithText:self.selectedViewController.tabBarItem.title];
    //newfriend:新的联系人 friends:联系人列表 msg:消息 feeds:职脉圈
    static int msgCount = 0;
    static int newFriendCount = 0;
    [[HeartBeatManager sharedInstane] registerInvokeMethod:@"msg" callback:^(int event, id object)
     {
         int newMsg = [(NSNumber*)object intValue];
         if(newMsg > 0)
         {
             [[NetworkEngine sharedInstance] receiveUnreadMessage:^(int event, id object)
             {
                 if(event == 1)
                 {
                     msgCount = [[LogicManager sharedInstance] getUnReadMessageCountWithOtherUser:nil];
                     if(msgCount+newFriendCount > 0)
                     {
                         profileViewContrller.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",msgCount+newFriendCount];
                     }
                     else
                     {
                         profileViewContrller.tabBarItem.badgeValue = nil;
                     }
                 }
             }];
         }
         else
         {
             msgCount = [[LogicManager sharedInstance] getUnReadMessageCountWithOtherUser:nil];
             if(msgCount+newFriendCount > 0)
             {
                 profileViewContrller.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",msgCount+newFriendCount];
             }
             else
             {
                 profileViewContrller.tabBarItem.badgeValue = nil;
             }
         }
     }];
    [[HeartBeatManager sharedInstane] registerInvokeMethod:@"newfriend" callback:^(int event, id object)
     {
         newFriendCount = [(NSNumber*)object intValue];
         if(msgCount+newFriendCount > 0)
         {
             profileViewContrller.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",msgCount+newFriendCount];
         }
         else
         {
             profileViewContrller.tabBarItem.badgeValue = nil;
         }
     }];
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
    if(tabBarController.selectedIndex == 4)
    {
        [[HeartBeatManager sharedInstane] setDataWithKey:@"newfriend" value:[NSNumber numberWithInt:0]];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
