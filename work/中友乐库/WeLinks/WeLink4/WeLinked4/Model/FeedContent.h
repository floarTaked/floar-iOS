//
//  FeedContent.h
//  WeLinked4
//
//  Created by floar on 14-6-6.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "NSObjectExtention.h"
#import "Comment.h"
#import "UserInfo.h"
#import "Tag.h"


typedef enum
{
    OnceVisible = 1,
    TwiceVisible,
    ThirdVisible
}AllowedFriend;

typedef enum
{
    feedDynamic = 10,
    feedDynamicUrl = 11,
    feedDynamicImage = 12,
    feedDynamicText = 13,
    feedQuestion = 20,
    feedQuestionVote = 22,
    feedQuestionRate = 23,
    feedQuestionOther = 24,
}FeedType;


@interface FeedContent : NSObject
{
    NSString *commentString;
    NSString *tagString;
    NSString *summaryString;
    NSString *pollOptionString;
}

@property (nonatomic, assign) AllowedFriend allowedFriend;
@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) double createDate;
@property (nonatomic, assign) int feedContentId;
@property (nonatomic, assign) NSString  *lastUpdate;
@property (nonatomic, strong) NSString *tagIds;
@property (nonatomic, assign) int totalComment;
@property (nonatomic, assign) int totalOptin;
@property (nonatomic, assign) int totalVote;
@property (nonatomic, assign) FeedType typeId;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSMutableArray *pollOptionsArray;
@property (nonatomic, strong) NSMutableArray *tagsArray;
@property (nonatomic, strong) NSMutableArray *summaryArray;
@property (nonatomic, strong) NSString *imageUrl; //服务器暂无该参数


@end
