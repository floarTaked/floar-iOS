//
//  JobInfo.m
//  WeLinked3
//
//  Created by 牟 文斌 on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "JobInfo.h"
#import "UserInfo.h"
#import "LogicManager.h"
@implementation JobInfo
@synthesize DBUid,identity,company,jobCode,locationCode,jobLevel,howLong,salaryLevel,education,describes,industryId,
subIndustryId,jobImage,poster,posterId,publishTime,isFriendJob,past,posterImg;
+(NSString*)primaryKey
{
    return @"identity";
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.DBUid = [UserInfo myselfInstance].userId;
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"JobInfo===UndefinedKey:%@",key);
}
-(void)setIndustryId:(NSString *)iid
{
    industryId = iid;
    self.jobImage = [[LogicManager sharedInstance] getIndustryImage:iid];
}
-(NSString*)jobImage
{
    if(jobImage != nil && [jobImage length]>0)
    {
        return jobImage;
    }
    if(industryId != nil && [industryId length]>0)
    {
        jobImage = [[LogicManager sharedInstance] getIndustryImage:industryId];
    }
    return jobImage;
}
- (void)dealloc
{
    self.DBUid = nil;
    self.identity = nil;
    self.company = nil;
    self.jobCode = nil;
    self.locationCode = nil;
    self.describes = nil;
    self.industryId = nil;
    self.subIndustryId = nil;
    self.jobImage = nil;
    self.poster = nil;
    self.posterId = nil;
}
@end
