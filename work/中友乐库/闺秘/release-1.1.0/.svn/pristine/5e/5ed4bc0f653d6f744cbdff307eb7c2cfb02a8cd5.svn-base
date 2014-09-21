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
        timer = nil;
        fullPackage = YES;
        particleSequnce = 0;
    }
    return self;
}

-(BOOL)isConnectToServer
{
    return [clientSocket isConnected];
}

-(void)sendData:(Package*)package block:(EventCallBack)block
{
    
    if(![clientSocket isConnected])
    {
        return;
    }
    if (package != nil)
    {
        [clientSocket writeData:[package getData] withTimeout:TIMEOUTTIME tag:0];
//        DLog(@"packData:%@---tag:%d",[package getData],package.packgeSequnce);
        [[InvocationManager shareInstance] parseBlock:block withTag:package.packgeSequnce];
    }
}

#pragma mark - TcpClientDelegate
-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    if(err)
    {
        //超时
        DLog(@"----%@",[err description]);
    }
}
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    if(![clientSocket isConnected])
    {
        return;
    }
    DLog(@"客户端连接到---%@:port:%d",host,port);
    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:connectServerSuccess object:nil];
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    DLog(@"连接断开...");
    [self reconnect];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    if(![clientSocket isConnected])
    {
        return;
    }
    if(fullPackage)
    {
        //全新的包
        if(data != nil)
        {
            Package* pack = [[Package alloc]initWithData:(NSMutableData*)data];
            int packSequnce = pack.packgeSequnce;
            [[InvocationManager shareInstance] parseData:data withTag:packSequnce];
            fullPackage = [[InvocationManager shareInstance] isFull:packSequnce];
            if(!fullPackage)
            {
                particleSequnce = packSequnce;
                [clientSocket readDataWithTimeout:-1 tag:0];
            }
        }
    }
    else
    {
        if(data != nil)
        {
            [[InvocationManager shareInstance] parseData:data withTag:particleSequnce];
            fullPackage = [[InvocationManager shareInstance] isFull:particleSequnce];
        }
        [clientSocket readDataWithTimeout:-1 tag:0];
    }
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if(![clientSocket isConnected])
    {
        return;
    }
//    [sock readDataWithTimeout:-1 tag:0];
    [clientSocket readDataWithTimeout:-1 tag:0];
}

-(void)reconnect
{
    DLog(@"......重连......");
    if(timer  == nil)
    {
        timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(connectToServer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)connectToServer
{
    NSError *error = nil;
    [clientSocket connectToHost:TCPSERVERIP onPort:TCPSERVERPORT error:&error];
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectingServer object:[NSNumber numberWithBool:YES]];
}

#pragma mark - 图片上传功能
-(void)postWithData:(NSString *)path
               data:(NSData*)data
            dataKey:(NSString*)dataKey
           mimeType:(NSString*)mimeType
         parameters:(NSDictionary *)parameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if(![clientSocket isConnected])
    {
        return;
    }
    
    if(parameters == nil)
    {
        parameters = [NSDictionary dictionary];
    }
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    for(NSString* key in parameters.allKeys)
    {
        [dic setObject:[parameters objectForKey:key] forKey:key];
    }
    
    NSString* fileName = @"file.png";
    if([mimeType isEqualToString:@"image/gif"])
    {
        fileName = @"file.gif";
    }
    NSMutableURLRequest *request = [server.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                  URLString:path
                                                                                 parameters:dic
                                                                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                                                                      [formData appendPartWithFileData:data name:dataKey fileName:fileName mimeType:mimeType];
                                                                  } error:nil];
    
	AFHTTPRequestOperation *operation = [server HTTPRequestOperationWithRequest:request success:success failure:failure];
    [server.operationQueue addOperation:operation];
    [operation resume];
}


#pragma mark - 业务逻辑组装socket发送数据
//用户注册
-(void)registWithAccountType:(uint32_t)accountType
                 accountName:(NSString *)accountName
                        setp:(uint32_t)step
                identifyCode:(NSString *)code
                    password:(NSString *)password
                       block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x01];
    
    NSString *pd = [[LogicManager sharedInstance] encodePasswordWithsha1:password];
    
    [pack appendInt32:accountType];
    [pack appendString:accountName];
    [pack appendInt32:step];
    [pack appendString:code];
    [pack appendString:pd];
    [self sendData:pack block:block];
}

//判断当前手机是否能够收到验证码
-(void)canReceiveVerificationCodeByPhoneNum:(NSString *)phoneNum
                           phoneRegistOrNot:(uint32_t)phoneType
                                      block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:IndentifySubsys withSubProcotol:0x01];
    [pack appendString:phoneNum];
    /*
     1，0x01:手机号未注册：错误表示手机号已注册，注册流程用
     2，0x02:手机号已注册：错误表示手机号未注册，重置密码流程用
     */
    [pack appendInt32:phoneType];
    [self sendData:pack block:block];
}

//修改密码
-(void)changePasswordWith:(NSString *)oldPassword
              newPassword:(NSString *)newPassword
                    block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x0b];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    
    NSString *oldPd = [[LogicManager sharedInstance] encodePasswordWithsha1:oldPassword];
    NSString *newPd = [[LogicManager sharedInstance] encodePasswordWithsha1:newPassword];
    
    [pack appendInt64:userId];
    [pack appendString:userKey];
    [pack appendString:oldPd];
    [pack appendString:newPd];
    [self sendData:pack block:block];
    
}

