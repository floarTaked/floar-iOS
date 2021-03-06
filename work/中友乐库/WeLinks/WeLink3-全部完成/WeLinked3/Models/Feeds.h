//
//  Feeds.h
//  WeLinked3
//
//  Created by 牟 文斌 on 3/3/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "NSObjectExtention.h"

typedef enum {
    FeedsArticle = 1,
    FeedsJob,
    FeedsUserPost,
    FeedsUpdateProfile,
    FeedsSystem,
}FeedsType;

typedef enum {
    FeedContentTypeComment = 2,
    FeedContentTypeSupport = 1,
    FeedContentTypeDefault = 0
}FeedContentType;

@interface Feeds : NSObjectExtention

@property(nonatomic,strong)NSString* DBUid;//区分数据库归属

@property (nonatomic, strong)NSString *         autoId;
@property(nonatomic, strong)NSString *          commentUser;
@property(nonatomic, assign)int                        commentUserNum;
@property(nonatomic,strong)NSMutableArray*commentList;
@property (nonatomic, strong) NSString *        content;
@property(nonatomic,assign)double                   createTime;
@property(nonatomic,strong)NSString *           targetContent;
@property(nonatomic, strong)NSString *          userAvatar;
@property(nonatomic, strong)NSString *          userId;
@property(nonatomic, strong)NSString *          userName;
@property(nonatomic, strong)NSString *          zanUser;
@property(nonatomic, strong)NSString *          feedsId;
@property(nonatomic, strong)NSString *          targetId;
@property(nonatomic, strong)NSString *          userCompany;
@property(nonatomic, strong)NSString *          userJob;
@property(nonatomic, strong)NSString *          userContent;
@property(nonatomic, strong)NSString *          feedUser;
@property (nonatomic, strong) NSString *commentString;
@property(nonatomic, assign)int                         zanUserNum;
@property(nonatomic, assign) BOOL                   hasZan;
@property (nonatomic, assign) FeedsType          feedsType;
@property (nonatomic, assign) FeedContentType          contentType;
@end
