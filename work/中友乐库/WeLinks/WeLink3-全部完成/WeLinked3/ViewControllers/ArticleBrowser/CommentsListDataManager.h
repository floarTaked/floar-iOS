//
//  CommentsListDataManager.h
//  WeLinked3
//
//  Created by 牟 文斌 on 3/10/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"
#import "Feeds.h"

@class CommentsListDataManager;
@protocol CommentsListDataManagerDelegate <NSObject>

- (void)getCommentListSuccess:(CommentsListDataManager *)dataManager;

- (void)getCommentListFailed:(CommentsListDataManager *)dataManager;

- (void)addNewCommentSuccess:(CommentsListDataManager *)dataManager;

- (void)addNewCommentFailed:(CommentsListDataManager *)dataManager;
@end

@interface CommentsListDataManager : NSObject
@property (nonatomic, strong) NSMutableArray *supportList;
@property (nonatomic, strong) NSMutableArray *commentList;
@property (nonatomic, strong) NSMutableArray *supportDetailArray;
//@property (nonatomic, strong) Article *article;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, assign) id<CommentsListDataManagerDelegate> delegate;

- (void)loadData;

-(void)loadCommentAndSupport:(NSString *)targetId;

-(void)loadUserPostCommentAndSupport:(NSString *)targetId;

- (void)addNewComment:(NSString *)comment;

@end
