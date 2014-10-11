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

@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) EGOImageView *bannerImageView;
//
//@property (nonatomic, assign) uint32_t xpLikeNum;
//@property (nonatomic, assign) uint32_t xpCommentNum;
//@property (nonatomic, strong) NSString *commitStr;
//@property (nonatomic, assign) uint32_t isSupportLike;


@property (nonatomic) CGFloat offsetY;
@property (nonatomic, assign) CGFloat parallaxHeight;
@property (nonatomic, assign) BOOL isZoomingEffect;


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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end
