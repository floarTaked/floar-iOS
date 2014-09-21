//
//  FeedsTableCell.h
//  WeLinked3
//
//  Created by 牟 文斌 on 2/25/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedsViewController.h"
#import "Feeds.h"
#import "CustomCellView.h"
#define kFeedsTableCellShouldResignFirstResponder @"kFeedsTableCellShouldResignFirstResponder"


@class FeedsTableCell;
@protocol FeedsTableCellDelegate <NSObject>

@optional;
//选择某条评论
- (void)didSelectCell:(FeedsTableCell *)cell WithRect:(CGRect)rect;
//评论
- (void)didSelectCell:(FeedsTableCell *)cell;
//发评论
- (void)addNewComment:(NSString *)comment Cell:(FeedsTableCell *)cell;
//赞
- (void)didClickSupportAtCell:(FeedsTableCell *)cell;
//点头像
- (void)didClickUserHeadAtCell:(FeedsTableCell *)cell;
//点击原文
- (void)didClickOriginViewAtCell:(FeedsTableCell *)cell;
//点击评论
- (void)didClickCommentViewAtCell:(FeedsTableCell *)cell;

@end

@interface FeedsTableCell : UITableViewCell

@property (nonatomic, weak) id<FeedsTableCellDelegate> delegate;
@property (nonatomic, weak) FeedsViewController *feedsController;
@property (nonatomic, strong) Feeds *feeds;
@property (nonatomic, strong) NSIndexPath *indexPath;
+(float)cellHeightWithFeed:(Feeds *)feed;
- (void)clearCommentField;
- (void)reloadCommentList;
@end
