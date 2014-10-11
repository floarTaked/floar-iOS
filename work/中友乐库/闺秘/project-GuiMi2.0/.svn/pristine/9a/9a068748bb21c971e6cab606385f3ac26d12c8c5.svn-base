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
@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    startButton.layer.cornerRadius = 3;
    leftButton.layer.cornerRadius = leftButton.frame.size.height/2;
    leftButton.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.6] CGColor];
    leftButton.layer.borderWidth = 1.0;
    
    rightButton.layer.cornerRadius = rightButton.frame.size.height/2;
    rightButton.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.6] CGColor];
    rightButton.layer.borderWidth = 1.0;
    NSArray* arr  = [[NSBundle mainBundle] loadNibNamed:@"SplashPageView" owner:self options:nil];
    items  = [[NSMutableArray alloc]initWithArray:arr];
    
    list.type = iCarouselTypeLinear;
    list.scrollEnabled = NO;
    pageControl.numberOfPages = [items count];
    [list reloadData];
    [list scrollToItemAtIndex:0 animated:NO];
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swap:)];
    swipeGestureRight.numberOfTouchesRequired = 1;
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRight];
    
    // left
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swap:)];
    swipeGestureLeft.numberOfTouchesRequired = 1;
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureLeft];
    
    
    
    [self.view bringSubviewToFront:pageControl];
    CGRect bounds = [UIScreen mainScreen].bounds;
    if(bounds.size.height <= 480)
    {
        CGPoint center = pageControl.center;
        center.y = 450;
        pageControl.center = center;
    }
    currentIndex = 0;
}
-(void)swap:(UISwipeGestureRecognizer*)gues
{
    if(gues.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        currentIndex++;
    }
    else if(gues.direction == UISwipeGestureRecognizerDirectionRight)
    {
        currentIndex--;
    }
    if(currentIndex < 0)
    {
        currentIndex = 0;
    }
    else if(currentIndex > [items count])
    {
        currentIndex = [items count];
    }
    
    [list scrollToItemAtIndex:currentIndex animated:YES];
}
-(IBAction)click:(id)sender
{
    int tag = [(UIButton*)sender tag];
    if(tag == 1)
    {
        [MobClick event:to_join];
        PhoneViewController *phone = [[PhoneViewController alloc] initWithNibName:NSStringFromClass([PhoneViewController class]) bundle:nil];
        [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:phone];
    }
    else if (tag == 2)
    {
        [MobClick event:existing_account];
        OldUserLoginViewController *oldUser = [[OldUserLoginViewController alloc] initWithNibName:NSStringFromClass([OldUserLoginViewController class]) bundle:nil];
        [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:oldUser];
    }
    else if (tag == 3)
    {
        MainViewController *mainCtl = [[MainViewController alloc] initWithNibName:NSStringFromClass([MainViewController class]) bundle:nil];
        [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:mainCtl];
    }
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
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.view.frame.size.width;
}
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [items count];
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if(items != nil && index >= [items count])
    {
        return nil;
    }
    UIImageView* v = [items objectAtIndex:index];
    return v;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionVisibleItems:
        {
            return [items count];
            break;
        }
        default:
            break;
    }
    return value;
}
-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    pageControl.currentPage = carousel.currentItemIndex;
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
