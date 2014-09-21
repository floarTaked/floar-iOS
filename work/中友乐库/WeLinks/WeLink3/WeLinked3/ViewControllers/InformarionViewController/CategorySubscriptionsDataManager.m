//
//  CategorySubscriptionsDataManager.m
//  WeLinked3
//
//  Created by Floar on 14-3-8.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "CategorySubscriptionsDataManager.h"
#import "Column.h"
#import "NetworkEngine.h"

@implementation CategorySubscriptionsDataManager

-(id)init
{
    self = [super init];
    if (self)
    {
        self.IndustryChoiceListArray = [[NSMutableArray alloc] init];
        self.GoodChoiceListArray = [[NSMutableArray alloc] init];
        [self subscriptionsLoadIndustryChoiceDataFromDB];
        [self subscriptionsLoadGoodChoiceDataFromDB];
    }
    return self;
}

-(void)dealloc
{
    self.IndustryChoiceListArray = nil;
    self.GoodChoiceListArray = nil;
}

-(void)subscriptionsLoadIndustryChoiceData
{
    [[NetworkEngine sharedInstance] getCategoryListWithType:@"1" black:^(int event, id object)
    {
        if (1 == event)
        {
            [self.IndustryChoiceListArray removeAllObjects];
            for (NSDictionary *dic in object)
            {
                Column *column = [[Column alloc] init];
                [column setValuesForKeysWithDictionary:dic];
                [self.IndustryChoiceListArray addObject:column];
                column.type = @"1";
                [column synchronize:nil];
            }
            if ([_delegate respondsToSelector:@selector(subscriptionsDataManagerGetIndustryChoiceListSuccess)])
            {
                [_delegate subscriptionsDataManagerGetIndustryChoiceListSuccess];
            }
        }
        else
        {
            if ([_delegate respondsToSelector:@selector(subscriptionsDataManagerGetIndustryChoiceListFailed)])
            {
                [_delegate subscriptionsDataManagerGetIndustryChoiceListFailed];
            }
        }

    }];
}

-(void)subscriptionsLoadGoodChoiceData
{
    [[NetworkEngine sharedInstance] getCategoryListWithType:@"2" black:^(int event, id object)
     {
         if (1 == event)
         {
             [self.GoodChoiceListArray removeAllObjects];
             for (NSDictionary *dic in object)
             {
                 Column *column = [[Column alloc] init];
                 [column setValuesForKeysWithDictionary:dic];
                 [self.GoodChoiceListArray addObject:column];
                 column.type = @"2";
                 [column synchronize:nil];
             }
             if ([_delegate respondsToSelector:@selector(subscriptionsDataManagerGetGoodChoiceListSuccess)])
             {
                 [_delegate subscriptionsDataManagerGetGoodChoiceListSuccess];
             }
         }
         else
         {
             if ([_delegate respondsToSelector:@selector(subscriptionsDataManagerGetGoodChoiceListFailed)])
             {
                 [_delegate subscriptionsDataManagerGetIndustryChoiceListFailed];
             }
         }
     }];
}

-(void)subscriptionsLoadIndustryChoiceDataFromDB
{
    NSArray *array = [[UserDataBaseManager sharedInstance] queryWithClass:[Column class] tableName:nil condition:@"where type = '1'"];
    [self.IndustryChoiceListArray addObjectsFromArray:array];
    
}

-(void)subscriptionsLoadGoodChoiceDataFromDB
{
    NSArray *array = [[UserDataBaseManager sharedInstance] queryWithClass:[Column class] tableName:nil condition:@"where type = '2'"];
    [self.GoodChoiceListArray addObjectsFromArray:array];
}
@end
