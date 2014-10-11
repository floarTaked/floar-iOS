//
//  Notice.h
//  Guimi
//
//  Created by jonas on 8/22/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "NSObjectExtention.h"

@interface Notice : NSObjectExtention
{
    
}
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, assign) uint64_t DBUid;
@property (nonatomic, assign) uint64_t userId;
@property (nonatomic, assign) uint64_t feedId;
@property (nonatomic, assign) int type;
@end
