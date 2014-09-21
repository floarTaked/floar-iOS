//
//  MainViewController.m
//  KitMoreTest
//
//  Created by floar on 14-6-12.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "MainViewController.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FifthViewController.h"

@interface MainViewController ()<UITabBarControllerDelegate>

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBarback"]];
    
    FirstViewController *first = [[FirstViewController alloc] initWithNibName:NSStringFromClass([FirstViewController class]) bundle:nil];
    SecondViewController *second = [[SecondViewController alloc] initWithNibName:NSStringFromClass([SecondViewController class]) bundle:nil];
    ThirdViewController *third = [[ThirdViewController alloc] initWithNibName:NSStringFromClass([ThirdViewController class]) bundle:nil];
    FourthViewController *fourth = [[FourthViewController alloc] initWithNibName:NSStringFromClass([FourthViewController class]) bundle:nil];
    FifthViewController *fifth = [[FifthViewController alloc] initWithNibName:NSStringFromClass([FifthViewController class]) bundle:nil];
    
    NSMutableArray *viewsArray = [[NSMutableArray alloc] init];
    
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:first];
    [viewsArray addObject:firstNav];
    
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:second];
    [viewsArray addObject:secondNav];
    
    UINavigationController *thirdNav = [[UINavigationController alloc] initWithRootViewController:third];
    [viewsArray addObject:thirdNav];
    
    UINavigationController *fourthNav = [[UINavigationController alloc] initWithRootViewController:fourth];
    [viewsArray addObject:fourthNav];
    
    UINavigationController *fifthNav = [[UINavigationController alloc] initWithRootViewController:fifth];
    [viewsArray addObject:fifthNav];
    
    self.viewControllers = viewsArray;
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//+(MainViewController *)shareInstance
//{
//    static MainViewController *mainCtl;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        mainCtl = [[MainViewController alloc] init];
//    });
//    
//    return mainCtl;
//}
//
//+(id)allocWithZone:(struct _NSZone *)zone
//{
//    return [self shareInstance];
//}


#pragma mark - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
