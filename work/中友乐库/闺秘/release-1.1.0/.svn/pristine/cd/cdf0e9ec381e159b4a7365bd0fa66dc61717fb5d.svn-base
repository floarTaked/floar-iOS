//
//  NavSettingAppearView.m
//  闺秘
//
//  Created by floar on 14-7-16.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "NavSettingAppearView.h"
#import "ShareBlurView.h"
#import <UIImage+Screenshot.h>

@implementation NavSettingAppearView
{
    
    __weak IBOutlet UIButton *inviteFriend;
    
    __weak IBOutlet UIButton *frequentQuestion;
    
    __weak IBOutlet UIButton *suggestFeedBack;
    
    __weak IBOutlet UIButton *changePW;
    
    __weak IBOutlet UIButton *markForMe;
    
    __weak IBOutlet UIButton *logOut;
    
    __weak IBOutlet UIButton *clearSpoor;
    
    __weak IBOutlet UILabel *commitLabel;
    
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
    [inviteFriend setTitleColor:colorWithHex(0xD0246C) forState:UIControlStateNormal];
    [frequentQuestion setTitleColor:colorWithHex(0xD0246C) forState:UIControlStateNormal];
    [suggestFeedBack setTitleColor:colorWithHex(0xD0246C) forState:UIControlStateNormal];
    [changePW setTitleColor:colorWithHex(0xD0246C) forState:UIControlStateNormal];
    [markForMe setTitleColor:colorWithHex(0xD0246C) forState:UIControlStateNormal];
    [logOut setTitleColor:colorWithHex(0xD0246C) forState:UIControlStateNormal];
//    [clearSpoor setTitleColor:colorWithHex(0x666666) forState:UIControlStateNormal];
    commitLabel.textColor = [UIColor whiteColor];

}

- (IBAction)inviteFriendBtnAction:(id)sender
{
    [MobClick event:share];
    if (self.handleInviteBtnBlock)
    {
        self.handleInviteBtnBlock();
    }
}

- (IBAction)frequentQuestionBtnAction:(id)sender
{
    [MobClick event:faq];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 570, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];

    if (self.handleFrequentQuestionsBlock)
    {
        self.handleFrequentQuestionsBlock();
    }
}

- (IBAction)suggestFeedbackBtnAction:(id)sender
{
    [MobClick event:feed_back];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 570, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];

    if (self.handleSuggestForUsBlock)
    {
        self.handleSuggestForUsBlock();
    }
}

- (IBAction)changPWBtnAction:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 570, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
    if (self.handleChangePWBlock)
    {
        self.handleChangePWBlock();
    }
}

- (IBAction)markForMeBtnAction:(id)sender
{
    if (self.handleRateMeBlock)
    {
        self.handleRateMeBlock();
    }
}

- (IBAction)logOutBtnAction:(id)sender
{
    if (self.handleLogoutBlcok)
    {
        self.handleLogoutBlcok();
    }
}

- (IBAction)clearSpoorBtnAction:(id)sender
{
    if (self.handleClearMarkBlock)
    {
        self.handleClearMarkBlock();
    }
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
