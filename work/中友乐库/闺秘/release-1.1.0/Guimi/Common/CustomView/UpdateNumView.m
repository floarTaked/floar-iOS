//
//  UpdateNumView.m
//  Guimi
//
//  Created by floar on 14-8-19.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "UpdateNumView.h"

@implementation UpdateNumView
{
    UILabel *updateNumLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorWithHex(0x66CCFF);
        self.hidden = YES;
        
        updateNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, frame.size.height)];
        updateNumLabel.center = self.center;
        updateNumLabel.font = [UIFont systemFontOfSize:12];
        updateNumLabel.textAlignment = NSTextAlignmentCenter;
        updateNumLabel.textColor = [UIColor whiteColor];
        [self addSubview:updateNumLabel];
    }
    return self;
}

-(void)setUpdateNum:(uint32_t)updateNum
{
    _updateNum = updateNum;
    if (updateNum == 0)
    {
        updateNumLabel.hidden = YES;
        self.hidden = YES;
    }
    else
    {
        self.hidden = NO;
        updateNumLabel.hidden = NO;
        updateNumLabel.text = [NSString stringWithFormat:@"更新了%d条秘密",updateNum];
        [UIView animateWithDuration:1.0 animations:^{
            updateNumLabel.alpha = 1.0;
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 animations:^{
                    self.alpha = 0;
                    updateNumLabel.alpha = 0;
                }];
            });
        }];
    }
}

-(void)setNoticeStr:(NSString *)noticeStr
{
    _noticeStr = noticeStr;
    updateNumLabel.text = noticeStr;
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
