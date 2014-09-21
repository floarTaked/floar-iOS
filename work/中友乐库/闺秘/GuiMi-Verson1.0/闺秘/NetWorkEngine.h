//
//  NetWorkEngine.h
//  闺秘
//
//  Created by floar on 14-7-8.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Package.h"
#import <AsyncSocket.h>
#import <AFNetworking.h>
@interface NetWorkEngine : NSObject<AsyncSocketDelegate>
{
    AsyncSocket *clientSocket;
    NSMutableDictionary *registDict;
    NSMutableDictionary *sendDict;
    
    AFHTTPRequestOperationManager* server;
}

//注册数据回调block,不要根据procotolId来标识，有重复，特别是发送验证码和验证验证码都是一个procotolId，在common自己维护一个UniqueCode枚举，用一个加一个
-(void)registBlockWithUniqueCode:(UniqueCode)code block:(EventCallBack)block;
-(void)sendData:(Package*)package UniqueCode:(UniqueCode)code block:(EventCallBack)block;
-(void)connectToServer;

//图片上传
-(void)postWithData:(NSString *)path
               data:(NSData*)data
            dataKey:(NSString*)dataKey
         parameters:(NSDictionary *)parameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(NetWorkEngine *)shareInstance;

@end
