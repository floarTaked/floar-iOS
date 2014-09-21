//
//  XHPathConver.h
//  XHPathCover
//
//  Created by 曾 宪华 on 14-2-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EGOImageView.h>

@interface XHPathCover : UIView

// parallax background
@property (nonatomic, strong) NSString *BGStr;
@property (nonatomic, assign) uint32_t xpLikeNum;
@property (nonatomic, assign) uint32_t xpCommentNum;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *commitStr;
@property (nonatomic, assign) uint32_t isSupportLike;
@property (nonatomic, strong) EGOImageView *bannerImageView;
@property (nonatomic, strong) UIImageView *bannerImageViewWithImageEffects;

//scrollView call back
@property (nonatomic) BOOL touching;
//控制顶部
@property (nonatomic) CGFloat offsetY;

// parallax background origin Y for parallaxHeight
@property (nonatomic, assign) CGFloat parallaxHeight; // default is 170， this height was not self heigth.

@property (nonatomic, assign) BOOL isZoomingEffect; // default is NO， if isZoomingEffect is YES, will be dissmiss parallax effect
@property (nonatomic, assign) BOOL isLightEffect; // default is YES
@property (nonatomic, assign) CGFloat lightEffectPadding; // default is 80
@property (nonatomic, assign) CGFloat lightEffectAlpha; // default is 1.12 (between 1 - 2)

@property (nonatomic, copy) void(^handleRefreshEvent)(void);

//custom view's buttons action
@property (nonatomic, copy) void(^handleOffsetBlock)(void);
@property (nonatomic, copy) void(^handleTapBackgroundImageEvent)(void);
//@property (nonatomic, copy) void(^handleBackBtnBlock)(void);
@property (nonatomic, copy) void(^handleShareBtnBlock)(void);
@property (nonatomic, copy) void(^handleCommitBtnBlock)(void);
@property (nonatomic, copy) void(^handleOtherBtnBlock)(void);
@property (nonatomic, copy) void(^handleCommentBtnBlock)(void);
@property (nonatomic, copy) void(^handleLikeBtnBlock)(void);

// stop Refresh
- (void)stopRefresh;

- (void)setBackgroundImage:(EGOImageView *)backgroundImage;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end
