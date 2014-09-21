//
//  WorkInfo.m
//  WeLinked3
//
//  Created by jonas on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "WorkInfo.h"

@implementation WorkInfo
@synthesize canDel,identity,userId,companyName,year,jobCode,jobDesc;
-(id)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.identity = value;
    }
}
+(NSString*)primaryKey
{
    return @"identity";
}
@end
