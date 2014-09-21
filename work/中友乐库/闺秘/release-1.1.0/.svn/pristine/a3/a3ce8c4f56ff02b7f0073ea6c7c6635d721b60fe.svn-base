//
//  AllowToVisitPhoneBookView.m
//  闺秘
//
//  Created by floar on 14-8-5.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "AllowToVisitPhoneBookView.h"

@implementation AllowToVisitPhoneBookView

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
    for (UILabel *label in self.subviews)
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            if (label.tag == 10)
            {
                label.font = getFontWith(YES, 18);
                label.textColor = colorWithHex(DeepRedColor);
            }
            else
            {
                label.font = getFontWith(NO, 12);
                label.textColor = colorWithHex(lightRedColor);
            }
        }
    }
}

- (IBAction)okBtnAction:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(CGRectGetMinX(self.frame), 570, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
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
