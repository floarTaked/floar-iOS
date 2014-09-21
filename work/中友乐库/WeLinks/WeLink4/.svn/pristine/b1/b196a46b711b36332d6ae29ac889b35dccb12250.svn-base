//
//  PhoneViewController.m
//  WeLinked4
//
//  Created by jonas on 5/19/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "PhoneViewController.h"
#import "LogicManager.h"
#import "BasicInformationViewController.h"
#import "NetworkEngine.h"
#import "AppDelegate.h"
@interface PhoneViewController ()

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
    [self.navigationItem setRightBarButtonItem:nil
                                 imageSelected:nil
                                         title:@"保存"
                                         inset:UIEdgeInsetsMake(0, 30, 0, 0)
                                        target:self
                                      selector:@selector(save:)];
    [self.navigationItem setTitleString:@"验证手机号码"];
    descLabel.textColor = [UIColor lightGrayColor];
    countLabel.font = getFontWith(YES, 15);
    [inputPhone becomeFirstResponder];
    
    countLabel.frame = CGRectMake(0, 0, countLabel.frame.size.width, countLabel.frame.size.height);
    [sendButton addSubview:countLabel];
}
-(void)save:(id)sender
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
    [[NetworkEngine sharedInstance] bindPhone:inputPhone.text verifiCode:codeTextField.text block:^(int event, id object)
     {
         if(event == 1)
         {
             [[LogicManager sharedInstance] showAlertWithTitle:nil
                                                       message:(NSString *)object
                                                    actionText:@"确定"];
         }
         else if (event == 0)
         {
             BasicInformationViewController* basic = [[BasicInformationViewController alloc]initWithNibName:@"BasicInformationViewController" bundle:nil];
             [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:basic];
         }
         else if (event == 2)
         {
             [(AppDelegate*)([UIApplication sharedApplication].delegate) login];
         }
     }];
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
-(IBAction)resendCode:(id)sender
{
    if([self checkPhoneNumber])
    {
        checkedNumber = inputPhone.text;
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
    countLabel.text = [NSString stringWithFormat:@"发验证码(%d秒)",timeTick];
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
    countLabel.text = @"发验证码";
    sendButton.enabled = YES;
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
             sendButton.enabled = NO;
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
