//
//  Comment.m
//  WeLinked4
//
//  Created by floar on 14-5-13.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize qid,userId,questUserId,commentId,createDate,content,userInfo;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.DBUid = [UserInfo myselfInstance].userId;
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        self.commentId = [value intValue];
    }
    if ([key isEqualToString:@"user"])
    {
        UserInfo *info = [[UserInfo alloc] init];
        [info setValuesForKeysWithDictionary:value];
        [info synchronize:FeedCommentUser];
        userInfo = info;
    }
}

+(NSString *)primaryKey
{
    return @"commentId";
}

@end
