//
//  Comment.m
//  闺秘
//
//  Created by floar on 14-7-11.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "Comment.h"
#import "UserInfo.h"

@implementation Comment
@synthesize DBUid,feedId,commentId,comment,avatarId,createTime,likeNum,floorNum,isOwnZanComment;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.DBUid = [UserInfo myselfInstance].userId;
    }
    return self;
}

+(NSString*)primaryKey
{
    return @"commentId";
}

-(void)analyzePackageForComment:(Package *)pack
{
    feedId = [pack readInt64];
    commentId = [pack readInt64];
    comment = [pack readString];
    floorNum = [pack readInt32];
    avatarId = [pack readInt32];
    likeNum = [pack readInt32];
    isOwnZanComment = [pack readInt32];
    createTime = [pack readInt32];
}

-(void)analyzePackageForPublishComment:(Package *)pack
{
    feedId = [pack readInt64];
    commentId = [pack readInt64];
    floorNum = [pack readInt32];
    avatarId = [pack readInt32];
    isOwnZanComment = 0;
    createTime = [[NSDate date] timeIntervalSince1970];
}

@end
