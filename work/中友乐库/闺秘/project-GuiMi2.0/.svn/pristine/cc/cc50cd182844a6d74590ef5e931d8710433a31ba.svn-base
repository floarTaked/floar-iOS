//
//  Notice.m
//  Guimi
//
//  Created by jonas on 8/22/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "Notice.h"
#import "UserInfo.h"
@implementation Notice
@synthesize DBUid,feedId,userId,createTime,type;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.DBUid = [UserInfo myselfInstance].userId;
        self.createTime = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

+(NSString*)primaryKey
{
    return @"createTime";
}
@end
