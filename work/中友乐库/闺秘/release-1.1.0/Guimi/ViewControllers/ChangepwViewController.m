//
//  ChangepwViewController.m
//  闺秘
//
//  Created by floar on 14-7-10.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "ChangepwViewController.h"
#import "LogicManager.h"
#import "NetWorkEngine.h"
#import "Package.h"
#import "UserInfo.h"

@interface ChangepwViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    
    __weak IBOutlet UIImageView *changPWArrowImg;
    
    __weak IBOutlet UITextField *currentPWtextFiled;
    
    __weak IBOutlet UITextField *newPWTextField;
    
    __weak IBOutlet UITextField *againPWTextFiled;
    
    
    MBProgressHUD *hud;
}

@end

@implementation ChangepwViewController

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
    
    [self.navigationItem setTitleString:@"修改密码"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15) target:self selector:@selector(changePWBack)];
    [changPWArrowImg AnimationLeftAndRight:26];
    [currentPWtextFiled becomeFirstResponder];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.delegate = self;
    [self.view addSubview:hud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"memoryWarning:%@",NSStringFromClass([self class]));
}

-(void)changePWBack
{
    [MobClick event:change_password_close];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)checkForPasswordAvailability:(NSString *)str
{
    if (str == nil || [str length] < 1 || [str isEqual:@""])
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"密码不能空" actionText:@"确定"];
        return NO;
    }
    else if ([str length] != 6)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"密码位数不对" actionText:@"确定"];
        return NO;
    }
    return YES;
}

-(BOOL)checkForPasswordLogic:(NSString *)firstInput newPW:(NSString *)secondInput
{
    if (![firstInput isEqual:secondInput])
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"两次输入密码不同" actionText:@"确定"];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (IBAction)changePW:(id)sender
{
    NSString *oldPW = nil;
    NSString *firstInputPW = nil;
    NSString *secondInputPW = nil;
    
    [currentPWtextFiled resignFirstResponder];
    [newPWTextField resignFirstResponder];
    [againPWTextFiled resignFirstResponder];
    
    if ([self checkForPasswordAvailability:currentPWtextFiled.text])
    {
        oldPW = currentPWtextFiled.text;
    }
    if ([self checkForPasswordAvailability:newPWTextField.text])
    {
        firstInputPW = newPWTextField.text;
    }
    if ([self checkForPasswordAvailability:againPWTextFiled.text])
    {
        secondInputPW = againPWTextFiled.text;
    }
    
    if ([self checkForPasswordLogic:firstInputPW newPW:secondInputPW])
    {
        [MobClick event:change_password_request];
        [[NetWorkEngine shareInstance] changePasswordWith:oldPW newPassword:firstInputPW block:^(int event, id object)
        {
            if (1 == event)
            {
                Package *returnPack = (Package *)object;
                if (0x0b == [returnPack getProtocalId])
                {
                    [returnPack reset];
                    uint32_t result = [returnPack readInt32];
                    if (0 == result)
                    {
                        hud.mode = MBProgressHUDModeText;
                        [hud show:YES];
                        hud.labelText = @"修改密码成功";
                        [hud hide:YES afterDelay:1.0 complete:^{
                            [self changePWBack];
                        }];
                        
                        UserInfo *user = [UserInfo myselfInstance];
                        user.userId = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID];
                        user.userKey = [returnPack readString];
                        [user synchronize:nil];
                    }
                    else if (-1 == result)
                    {
                        hud.mode = MBProgressHUDModeText;
                        [hud show:YES];
                        hud.labelText = @"旧密码不正确";
                        [hud hide:YES afterDelay:1.0];
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

#pragma mark - UITextFiledDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == currentPWtextFiled)
    {
        [UIView animateWithDuration:0.5 animations:^{
            changPWArrowImg.frame = CGRectMake(CGRectGetMinX(changPWArrowImg.frame), CGRectGetMidY(currentPWtextFiled.frame)-10, 10, 14);
        }];
    }
    if (textField == newPWTextField)
    {
        [UIView animateWithDuration:0.5 animations:^{
            changPWArrowImg.frame = CGRectMake(CGRectGetMinX(changPWArrowImg.frame), CGRectGetMidY(newPWTextField.frame)-2, 10, 14);
        }];
    }
    if (textField == againPWTextFiled)
    {
        [UIView animateWithDuration:0.5 animations:^{
            changPWArrowImg.frame = CGRectMake(CGRectGetMinX(changPWArrowImg.frame), CGRectGetMinY(againPWTextFiled.frame)+10, 10, 14);
        }];
    }
}

@end
