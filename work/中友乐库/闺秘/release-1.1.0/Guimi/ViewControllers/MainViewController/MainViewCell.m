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
#import <RQShineLabel.h>

static const int cellColor = 0xD0246C;

//static const int noLikeNumX = 265;
//static const int haveLikeNumX = 250;
//static const int noCommentX = 190;
//static const int haveCommentX = 176;

@implementation MainViewCell
{
    __weak IBOutlet UILabel *commitLabel;
    
    __weak IBOutlet UILabel *commentNumLabel;
    
    __weak IBOutlet UILabel *likeNumLabel;
    
    __weak IBOutlet UILabel *contentLabel;
    
    __weak IBOutlet UIButton *commentbtn;
    
    __weak IBOutlet UIButton *likeBtn;
    
    __weak IBOutlet EGOImageView *BGImagView;
    
    __weak IBOutlet UIView *bottonSepView;
    int currentLikeNum;
    BOOL isShow;
    
}

- (void)awakeFromNib
{
    contentLabel.font = getFontWith(NO, 18);
//    contentLabel.shadowColor = [UIColor blackColor];
//    contentLabel.shadowOffset = CGSizeMake(0, 0.5);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    
    commitLabel.font = getFontWith(NO, 14);
    commitLabel.textColor = colorWithHex(cellColor);
    
    likeNumLabel.font = getFontWith(NO, 14);
    likeNumLabel.textColor = colorWithHex(cellColor);
    
    commentNumLabel.font = getFontWith(NO, 14);
    commentNumLabel.textColor = colorWithHex(cellColor);
    
    bottonSepView.backgroundColor = colorWithHex(0xCCCCCC);
    
    isShow = YES;
}

-(void)setFeed:(Feed *)feed
{
    _feed = feed;

    NSRange range = [feed.imageStr rangeOfString:@"http"];
    if (range.location != NSNotFound)
    {
        BGImagView.image = nil;
        BGImagView.imageURL = [NSURL URLWithString:feed.imageStr];
    }
    else
    {
        NSRange imgNumRange = [feed.imageStr rangeOfString:@"12"];
        if (imgNumRange.location != NSNotFound)
        {
            BGImagView.image = [UIImage imageNamed:@"img_secretCell_background_2"];
        }
        else
        {
            BGImagView.image = [UIImage imageNamed:feed.imageStr];
        }
    }
    if(feed.addressStr == nil || [feed.addressStr length]<=0)
    {
        commitLabel.text = @"火星";
    }
    else
    {
        commitLabel.text = [NSString stringWithFormat:@"%@",feed.addressStr];
    }
    
    if (feed.commentNum != 0)
    {
        commentNumLabel.text = [NSString stringWithFormat:@"%d",feed.commentNum];
//        commentbtn.frame = CGRectMake(haveCommentX, CGRectGetMinY(commentbtn.frame), CGRectGetWidth(commentbtn.frame), CGRectGetHeight(commentbtn.frame));
    }
    else
    {
//        commentbtn.frame = CGRectMake(noCommentX, CGRectGetMinY(commentbtn.frame), CGRectGetWidth(commentbtn.frame), CGRectGetHeight(commentbtn.frame));
        commentNumLabel.text = @"评论";
    }
    
    if (feed.likeNum != 0)
    {
        likeNumLabel.text = [NSString stringWithFormat:@"%d",feed.likeNum];
//        likeBtn.frame = CGRectMake(haveLikeNumX, CGRectGetMinY(likeBtn.frame), CGRectGetWidth(likeBtn.frame), CGRectGetHeight(likeBtn.frame));
    }
    else
    {
//        likeBtn.frame = CGRectMake(noLikeNumX, CGRectGetMinY(likeBtn.frame), CGRectGetWidth(likeBtn.frame), CGRectGetHeight(likeBtn.frame));
        likeNumLabel.text = @"赞";
    }
    currentLikeNum = feed.likeNum;
    
    if (feed.contentStr != nil)
    {
        contentLabel.text = feed.contentStr;
        NSString *str = feed.contentStr;
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *apragraphStytle = [[NSMutableParagraphStyle alloc] init];
        [apragraphStytle setLineSpacing:4];
        apragraphStytle.alignment = NSTextAlignmentCenter;
        apragraphStytle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:apragraphStytle range:NSMakeRange(0, str.length)];
        [contentLabel setAttributedText:attributedStr];
        
//        [contentLabel shine];
    }
    
    if (feed.isOwnZanFeed == 0)
    {
        [likeBtn setImage:[UIImage imageNamed:@"btn_support_no"] forState:UIControlStateNormal];
    }
    else if (feed.isOwnZanFeed == 1)
    {
        [likeBtn setImage:[UIImage imageNamed:@"btn_support_yes"] forState:UIControlStateNormal];
    }
}
-(void)disappear
{
    if(contentLabel != nil)
    {
//        [contentLabel paused];
    }
}
#pragma mark - Actions

