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

@end
