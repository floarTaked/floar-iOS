//
//  WeiBoProfileViewController.m
//  WeLinked3
//
//  Created by jonas on 3/18/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "WeiBoProfileViewController.h"
#import "UserInfo.h"
@interface WeiBoProfileViewController ()

@end

@implementation WeiBoProfileViewController

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
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack
                                                                 title:nil
                                                                target:self
                                                              selector:@selector(back:)];
    
    [self.navigationItem setTitleViewWithText:self.titleString];
    
    NSString* url = [NSString stringWithFormat:@"http://m.weibo.cn/%@",self.weiboId];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
