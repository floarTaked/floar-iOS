//
//  SearchUserViewController.m
//  WeLinked3
//
//  Created by jonas on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "SearchUserViewController.h"
#import "LogicManager.h"
@interface SearchUserViewController ()

@end

@implementation SearchUserViewController

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
    [self.navigationItem setTitleString:@"职脉号搜索"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
                                imageSelected:[UIImage imageNamed:@"backSelected"]
                                        title:nil
                                        inset:UIEdgeInsetsMake(0, 30, 0, 0)
                                       target:self
                                     selector:@selector(back:)];
    [self.navigationItem setRightBarButtonItem:nil
                                 imageSelected:nil
                                         title:@"搜索"
                                         inset:UIEdgeInsetsMake(0, 30, 0, 0)
                                        target:self
                                      selector:@selector(search:)];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.textColor = colorWithHex(0x444444);
    [descLabel setText:@"朋友职脉号"];
    descLabel.shadowColor = [UIColor whiteColor];
    descLabel.shadowOffset = CGSizeMake(0, 1.0);
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)search:(id)sender
{
    if(textFiled.text == nil || [textFiled.text length]<=0)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:@"" message:@"请输入对方的职脉号" actionText:@"确定"];
        return;
    }
//    [[NetworkEngine sharedInstance] getProfileInfo:textFiled.text block:^(int event, id object)
//    {
//        if(event == 0)
//        {
//            [[LogicManager sharedInstance] showAlertWithTitle:@"" message:object actionText:@"确定"];
//        }
//        else if (event == 1)
//        {
//            ProfileInfo* profile =  (ProfileInfo*)object;
//            [[LogicManager sharedInstance] gotoProfile:self userId:profile.userId];
//        }
//    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
