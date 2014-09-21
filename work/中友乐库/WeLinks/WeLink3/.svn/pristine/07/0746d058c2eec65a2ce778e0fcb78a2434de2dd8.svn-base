//
//  InfoDetailSubscriptionDataManager.h
//  WeLinked3
//
//  Created by Floar on 14-3-8.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "NSObjectExtention.h"

@protocol InfoDetailSubscriptionDataManagerDelegate <NSObject>

-(void)InfoDetailSubscriptionDataManagerGetDataSuccess;
-(void)InfoDetailSubscriptionDataManagerGetDataFailed;

@end

@interface InfoDetailSubscriptionDataManager : NSObjectExtention

@property (nonatomic, strong) NSMutableArray *infoDetailSubscriptionArray;
@property (nonatomic, strong) NSMutableArray *infoDetailSearchArray;
@property (nonatomic, strong) NSString *parentId;

@property (nonatomic, weak) id<InfoDetailSubscriptionDataManagerDelegate>delegate;

-(void)loadInfoDetailSubscriptionDataWithPreViewCellId:(NSString *)preViewCellId;
-(void)loadInfoDetailSubscriptionDataFromDBWithParentId:(NSString *)parentId;
-(void)loadSearchDataWithKeyword:(NSString *)keyword;


@end
