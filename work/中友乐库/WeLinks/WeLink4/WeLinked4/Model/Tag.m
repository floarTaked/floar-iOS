//
//  Tag.m
//  WeLinked4
//
//  Created by floar on 14-6-4.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "Tag.h"
#import "UserInfo.h"

@implementation Tag

@synthesize tagId,title;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"] && value != nil)
    {
        self.tagId = [value intValue];
    }
}


@end
