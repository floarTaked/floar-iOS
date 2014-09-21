//
//  EducationInfo.m
//  WeLinked3
//
//  Created by jonas on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "EducationInfo.h"
@implementation EducationInfo
@synthesize canDel,identity,userId,department,education,school,specialty,year,educationDesc;
-(id)init
{
    self = [super init];
    if(self)
    {
        education = -1;
    }
    return self;
}
+(NSString*)primaryKey
{
    return @"identity";
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.identity = value;
    }
}
@end
