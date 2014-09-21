//
//  LoginViewController.m
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "LoginViewController.h"
#import <WeiboSDK.h>
#import "UINavigationItem+WMStyle.h"
#import "LogicManager.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "AgreementViewController.h"
#import "BindPhoneViewController.h"
#import "FillInformationViewController.h"
@interface LoginViewController ()
{
}
@end

@implementation LoginViewController

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
//    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleConfirm title:@"确定" target:nil selector:nil];
//    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back:)];
    [self.navigationItem setTitleViewWithText:@"新浪微博登录"];
    if([UIScreen mainScreen].bounds.size.height > 480)
    {
        background.image = [UIImage imageNamed:@"loginBack2"];
    }
    else
    {
        background.image = [UIImage imageNamed:@"loginBack1"];
    }
    [self.navigationController setNavigationBarHidden:NO];
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    HUD.labelText = @"Loading...";
    
    [self.navigationController.view addSubview:HUD];
    
    
    NSString*str = @"我已仔细阅读并同意《职脉用户使用协议》";
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:str];
    
    [string addAttribute:NSBackgroundColorAttributeName
                   value:[UIColor clearColor]
                   range:NSMakeRange(0,[str length])];
    
    [string addAttribute:NSForegroundColorAttributeName
                   value:colorWithHex(0x596c96)
                   range:NSMakeRange(0,[str length])];
    
    [string addAttribute:NSFontAttributeName
                   value:getFontWith(YES, 12)
                   range:NSMakeRange(0,[str length])];
    
    [string addAttribute:NSUnderlineStyleAttributeName
                   value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                   range:NSMakeRange(0,[str length])];
    [agreementLabel setAttributedText:string];
    agreementLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer* gues = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreement:)];
    [agreementLabel addGestureRecognizer:gues];
    agree = YES;
    [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:1] withKey:FirstInstall];
}
-(void)agreement:(id)sender
{
    AgreementViewController* control = [[AgreementViewController alloc]initWithNibName:@"AgreementViewController" bundle:nil];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:control];
    [self presentViewController:navController animated:YES completion:nil];
    
}
-(IBAction)clickAgreement:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    agree = !agree;
    loginButton.enabled = agree;
    if(agree)
    {
        [btn setImage:[UIImage imageNamed:@"btn_selectFriend_s"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"btn_select_friend_n"] forState:UIControlStateNormal];
    }
}
//-(void)back:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)loginSina:(id)sender
{
    [HUD show:YES];
    [[NetworkEngine sharedInstance] weiboLogin:^(int event, id object)
    {
        [HUD hide:YES];
        if(event == 0)
        {
            
        }
        else if (event == 1)
        {
//            [(AppDelegate*)([UIApplication sharedApplication].delegate) login];
            UserInfo* myself = [UserInfo myselfInstance];
            if(myself.infoStep == 0)
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
             else if (myself.infoStep == 2)
             {
                 //已完善资料 进入主页
                 MainViewController* main = [[MainViewController alloc]init];
                 [[LogicManager sharedInstance] setRootViewContrller:main];
             }
        }
    }];
}
//-(IBAction)sendWeibo:(id)sender
//{
//    [[LogicManager sharedInstance] sendWeiBo:@"发微博"];
//}
@end
