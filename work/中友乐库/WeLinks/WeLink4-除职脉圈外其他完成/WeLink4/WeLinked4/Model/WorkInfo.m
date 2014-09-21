//
//  WorkInfo.m
//  WeLinked3
//
//  Created by jonas on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "WorkInfo.h"

@implementation WorkInfo
@synthesize identity,canDel,companyName,year,jobTitle,jobDesc,industry,jobCode;
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
    if(value == nil)
    {
        return;
    }
    if([key isEqualToString:@"id"])
    {
        self.identity = [value intValue];
    }
}
+(NSString*)primaryKey
{
    return @"identity";
}
@end
