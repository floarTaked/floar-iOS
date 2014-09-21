//
//  Invocation.h
//  闺秘
//
//  Created by jonas on 7/31/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Package.h"
#include "Common.h"

@interface Invocation : NSObject
@property(nonatomic,assign)int code;
@property(nonatomic,strong)Package* package;
@property(nonatomic,strong)EventCallBack block;
-(BOOL)fire;
@end

@interface InvocationManager : NSObject
{
    NSMutableDictionary* invocations;
}
-(void)parseBlock:(EventCallBack)block withTag:(int)tag;
-(void)parseData:(NSData *)data withTag:(int)tag;
-(BOOL)isFull:(int)tag;
+(InvocationManager *)shareInstance;
@end