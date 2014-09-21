//
//  JustExperienceView.m
//  Guimi
//
//  Created by floar on 14-8-20.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "JustExperienceView.h"
#import "AppDelegate.h"

@implementation JustExperienceView
{
    __weak IBOutlet UILabel *titleLabel;
    
    __weak IBOutlet UILabel *subTitleLable;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    titleLabel.textColor = colorWithHex(DeepRedColor);
    titleLabel.font = getFontWith(NO, 20);
    subTitleLable.textColor = colorWithHex(lightRedColor);
    subTitleLable.font = getFontWith(NO, 14);
}

- (IBAction)cancleAction:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

- (IBAction)askUserLogin:(id)sender
{
    [(AppDelegate *)[UIApplication sharedApplication].delegate login];
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
