//
//  RecommendInfo.m
//  WeLinked3
//
//  Created by jonas on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "RecommendInfo.h"
#import "UserInfo.h"
#import "LogicManager.h"
@implementation RecommendInfo
@synthesize DBUid,identity,company1,company2,company3,industryId,jobCode,locationCode,currentCompany,
currentJob,currentLevel,howLong,education,descriptions,subIndustryId,jobImage,poster,posterId,publishTime;
-(id)init
{
    self = [super init];
    if(self)
    {
        self.DBUid = [UserInfo myselfInstance].userId;
    }
    return self;
}

+(NSString*)primaryKey
{
    return @"identity";
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"====%@",key);
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"identity"])
    {
        if(value != nil)
        {
            if([value isKindOfClass:[NSNumber class]])
            {
                [super setValue:[NSString stringWithFormat:@"%d",[(NSNumber*)value intValue]] forKey:key];
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                [super setValue:value forKey:key];
            }
        }
    }
    else
    {
        [super setValue:value forKey:key];
    }
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
    self.company1 = nil;
    self.company2 = nil;
    self.company3 = nil;
    self.industryId = nil;
    self.jobCode = nil;
    self.locationCode = nil;
    self.currentCompany = nil;
    self.currentJob = nil;
    self.descriptions = nil;
}
@end
