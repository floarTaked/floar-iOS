//
//  AgreementViewController.m
//  闺秘
//
//  Created by floar on 14-7-30.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()
{
    
    __weak IBOutlet UIWebView *agreementWeb;
}

@end

@implementation AgreementViewController

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
    [self.navigationItem setTitleString:@"职脉用户协议"];
    
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15) target:self selector:@selector(agreeViewGotoBack)];
    
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Agreement" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [agreementWeb loadHTMLString:html baseURL:baseUrl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"memoryWarning:%@",NSStringFromClass([self class]));
}

-(void)agreeViewGotoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
