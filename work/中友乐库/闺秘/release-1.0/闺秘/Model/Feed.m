//
//  Feed.m
//  闺秘
//
//  Created by floar on 14-6-24.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "Feed.h"
#import "Comment.h"
#import "UserInfo.h"
#import "LogicManager.h"

@implementation Feed
@synthesize DBUid,feedId,contentJson,likeNum,commentNum,contentStr,imageStr,addressStr,isOwnZanFeed;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.DBUid = [UserInfo myselfInstance].userId;
//        commentArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+(NSString*)primaryKey
{
    return @"feedId";
}

//-(NSMutableArray *)commentArray
//{
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    
//    
//    
//    return array;
//}

@end
