//
//  WeiboRelationInfo.m
//  WeLinked3
//
//  Created by jonas on 3/12/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "WeiboRelationInfo.h"
@implementation WeiboRelationInfo
@synthesize weiboId,weiboUid,createTime;
+(NSString*)primaryKey
{
    return @"weiboId";
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"uid"])
    {
        self.weiboUid = [NSString stringWithFormat:@"%lld",[(NSNumber*)value longLongValue]];
    }
    else if ([key isEqualToString:@"created_at"])
    {
        if(value != nil)
        {
            struct tm  sometime;
            const char *formatString = "%a %b %d %H:%M:%S %z %Y";
            strptime([value UTF8String], formatString, &sometime);
            self.createTime = mktime(&sometime);
        }
    }
    else if ([key isEqualToString:@"id"])
    {
        self.weiboId = [NSString stringWithFormat:@"%lld",[(NSNumber*)value longLongValue]];
    }
}
@end
