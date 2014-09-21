//
//  BindPhoneViewController.m
//  WeLinked3
//
//  Created by jonas on 3/5/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "FillInformationViewController.h"
#import "LogicManager.h"
#import "AppDelegate.h"
@interface BindPhoneViewController ()

@end

@implementation BindPhoneViewController

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
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:nil selector:nil];
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleConfirm
                                                                  title:@"确定"
                                                                 target:self
                                                               selector:@selector(submit:)];
    [self.navigationItem setTitleViewWithText:@"绑定手机"];
    
    phoneNumber.font = getFontWith(YES, 16);
    [phoneNumber becomeFirstResponder];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = colorWithHex(0x444444);
    [descLabel setText:@"为了确保信息的真实性,请验证手机号码"];
    descLabel.shadowColor = [UIColor whiteColor];
    descLabel.shadowOffset = CGSizeMake(0, 1.0);
    
    
    
    
    resendButton.titleLabel.font = getFontWith(YES, 16);
    resendButton.titleLabel.textColor = [UIColor whiteColor];
    resendButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    codeTextField.delegate = self;
    codeTextField.textAlignment = NSTextAlignmentLeft;
    codeTextField.font = getFontWith(YES, 16);
    codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}
-(void)submit:(id)sender
{
    if(codeTextField.text==nil || [codeTextField.text length]<=0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"验证码不能为空,请输入验证码"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    [[NetworkEngine sharedInstance] bindPhone:checkedNumber verifiCode:codeTextField.text block:^(int event, id object)
    {
        if(event == 0)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil
                                                      message:(NSString *)object
                                                   actionText:@"确定"];
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
        }
    }];
}
-(BOOL)checkPhoneNumber
{
    if(phoneNumber.text==nil || [phoneNumber.text length]<=0)
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
        if(![[LogicManager sharedInstance] isMobileNumber:phoneNumber.text])
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
-(IBAction)resendCode:(id)sender
{
    if([self checkPhoneNumber])
    {
        checkedNumber = phoneNumber.text;
        [self requestCode];
    }
}
-(void)startTick
{
    if(timer == nil)
    {
        timeTick = 60;
        timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startTick) userInfo:nil repeats:YES];
    }
    timeTick--;
    [resendButton.titleLabel setText:[NSString stringWithFormat:@"发验证码(%d秒)",timeTick]];
    if(timeTick <= 0)
    {
        [self stoptick];
    }
}
-(void)stoptick
{
    if(timer != nil && [timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    [resendButton.titleLabel setText:@"发送验证码"];
    resendButton.enabled = YES;
    resendButton.titleLabel.font = getFontWith(YES, 16);
}
-(void)requestCode
{
    if(checkedNumber == nil || [checkedNumber length]<=0)
    {
        return;
    }
    
    [[NetworkEngine sharedInstance] getVerifiCode:checkedNumber block:^(int event, id object)
     {
         if(event == 0)
         {
             //号码异常
             [[LogicManager sharedInstance] showAlertWithTitle:nil
                                                       message:(NSString *)object
                                                    actionText:@"确定"];
         }
         else if (event == 1)
         {
             resendButton.enabled = NO;
             [self startTick];
         }
     }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
