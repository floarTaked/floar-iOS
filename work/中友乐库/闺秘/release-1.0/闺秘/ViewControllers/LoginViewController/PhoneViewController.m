//
//  PhoneViewController.m
//  WeLinked4
//
//  Created by jonas on 5/19/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "PhoneViewController.h"
#import "LogicManager.h"
#import "NetWorkEngine.h"
#import "AppDelegate.h"
#import "ShareBlurView.h"
#import <UIImage+Screenshot.h>
#import "SplashViewController.h"
#import "IdentifyViewController.h"

#import "UserInfo.h"

@interface PhoneViewController ()
{
    
    __weak IBOutlet UIImageView *phoneArrow;
    
    __weak IBOutlet UITextField *secretTextField;
}

@end

@implementation PhoneViewController

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
    [self.navigationItem setTitleString:@"加入闺秘"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -10, 0, 10) target:self selector:@selector(phoneViewGotoBack)];
    
    [phoneArrow AnimationLeftAndRight:26];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ShareBlurView *blurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

        [blurView shareBlurWithImage:[UIImage screenshot] withBlurType:BlurSplashPhoneType];
        
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.window.windowLevel = UIWindowLevelAlert;
        [self.navigationController.view addSubview:blurView];

    });
    
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:SendIdentifyCode block:^(int event, id object)
     {
         if (1 == event)
         {
             Package *pack = (Package *)object;
             if ([pack handleRegist:pack WithWrite:NO withErrorCode:NoCheckErrorCode])
             {
//                 NSLog(@"获取验证码成功");
                 DLog(@"获取验证码成功");
             }
         }
     }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.window.windowLevel = UIWindowLevelNormal;
}

-(BOOL)checkPhoneNumber
{
    if(inputPhone.text==nil || [inputPhone.text length]<=0)
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
        if(![[LogicManager sharedInstance] isMobileNumber:inputPhone.text])
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
    
    if(secretTextField.text==nil || [secretTextField.text length]<=0)
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
    int secretLength = [secretTextField.text length];
    if( secretLength != 6 )
    {
        [self showAlertViewWithMessage:@"密码位数不对，请重新输入6位数字密码"];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(IBAction)resendCode:(id)sender
{
    if([self checkPhoneNumber] && [self checkSecretNumber])
    {
        checkedNumber = inputPhone.text;
        checkedSecretNumber = secretTextField.text;
        [self requestCode];
        IdentifyViewController *identify = [[IdentifyViewController alloc] initWithNibName:NSStringFromClass([IdentifyViewController class]) bundle:nil];
        identify.phoneNum = checkedNumber;
        identify.password = checkedSecretNumber;
        [self.navigationController pushViewController:identify animated:YES];
    }
}

-(void)requestCode
{
    if(checkedNumber == nil || [checkedNumber length]<=0)
    {
        return;
    }
    
    Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x01];
    [pack registWithAccountType:0x01 accountName:checkedNumber setp:0x01 identifyCode:@"" password:checkedNumber];
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:SendIdentifyCode block:^(int event, id object) {
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)phoneViewGotoBack
{
    [[LogicManager sharedInstance] setRootViewContrller:[SplashViewController sharedInstance]];
}

-(void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
    
    [alert show];
}

#pragma mark - TextFiledDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == inputPhone)
    {
        [UIView animateWithDuration:0.5 animations:^{
            phoneArrow.frame = CGRectMake(CGRectGetMinX(phoneArrow.frame), CGRectGetMinY(inputPhone.frame)+13, CGRectGetWidth(phoneArrow.frame), CGRectGetHeight(phoneArrow.frame));
        }];
    }
    else if (textField == secretTextField)
    {
        [UIView animateWithDuration:0.5 animations:^{
            phoneArrow.frame = CGRectMake(CGRectGetMinX(phoneArrow.frame), CGRectGetMinY(secretTextField.frame)+13, CGRectGetWidth(phoneArrow.frame), CGRectGetHeight(phoneArrow.frame));
        }];
    }
}

@end
