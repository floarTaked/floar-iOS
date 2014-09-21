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

@interface ChangepwViewController ()<UITextFieldDelegate>
{
    
    __weak IBOutlet UIImageView *changPWArrowImg;
    
    __weak IBOutlet UITextField *currentPWtextFiled;
    
    __weak IBOutlet UITextField *newPWTextField;
    
    __weak IBOutlet UITextField *againPWTextFiled;
    
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
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -10, 0, 10) target:self selector:@selector(changePWBack)];
    [changPWArrowImg AnimationLeftAndRight:26];
    [currentPWtextFiled becomeFirstResponder];
    
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:ChangePasswordCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            if ([pack handleChangePassword:pack withErrorCode:NoCheckErrorCode])
            {
                NSLog(@"修改密码成功");
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changePWBack
{
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
        Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x0b];
        uint64_t userId = [UserInfo myselfInstance].userId;
        NSString *userKey = [UserInfo myselfInstance].userKey;
        
        [pack changePasswordWithUserId:userId userKey:userKey oldPassword:oldPW newPassword:firstInputPW];
        [[NetWorkEngine shareInstance] sendData:pack UniqueCode:ChangePasswordCode block:^(int event, id object) {
            
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
