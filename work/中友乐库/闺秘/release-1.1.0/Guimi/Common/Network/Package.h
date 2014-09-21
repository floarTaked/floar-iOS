//
//  Package.h
//  闺秘
//
//  Created by floar on 14-7-2.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogicManager.h"
#import "UserInfo.h"
#import "Feed.h"
#import "Comment.h"

//static int packageSequenceId = 0;
@interface Package : NSObject
{
    NSMutableData *data;
    int index;
    int packgeSequnce;
}
- (id)initWithSubSystem:(SubSystem)SubsystemId withSubProcotol:(uint32_t)subProcotol;
- (id)initWithData:(NSMutableData *)value;
-(NSData *)getData;
-(void)seek:(int)idx;
-(void)reset;
-(int)length;
-(int)fullLength;
-(int)packgeSequnce;


-(uint32_t)readInt32;
-(uint64_t)readInt64;
-(NSString *)readString;

-(void)appendInt32:(uint32_t)value;
-(void)appendInt64:(uint64_t)value;
-(void)appendString:(NSString *)value;


-(void)setProtocalId:(uint32_t)protocalId;
-(uint32_t)getProtocalId;

-(void)appendData:(NSData*)subData;
@end