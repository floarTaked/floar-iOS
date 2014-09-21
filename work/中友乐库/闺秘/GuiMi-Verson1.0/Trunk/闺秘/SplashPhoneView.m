//
//  SplashPhoneView.m
//  闺秘
//
//  Created by floar on 14-7-17.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "SplashPhoneView.h"
#import "LogicManager.h"
#import "SplashViewController.h"

@implementation SplashPhoneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (IBAction)girlSelectedBtnAction:(id)sender
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(10, 600, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
    
}

- (IBAction)boySelectedBtnAction:(id)sender
{
    [self.superview removeFromSuperview];
    [[LogicManager sharedInstance] setRootViewContrller:[SplashViewController sharedInstance]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
