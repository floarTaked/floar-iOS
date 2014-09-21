//
//  Comment.h
//  WeLinked3
//
//  Created by 牟 文斌 on 3/3/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "NSObjectExtention.h"

@interface Comment : NSObjectExtention
{   
}
@property(nonatomic,strong)NSString* DBUid;//区分数据库归属

@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) double createTime;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *targetId;
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userJob;
@property (nonatomic, strong) NSString *userCompany;
@end
