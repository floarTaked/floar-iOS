//
//  IdentifyViewController.m
//  闺秘
//
//  Created by floar on 14-7-7.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "IdentifyViewController.h"
#import "NetWorkEngine.h"
#import "LogicManager.h"
#import "UserInfo.h"
//#import "MainViewController.h"
#import "PhoneIntroViewController.h"
#import <MBProgressHUD.h>

@interface IdentifyViewController ()<MBProgressHUDDelegate>
{
    
    __weak IBOutlet UILabel *phoneNumLabel;
    
    __weak IBOutlet UITextField *identifyTextField;
    
    __weak IBOutlet UIImageView *identifyArrow;
    
    MBProgressHUD *hud;
}

@end

@implementation IdentifyViewController

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
    
    [identifyTextField becomeFirstResponder];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -10, 0, 10) target:self selector:@selector(IdentifyGoToBack)];

    [self.navigationItem setTitleString:@"输入验证码"];
    phoneNumLabel.text = self.phoneNum;
    phoneNumLabel.textColor = colorWithHex(DeepRedColor);
    
    [identifyArrow AnimationLeftAndRight:26];
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:CheckIdentifyCode block:^(int event, id object)
     {
         if(event == 1)
         {
             identifyBtn.enabled = YES;
             Package *pack = (Package *)object;
             if ([pack handleRegist:pack WithWrite:YES withErrorCode:IdentifyCodeCheckError])
             {
                 hud.mode = MBProgressHUDModeIndeterminate;
                 hud.labelText = @"验证成功";
                 PhoneIntroViewController *phoneCtl = [[PhoneIntroViewController alloc] initWithNibName:NSStringFromClass([PhoneIntroViewController class]) bundle:nil];
                 [hud hide:YES afterDelay:1.0 complete:^{
//                     [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:[MainViewController sharedInstance]];
                     [[LogicManager sharedInstance] setRootViewContrller:phoneCtl];
                 }];
             }
             else
             {
                 [hud hide:YES];
             }
         }
     }];
    
}

- (IBAction)identifyCode:(id)sender
{
    if (identifyTextField.text == nil || [identifyTextField.text isEqualToString:@""] || [identifyTextField.text length] < 1)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"验证码不能为空" actionText:@"确定"];
    }
    else
    {
        int length = [identifyTextField.text length];
        if (length > 4 || length < 1)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"验证码位数不对" actionText:@"确定"];
        }
        else
        {
            Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x01];
            [pack registWithAccountType:0x01 accountName:self.phoneNum setp:0x02 identifyCode:identifyTextField.text password:self.password];
            
            identifyBtn.enabled = NO;
            [identifyTextField resignFirstResponder];
            hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.delegate = self;
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"验证中...";
            [hud show:YES];
            [self.view addSubview:hud];
            [[NetWorkEngine shareInstance] sendData:pack UniqueCode:CheckIdentifyCode block:^(int event, id object) {
                
            }];
        }
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)IdentifyGoToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
