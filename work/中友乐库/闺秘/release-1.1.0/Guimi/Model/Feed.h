//
//  Feed.h
//  闺秘
//
//  Created by floar on 14-6-24.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "NSObjectExtention.h"
typedef enum
{
    FeedNormalType = 0,
    FeedSystemType
}FeedType;

@interface Feed : NSObjectExtention

@property (nonatomic, assign) uint64_t DBUid;//区分数据库归属
@property (nonatomic, assign) uint64_t feedId;
@property (nonatomic, strong) NSString *contentJson;
@property (nonatomic, assign) uint32_t likeNum;
@property (nonatomic, assign) uint32_t commentNum;
@property (nonatomic, strong) NSString *addressStr;
@property (nonatomic, assign) uint32_t isOwnZanFeed;
@property (nonatomic, assign) uint32_t canComment;
@property (nonatomic, assign) NSTimeInterval createTime;

//解析内容Json后结果
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *imageStr;



//@property (nonatomic, strong) NSString *commentJson;
//@property (nonatomic, strong) NSMutableArray *commentArray;
@end
