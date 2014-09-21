//
//  Feeds.m
//  WeLinked3
//
//  Created by 牟 文斌 on 3/3/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "Feeds.h"
#import "Comment.h"
#import "LogicManager.h"
#import "Comment.h"
#import "UserInfo.h"
#import "Article.h"
#import "JobInfo.h"

@interface Feeds ()
@end

@implementation Feeds
@synthesize DBUid,autoId,commentUser,commentList,content,createTime,userAvatar,userId,userName,zanUser,feedsId,targetId,zanUserNum,hasZan,feedsType,targetContent,feedUser,userContent,contentType;
- (id)init
{
    self = [super init];
    if (self) {
        self.DBUid = [UserInfo myselfInstance].userId;
    }
    return self;
}

+(NSString*)primaryKey
{
    return @"feedsId";
}

- (void)dealloc
{
    self.autoId = nil;
    self.commentUser = nil;
    self.commentList = nil;
    self.content = nil;
    self.targetContent = nil;
    self.userAvatar = nil;
    self.userId = nil;
    self.userName = nil;
    self.zanUser = nil;
    self.feedsId = nil;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"comments"])
    {
        NSArray* arr = (NSArray*)value;
        NSString *json = [[LogicManager sharedInstance] objectToJsonString:arr];
        self.commentString = json;
        NSMutableArray* commentArray = [[NSMutableArray alloc]init];
        for(NSDictionary* dic in arr)
        {
            Comment* comment = [[Comment alloc]init];
            [comment setValuesForKeysWithDictionary:dic];
            [comment synchronize:nil];
            [commentArray addObject:comment];
        }
//        self.comments = commentArray;
    }else if ([key isEqualToString:@"id"])
    {
        self.feedsId = value;
    }else if ([key isEqualToString:@"feedType"])
    {
        self.feedsType = [value intValue];
    }
}

- (NSMutableArray *)commentList
{
    NSError* error = nil;
    id data = nil;
    if (self.commentString.length) {
        data = [NSJSONSerialization JSONObjectWithData:[self.commentString dataUsingEncoding:NSUTF8StringEncoding]
                                               options:NSJSONReadingMutableLeaves error:&error];
    }
    if(error != nil)
    {
        data = nil;
    }
    NSMutableArray *mutArray = [NSMutableArray array];
    
    for (NSDictionary *dic in data) {
        Comment *comment = [[Comment alloc] init];
        [comment setValuesForKeysWithDictionary:dic];
        [mutArray addObject:comment];
    }
     self.commentList = mutArray;
    return commentList;
    
//    switch (self.feedsType) {
//        case FeedsArticle:
//        case FeedsJob:
//        {
//        
//            array =  [[UserDataBaseManager sharedInstance] queryWithClass:[Comment class] tableName:nil condition:[NSString stringWithFormat:@"where targetId = '%@'",self.targetId]];
//            
//        }
//            
//            break;
//            
//        default:
//        {
//            array =  [[UserDataBaseManager sharedInstance] queryWithClass:[Comment class] tableName:nil condition:[NSString stringWithFormat:@"where targetId = '%@'",self.feedsId]];
//        }
//            break;
//    }
//
//    [array sortedArrayUsingComparator:^NSComparisonResult(Comment *comment1, Comment *comment2) {
//        return comment1.createTime < comment2.createTime;
//    }];
//    if (!array.count) {
//        self.commentList = [NSMutableArray array];
//        return commentList;
//    }
//    NSMutableArray *mutArray = [NSMutableArray array];
//    if (array.count <= 2) {
//        for (int i = array.count - 1 ;  i >= 0 ; i --) {
//            Comment *comment = [array objectAtIndex:i];
//            [mutArray addObject:comment];
//        }
//    }else{
//        for (int i = array.count - 1 ;  i >= array.count - 2; i --) {
//            Comment *comment = [array objectAtIndex:i];
//            [mutArray addObject:comment];
//        }
//    }
//    
//    self.commentList = mutArray;
////    DLog(@"comment count %d",commentList.count);
//    return commentList;
}
@end
