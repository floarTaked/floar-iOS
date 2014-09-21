//
//  ForgetPWViewController.m
//  Guimi
//
//  Created by floar on 14-8-21.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "ResetPWViewController.h"
#import "Package.h"
#import "NetWorkEngine.h"

#import <MBProgressHUD.h>

@interface ForgetPWViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *phoneTextField;
    
    __weak IBOutlet UITextField *checkCodeTextField;
    
    __weak IBOutlet UILabel *timeLabel;
    
    __weak IBOutlet UIImageView *arrowImg;
    
//    BOOL canNext;
    
    __weak IBOutlet UIButton *checkCodeBtn;
    
    NSString *rightPhoneNum;
    NSString *rightIdentifyNum;
    
    MBProgressHUD *hud;
    
}

@end

@implementation ForgetPWViewController

#pragma mark - ViewController生命周期函数

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
    
    [self.navigationItem setTitleString:@"忘记密码"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15) target:self selector:@selector(forgetGoToBack)];
    
    [arrowImg AnimationLeftAndRight:26];
    timeLabel.text = @"获取验证码";
    [phoneTextField becomeFirstResponder];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.delegate = self;
    hud.mode = MBProgressHUDModeText;
    [self.view addSubview:hud];
    
//    canNext = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldisChanging:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - phoneNum增加/删除间隔
-(NSString *)enCodePhoneNumStr:(NSString *)newPhoneNum
{
    NSMutableString *enCodeStr = [[NSMutableString alloc] initWithString:newPhoneNum];
    if (newPhoneNum.length > 2)
    {
        [enCodeStr insertString:@" " atIndex:3];
        if (newPhoneNum.length > 7)
        {
            [enCodeStr insertString:@" " atIndex:8];
        }
    }
    NSString *str = (NSString *)enCodeStr;
    
    return str;
}

-(NSString *)deCodePhoneNumStr:(NSString *)newPhoneNum
{
    NSString *deCodeStr = [[NSString alloc] init];
    NSArray *arr = [newPhoneNum componentsSeparatedByString:@" "];
    if (arr != nil && arr.count > 0)
    {
        for (NSString *str in arr)
        {
           deCodeStr = [deCodeStr stringByAppendingString:str];
        }
        return deCodeStr;
    }
    else
    {
        return newPhoneNum;
    }
}

