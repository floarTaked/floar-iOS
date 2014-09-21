//
//  Column.m
//  WeLinked3
//
//  Created by Floar on 14-3-8.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "Column.h"
#import "UserInfo.h"

@implementation Column
@synthesize DBUid,colunmID,img,firstImg,isSubscribe,parentId,title,type;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.DBUid = [UserInfo myselfInstance].userId;
    }
    return self;
}

-(void)dealloc
{
    self.colunmID = nil;
    self.img = nil;
    self.title = nil;
    self.isSubscribe = nil;
    self.parentId = nil;
    self.type = nil;
    self.firstImg = nil;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        self.colunmID = value;
    }
}

+(NSString *)primaryKey
{
    return @"colunmID";
}

@end
