//
//  SplashViewController.m
//  WeLinked4
//
//  Created by jonas on 5/12/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "SplashViewController.h"
#import "UINavigationItemCustom.h"
#import "LoginViewController.h"
#import "LogicManager.h"
#import "PhoneViewController.h"
#import "OldUserLoginViewController.h"
#import "MainViewController.h"

#import "NetWorkEngine.h"
@interface SplashViewController ()
{
    int lastPage;
    
    __weak IBOutlet UIButton *OldUserBtnAction;
    
    __weak IBOutlet UIButton *justExperience;
    
}

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    lastPage = 0;
    splashPageCtl.currentPageIndicatorTintColor = colorWithHex(0xF88BB4);
    [OldUserBtnAction setTitleColor:colorWithHex(0xF88BB4) forState:UIControlStateNormal];
    [justExperience setTitleColor:colorWithHex(0xF88BB4) forState:UIControlStateNormal];
    
    splashScollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*4, [UIScreen mainScreen].bounds.size.height);
    splashScollView.contentOffset = CGPointMake(0, 0);
    splashScollView.pagingEnabled = YES;
    splashScollView.bounces = NO;
    
    for (int i = 0; i < 4; i++)
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*i, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        img.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        if ([UIScreen mainScreen].bounds.size.height > 480)
        {
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"splash%d",i+1]];
        }
        else
        {
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"splash-%d",i+1]];
        }
        [splashScollView addSubview:img];
    }
}

- (IBAction)registerBtn:(id)sender
{
    [MobClick event:to_join];
    PhoneViewController *phone = [[PhoneViewController alloc] initWithNibName:NSStringFromClass([PhoneViewController class]) bundle:nil];
    [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:phone];
}

- (IBAction)loginBtn:(id)sender
{
    [MobClick event:existing_account];
    OldUserLoginViewController *oldUser = [[OldUserLoginViewController alloc] initWithNibName:NSStringFromClass([OldUserLoginViewController class]) bundle:nil];
    [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:oldUser];
}

- (IBAction)justExperienceAction:(id)sender
{
    MainViewController *mainCtl = [[MainViewController alloc] initWithNibName:NSStringFromClass([MainViewController class]) bundle:nil];
    [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:mainCtl];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose  çof any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    splashPageCtl.currentPage = page;
//    if (lastPage == page)
//    {
//        lastPage++;
//    }
//    else
//    {
//        lastPage = page;
//    }
//    if (lastPage > page)
//    {
//        [self registerBtn:nil];
//    }
}

+(SplashViewController*)sharedInstance
{
    static SplashViewController* m_instance = nil;
    if(m_instance == nil)
    {
        m_instance = [[SplashViewController alloc]init];
    }
    return m_instance;
}
@end
