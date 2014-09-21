//
//  WebViewViewController.m
//  Welinked2
//
//  Created by 牟 文斌 on 12/21/13.
//
//

#import "WebViewViewController.h"

@interface WebViewViewController ()
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewViewController

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
    [self.navigationItem setTitleViewWithText:@"博客"];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack
                                                                 title:nil
                                                                target:self
                                                              selector:@selector(back:)];
    [self.webView loadRequest:_request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
