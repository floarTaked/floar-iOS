//
//  InfoDetailDataManager.h
//  WeLinked3
//
//  Created by Floar on 14-3-9.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InfoDetailDataManagerDelegate <NSObject>

-(void)infoDetailDataManagerGetDataSuccess;
-(void)infoDetailDataManagerGetDataFailed;

@end

@interface InfoDetailDataManager : NSObject

@property (nonatomic,strong) NSMutableArray *infoDetailArray;
@property (nonatomic, copy) NSString *infoDetailSubscribeItem;
@property (nonatomic, copy) NSString *infoDetailLastItem;
@property (nonatomic, weak) id<InfoDetailDataManagerDelegate>delegate;

//老版本获取文章列表
-(void)loadinfoDetailDataWithSubscribeItem:(NSString *)subscribeItem;

-(void)loadMoreinfoDetailDataWithSubscribeItem:(NSString *)subscribeItem
                                andLastArticleId:(NSString *)lastArticleId;

////timeline获取文章列表
//-(void)loadTimeLineTodayDataWithTimeSubscribeItem:(NSString *)subscribeItem;
//-(void)loadTimeLineMoreDayDataWithTimeSubscribeItem:(NSString *)subscribeItem
//                                            andTime:(NSString *)time;


-(NSArray *)loadinfoDetailDataFromDB;

@end
