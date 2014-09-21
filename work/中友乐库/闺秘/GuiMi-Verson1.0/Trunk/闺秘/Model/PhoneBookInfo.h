//
//  PhoneBookInfo.h
//  WeLinked3
//
//  Created by jonas on 3/10/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "NSObjectExtention.h"

@interface PhoneBookInfo : NSObject
@property(nonatomic, assign) uint64_t phone;
@property(nonatomic, strong) NSString *name;
@end
