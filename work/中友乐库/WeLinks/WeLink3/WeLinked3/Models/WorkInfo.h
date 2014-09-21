//
//  WorkInfo.h
//  WeLinked3
//
//  Created by jonas on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "NSObjectExtention.h"

@interface WorkInfo : NSObjectExtention
@property(nonatomic,assign)int            canDel;
@property(nonatomic,strong)NSString*      identity;
@property(nonatomic,strong)NSString*      userId;
@property(nonatomic,strong)NSString*      companyName;
@property(nonatomic,strong)NSString*      year;
@property(nonatomic,strong)NSString*      jobCode;
@property(nonatomic,strong)NSString*      jobDesc;
@end
