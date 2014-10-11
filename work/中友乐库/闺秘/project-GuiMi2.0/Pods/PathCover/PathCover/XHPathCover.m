//
//  XHPathConver.m
//  XHPathCover
//
//  Created by 曾 宪华 on 14-2-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPathCover.h"

#import <Accelerate/Accelerate.h>
#import <float.h>

@interface XHPathCover ()
{
    UILabel *contentLabel;
    UIView *bottonView;
    UILabel *commitLabel;
    UILabel *commentNumLable;
    UILabel *likeNumLable;
    UIButton *likeBtn;
}

@property (nonatomic, strong) UIView *bannerView;

@end

@implementation XHPathCover

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.offsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)setOffsetY:(CGFloat)y
{
//    NSLog(@"offsetY:%f",_offsetY);
    _offsetY = y;
    contentLabel.alpha = 1 - (-_offsetY/25);
    
    UIView *bannerSuper = _bannerImageView.superview;
    CGRect bframe = bannerSuper.frame;
    if(y < 0)
    {
        bframe.origin.y = y;
        bframe.size.height = -y + bannerSuper.superview.frame.size.height;
        bannerSuper.frame = bframe;
        
        CGPoint center =  _bannerImageView.center;
        center.y = bannerSuper.frame.size.height / 2;
        _bannerImageView.center = center;
        
        if (self.isZoomingEffect)
        {
            _bannerImageView.center = center;
            CGFloat scale = fabsf(y) / self.parallaxHeight;
            _bannerImageView.transform = CGAffineTransformMakeScale(1+scale, 1+scale);
        }
    }
    else
    {
        if(bframe.origin.y != 0)
        {
            bframe.origin.y = 0;
            bframe.size.height = bannerSuper.superview.frame.size.height;
            bannerSuper.frame = bframe;
        }
        if(y < bframe.size.height)
        {
            CGPoint center =  _bannerImageView.center;
            center.y = bannerSuper.frame.size.height/2 + 0.5 * y;
            _bannerImageView.center = center;
        }
    }
}

#pragma mark - Life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.parallaxHeight = 170;
//    self.isLightEffect = YES;
//    self.lightEffectPadding = 80;
//    self.lightEffectAlpha = 1.15;
    
    _bannerView = [[UIView alloc] initWithFrame:self.bounds];
    _bannerView.clipsToBounds = YES;
    
    _bannerImageView = [[EGOImageView alloc] initWithFrame:_bannerView.bounds];
    _bannerImageView.contentMode = UIViewContentModeScaleToFill;
    [_bannerView addSubview:self.bannerImageView];
    
    [self addSubview:self.bannerView];
    
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    shareBtn.frame = CGRectMake(270, 10, 44, 44);
//    [shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_cellShare_n"] forState:UIControlStateNormal];
//    [shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_cellShare_h"] forState:UIControlStateHighlighted];
//    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:shareBtn];

    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 290, 320)];
    contentLabel.text = self.contentStr;
    contentLabel.numberOfLines = 0;
    contentLabel.font =[UIFont fontWithName:@"HiraKakuProN-W3" size:20];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = [UIColor whiteColor];
    if (self.contentStr != nil)
    {
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self.contentStr];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        [paragraph setLineSpacing:7];
        [attribute addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, self.contentStr.length)];
        [contentLabel setAttributedText:attribute];
    }
    
    /*
     1,_banner上面会移动而在_bannerImageView上面不会
     */
    [_bannerImageView addSubview:contentLabel];
}

- (void)dealloc
{
    self.bannerImageView = nil;
    self.bannerView = nil;
}

#pragma mark - setters
-(void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
    contentLabel.text = contentStr;
}

//-(void)setXpCommentNum:(uint32_t)xpCommentNum
//{
//    _xpCommentNum = xpCommentNum;
//    commentNumLable.text = [NSString stringWithFormat:@"%d",xpCommentNum];
//}
//
//-(void)setXpLikeNum:(uint32_t)xpLikeNum
//{
//    _xpLikeNum = xpLikeNum;
//    likeNumLable.text = [NSString stringWithFormat:@"%d",xpLikeNum];
//}
//
//-(void)setCommitStr:(NSString *)commitStr
//{
//    _commitStr = commitStr;
//    commitLabel.text = commitStr;
//}
//
//-(void)setIsSupportLike:(uint32_t)isSupportLike
//{
//    _isSupportLike = isSupportLike;
//    if (isSupportLike == 0)
//    {
//        [likeBtn setImage:[[UIImage imageNamed:@"btn_support_no"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    }
//    else if (isSupportLike == 1)
//    {
//        [likeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_support_yes"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    }
//    else if (isSupportLike == 0xFFFFFFFF)
//    {
//        [likeBtn setImage:[[UIImage imageNamed:@"btn_support_no"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    }
//}

