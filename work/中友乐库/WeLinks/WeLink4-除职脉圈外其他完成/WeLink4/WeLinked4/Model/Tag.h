//
//  Tag.h
//  WeLinked4
//
//  Created by floar on 14-6-4.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "NSObjectExtention.h"

@interface Tag : NSObjectExtention

@property (nonatomic, assign) int DBUid;//区分数据库归属

@property (nonatomic, assign) double tagId;
@property (nonatomic, strong) NSString *title;

@end
