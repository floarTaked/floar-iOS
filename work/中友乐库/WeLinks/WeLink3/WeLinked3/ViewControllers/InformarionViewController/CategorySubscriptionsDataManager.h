//
//  CategorySubscriptionsDataManager.h
//  WeLinked3
//
//  Created by Floar on 14-3-8.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CategorySubscriptionsDataManagerDelegate <NSObject>

- (void)subscriptionsDataManagerGetIndustryChoiceListSuccess;
- (void)subscriptionsDataManagerGetIndustryChoiceListFailed;
- (void)subscriptionsDataManagerGetGoodChoiceListSuccess;
- (void)subscriptionsDataManagerGetGoodChoiceListFailed;

@end

@interface CategorySubscriptionsDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *IndustryChoiceListArray;
@property (nonatomic, strong) NSMutableArray *GoodChoiceListArray;
@property (nonatomic, weak) id<CategorySubscriptionsDataManagerDelegate>delegate;

-(void)subscriptionsLoadIndustryChoiceData;
-(void)subscriptionsLoadIndustryChoiceDataFromDB;


-(void)subscriptionsLoadGoodChoiceData;
-(void)subscriptionsLoadGoodChoiceDataFromDB;



@end
