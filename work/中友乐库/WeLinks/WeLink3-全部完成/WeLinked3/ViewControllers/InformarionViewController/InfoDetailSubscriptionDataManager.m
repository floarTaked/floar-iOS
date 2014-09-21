//
//  InfoDetailSubscriptionDataManager.m
//  WeLinked3
//
//  Created by Floar on 14-3-8.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "InfoDetailSubscriptionDataManager.h"
#import "NetworkEngine.h"
#import "Column.h"

@implementation InfoDetailSubscriptionDataManager

-(id)init
{
    self = [super init];
    if (self)
    {
        self.infoDetailSubscriptionArray = [[NSMutableArray alloc] init];
        self.infoDetailSearchArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//loadInfoDetailSubscriptionDataFromDBWithParentId这个方法写在init里面是不行的，而且还必须重写parentid的set方法，而且还必须在其他执行这个方法的时候，要用self.parentId,如果用_parentId也是不行的
-(void)setParentId:(NSString *)parentId
{
    _parentId = parentId;
    [self loadInfoDetailSubscriptionDataFromDBWithParentId:self.parentId];
}

-(void)dealloc
{
    self.infoDetailSubscriptionArray = nil;
    self.infoDetailSearchArray = nil;
}

-(void)loadInfoDetailSubscriptionDataWithPreViewCellId:(NSString *)preViewCellId
{
    [[NetworkEngine sharedInstance] getArticleSourceList:preViewCellId block:^(int event, id object)
    {
        if (1 == event)
        {
            [self.infoDetailSubscriptionArray removeAllObjects];
            for (NSDictionary *dict in object)
            {
                Column *column = [[Column alloc] init];
                [column setValuesForKeysWithDictionary:dict];
                [self.infoDetailSubscriptionArray addObject:column];
                [column synchronize:nil];
            }
            
            if ([_delegate respondsToSelector:@selector(InfoDetailSubscriptionDataManagerGetDataSuccess)])
            {
                [_delegate InfoDetailSubscriptionDataManagerGetDataSuccess];
            }
        }
        else
        {
            
        }
    }];
}

-(void)loadInfoDetailSubscriptionDataFromDBWithParentId:(NSString *)parentId
{
    NSArray *array = [[UserDataBaseManager sharedInstance] queryWithClass:[Column class] tableName:nil condition:[NSString stringWithFormat:@"where parentId = '%@' ",parentId]];
    [self.infoDetailSubscriptionArray addObjectsFromArray:array];
}

-(void)loadSearchDataWithKeyword:(NSString *)keyword
{
    [[NetworkEngine sharedInstance] searchArticleByKeyWord:keyword Block:^(int event, id object)
    {
        if (1 == event)
        {
            [self.infoDetailSearchArray removeAllObjects];
            for (NSDictionary *dic in object)
            {
                Column *column = [[Column alloc] init];
                [column setValuesForKeysWithDictionary:dic];
                [self.infoDetailSearchArray addObject:column];
            }
        }
        else
        {
            NSLog(@"search---error");
        }
    }];
}


@end
