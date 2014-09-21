//
//  FeedContent.m
//  WeLinked4
//
//  Created by floar on 14-6-6.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "FeedContent.h"
#import "LogicManager.h"

@implementation FeedContent
@synthesize DBUid,allowedFriend,commentsArray,content,feedContentId,lastUpdate,tagIds,totalComment,totalOptin,totalVote,userInfo,pollOptionsArray,tagsArray,summaryArray,imageUrl,typeId;

- (instancetype)init
{
    self = [super init];
    if (self) {
        DBUid = [UserInfo myselfInstance].userId;
        commentsArray = [[NSMutableArray alloc] init];
        pollOptionsArray = [[NSMutableArray alloc] init];
        tagsArray = [[NSMutableArray alloc] init];
        summaryArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

+(NSString *)primaryKey
{
    return @"feedContentId";
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"])
    {
        feedContentId = [value intValue];
    }
    else if ([key isEqual:@"allowedFriend"])
    {
        allowedFriend = [value intValue];
    }
    else if ([key isEqual:@"comments"])
    {
        NSArray *array = (NSArray *)value;
        commentString = [[LogicManager sharedInstance] objectToJsonString:array];
        for (NSDictionary *dict in array) {
            Comment *comment = [[Comment alloc] init];
            [comment setValuesForKeysWithDictionary:dict];
            [comment synchronize:nil];
            [commentsArray addObject:comment];
        }
    }
    else if ([key isEqual:@"summary"])
    {
        
    }
    else if ([key isEqual:@"typeId"])
    {
        typeId = [value intValue];
    }
    else if ([key isEqual:@"user"])
    {
        UserInfo *info = [[UserInfo alloc] init];
        [info setValuesForKeysWithDictionary:value];
        [info synchronize:nil];
        userInfo = info;
    }
    else if ([key isEqual:@"pollOptions"])
    {
        NSDictionary *dict = (NSDictionary *)value;
        pollOptionString = [[LogicManager sharedInstance] objectToJsonString:dict];
        NSString *option = nil;
        NSArray *keyArray = [dict allKeys];
        NSMutableArray *resultArray = [NSMutableArray arrayWithArray:keyArray];
        
        for (int i = 0; i < resultArray.count; i++)
        {
            for (int j = i+1; j < resultArray.count; j++)
            {
                if ([[resultArray objectAtIndex:i] intValue] > [[resultArray objectAtIndex:j] intValue])
                {
                    [resultArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
        
        for (NSString *keyString in resultArray)
        {
            option = [dict objectForKey:keyString];
            if (option != nil)
            {
                [pollOptionsArray addObject:option];
            }
        }
    }
    else if ([key isEqual:@"tags"])
    {
        NSArray *array = (NSArray *)value;
        tagString = [[LogicManager sharedInstance] objectToJsonString:array];
        for (NSDictionary *dict  in array)
        {
            Tag *tag = [[Tag alloc] init];
            [tag setValuesForKeysWithDictionary:dict];
            [tag synchronize:nil];
            [tagsArray addObject:tag];
        }
    }
}

@end