- (IBAction)cellShareBtnAction:(id)sender
{
    [MobClick event:share];
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
    if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
    {
        if (self.handleLikeBtnBlcok)
        {
            self.handleLikeBtnBlcok();
        }
    }
    else
    {
        if (_feed.isOwnZanFeed == 0)
        {
            [MobClick event:some_praise];
            _feed.isOwnZanFeed = 1;
            _feed.likeNum++;
            currentLikeNum++;
            [likeBtn setImage:[UIImage imageNamed:@"btn_support_yes"] forState:UIControlStateNormal];
            //        likeBtn.frame = CGRectMake(haveLikeNumX, 0, CGRectGetWidth(likeBtn.frame), CGRectGetHeight(likeBtn.frame));
            likeNumLabel.text = [NSString stringWithFormat:@"%d",currentLikeNum];
            
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
            [MobClick event:cancel_praise];
            _feed.isOwnZanFeed = 0;
            currentLikeNum--;
            _feed.likeNum--;
            if (currentLikeNum == 0)
            {
                //            likeBtn.frame = CGRectMake(noLikeNumX, 0,CGRectGetWidth(likeBtn.frame),CGRectGetHeight(likeBtn.frame));
                likeNumLabel.text = @"赞";
            }
            else
            {
                //            likeBtn.frame = CGRectMake(haveLikeNumX, 0, CGRectGetWidth(likeBtn.frame), CGRectGetHeight(likeBtn.frame));
                likeNumLabel.text = [NSString stringWithFormat:@"%d",currentLikeNum];
            }
            [likeBtn setImage:[UIImage imageNamed:@"btn_support_no"] forState:UIControlStateNormal];
            [self cancleSupportFeed];
        }
        else if (_feed.isOwnZanFeed == -1020202)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"对不起您已被禁言" actionText:@"确定"];
        }

    }
}
#pragma mark - NetWork
-(void)supportFeed
{
    [[NetWorkEngine shareInstance] supportOrCommentWith:_feed.feedId commentId:0 operation:0x01 comment:@"" block:^(int event, id object)
    {
        if (1 == event)
        {
            Package *returnPack = (Package *)object;
            if (0x02 == [returnPack getProtocalId])
            {
                [returnPack reset];
                uint32_t result = [returnPack readInt32];
                if (0 == result)
                {
                    uint64_t feedId = [returnPack readInt64];
                    uint64_t commentId = [returnPack readInt64];
                    DLog(@"赞feed成功，feedId%llu:commentId%llu",feedId,commentId);
                }
                else if (-3 == result)
                {
                    [[LogicManager sharedInstance] makeUserReLoginAuto];
                }
            }
            
        }
    }];
}

-(void)cancleSupportFeed
{
    [[NetWorkEngine shareInstance] supportOrCommentWith:_feed.feedId commentId:0 operation:0x02 comment:@"" block:^(int event, id object)
    {
        if (1 == event)
        {
            Package *returnPack = (Package *)object;
            if (0x02 == [returnPack getProtocalId])
            {
                [returnPack reset];
                uint32_t result = [returnPack readInt32];
                if (0 == result)
                {
                    uint64_t feedId = [returnPack readInt64];
                    uint64_t commentId = [returnPack readInt64];
                    DLog(@"取消赞feed成功，feedId%llu:commentId%llu",feedId,commentId);
                }
            }
        }
    }];
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
