//
//  FeedsViewDataManager.h
//  WeLinked3
//
//  Created by 牟 文斌 on 3/3/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feeds.h"

@class FeedsViewDataManager;
@protocol FeedsViewDataManagerDelegate <NSObject>

- (void)feedsViewDataManagerDidGetFeedsListSuccess:(FeedsViewDataManager *)manager;

- (void)feedsViewDataManagerDidGetFeedsListFailed:(FeedsViewDataManager *)manager;

@end

@interface FeedsViewDataManager : NSObject
@property (nonatomic, assign) id<FeedsViewDataManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *feedsList;

- (void)loadData;
- (void)loadNextPageData;
- (void)supportFeed:(Feeds *)feed Block:(EventCallBack)block;
- (void)disSupportFeed:(Feeds *)feed Block:(EventCallBack)block;
@end
