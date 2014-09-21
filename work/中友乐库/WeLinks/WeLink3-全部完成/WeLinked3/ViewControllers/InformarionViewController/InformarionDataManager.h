//
//  InformarionDataManager.h
//  WeLinked3
//
//  Created by Floar on 14-3-8.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InformarionDataManagerDelegate <NSObject>

@optional;

-(void)informarionDataMangerGetDataSuccess;
-(void)informarionDataMangerGetDataFailed;

@end

@interface InformarionDataManager : NSObject


@property (nonatomic, strong) NSMutableArray *informarionArray;
@property (nonatomic, weak) id<InformarionDataManagerDelegate>delegate;

-(void)loadInformarionDataFromNetWork;
-(void)loadInformarionDataFromDB;

@end
