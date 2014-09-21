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
#import "AgreementViewController.h"
#import <MBProgressHUD.h>

#import "UserInfo.h"

@interface PhoneViewController ()<MBProgressHUDDelegate>
{
    
    __weak IBOutlet UIImageView *phoneArrow;
    
    __weak IBOutlet UITextField *secretTextField;
    
    __weak IBOutlet UILabel *commitLabel;
    
    __weak IBOutlet UIButton *registerbtn;
    
    MBProgressHUD *hud;
    
    BOOL phoneOverTime;
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
    
    phoneOverTime = YES;
    
    [self.navigationItem setTitleString:@"加入闺秘"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15) target:self selector:@selector(phoneViewGotoBack)];
    
    //箭头动画
    [phoneArrow AnimationLeftAndRight:26];
    
    [self changeBottonLabel];
    [self showBoyOrGirlBlur];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.delegate = self;
    [self.navigationController.view addSubview:hud];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldHaveChangeing:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.window.windowLevel = UIWindowLevelNormal;
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



#pragma mark - 检查输入正确性
-(BOOL)checkPhoneNumber
{
    NSString *str = [self deCodePhoneNumStr:inputPhone.text];
    if(str ==nil || [str length]<=0)
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
            checkedNumber = [self deCodePhoneNumStr:inputPhone.text];
            return YES;
        }
    }
    return YES;
}

-(BOOL)checkSecretNumber
{
    if(secretTextField.text==nil || [secretTextField.text length]<=0)
    {
        [hud show:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入密码";
        [hud hide:YES afterDelay:1.0];

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
            checkedSecretNumber = secretTextField.text;
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


#pragma mark - Actions

-(IBAction)resendCode:(id)sender
{
//    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    app.window.windowLevel = UIWindowLevelNormal;
    
    if([self checkPhoneNumber] && [self checkSecretNumber])
    {
        [MobClick event:Register];
        checkedSecretNumber = secretTextField.text;
        checkedNumber = [self deCodePhoneNumStr:inputPhone.text];
        
        [inputPhone resignFirstResponder];
        [secretTextField resignFirstResponder];
        registerbtn.enabled = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (phoneOverTime == YES)
            {
                registerbtn.enabled = YES;
                [hud show:YES];
                hud.labelText = @"验证超时";
                [hud hide:YES afterDelay:1.0];
            }
        });
        
        [hud show:YES];
        hud.labelText = @"手机号验证中...";
        
        [[NetWorkEngine shareInstance] canReceiveVerificationCodeByPhoneNum:checkedNumber phoneRegistOrNot:0x01 block:^(int event, id object) {
            if (1 == event)
            {
                Package *pack = (Package *)object;
                registerbtn.enabled = YES;
                phoneOverTime = NO;
                
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
                        hud.labelText = @"验证成功";
                        [hud hide:YES afterDelay:1.5 complete:^{
                            IdentifyViewController *identify = [[IdentifyViewController alloc] initWithNibName:NSStringFromClass([IdentifyViewController class]) bundle:nil];
                            identify.phoneNum = checkedNumber;
                            identify.password = checkedSecretNumber;
                            identify.checkPhoneOkorNot = YES;
                            [self.navigationController pushViewController:identify animated:YES];
                        }];

                        DLog(@"获取验证码成功");
                    }
                    else if (-1030101 == result)
                    {
                        [hud show:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"手机号已注册";
                        [hud hide:YES afterDelay:2.0];
                    }
                    else if (-1 == result)
                    {
                        [hud show:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"业务异常";
                        [hud hide:YES afterDelay:1.0];
                    }
                }
            }
        }];
    }
}

-(void)showBoyOrGirlBlur
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ShareBlurView *blurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        [blurView shareBlurWithImage:[UIImage screenshot] withBlurType:BlurSplashPhoneType];
        
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.window.windowLevel = UIWindowLevelAlert;
        [self.navigationController.view addSubview:blurView];
        
    });
}

//修改底部字体
-(void)changeBottonLabel
{
    NSString *commitStr = @"您的手机号不会被展示，仅用于识别你的朋友并展示他们的秘密,查看《闺秘用户使用协议》";
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:commitStr];
    
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:colorWithHex(0xCCCCCC)
                         range:NSMakeRange(0,[commitStr length])];
    
    [attributeStr addAttribute:NSFontAttributeName
                         value:getFontWith(NO, 11)
                         range:NSMakeRange(0,[commitStr length])];
    
    NSRange range = [commitStr rangeOfString:@"《"];
    if (range.location != NSNotFound)
    {
        [attributeStr addAttribute:NSForegroundColorAttributeName value:colorWithHex(0xF88BB4) range:NSMakeRange(range.location, 10)];
    }
    [commitLabel setAttributedText:attributeStr];
    commitLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAgreement)];
    [commitLabel addGestureRecognizer:tapGesture];
}


-(void)phoneViewGotoBack
{
    [[LogicManager sharedInstance] setRootViewContrller:[SplashViewController sharedInstance]];
}

-(void)tapAgreement
{
    AgreementViewController *agreeCtl = [[AgreementViewController alloc] initWithNibName:NSStringFromClass([AgreementViewController class]) bundle:nil];
    [self.navigationController pushViewController:agreeCtl animated:YES];
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

-(void)textFieldHaveChangeing:(NSNotification *)note
{
    UITextField *textField = (UITextField *)[note object];
    if (textField == inputPhone)
    {
        NSString *str = [self deCodePhoneNumStr:inputPhone.text];
        if (str.length == 11)
        {
            if ([[LogicManager sharedInstance] isMobileNumber:str])
            {
                textField.text = [self enCodePhoneNumStr:str];
            }
        }
    }

}

@end
