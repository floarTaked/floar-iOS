//
//  SplashViewController.m
//  UnNamed
//
//  Created by jonas on 9/4/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import "SplashViewController.h"
#import "AppDelegate.h"
#import "LogicManager.h"
@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        items = [[NSMutableArray alloc]init];
        for(int i = 0;i<4;i++)
        {
            CGRect bounds = [UIScreen mainScreen].bounds;
            UIImageView* view = nil;
            if(bounds.size.height > 480)
            {
                view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"splash%d%d",i,i]]];
            }
            else
            {
                view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"splash%d",i]]];
            }
            [items addObject:view];
        }
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    list.type = iCarouselTypeCustom;
    list.scrollEnabled = NO;
    pageControl.numberOfPages = [items count];
    [list reloadData];
    
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
    self.view.backgroundColor = colorWithHex(0x5B9FEB);
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
-(void)gotoLogin:(id)sender
{
    LoginViewController* login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:login];
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.view.frame.size.width;
}
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [items count]+1;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if(items != nil && index >= [items count])
    {
        return nil;
    }
    UIImageView* v = [items objectAtIndex:index];
//    UIButton* btn = (UIButton*)[v viewWithTag:2];
//    if(btn == nil)
//    {
//        CGRect bounds = [UIScreen mainScreen].bounds;
//        if(bounds.size.height > 480)
//        {
//            btn = [[UIButton alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height-190, 240, 42)];
//        }
//        else
//        {
//            btn = [[UIButton alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height-120, 240, 42)];
//        }
//        [btn setBackgroundImage:[UIImage imageNamed:@"tiyan"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"tiyanSelected"] forState:UIControlStateHighlighted];
//        [btn addTarget:self action:@selector(gotoLogin:) forControlEvents:UIControlEventTouchUpInside];
////        btn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-150);
//        btn.tag = 2;
//        [v addSubview:btn];
//    }
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
    if(carousel.currentItemIndex >= [items count])
    {
        [self gotoLogin:nil];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [list setCurrentItemIndex:[items count]-1];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)checkSchool:(EventCallBack)callback
{
}
+(SplashViewController*)sharedInstance
{
    static SplashViewController* m_instance = nil;
    if(m_instance == nil)
    {
        m_instance = [[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:nil];
    }
    return m_instance;
}
@end