#pragma mark - 检查TextField输入合法性并给出相关提示
-(BOOL)checkPhoneNum
{
    NSString *str = [self deCodePhoneNumStr:phoneTextField.text];
    
    if(str == nil || str <= 0 || [str isEqual:@""])
    {
        [hud show:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"手机号码不能为空";
        [hud hide:YES afterDelay:1.0];
        
        return NO;
    }
    else
    {
        if(![[LogicManager sharedInstance] isMobileNumber:str])
        {
            [hud show:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入真实手机号码";
            [hud hide:YES afterDelay:1.0];
            
            return NO;
        }
        else
        {
            rightPhoneNum = str;
            return YES;
        }
    }
}

-(BOOL)checkIdentifyCode
{
    if (checkCodeTextField.text == nil || [checkCodeTextField.text isEqualToString:@""] || [checkCodeTextField.text length] < 1)
    {
        [hud show:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"验证码不能为空";
        [hud hide:YES afterDelay:1.0];
        return NO;
    }
    else
    {
        int length = [checkCodeTextField.text length];
        if (length != 4)
        {
            [hud show:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请输入4位数字验证码";
            [hud hide:YES afterDelay:1.0];
            return NO;
        }
        else
        {
            rightIdentifyNum = checkCodeTextField.text;
            return YES;
        }
        
    }
}

#pragma mark - 倒计时、获取验证码
- (IBAction)reGetCheckCodeBtnAction:(id)sender
{
    if ([self checkPhoneNum])
    {
        __block int timeout = 59;
        
        [MobClick event:ver_code];
        
        [phoneTextField resignFirstResponder];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(timer, ^{
            if(timeout <= 0)
            {
                //倒计时结束，关闭
                dispatch_source_cancel(timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    timeLabel.text = @"重新获取验证码";
                    [checkCodeBtn setImage:[UIImage imageNamed:@"btn_checkout_yes"] forState:UIControlStateNormal];
                    checkCodeBtn.enabled = YES;
                });
            }
            else
            {
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSLog(@"____%@",strTime);
                    timeLabel.text = [NSString stringWithFormat:@"%@秒后重发",strTime];
                    checkCodeBtn.enabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(timer);
        
        [[NetWorkEngine shareInstance] canReceiveVerificationCodeByPhoneNum:rightPhoneNum phoneRegistOrNot:0x02 block:^(int event, id object) {
            if (1 == event)
            {
                Package *pack = (Package *)object;
                
                if (0x01 == [pack getProtocalId])
                {
                    [pack reset];
                    uint32_t result = [pack readInt32];
                    if (0 == result)
                    {
                        /*
                         1,如果判断能够发送验证码，则直接发送验证码，不用再手动调用发送验证码接口
                         2,如果再调用发送验证码接口，验证码重复发送，后面步骤验证码肯定验证不成功
                         */
                    }
                    else if (-1030101 == result)
                    {
                        [hud show:YES];
                        dispatch_source_cancel(timer);
                        timeLabel.text = @"重新获取验证码";
                        [checkCodeBtn setImage:[UIImage imageNamed:@"btn_checkout_yes"] forState:UIControlStateNormal];
                        checkCodeBtn.enabled = YES;
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"手机号未注册,不能找回密码";
                        [hud hide:YES afterDelay:2.0];
//                        canNext = NO;
                    }
                    else if (-3 == result)
                    {
                        [[LogicManager sharedInstance] makeUserReLoginAuto];
                    }
                }
            }
        }];
        
    }
}

#pragma mark - Actions
- (IBAction)gotoResetPW:(id)sender
{
    if ([self checkPhoneNum])
    {
        if ([self checkIdentifyCode])
        {
            ResetPWViewController *resetCtl = [[ResetPWViewController alloc] initWithNibName:NSStringFromClass([ResetPWViewController class]) bundle:nil];
            resetCtl.phoneNum = rightPhoneNum;
            resetCtl.identifyCode = rightIdentifyNum;
            [self.navigationController pushViewController:resetCtl animated:YES];
        }
    }
}

-(void)forgetGoToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextFiledDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == phoneTextField)
    {
        [UIView animateWithDuration:0.5 animations:^{
            arrowImg.frame = CGRectMake(CGRectGetMinX(arrowImg.frame), CGRectGetMinY(phoneTextField.frame)+13, CGRectGetWidth(arrowImg.frame), CGRectGetHeight(arrowImg.frame));
        }];
    }
    else if (textField == checkCodeTextField)
    {
        [UIView animateWithDuration:0.5 animations:^{
            arrowImg.frame = CGRectMake(CGRectGetMinX(arrowImg.frame), CGRectGetMinY(checkCodeTextField.frame)+13, CGRectGetWidth(arrowImg.frame), CGRectGetHeight(arrowImg.frame));
        }];
    }
}

-(void)textFieldisChanging:(NSNotification *)note
{
    UITextField *textField = (UITextField *)[note object];
    if (textField == phoneTextField)
    {
        NSString *str = [self deCodePhoneNumStr:phoneTextField.text];
        if (str.length == 11)
        {
            if ([[LogicManager sharedInstance] isMobileNumber:str])
            {
                textField.text = [self enCodePhoneNumStr:str];
                [checkCodeBtn setImage:[UIImage imageNamed:@"btn_checkout_yes"] forState:UIControlStateNormal];
            }
        }
        else
        {
            [checkCodeBtn setImage:[UIImage imageNamed:@"btn_checkout_no"] forState:UIControlStateNormal];
        }
    }
}


@end
