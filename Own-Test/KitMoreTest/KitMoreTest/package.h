//
//  package.h
//  KitMoreTest
//
//  Created by floar on 14-7-2.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface package : NSObject
{
    NSMutableData *data;
    int index;
}
-(NSData*)getData;
-(void)reset;
-(int)readInt;
-(NSString *)readString;
-(long long)readDouble;

-(void)setInt:(int)value;
-(void)setdouble:(long long)value;
-(void)setString:(NSString *)value;

-(id)initWithData:(NSData *)value;

-(long long)anOtherSetdouble:(long long)value;

@end