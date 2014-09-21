//
//  DetailViewCell.m
//  闺秘
//
//  Created by floar on 14-7-14.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "DetailViewCell.h"
#import "NetWorkEngine.h"
#import "Package.h"
#import "ShareBlurView.h"
#import <UIImage+Screenshot.h>

@implementation DetailViewCell
{
    
    __weak IBOutlet UIImageView *avatorImageView;
    
    __weak IBOutlet UILabel *detailContentLabel;
    
    __weak IBOutlet UILabel *floorLabel;
    
    __weak IBOutlet UILabel *timeLabel;
    
    __weak IBOutlet UIButton *detailLikeBtn;
    
}

- (void)awakeFromNib
{
    
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:SupportCommentCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            if ([pack handleSupportOrComment:pack withErrorCode:NoCheckErrorCode])
            {
                DLog(@"赞评论ok");
            }
        }
    }];
    
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:CancleSupportCommentCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            if ([pack handleSupportOrComment:pack withErrorCode:NoCheckErrorCode])
            {
                DLog(@"取消赞评论OK");
            }
        }
    }];
    
    
    if (_comment.floorNum == 1)
    {
        detailContentLabel.textColor = colorWithHex(0xD0246C);
    }
    else
    {
        detailContentLabel.textColor = [UIColor blackColor];
    }
    
    if (_comment.isOwnZanComment == 0)
    {
        [detailLikeBtn setBackgroundImage:[UIImage imageNamed:@"btn_comment_like"] forState:UIControlStateNormal];
    }
    else if (_comment.isOwnZanComment == 1)
    {
        [detailLikeBtn setBackgroundImage:[UIImage imageNamed:@"btn_support_yes"] forState:UIControlStateNormal];
    }
    detailContentLabel.font = getFontWith(NO, 14);
    floorLabel.font = getFontWith(NO, 10);
    timeLabel.font = getFontWith(NO, 10);
}

-(void)setComment:(Comment *)comment
{
    _comment = comment;
    avatorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",comment.avatarId]];
    if (comment.avatarId == 0)
    {
        int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"masterFloor"];
        if (0 == i)
        {
            ShareBlurView *master = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [master shareBlurWithImage:[UIImage imageFromUIView:self] withBlurType:BlurTipsType];
            master.tipsHeight = 195;
            master.tip.contentStr = @"[大粉钻]这个头像是作者专属的";
            master.tip.standImgStr = @"img_tipsStand_up";
            [master.tip customTipsViewWithPoint:CGPointMake(10, -15) tipType:TipsAvatorType withSubTitle:nil withSubImageStr:@"0" subImageSize:CGSizeMake(32, 32)];
//            __weak ShareBlurView *weakMaster = master;
//            [master.tip setHandleTipsOKBtnActionBlock:^{
//                [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:0] withKey:@"masterFloor"];
//                [weakMaster removeFromSuperview];
//            }];
            
            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:0] withKey:@"masterFloor"];
            [self addSubview:master];
        
        }
    }
    else
    {
        int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"follow"];
        if (0 == i)
        {
            ShareBlurView *follow = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [follow shareBlurWithImage:[UIImage screenshot] withBlurType:BlurTipsType];
            follow.tip.contentStr = @"用户头像是随机出现的，每个秘密里相同的头像表示一个人";
            follow.tip.standImgStr = @"img_tipsStand_down";
            [follow.tip customTipsViewWithPoint:CGPointMake(10, 65) tipType:TipsAvatorType withSubTitle:nil withSubImageStr:[NSString stringWithFormat:@"%d",comment.avatarId] subImageSize:CGSizeMake(32, 32)];
//            __weak ShareBlurView *weakFollow = follow;
//            [follow.tip setHandleTipsOKBtnActionBlock:^{
//                [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"follow"];
//                [weakFollow removeFromSuperview];
//            }];
            
            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"follow"];
            [self addSubview:follow];

        }
        
    }
    
    
    detailContentLabel.text = comment.comment;
    floorLabel.text = [NSString stringWithFormat:@"%d楼 —",comment.floorNum];
    NSString *timeStr = [Common timeIntervalStringFromTime:comment.createTime];
    timeLabel.text = timeStr;
    if (comment.isOwnZanComment == 0)
    {
        [detailLikeBtn setBackgroundImage:[UIImage imageNamed:@"btn_comment_like"] forState:UIControlStateNormal];
    }
    else if (comment.isOwnZanComment == 1)
    {
        [detailLikeBtn setBackgroundImage:[UIImage imageNamed:@"btn_support_yes"] forState:UIControlStateNormal];
    }
    else if (comment.isOwnZanComment == 0xFFFFFFFF)
    {
        [detailLikeBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (IBAction)detailLikeBtnAction:(id)sender
{
    if (_comment.isOwnZanComment == 0)
    {
        _comment.isOwnZanComment = 1;
        [detailLikeBtn setBackgroundImage:[UIImage imageNamed:@"btn_support_yes"] forState:UIControlStateNormal];
        [self supportComment];
    }
    else if (_comment.isOwnZanComment == 1)

    {
        _comment.isOwnZanComment = 0;
        [detailLikeBtn setBackgroundImage:[UIImage imageNamed:@"btn_comment_like"] forState:UIControlStateNormal];
        [self cancleSupportComment];
    }
    else if (_comment.isOwnZanComment == 0xFFFFFFFF)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"不能赞自己..." actionText:@"确定"];
    }

}

#pragma mark - 网络请求
-(void)supportComment
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x02];
    
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    [pack supportOrCommentWithUserId:userId userKey:userKey feedId:_comment.feedId commentId:_comment.commentId operation:0x06 comment:@""];
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:SupportCommentCode block:^(int event, id object) {
        
    }];
}

-(void)cancleSupportComment
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x02];
    
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    [pack supportOrCommentWithUserId:userId userKey:userKey feedId:_comment.feedId commentId:_comment.commentId operation:0x07 comment:@""];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
