//
//  SettingViewController.m
//  闺秘
//
//  Created by floar on 14-6-25.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    [self.navigationItem setTitleString:@"设置"];
    [self.navigationItem setLeftBarButtonItem:nil imageSelected:nil title:@"back" inset:UIEdgeInsetsZero target:self selector:@selector(settingGoBack)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
-(void)settingGoBack
{
    
}

@end
