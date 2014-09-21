//
//  ResetPWViewController.m
//  Guimi
//
//  Created by floar on 14-8-21.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "ResetPWViewController.h"
#import "Package.h"
#import "NetWorkEngine.h"
#import "AppDelegate.h"

#import <MBProgressHUD.h>

@interface ResetPWViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *firstPWTextField;
    
    __weak IBOutlet UITextField *secondPWTextFiled;
    
    __weak IBOutlet UIImageView *resetArrowImg;
    
    __weak IBOutlet UILabel *subTitleLabel;
    
    
    __weak IBOutlet UIButton *resetBtn;
    
    NSString *rightFirstPW;
    NSString *rightSecondPW;
    
    MBProgressHUD *hud;
}

@end

@implementation ResetPWViewController
@synthesize phoneNum,identifyCode;

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
    [super viewDidLoad];
    [self.navigationItem setTitleString:@"重置密码"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15) target:self selector:@selector(reSetGoToBack)];
    
    [resetArrowImg AnimationLeftAndRight:26];
    subTitleLabel.textColor = colorWithHex(0xCCCCCC);
    [firstPWTextField becomeFirstResponder];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.delegate = self;
    [self.navigationController.view addSubview:hud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetPWBtnAction:(id)sender
{
    if ([self getRightSendPW])
    {
        resetBtn.enabled = NO;
        [[NetWorkEngine shareInstance] resetpasswordWithPhoneNumStr:phoneNum identifyCode:identifyCode passWd:rightFirstPW block:^(int event, id object) {
            if (1 == event)
            {
                resetBtn.enabled = YES;
                Package *pack = (Package *)object;
                if (0x0e == [pack getProtocalId])
                {
                    [pack reset];
                    uint32_t result = [pack readInt32];
                    if (0 == result)
                    {
                        UserInfo *user = [UserInfo myselfInstance];
                        user.userId = [pack readInt64];
                        user.userKey = [pack readString];
                        [user synchronize:nil];
                        
                        //记录下手机号和密码用于后面自动登录
                        [[LogicManager sharedInstance] setPersistenceData:phoneNum withKey:PHONENUMSTR];
                        [[LogicManager sharedInstance] setPersistenceData:rightFirstPW withKey:USERINPUTPW];
                        
                        [hud show:YES];
                        hud.labelText = @"重置密码成功";
                        [hud hide:YES afterDelay:1.0 complete:^{
                            [[LogicManager sharedInstance] setPersistenceData:nil withKey:USERID];
                            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithUnsignedLongLong:0] withKey:FeedLastMessageId];
                            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:0] withKey:@"feedsFirstTime"];
                            [[LogicManager sharedInstance] setPersistenceData:nil withKey:APNSTOKEN];
                            [(AppDelegate*)([UIApplication sharedApplication].delegate) login];
                        }];
                    }
                    else if (-1011401 == result)
                    {
                        [hud show:YES];
                        hud.labelText = @"手机号未注册";
                        [hud hide:YES afterDelay:1.0];
                    }
                    else if (-1011402 == result)
                    {
                        [hud show:YES];
                        hud.labelText = @"验证码不正确";
                        [hud hide:YES afterDelay:1.0];
                    }
                }
            }
        }];
    }
}

-(BOOL)getRightSendPW
{
    if ([self checkPW:firstPWTextField.text])
    {
        rightFirstPW = firstPWTextField.text;
    }
    
    if ([self checkPW:secondPWTextFiled.text])
    {
        rightSecondPW = secondPWTextFiled.text;
    }
    
    if ([self checkPW:firstPWTextField.text] && [self checkPW:secondPWTextFiled.text])
    {
        
        if ([rightFirstPW isEqual:rightSecondPW])
        {
            return YES;
        }
        else
        {
            [hud show:YES];
            hud.labelText = @"两次密码不同";
            [hud hide:YES afterDelay:1.0];
            return NO;
        }
    }
    else
    {
        return NO;
    }
}



-(BOOL)checkPW:(NSString *)pw
{
    if(pw ==nil || [pw length]<=0)
    {
        [hud show:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入密码";
        [hud hide:YES afterDelay:1.0];
        
        return NO;
    }
    else
    {
        if(![self isSecretNum:pw])
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

-(BOOL)isSecretNum:(NSString *)pw
{
    int secretLength = [pw length];
    if( secretLength != 6 )
    {
        [hud show:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入6位密码";
        [hud hide:YES afterDelay:1.0];
        return NO;
    }
    else
    {
        return YES;
    }
}



-(void)reSetGoToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextFiledDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == firstPWTextField)
    {
        [UIView animateWithDuration:0.5 animations:^{
            resetArrowImg.frame = CGRectMake(CGRectGetMinX(resetArrowImg.frame), CGRectGetMinY(firstPWTextField.frame)+13, CGRectGetWidth(resetArrowImg.frame), CGRectGetHeight(resetArrowImg.frame));
        }];
    }
    else if (textField == secondPWTextFiled)
    {
        [UIView animateWithDuration:0.5 animations:^{
            resetArrowImg.frame = CGRectMake(CGRectGetMinX(resetArrowImg.frame), CGRectGetMinY(secondPWTextFiled.frame)+13, CGRectGetWidth(resetArrowImg.frame), CGRectGetHeight(resetArrowImg.frame));
        }];
    }
}

@end
