//
//  CellShareView.m
//  闺秘
//
//  Created by floar on 14-7-16.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "CellShareView.h"
#import "LogicManager.h"

@implementation CellShareView
{
    
    __weak IBOutlet UILabel *titleLabel;
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
}

/*
 聊天界面
WXSceneSession  = 0, 
 朋友圈
WXSceneTimeline = 1
 收藏
WXSceneFavorite = 2
 */

- (IBAction)wechatBtnAction:(id)sender
{
    if (self.handleWechat)
    {
        self.handleWechat();
    }
}

- (IBAction)weChatCircleBtnAction:(id)sender
{
    if (self.hanldeWechatCircle)
    {
        self.hanldeWechatCircle();
    }
}

- (IBAction)weiboBtnAction:(id)sender
{
    if (self.handleWeibo)
    {
        self.handleWeibo();
    }
}

- (IBAction)messageBtnAction:(id)sender
{
    if (self.handleShareByMessage)
    {
        self.handleShareByMessage();
    }
}

- (IBAction)closeBtnAction:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(-400, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
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
