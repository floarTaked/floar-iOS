//
//  Feed.h
//  WeLinked4
//
//  Created by floar on 14-5-13.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "NSObjectExtention.h"
#import "UserInfo.h"
#import "Tag.h"
#import "Comment.h"
#import "FeedContent.h"

@interface Feed : NSObjectExtention

@property (nonatomic, assign)int DBUid;//区分数据库归属

@property (nonatomic, assign) AllowedFriend allowedFriend; //定义在feedContent中
@property (nonatomic, assign) double createTime;
@property (nonatomic, strong) NSString *feedUrl;
@property (nonatomic, assign) int feedId;

@property (nonatomic, strong) FeedContent *feedContent;

@property (nonatomic, assign) int targetId;
@property (nonatomic, assign) FeedType targetType;  //定义在feedContent中
@property (nonatomic, assign) int targetUserId;
@property (nonatomic, strong) NSString *userContent;
@property (nonatomic, strong) UserInfo *userInfo;





@end
