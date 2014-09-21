//
//  OldUserLoginViewController.m
//  闺秘
//
//  Created by floar on 14-7-7.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "OldUserLoginViewController.h"
#import "NetWorkEngine.h"
#import "UserInfo.h"
#import "Package.h"
#import "LogicManager.h"
#import "MainViewController.h"
#import "SplashViewController.h"
#import <MBProgressHUD.h>

@interface OldUserLoginViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITextField *phoneNum;
    
    __weak IBOutlet UITextField *secretNum;
    
    __weak IBOutlet UIImageView *arrowImg;
    
    __weak IBOutlet UIButton *loginBtn;
    
    NSString *rightPhoneNum;
    NSString *rightPassword;
    
    MBProgressHUD *hub;
    
}

@end

@implementation OldUserLoginViewController

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
    
    [self.navigationItem setTitleString:@"已有账号登陆"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -10, 0, 10) target:self selector:@selector(oldGoToBack)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForServer:) name:ServerOK object:nil];
    
    [arrowImg AnimationLeftAndRight:26];
    [phoneNum becomeFirstResponder];
    
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:OldUserLoginCode block:^(int event, id object)
    {
        if (1 == event)
        {
            loginBtn.enabled = YES;
            Package *pack = (Package *)object;
            if ([pack  handleLogin:pack withErrorCode:PasswordCheckError])
            {
                hub.labelText = @"登陆成功";
                [hub hide:YES afterDelay:0.5 complete:^{
                    [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:[MainViewController sharedInstance]];
                }];
                
            }
            else
            {
                hub.mode = MBProgressHUDModeText;
                hub.labelText = @"登陆失败";
                [hub hide:YES afterDelay:1];
            }
        }
    }];
}

-(BOOL)checkPhoneNumber
{
    if(phoneNum.text==nil || [phoneNum.text length]<=0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"手机号码不能为空,请输入手机号码"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
    }
    else
    {
        if(![[LogicManager sharedInstance] isMobileNumber:phoneNum.text])
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"手机号码格式不正确,请输入真实的手机号码"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
            
            [alert show];
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

-(BOOL)checkSecretNumber
{
    
    if(secretNum.text==nil || [secretNum.text length]<=0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"密码不能为空,请输入秘密"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
    }
    else
    {
        if(![self isSecretNum])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

-(BOOL)isSecretNum
{
    int secretLength = [secretNum.text length];
    if( secretLength != 6 )
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"密码位数不对，请重新输入6位数字密码" actionText:@"确定"];
        return NO;
    }
    else
    {
        return YES;
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)oldUserLogin:(id)sender
{
    
    if([self checkPhoneNumber] && [self checkSecretNumber])
    {
        rightPhoneNum = phoneNum.text;
        rightPassword = secretNum.text;
        [self checkForLogin];
    }
}

-(void)checkForLogin
{
    hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.labelText = @"登录中...";
    hub.delegate = self;
    [hub show:YES];
    [self.view addSubview:hub];
    loginBtn.enabled = NO;
    
    Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x02];
    [pack loginWithAccountType:0x01 accountName:rightPhoneNum password:rightPassword];
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:OldUserLoginCode block:^(int event, id object) {
        
    }];
}

-(void)requestForServer:(NSNotification *)note
{
    BOOL isServerOK = [[note object] boolValue];
    if (isServerOK)
    {
        [self checkForLogin];
    }
}

-(void)oldGoToBack
{
    [[LogicManager sharedInstance] setRootViewContrller:[SplashViewController sharedInstance]];
}

#pragma mark - TextFiledDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == phoneNum)
    {
        [UIView animateWithDuration:0.5 animations:^{
            arrowImg.frame = CGRectMake(CGRectGetMinX(arrowImg.frame), CGRectGetMinY(phoneNum.frame)+13, CGRectGetWidth(arrowImg.frame), CGRectGetHeight(arrowImg.frame));
        }];
    }
    else if (textField == secretNum)
    {
        [UIView animateWithDuration:0.5 animations:^{
            arrowImg.frame = CGRectMake(CGRectGetMinX(arrowImg.frame), CGRectGetMinY(secretNum.frame)+13, CGRectGetWidth(arrowImg.frame), CGRectGetHeight(arrowImg.frame));
        }];
    }
}

@end