//用户登录
-(void)loginWithAccountType:(uint32_t)accountType
                accountName:(NSString *)accountName
                   password:(NSString *)password
                      block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x02];
    NSString *pd = [[LogicManager sharedInstance] encodePasswordWithsha1:password];
    [pack appendInt32:accountType];
    [pack appendString:accountName];
    [pack appendString:pd];
    [self sendData:pack block:block];
}

//用户消息
-(void)publishSecretWith:(NSString *)address
          contentJsonStr:(NSString *)content
                   block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x01];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    
    [pack appendInt64:userId];
    [pack appendString:userKey];
    [pack appendString:address];
    [pack appendString:content];
    [self sendData:pack block:block];
}

//用户评论或者赞
-(void)supportOrCommentWith:(uint64_t)feedId
                  commentId:(uint64_t)commentId
                  operation:(uint32_t)operation
                    comment:(NSString *)comment
                      block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x02];
    
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    
    [pack appendInt64:userId];
    [pack appendString:userKey];
    [pack appendInt64:feedId];
    [pack appendInt64:commentId];
    [pack appendInt32:operation];
    [pack appendString:comment];
    [self sendData:pack block:block];
}

//批量拉取最近feed
-(void)lastedFeedsWith:(uint32_t)time
             messageId:(uint64_t)messageId
              limitNum:(uint32_t)num
                 block:(EventCallBack)block
{
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x03];
    
    if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
    {
        userKey = @"";
        userId = 0;
    }
    
    [pack appendInt64:userId];
    [pack appendString:userKey];
    [pack appendInt32:time];
    [pack appendInt64:messageId];
    [pack appendInt32:num];
    [self sendData:pack block:block];
}

//拉取feed详细信息
-(void)feedDetailInfoWith:(uint64_t)feedId
                    block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x06];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    [pack appendInt64:userId];
    [pack appendString:userKey];
    [pack appendInt64:feedId];
    [self sendData:pack block:block];
}

//上传通讯录
-(void)updateContractListWith:(NSString *)jsonStr
                        block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x0c];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    [pack appendInt64:userId];
    [pack appendString:userKey];
    [pack appendString:jsonStr];
    [self sendData:pack block:block];
}
//收藏消息
-(void)collectFeedWith:(uint64_t)feedId
                 block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x08];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    [pack appendInt64:userId];
    [pack appendString:userKey];
    [pack appendInt64:feedId];
    [self sendData:pack block:block];
}
//举报消息
-(void)reportFeedWith:(uint64_t)feedId
           uniqueCode:(uint32_t)num
         reportReason:(NSString *)reason
                block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x09];
    uint64_t userId =[UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    [pack appendInt64:userId];
    [pack appendString:userKey];
    [pack appendInt64:feedId];
    [pack appendInt32:num];
    [pack appendString:reason];
    [self sendData:pack block:block];
}

-(void)fetchCollectedFeeds:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x0e];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    [pack appendInt64:userId];
    [pack appendString:userKey];
    [self sendData:pack block:block];
}

-(void)deleteFeedInMainViewWith:(uint64_t)feedId
                          block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x0c];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    [pack appendInt64:userId];
    [pack appendString:userKey];
    [pack appendInt64:feedId];
    [self sendData:pack block:block];
}

-(void)fetchGuideQuestionWithWith:(uint32_t)time
                     preMessageId:(uint64_t)messageId
                        limitsNum:(uint32_t)num
                            block:(EventCallBack)block
{
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x0f];
    
    if (userKey != nil && userId != 0)
    {
        [pack appendInt64:userId];
        [pack appendString:userKey];
        [pack appendInt32:time];
        [pack appendInt64:messageId];
        [pack appendInt32:num];
        [self sendData:pack block:block];
    }
}

-(void)fetchNumberOfFriendsWith:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x0d];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    if (userKey != nil && userId != 0)
    {
        [pack appendInt64:userId];
        [pack appendString:userKey];
        [self sendData:pack block:block];
    }
}

-(void)suggestForUsWith:(NSString *)content
                  block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:FAQSubSys withSubProcotol:0x02];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    [pack appendInt64:userId];
    [pack appendString:userKey];
    [pack appendString:content];
    [self sendData:pack block:block];
}
//注册APNs Token
-(void)registDeviceToken:(NSString*)token block:(EventCallBack)block
{
    //[[NetWorkEngine shareInstance] updateAPNsTokenWith:0x02 apnsToken:userToken systemCode:0x02
     
    Package *pack = [[Package alloc] initWithSubSystem:0x08 withSubProcotol:0x01];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    
    [pack appendInt64:userId];
    [pack appendString:userKey];
    //注册:0x01  注销:0x02
    [pack appendInt32:0x01];
    [pack appendString:token];
    //android:0x01 iOS:0x02
    [pack appendInt32:0x02];
    [self sendData:pack block:block];
}
//取消注册
-(void)unRegistDeviceToken:(NSString*)token block:(EventCallBack)block
{
    Package *pack = [[Package alloc] initWithSubSystem:0x08 withSubProcotol:0x01];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    
    [pack appendInt64:userId];
    [pack appendString:userKey];
    //注册:0x01  注销:0x02
    [pack appendInt32:0x01];
    [pack appendString:token];
    //android:0x01 iOS:0x02
    [pack appendInt32:0x02];
    [self sendData:pack block:block];
}
//重置密码
-(void)resetpasswordWithPhoneNumStr:(NSString *)phoneNum
                       identifyCode:(NSString *)identify
                             passWd:(NSString *)password
                              block:(EventCallBack)block;
{
    Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x0e];
    [pack appendString:phoneNum];
    [pack appendString:identify];
    NSString *pw = [[LogicManager sharedInstance] encodePasswordWithsha1:password];
    [pack appendString:pw];
    [self sendData:pack block:block];
}
@end
