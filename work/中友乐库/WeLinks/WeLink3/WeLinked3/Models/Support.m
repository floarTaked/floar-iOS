//
//  Support.m
//  WeLinked3
//
//  Created by Caesar on 14-3-21.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "Support.h"
#import "UserInfo.h"

@implementation Support
@synthesize DBUid,createTime,targetId,userAvatar,userId,userName,userJob,userCompany,supportId;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.DBUid = [UserInfo myselfInstance].userId;
    }
    return self;
}

+(NSString*)primaryKey
{
    return @"supportId";
}

- (void)dealloc
{
    self.supportId = nil;
    self.targetId = nil;
    self.userAvatar = nil;
    self.userId = nil;
    self.userName = nil;
    self.userCompany = nil;
    self.userJob = nil;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        self.supportId = value;
    }
}


@end
