//
//  Package.m
//  闺秘
//
//  Created by floar on 14-7-2.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "Package.h"
#import "PhoneBookInfo.h"
#import <CoreFoundation/CFByteOrder.h>
#import "DataBaseManager.h"
#import "StringHelper.h"

static int sequence = 0;
@implementation Package
- (id)initWithSubSystem:(SubSystem)systemId withSubProcotol:(uint32_t)subProcotol
{
    self = [super init];
    if (self)
    {
        sequence++;
        data = [[NSMutableData alloc] init];
        index = 0;
        [self appendInt32:0];//length
        [self appendInt32:'ZALB'];//MagicNumber
        [self appendInt32:PROJECTID];//ProjectId
        [self appendInt32:systemId];//SubsysId
        [self appendInt32:subProcotol];//ProtocalId
        [self appendInt32:sequence];//SequenceId
        packgeSequnce = sequence;
    }
    return self;
}

- (id)initWithData:(NSMutableData *)value
{
    self = [super init];
    if (self)
    {
        index = 0;
        data = value;
    }
    return self;
}
-(int)packgeSequnce
{
    if(data != nil && [data length]>=24)
    {
        int preIndex = index;
        [self seek:20];
        int seq = [self readInt32];
        index = preIndex;
        return seq;
    }
    return 0;
}
- (id)init
{
    self = [super init];
    if (self)
    {
        data = [[NSMutableData alloc] init];
        index = 0;
    }
    return self;
}

#pragma mark - Function

-(NSData *)getData
{
    uint32_t len = [data length] - sizeof(uint32_t);
    uint32_t l = CFSwapInt32HostToBig(len);
    [data replaceBytesInRange:NSMakeRange(0, sizeof(l)) withBytes:&l];
    
//    char buffer[10240];
//    [data getBytes:buffer length:[data length]];
//    auto s = zli::hexShow(buffer, [data length]);
//    NSLog(@"\n%s", s.c_str());
    
//    char buffer[10240];
//    [data getBytes:buffer length:[data length]];
//    auto s = zli::hexShow(buffer, [data length]);
    return data;
}
-(void)setProtocalId:(uint32_t)protocalId;
{
    uint32_t proID = CFSwapInt32HostToBig(protocalId);
    [data replaceBytesInRange:NSMakeRange(4 * sizeof(uint32_t), sizeof(proID)) withBytes:&proID];
}
-(uint32_t)getProtocalId
{
    uint32_t value;
    [data getBytes:&value range:NSMakeRange(4 * sizeof(uint32_t), sizeof(uint32_t))];
    value = CFSwapInt32BigToHost(value);
    return value;
}

#pragma mark - InvocationManager
-(int)length
{
    if(data != nil)
    {
        return [data length];
    }
    return 0;
}
-(int)fullLength
{
    if(data != nil && [data length]>0)
    {
        int preIndex = index;
        [self seek:0];
        int fullLength = [self readInt32];
        index = preIndex;
        return fullLength;
    }
    return 0;
}
-(void)seek:(int)idx
{
    index = idx;
}

-(void)reset
{
    index = 6 * sizeof(uint32_t);
}

-(void)appendData:(NSData*)subData
{
    if(subData != nil)
    {
        [data appendData:subData];
    }
}

#pragma mark - readData
-(uint32_t)readInt32
{
    uint32_t value = 0;
    [data getBytes:&value range:NSMakeRange(index, sizeof(value))];
    index += sizeof(value);
    value = CFSwapInt32BigToHost(value);
    return value;
}

-(uint64_t)readInt64
{
    uint64_t value = 0;
    [data getBytes:&value range:NSMakeRange(index, sizeof(value))];
    value = CFSwapInt64BigToHost(value);
    index += sizeof(value);
    return value;
}

-(NSString *)readString
{
    uint32_t length = [self readInt32];
    if (index+length <= data.length)
    {
        NSData *d = [data subdataWithRange:NSMakeRange(index, length)];
        NSString *str = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        index += length;
        return str;
    }
    else
    {
        return @"readString Length Error!";
    }
}

#pragma mark - appendData
-(void)appendInt32:(uint32_t)value
{
    value = CFSwapInt32HostToBig(value);
    [data appendBytes:&value length:sizeof(value)];
    index += sizeof(value);
}

-(void)appendInt64:(uint64_t)value
{
    value = CFSwapInt64HostToBig(value);
    [data appendBytes:&value length:sizeof(value)];
    index += sizeof(value);
}

-(void)appendString:(NSString *)value
{
    if (value != nil)
    {
        const char * str = [value UTF8String];
        uint32_t length = strlen(str);
        NSData* d = [NSData dataWithBytes:str length:length];
        [self appendInt32:length];
        [data appendData:d];
        index += length;
    }
}
@end
