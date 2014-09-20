
//
//  package.m
//  KitMoreTest
//
//  Created by floar on 14-7-2.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "package.h"

@implementation package
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        index = 0;
        data = [[NSMutableData alloc] init];
    }
    return self;
}

-(id)initWithData:(NSMutableData *)value
{
    self = [super init];
    if(self)
    {
        index = 0;
        data = value;
    }
    return self;
}

-(void)reset
{
    index = 0;
}
-(int)readInt
{
    int value;
    [data getBytes:&value range:NSMakeRange(index, 4)];
    index += 4;
    NTOHL(value);
    return value;
}

-(long long)readDouble
{
    double value;
    int* a = (int*)&value;
    NTOHL(*a);
    a += 1;
    NTOHL(*a);
    
    [data getBytes:&value range:NSMakeRange(index, 8)];
    index += 8;
    return value;
}

-(NSString *)readString
{
    int length = [self readInt];
    NSData *d = [data subdataWithRange:NSMakeRange(index, length)];
    NSString* s = [[NSString alloc]initWithData:d encoding:NSUTF8StringEncoding];
    index += length;
    return s;
}


-(void)setInt:(int)value
{
//    <00000001>
    value = CFSwapInt32HostToBig(value);
    [data appendBytes:&value length:sizeof(value)];
    index += sizeof(value);
}
-(void)setdouble:(long long)value
{
    //<02000001 02000001>
    //<01000002 01000002>
    
    //<01000000 00000000> : 0x01
    //<00000000 00000001>
    
    //<30000000 00000000> : 0x30
    //<00000030 00000000>
    
    int* a = (int*)&value;
    HTONL(*a);
    a += 1;
    HTONL(*a);
    [data appendBytes:&value length:sizeof(value)];
    index += sizeof(value);
}

-(long long)anOtherSetdouble:(long long)value
{
    int low = (UInt32)(value&0xFFFFFFFF);
    value >>= 32;
    int high = (UInt32)(value&0xFFFFFFFF);
    value = HTONL(low);
    value <<= 32;
    value |=HTONL(high);
    [data appendBytes:&value length:sizeof(value)];
    return(value);
}

-(void)setString:(NSString *)value
{
    int length = [value length];
    [self setInt:length];
    [data appendBytes:[value cStringUsingEncoding:NSUTF8StringEncoding] length:length];
    index += length;
}

-(NSData *)getData
{
    NSMutableData* d = [[NSMutableData alloc]init];
    int l = [data length];
    [d appendBytes:&l length:sizeof(l)];
    [d appendData:data];
    return d;
}

@end
