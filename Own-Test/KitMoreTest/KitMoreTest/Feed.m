//
//  Feed.m
//  MoreTest
//
//  Created by floar on 14-6-11.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "Feed.h"
#import "Comment.h"

@implementation Feed

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.commentArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
