//
//  EducationInfo.m
//  WeLinked3
//
//  Created by jonas on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "EducationInfo.h"
@implementation EducationInfo
@synthesize canDel,identity,department,education,school,specialty,year,educationDesc;
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
    if(value == nil)
    {
        return;
    }
    if([key isEqualToString:@"id"])
    {
        self.identity = [value intValue];
    }
}
@end
