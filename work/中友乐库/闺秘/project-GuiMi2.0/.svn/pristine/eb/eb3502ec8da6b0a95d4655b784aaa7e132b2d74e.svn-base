//
//  Invocation.m
//  闺秘
//
//  Created by jonas on 7/31/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "Invocation.h"

@implementation Invocation
@synthesize code,package,block;
-(id)init
{
    self = [super init];
    if(self)
    {
        code = 0;
        package = [[Package alloc]init];
        block = nil;
    }
    return self;
}

-(BOOL)fire
{
    if([[InvocationManager shareInstance] isFull:self.code])
    {
        if(self.package != nil && block != nil)
        {
            if([package length] > 0)
            {
                self.block(1,self.package);
            }
            else
            {
                self.block(0,self.package);
            }
        }
        return YES;
    }
    return NO;
}
@end


@implementation InvocationManager
-(id)init
{
    self = [super init];
    if(self)
    {
        invocations = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)parseBlock:(EventCallBack)block withTag:(int)tag
{
    Invocation* inv = [invocations objectForKey:[NSNumber numberWithInt:tag]];
    if(inv == nil)
    {
        inv = [[Invocation alloc]init];
        inv.code = tag;
        inv.block = block;
        [invocations setObject:inv forKey:[NSNumber numberWithInt:inv.code]];
    }
}
-(BOOL)isFull:(int)tag
{
    Invocation* inv = [invocations objectForKey:[NSNumber numberWithInt:tag]];
    if(inv != nil)
    {
        Package* package = inv.package;
        if(package.length + sizeof(uint32_t) < package.fullLength)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}
-(void)parseData:(NSData *)data withTag:(int)tag
{
    Invocation* inv = [invocations objectForKey:[NSNumber numberWithInt:tag]];
    if(inv == nil)
    {
        inv = [[Invocation alloc]init];
        inv.code = tag;
        [invocations setObject:inv forKey:[NSNumber numberWithInt:inv.code]];
    }
    //处理粘包的问题
    if(data != nil)
    {
        Package* pack = inv.package;
        if(pack.length > 0)
        {
            int fullData = pack.fullLength + sizeof(size_t);
            if(pack.length + [data length] > fullData)
            {
                //有粘包
                [pack appendData:[data subdataWithRange:NSMakeRange(0, fullData - pack.length)]];
                int leftLength = [data length] - (fullData - pack.length);
                NSMutableData* leftData = [[NSMutableData alloc]initWithData:[data subdataWithRange:NSMakeRange(fullData-pack.length,
                                                                                                                leftLength)]];
                Package* tempPack = [[Package alloc]initWithData:leftData];
                int tag = tempPack.packgeSequnce;
                [[InvocationManager shareInstance] parseData:leftData withTag:tag];
            }
            else
            {
                //没有粘包
                [pack appendData:data];
            }
        }
        else
        {
            [pack appendData:data];
        }
    }
    if([inv fire])
    {
        [invocations removeObjectForKey:[NSNumber numberWithInt:inv.code]];
    }
}
+(InvocationManager *)shareInstance
{
    static InvocationManager *invocation;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        invocation = [[InvocationManager alloc] init];
    });
    return invocation;
}

@end