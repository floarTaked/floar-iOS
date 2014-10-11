//
//  Comment.h
//  闺秘
//
//  Created by floar on 14-7-11.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObjectExtention.h"
#import "Package.h"

@interface Comment : NSObjectExtention

@property (nonatomic, assign) uint64_t DBUid;//区分数据库归属
@property (nonatomic, assign) uint64_t feedId;
@property (nonatomic, assign) uint64_t commentId;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) uint32_t avatarId;
@property (nonatomic, assign) uint32_t createTime;
@property (nonatomic, assign) uint32_t likeNum;
@property (nonatomic, assign) uint32_t floorNum;
@property (nonatomic, assign) uint32_t isOwnZanComment;

-(void)analyzePackageForComment:(Package *)pack;
-(void)analyzePackageForPublishComment:(Package *)pack;

@end
