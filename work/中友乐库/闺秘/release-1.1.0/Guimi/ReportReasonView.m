//
//  ReportReasonView.m
//  闺秘
//
//  Created by floar on 14-7-15.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "ReportReasonView.h"

@implementation ReportReasonView
{
    NSNotificationCenter *center;
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
    center = [NSNotificationCenter defaultCenter];
    for (UIButton *btn in self.subviews)
    {
        if ([btn isKindOfClass:[UIButton class]])
        {
            [btn setTintColor:colorWithHex(0xD0246C)];
        }
    }
}

- (IBAction)reportBtnActions:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reportReason" object:btn.titleLabel.text];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.superview removeFromSuperview];
    });
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
