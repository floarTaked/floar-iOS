//
//  MainViewCell.m
//  闺秘
//
//  Created by floar on 14-7-14.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "MainViewCell.h"
#import "ExtraButton.h"
#import "DetailSecretViewController.h"
#import "ShareBlurView.h"
#import "Package.h"
#import "NetWorkEngine.h"
#import <UIImage+Screenshot.h>

static const int cellColor = 0xD0246C;

@implementation MainViewCell
{
    
    __weak IBOutlet UILabel *commitLabel;
    
    __weak IBOutlet UILabel *commentNumLabel;
    
    __weak IBOutlet UILabel *likeNumLabel;
    
    
    __weak IBOutlet UILabel *contentLabel;
    
    
    __weak IBOutlet UIButton *commentbtn;
    
    
    __weak IBOutlet UIButton *likeBtn;
    
    
    __weak IBOutlet EGOImageView *BGImagView;
    
    int currentLikeNum;
    BOOL isShow;
    
}

- (void)awakeFromNib
{
    contentLabel.font = getFontWith(NO, 20);
    
    commitLabel.font = getFontWith(NO, 14);
    commitLabel.textColor = colorWithHex(cellColor);
    
    likeNumLabel.font = getFontWith(NO, 14);
    likeNumLabel.textColor = colorWithHex(cellColor);
    
    commentNumLabel.font = getFontWith(NO, 14);
    commentNumLabel.textColor = colorWithHex(cellColor);
    
    isShow = YES;
    //赞
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:SupportFeedCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            if ([pack handleSupportOrComment:pack withErrorCode:NoCheckErrorCode])
            {
                DLog(@"赞成功");
            }
        }
    }];
    
    //取消赞
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:CancleSupportFeedCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            if ([pack handleSupportOrComment:pack withErrorCode:NoCheckErrorCode])
            {
//                NSLog(@"取消成功");
                DLog(@"取消成功");
            }
        }
    }];
}

-(void)setFeed:(Feed *)feed
{
    _feed = feed;
    
    NSRange range = [feed.imageStr rangeOfString:@"http"];

    if (range.location != NSNotFound)
    {
        BGImagView.imageURL = [NSURL URLWithString:feed.imageStr];
    }
    else
    {
        BGImagView.image = [UIImage imageNamed:feed.imageStr];
    }
    
    //tips
    if ([feed.addressStr isEqualToString:@"朋友"])
    {
        int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"friendType"];
        if (0 == i)
        {
            
            ShareBlurView *tip = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            [tip shareBlurWithImage:[UIImage imageFromUIView:self] withBlurType:BlurTipsType];
            tip.tipsHeight = 195;
            tip.tip.contentStr = @"这个秘密来自你的朋友圈,表示是你的朋友或者朋友的朋友发的";
            [tip.tip customTipsViewWithPoint:CGPointMake(10, 65) tipType:TipsFriendType withSubTitle:@"朋友圈" withSubImageStr:nil subImageSize:CGSizeZero];
//            __weak ShareBlurView *weakTip = tip;
//            [tip.tip setHandleTipsOKBtnActionBlock:^{
//                
//                [weakTip removeFromSuperview];
//            }];
            [self addSubview:tip];
            
            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"friendType"];
        }
        
    }
    else
    {
        int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"addressType"];
        if (0 == i)
        {
            ShareBlurView *tip = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            
            [tip shareBlurWithImage:[UIImage imageFromUIView:self] withBlurType:BlurTipsType];
            tip.tipsHeight = 195;
            tip.tip.contentStr = @"这条秘密来自朋友圈外,这是一条热门秘密,或者你朋友赞过";
            
            [tip.tip customTipsViewWithPoint:CGPointMake(10, 65) tipType:TipsAddressType withSubTitle:@"无秘密去" withSubImageStr:nil subImageSize:CGSizeZero];
//            __weak ShareBlurView *weakTip = tip;
//            [tip.tip setHandleTipsOKBtnActionBlock:^{
//                [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"addressType"];
//                [weakTip removeFromSuperview];
//                
//            }];
            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"addressType"];
            [self addSubview:tip];
        }
    }
    commitLabel.text = [NSString stringWithFormat:@"%@",feed.addressStr];
    
    if (feed.commentNum != 0)
    {
        commentNumLabel.text = [NSString stringWithFormat:@"%d",feed.commentNum];
    }
    else
    {
        commentbtn.frame = CGRectMake(CGRectGetMaxX(commentbtn.frame)-5, CGRectGetMinY(commentbtn.frame), CGRectGetWidth(commentbtn.frame), CGRectGetHeight(commentbtn.frame));
        commentNumLabel.text = nil;
    }
    if (feed.likeNum != 0)
    {

        likeNumLabel.text = [NSString stringWithFormat:@"%d",feed.likeNum];
    }
    else
    {
        likeBtn.frame = CGRectMake(CGRectGetMaxX(likeBtn.frame)-5, CGRectGetMinY(likeBtn.frame), CGRectGetWidth(likeBtn.frame), CGRectGetHeight(likeBtn.frame));
        likeNumLabel.text = nil;
    }
    currentLikeNum = feed.likeNum;
    contentLabel.text = [NSString stringWithFormat:@"%@",feed.contentStr];
    
    if (feed.isOwnZanFeed == 0)
    {
        [likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_support_no"] forState:UIControlStateNormal];
    }
    else if (feed.isOwnZanFeed == 1)
    {
        int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"zanFlag"];
        if (0 == i)
        {
            ShareBlurView *tip = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            [tip shareBlurWithImage:[UIImage imageFromUIView:self] withBlurType:BlurTipsType];
            tip.tipsHeight = 195;
            [tip.tip customTipsViewWithPoint:CGPointMake(270, 65) tipType:TipsSupportType withSubTitle:nil withSubImageStr:@"btn_support_yes" subImageSize:CGSizeMake(20, 20)];
//            __weak ShareBlurView *weakTip = tip;
//            [tip.tip setHandleTipsOKBtnActionBlock:^{
//                [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"zanFlag"];
//                [weakTip removeFromSuperview];
//            }];
            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"zanFlag"];
            [self addSubview:tip];
        }
        [likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_support_yes"] forState:UIControlStateNormal];
    }
}



