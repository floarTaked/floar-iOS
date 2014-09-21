//
//  FrequentQuestionViewController.m
//  闺秘
//
//  Created by floar on 14-8-6.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "FrequentQuestionViewController.h"

@interface FrequentQuestionViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *frequentWeb;

@end

@implementation FrequentQuestionViewController
@synthesize frequentWeb;

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
    
    [self.navigationItem setTitleString:@"常见问题"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15) target:self selector:@selector(frequentQuestionBack)];
    
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"frequentQuention" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [frequentWeb loadHTMLString:html baseURL:baseUrl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"memoryWarning:%@",NSStringFromClass([self class]));
}

-(void)frequentQuestionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
