//
//  InfoDetailDataManager.m
//  WeLinked3
//
//  Created by Floar on 14-3-9.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "InfoDetailDataManager.h"
#import "NetworkEngine.h"
#import "Article.h"

@implementation InfoDetailDataManager
{
    //必须声明为全局
    NSMutableArray *arr;
}

-(id)init
{
    self = [super init];
    
    if (self)
    {
        self.infoDetailArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc
{
    self.infoDetailArray = nil;
}

-(void)setInfoDetailSubscribeItem:(NSString *)infoDetailSubscribeItem
{
    _infoDetailSubscribeItem = infoDetailSubscribeItem;
    [self loadinfoDetailDataFromDB];
    
}

-(void)loadinfoDetailDataWithSubscribeItem:(NSString *)subscribeItem
{
    [[NetworkEngine sharedInstance] getArticleList:subscribeItem withAritcle:nil block:^(int event, id object)
    {
         if (1 == event)
         {
             [self.infoDetailArray removeAllObjects];
             for (NSDictionary *dic in object)
             {
                 Article *article = [[Article alloc] init];
                 [article setValuesForKeysWithDictionary:dic];
                 article.columnId = subscribeItem;
                 [self.infoDetailArray addObject:article];
                 [article synchronize:nil];
             }
             
             if ([_delegate respondsToSelector:@selector(infoDetailDataManagerGetDataSuccess)])
             {
                 [_delegate infoDetailDataManagerGetDataSuccess];
             }
         }
         else
         {
             [_delegate infoDetailDataManagerGetDataFailed];
         }
     }];
}

-(void)loadMoreinfoDetailDataWithSubscribeItem:(NSString *)subscribeItem andLastArticleId:(NSString *)lastArticleId
{
    [[NetworkEngine sharedInstance] getArticleList:subscribeItem withAritcle:lastArticleId block:^(int event, id object)
     {
         if (1 == event)
         {
             for (NSDictionary *dic in object)
             {
                 Article *article = [[Article alloc] init];
                 [article setValuesForKeysWithDictionary:dic];
                 article.columnId = subscribeItem;
                 
                 [self.infoDetailArray addObject:article];
                 [article synchronize:nil];
             }
             
             
             
             
             if ([_delegate respondsToSelector:@selector(infoDetailDataManagerGetDataSuccess)])
             {
                 [_delegate infoDetailDataManagerGetDataSuccess];
             }
         }
         else
         {
             [_delegate infoDetailDataManagerGetDataFailed];
             NSLog(@"articleList error");
         }
     }];
    
    [self testForTime];
}

-(NSMutableString *)getTimeString:(double)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    
    NSMutableString *tempStr = [NSMutableString stringWithString:timeStr];
    NSRange range = [tempStr rangeOfString:@"月"];
    if (range.location != NSNotFound)
    {
        if ([tempStr characterAtIndex:range.location+1] == '0')
        {
            [tempStr deleteCharactersInRange:NSMakeRange(range.location+1, range.length)];
        }
        if ([tempStr characterAtIndex:range.location-2] == '0')
        {
            [tempStr deleteCharactersInRange:NSMakeRange(range.location-2, range.length)];
        }
    }
    return tempStr;
}

////timeline获取文章列表
//-(void)loadTimeLineTodayDataWithTimeSubscribeItem:(NSString *)subscribeItem
//{
//    NSDate *date = [NSDate date];
//    double time = [date timeIntervalSince1970];
//    NSLog(@"%0.0f",time);
//    
//    NSString *timeString = [NSString stringWithFormat:@"%0.0f",time*1000];
//
//    [[NetworkEngine sharedInstance] getArticleList:subscribeItem withTime:timeString block:^(int event, id object) {
//        if (1 == event)
//        {
//            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//            for (NSDictionary *dict in object)
//            {
//                Article *article = [[Article alloc] init];
////                [article setValuesForKeysWithDictionary:dict];
//                [tempArray addObject:article];
//            }
//            
//            Article *firstArticle = [tempArray firstObject];
//            NSMutableDictionary *timeDict = [[NSMutableDictionary alloc] init];
//            [timeDict setObject:tempArray forKey:[self getTimeString:firstArticle.publishTime]];
////            [self.infoDetailArray addObject:timeDict];
//        }
//    }];
//}

//-(void)loadTimeLineMoreDayDataWithTimeSubscribeItem:(NSString *)subscribeItem
//                                            andTime:(NSString *)time
//{
//    [[NetworkEngine sharedInstance] getArticleList:subscribeItem withTime:time block:^(int event, id object)
//    {
//        if (1 == event)
//        {
//            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//            for (NSDictionary *dict in object)
//            {
//                Article *article = [[Article alloc] init];
////                [article setValuesForKeysWithDictionary:dict];
//                [tempArray addObject:article];
//            }
//            
//            Article *firstArticle = [tempArray firstObject];
//            NSMutableDictionary *timeDict = [[NSMutableDictionary alloc] init];
//            [timeDict setObject:tempArray forKey:[self getTimeString:firstArticle.publishTime]];
////            [self.infoDetailArray addObject:timeDict];
//            
////            NSLog(@"timeResult---%@",self.infoDetailArray);
//        }
//    }];
//}



-(NSArray *)loadinfoDetailDataFromDB
{
    NSArray *array = [[UserDataBaseManager sharedInstance] queryWithClass:[Article class] tableName:nil condition:[NSString stringWithFormat:@"where columnId = '%@'",self.infoDetailSubscribeItem]];
    [self.infoDetailArray addObjectsFromArray:array];
    
    return array;
}


//本地组装timeline标签数据结构
-(void)testForTime
{
    NSArray *array = [[UserDataBaseManager sharedInstance] queryWithClass:[Article class] tableName:nil condition:[NSString stringWithFormat:@"where columnId = '%@' order by publishTime desc",self.infoDetailSubscribeItem]];
    
    NSMutableArray *dataDicArray = [[NSMutableArray alloc] init];
    static NSString *firstDate = @"1";
    
    if (array != nil && array.count != 0)
    {
        for (Article *articel in array)
        {
            NSString *articleTime = [self getTimeString:articel.publishTime];
            
            if (![firstDate isEqualToString:articleTime])
            {
                firstDate = articleTime;
                arr = [[NSMutableArray alloc] init];
                [arr addObject:articel];
                
                NSDictionary *dic = [NSDictionary dictionaryWithObject:arr forKey:firstDate];
                [dataDicArray addObject:dic];
            }
            else
            {
                [arr addObject:articel];
            }
        }
    }
    NSLog(@"dictArray --- %@",dataDicArray);
    NSLog(@"over");
}

@end
