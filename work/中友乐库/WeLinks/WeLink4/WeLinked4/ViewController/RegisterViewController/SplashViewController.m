//
//  SplashViewController.m
//  WeLinked4
//
//  Created by jonas on 5/12/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "SplashViewController.h"
#import "UINavigationItemCustom.h"
#import "LoginViewController.h"
#import "LogicManager.h"
#import "PhoneViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

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
    
    self.view.frame = [UIScreen mainScreen].bounds;
//    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
//                                imageSelected:[UIImage imageNamed:@"backSelected"]
//                                        title:@"返回"
//                                        inset:UIEdgeInsetsMake(0, -30, 0, 0)
//                                       target:self
//                                     selector:@selector(back:)];
//    [self.navigationItem setTitleString:@"你好"];
    
    if([UIScreen mainScreen].bounds.size.height > 480)
    {
        bkImageView.image = [UIImage imageNamed:@"background960"];
    }
    else
    {
        bkImageView.image = [UIImage imageNamed:@"background1136"];
    }
    selected = YES;
}
-(IBAction)checkMark:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    selected = !selected;
    if(selected)
    {
        start.enabled = YES;
        [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    else
    {
        start.enabled = NO;
        [btn setImage:[UIImage imageNamed:@"unSelected"] forState:UIControlStateNormal];
    }
}
-(IBAction)start:(id)sender
{
    PhoneViewController* phone = [[PhoneViewController alloc]initWithNibName:@"PhoneViewController" bundle:nil];
    [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:phone];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
+(SplashViewController*)sharedInstance
{
    static SplashViewController* m_instance = nil;
    if(m_instance == nil)
    {
        m_instance = [[SplashViewController alloc]init];
    }
    return m_instance;
}
@end
