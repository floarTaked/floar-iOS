//
//  NetWorkEngine.m
//  闺秘
//
//  Created by floar on 14-7-8.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "NetWorkEngine.h"
#import <AsyncSocket.h>
#import "LogicManager.h"

@implementation NetWorkEngine

+(NetWorkEngine *)shareInstance
{
    static NetWorkEngine *tcpEngine;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tcpEngine = [[NetWorkEngine alloc] init];
    });
    return tcpEngine;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        clientSocket = [[AsyncSocket alloc] initWithDelegate:self];
        
        server = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:IMAGESERVER]];
        NSSet* set = server.responseSerializer.acceptableContentTypes;
        set = [set setByAddingObject:@"text/plain"];
        set = [set setByAddingObject:@"text/html"];
        server.responseSerializer.acceptableContentTypes = set;
    }
    return self;
}

-(void)connectToServer
{
    NSError *error = nil;
    [clientSocket connectToHost:TCPSERVERIP onPort:TCPSERVERPORT error:&error];
}

-(void)registBlockWithUniqueCode:(UniqueCode)code block:(EventCallBack)block
{
    if(registDict == nil)
    {
        registDict = [[NSMutableDictionary alloc] init];
    }
    [registDict setObject:block forKey:[NSNumber numberWithInt:code]];
}

-(void)sendData:(Package*)package UniqueCode:(UniqueCode)code block:(EventCallBack)block
{
    if (sendDict == nil)
    {
        sendDict = [[NSMutableDictionary alloc] init];
    }
    [sendDict setObject:block forKey:[NSNumber numberWithInt:code]];
    
    if (package != nil)
    {
        [clientSocket writeData:[package getData] withTimeout:-1 tag:code];
    }
}

#pragma mark - 图片上传功能
-(void)postWithData:(NSString *)path
               data:(NSData*)data
            dataKey:(NSString*)dataKey
         parameters:(NSDictionary *)parameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if(parameters == nil)
    {
        parameters = [NSDictionary dictionary];
    }
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    for(NSString* key in parameters.allKeys)
    {
        [dic setObject:[parameters objectForKey:key] forKey:key];
    }
    
    
    NSMutableURLRequest *request = [server.requestSerializer multipartFormRequestWithMethod:@"POST"
                            URLString:path
                           parameters:dic
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileData:data name:dataKey fileName:@"file.png" mimeType:@"image/png"];
    } error:nil];
    
	AFHTTPRequestOperation *operation = [server HTTPRequestOperationWithRequest:request success:success failure:failure];
    [server.operationQueue addOperation:operation];
    [operation resume];
}

#pragma mark - TcpClientDelegate
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
//    NSLog(@"客户端连接到---%@:port:%d",host,port);
    DLog(@"客户端连接到---%@:port:%d",host,port);
    [[NSNotificationCenter defaultCenter] postNotificationName:ServerOK object:[NSNumber numberWithBool:YES]];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    [sock readDataWithTimeout:-1 tag:tag];
//    NSLog(@"读取数据:%@---%ld",data,tag);
    DLog(@"读取数据:%@---%ld",data,tag);
    EventCallBack block;
    if (data != nil)
    {
        Package* pack = [[Package alloc]initWithData:(NSMutableData*)data];
        block = [registDict objectForKey:[NSNumber numberWithInt:tag]];
        if(block)
        {
            block(1,pack);
        }
        else
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:[NSString stringWithFormat:@"block为空,tag:%ld",tag] actionText:@"确定"];
        }
    }
    else
    {
        if (block)
        {
            block(0,nil);
        }
    }
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    NSLog(@"写入数据完成:%ld",tag);
    DLog(@"写入数据完成:%ld",tag);
    [sock readDataWithTimeout:-1 tag:tag];
    //    EventCallBack block = [sendDict objectForKey:[NSNumber numberWithInt:tag]];
    //    if (block)
    //    {
    //        block(1,@"send");
    //    }
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    DLog(@"%@",err);
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    
//    [[LogicManager sharedInstance]showAlertWithTitle:nil message:@"连接断开" actionText:@"确定"];
//    [sock setDelegate:nil];
//    [sock disconnect];
    DLog(@"连接断开");
    [self connectToServer];
}


@end
