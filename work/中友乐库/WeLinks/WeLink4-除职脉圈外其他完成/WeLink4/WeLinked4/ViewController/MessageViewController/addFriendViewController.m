//
//  addFriendViewController.m
//  WeLinked4
//
//  Created by floar on 14-5-16.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "addFriendViewController.h"
#import "LogicManager.h"
#import "NetworkEngine.h"

@interface addFriendViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;


@end

@implementation addFriendViewController

@synthesize inputTextField;

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
    
    [self.navigationItem setTitleString:@"职脉号添加"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
                                imageSelected:[UIImage imageNamed:@"backSelected"]
                                        title:nil inset:UIEdgeInsetsMake(0, -20, 0, 0)
                                       target:self
                                     selector:@selector(goToBack)];
    
    [self.navigationItem setRightBarButtonItem:nil
                                 imageSelected:nil
                                         title:@"确定"
                                         inset:UIEdgeInsetsZero
                                        target:self
                                      selector:@selector(addFriend)];
    
    [inputTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationItemAction
-(void)addFriend
{
    if (inputTextField.text == nil || inputTextField.text.length <= 0)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"请输入对方职脉号" actionText:@"确定"];
    }
    else
    {
        int number = [inputTextField.text intValue];
        [[NetworkEngine sharedInstance] getUserProfile:number block:^(int event, id object)
        {
            if (0 == event)
            {
                [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"未找到任何用户" actionText:@"确定"];
            }
            else
            {
                ProfileInfo* profile =  (ProfileInfo*)object;
                if(profile.userId == [UserInfo myselfInstance].userId)
                {
                    [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"不能搜索自己" actionText:@"确定"];
                }
                else
                {
                    [[LogicManager sharedInstance] gotoProfile:self userId:profile.userId];
                }
            }
        }];
    }
}

-(void)goToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