//-(void)shareBtnAction
//{
//    if (self.handleShareBtnBlock)
//    {
//        self.handleShareBtnBlock();
//    }
//}
//
//-(void)commitBtnAction
//{
//    if (self.handleCommitBtnBlock)
//    {
//        self.handleCommitBtnBlock();
//    }
//}
//
//-(void)otherBtnAction
//{
//    if (self.handleOtherBtnBlock)
//    {
//        self.handleOtherBtnBlock();
//    }
//}
//
//-(void)commentBtnAction
//{
//    if (self.handleCommentBtnBlock)
//    {
//        self.handleCommentBtnBlock();
//    }
//}
//
////-(void)likeBtnAction
////{
////    if (self.handleLikeBtnBlock)
////    {
////        self.handleLikeBtnBlock();
////    }
////    if (_isSupportLike == 0)
////    {
////        _xpLikeNum++;
////        [likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_support_yes"] forState:UIControlStateNormal];
////    }
////    else if (_isSupportLike == 1)
////    {
////        _xpLikeNum--;
////        [likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_support_no"] forState:UIControlStateNormal];
////    }
////    else if (_isSupportLike == 0xFFFFFFFF)
////    {
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"居然不能点赞" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
////        [alert show];
////    }
////    likeNumLable.text = [NSString stringWithFormat:@"%d",_xpLikeNum];
////}
//
//- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
//{
//    UIGraphicsBeginImageContext(theView.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    UIRectClip(r);
//    [theView.layer renderInContext:context];
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
//}
//
//
//-(void)customBottonToolView:(UIView *)view
//{
//    bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 50)];
//    bottonView.backgroundColor = [UIColor whiteColor];
//    [view addSubview:bottonView];
//    
//    commitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
//    commitLabel.font = [UIFont systemFontOfSize:12];
//    commitLabel.textColor = [UIColor redColor];
//    [bottonView addSubview:commitLabel];
//    
//    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    commitBtn.frame = CGRectMake(CGRectGetMinX(commitLabel.frame), 3, 50, 34);
//    [commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [bottonView addSubview:commitBtn];
//    
//    
//    UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    otherBtn.frame = CGRectMake(145, 15, 20, 20);
//    [otherBtn setImage:[[UIImage imageNamed:@"btn_other_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [otherBtn addTarget:self action:@selector(otherBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [bottonView addSubview:otherBtn];
//    
//    
//    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(otherBtn.frame)+15, CGRectGetMinY(otherBtn.frame), 1, 20)];
//    lineImage.image = [UIImage imageNamed:@"img_sepLine"];
//    [bottonView addSubview:lineImage];
//    
//    
//    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    commentBtn.frame = CGRectMake(CGRectGetMaxX(lineImage.frame)+15, CGRectGetMinY(otherBtn.frame), 20, 20);
//    [commentBtn setImage:[[UIImage imageNamed:@"btn_chat_no"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [commentBtn addTarget:self action:@selector(commentBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [bottonView addSubview:commentBtn];
//    
//    
//    commentNumLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentBtn.frame), 5, 30, 40)];
//    //    commentNumLable.text = @"50";
//    commentNumLable.textAlignment = NSTextAlignmentCenter;
//    [bottonView addSubview:commentNumLable];
//    //
//    UIImageView *lineImageOther = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentNumLable.frame)+5, CGRectGetMinY(lineImage.frame), 1, 20)];
//    lineImageOther.image = [UIImage imageNamed:@"img_sepLine"];
//    [bottonView addSubview:lineImageOther];
//    
//    likeNumLable =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineImageOther.frame)+30,5, 40, 40)];
//    //    likeNumLable.text = @"20";
//    likeNumLable.textAlignment = NSTextAlignmentCenter;
//    [bottonView addSubview:likeNumLable];
//    
//    likeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    likeBtn.frame = CGRectMake(CGRectGetMaxX(lineImageOther.frame)+15, CGRectGetMinY(lineImageOther.frame), 20, 20);
//    [likeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_support_no"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [likeBtn addTarget:self action:@selector(likeBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [bottonView addSubview:likeBtn];
//}

@end
