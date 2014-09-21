//
//  JobViewDataManager.h
//  WeLinked3
//
//  Created by 牟 文斌 on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JobViewDataManagerDelegate <NSObject>
@optional;
- (void)jobViewDataManagerGetFriendJobListSuccess;
- (void)jobViewDataManagerGetFriendJobListFailed;

- (void)jobViewDataManagerGetCompanyJobListSuccess;
- (void)jobViewDataManagerGetCompanyJobListFailed;
@end

@interface JobViewDataManager : NSObject
@property (nonatomic, strong) NSMutableArray *friendJobList;
@property (nonatomic, strong) NSMutableArray *companyJobList;
@property (nonatomic, weak) id<JobViewDataManagerDelegate> delegate;

- (void)loadFriendJob;
- (void)loadCompanyJob;
- (void)loadFriendJobNextPageData;
- (void)loadCompanyJobNextPageData;
@end
