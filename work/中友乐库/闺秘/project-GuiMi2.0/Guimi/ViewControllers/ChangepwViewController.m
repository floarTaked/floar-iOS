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
    
    __weak IBOutlet UITextField *currentPWtextFiled;
    
    __weak IBOutlet UITextField *newPWTextField;
    
    __weak IBOutlet UITextField *againPWTextFiled;
    
    __weak IBOutlet UIView *changePWInputView;
    
    MBProgressHUD *hud;
    
    UIButton *changPWBtn;
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
    
    self.view.backgroundColor = colorWithHex(BackgroundColor3);
    
    [self.navigationItem setTitleString:@"修改密码"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15) target:self selector:@selector(changePWBack)];
    
    [self changePWInputView];
    
    changPWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changPWBtn.frame = CGRectMake(0, 0, 44, 44);
    changPWBtn.enabled = NO;
    [changPWBtn setTitle:@"提交" forState:UIControlStateNormal];
    changPWBtn.titleLabel.font = getFontWith(NO, 16);
    [changPWBtn setTitleColor:colorWithHex(FontColor3) forState:UIControlStateDisabled];
    [changPWBtn addTarget:self action:@selector(changePW) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:changPWBtn];
    [self.navigationItem setRightBarButtonItem:barBtnItem];
    
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

- (void)changePW
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
        [[NetWorkEngine shareInstance] changePasswordWithOldPW:oldPW newPassword:firstInputPW block:^(int event, id object)
        {
            if (1 == event)
            {
                Package *returnPack = (Package *)object;
                [[LogicManager sharedInstance] handlePackage:returnPack block:^(int event, id object) {
                    if (1 == event)
                    {
                        NSDictionary *dict = (NSDictionary *)object;
                        uint32_t result = [[dict objectForKey:PACKAGERESULT] longValue];
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
                            user.userKey = [dict objectForKey:USERKEY];
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
                    
                }];
            }
        }];
    } 
}

-(void)changePWInputView
{
    changePWInputView.backgroundColor = colorWithHex(BackgroundColor2);
    changePWInputView.layer.cornerRadius = 5;
}
@end
