//
//  Column.h
//  WeLinked3
//
//  Created by Floar on 14-3-8.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "NSObjectExtention.h"

@interface Column : NSObjectExtention

@property(nonatomic,strong)NSString* DBUid;//区分数据库归属

@property (nonatomic, strong) NSString *colunmID;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *firstImg;
@property (nonatomic, strong) NSString *isSubscribe;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@end
