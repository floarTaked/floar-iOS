//
//  APNsMessage.h
//  Guimi
//
//  Created by floar on 14-8-14.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "NSObjectExtention.h"

@interface APNsMessage : NSObjectExtention

@property (nonatomic, assign) uint64_t DBUid;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) NSString *data;

@end
