//
//  Comment.m
//  WeLinked3
//
//  Created by 牟 文斌 on 3/3/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "Comment.h"
#import "UserInfo.h"

@implementation Comment
@synthesize content,createTime,commentId,targetId,userAvatar,userId,userName,userJob,userCompany;
- (id)init
{
    self = [super init];
    if (self)
    {
        self.DBUid = [UserInfo myselfInstance].userId;
    }
    return self;
}

+(NSString*)primaryKey
{
    return @"commentId";
}

- (void)dealloc
{
    self.content = nil;
    self.commentId = nil;
    self.targetId = nil;
    self.userAvatar = nil;
    self.userId = nil;
    self.userName = nil;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        self.commentId = value;
    }
}

@end
