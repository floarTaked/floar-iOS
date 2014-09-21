//
//  ViewController.m
//  RotationAnimation
//
//  Created by floar on 14-7-28.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIBarButtonItem *rightBarBtn;
    UIButton *navbtn;
}

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end

@implementation ViewController

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
    
    self.navigationController.view.backgroundColor = [UIColor blueColor];
    navbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navbtn.frame = CGRectMake(0, 0, 44, 44);
    navbtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        navbtn.enabled = YES;
    });
    [navbtn addTarget:self action:@selector(navBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navbtn setTitle:@"发布" forState:UIControlStateNormal];
    rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:navbtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    NSString *commitStr = @"您的手机号不会被展示，仅用于识别你的朋友并展示他们的秘密,查看《职脉用户使用协议》";
    NSRange range = [commitStr rangeOfString:@"《"];
    if (range.location != NSNotFound)
    {
        NSLog(@"%@",[commitStr substringWithRange:NSMakeRange(range.location, 10)]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)navBtnAction:(UIButton *)btn
{
    self.navigationItem.rightBarButtonItem = nil;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    indicator.color = [UIColor redColor];
    indicator.hidesWhenStopped = YES;
    [indicator startAnimating];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [indicator stopAnimating];
        self.navigationItem.rightBarButtonItem = rightBarBtn;
    });
    
//    [UIView animateWithDuration:0.4 animations:^{
//        btn.transform = CGAffineTransformMakeRotation(M_PI);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.4 animations:^{
//            btn.transform = CGAffineTransformIdentity;
//        }];
//    }];
}

- (IBAction)changeBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
	theAnimation.values = [NSArray arrayWithObjects:
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,0,1)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0,0,1)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.26, 0,0,1)],
						   nil];
	theAnimation.cumulative = YES;
	theAnimation.duration = 0.5;
	theAnimation.repeatCount = 3;
	theAnimation.removedOnCompletion = YES;
    [btn.layer addAnimation:theAnimation forKey:@"transform"];
}

-(void) startAnimation
{
//        CGAffineTransform endAngle = CGAffineTransformMakeRotation(imageviewAngle * (M_PI / 180.0f));
    
//        [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            _changeBtn.transform = endAngle;
//        } completion:^(BOOL finished) {
//            angle += 10;
//            [self startAnimation];
//        }];  
    
}



@end