#pragma mark - Actions

- (IBAction)cellShareBtnAction:(id)sender
{
    if (self.handleCellShareViewShow)
    {
        self.handleCellShareViewShow();
    }
}

- (IBAction)commitBtnAction:(id)sender
{
    
}

- (IBAction)otherBtnAction:(id)sender
{
    if (self.handleOtherAgainstBtnBlock)
    {
        self.handleOtherAgainstBtnBlock();
    }
}

- (IBAction)commentBtnAction:(ExtraButton *)btn
{
    if (self.handleCommentBtnBlock != nil)
    {
        self.handleCommentBtnBlock();
    }
}

- (IBAction)likeBtnAction:(ExtraButton *)btn
{
    if (_feed.isOwnZanFeed == 0)
    {
        _feed.isOwnZanFeed = 1;
        _feed.likeNum++;
        currentLikeNum++;
        [likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_support_yes"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.5, 2.5);
        } completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.3 animations:^{
                 btn.transform = CGAffineTransformIdentity;
             }];
         }];
        [self supportFeed];
    }
    else if (_feed.isOwnZanFeed == 1)
    {
        _feed.isOwnZanFeed = 0;
        currentLikeNum--;
        _feed.likeNum--;
        [likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_support_no"] forState:UIControlStateNormal];
        [self cancleSupportFeed];
    }
    else if (_feed.isOwnZanFeed == 0xFFFFFFFF)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"不能赞自己..." actionText:@"确定"];
    }
    
    if (currentLikeNum == 0)
    {
        likeNumLabel.text = @"";
    }
    else
    {
       likeNumLabel.text = [NSString stringWithFormat:@"%d",currentLikeNum];
    }
}

#pragma mark - NetWork
-(void)supportFeed
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x02];
    
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    [pack supportOrCommentWithUserId:userId userKey:userKey feedId:_feed.feedId commentId:0 operation:0x01 comment:@""];
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:SupportFeedCode block:^(int event, id object) {
    }];
}

-(void)cancleSupportFeed
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x02];
    
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    [pack supportOrCommentWithUserId:userId userKey:userKey feedId:_feed.feedId commentId:0 operation:0x02 comment:@""];
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:CancleSupportFeedCode block:^(int event, id object) {
        
    }];
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
