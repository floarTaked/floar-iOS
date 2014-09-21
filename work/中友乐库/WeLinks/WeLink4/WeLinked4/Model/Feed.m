//
//  Feed.m
//  WeLinked4
//
//  Created by floar on 14-5-13.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "Feed.h"
#import "UserInfo.h"
#import "LogicManager.h"
#import "Comment.h"

@implementation Feed

@synthesize DBUid,allowedFriend,createTime,feedUrl,feedId,feedContent,targetId,targetType,targetUserId,userContent,userInfo;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.DBUid = [UserInfo myselfInstance].userId;
    }
    return self;
}

+(NSString *)primaryKey
{
    return @"feedId";
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        feedId = [value intValue];
    }
    else if ([key isEqualToString:@"target"])
    {
        if (value == nil)
        {
            NSLog(@"Error---%@ == nil",key);
        }
        if (value != nil)
        {
            feedContentString = [[LogicManager sharedInstance] objectToJsonString:value];
            
//            FeedContent *content = [[FeedContent alloc] init];
//            [content setValuesForKeysWithDictionary:value];
//            feedContent = content;
        }

    }
    else if ([key isEqualToString:@"targetType"])
    {
        targetType = [value intValue];
    }
    else if ([key isEqualToString:@"allowedFriend"])
    {
        allowedFriend = [value intValue];
    }
    else if ([key isEqualToString:@"user"])
    {
        UserInfo *info
        = [[UserInfo alloc] init];
        [info setValuesForKeysWithDictionary:value];
        [info synchronize:FeedCommentUser];
        userInfo = info;
    }
}
-(FeedContent*)feedContent
{
    if(feedContent==nil)
    {
        if(feedContentString != nil)
        {
            NSDictionary* dic = [[LogicManager sharedInstance] jsonStringTOObject:feedContentString];
            if (dic != nil)
            {
                feedContent = [[FeedContent alloc]init];
                [feedContent setValuesForKeysWithDictionary:dic];
            }
        }
    }
    return feedContent;
}
@end

