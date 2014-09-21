//
//  NetWorkEngine.h
//  闺秘
//
//  Created by floar on 14-7-8.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Package.h"
#include "Invocation.h"
#import <AsyncSocket.h>
#import <AFNetworking.h>
@interface NetWorkEngine : NSObject<AsyncSocketDelegate>
{
    AsyncSocket *clientSocket;
    
    AFHTTPRequestOperationManager* server;
    NSTimer* timer;
    BOOL fullPackage;
    int particleSequnce;
}

-(void)sendData:(Package*)package block:(EventCallBack)block;
-(void)connectToServer;
-(BOOL)isConnectToServer;

//图片上传
-(void)postWithData:(NSString *)path
               data:(NSData*)data
            dataKey:(NSString*)dataKey
           mimeType:(NSString*)mimeType
         parameters:(NSDictionary *)parameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void)reconnect;
+(NetWorkEngine *)shareInstance;

#pragma mark - 业务逻辑组装socket发送数据
//用户注册
-(void)registWithAccountType:(uint32_t)accountType
                 accountName:(NSString *)accountName
                        setp:(uint32_t)step
                identifyCode:(NSString *)code
                    password:(NSString *)password
                       block:(EventCallBack)block;

//判断当前手机是否能够收到验证码
-(void)canReceiveVerificationCodeByPhoneNum:(NSString *)phoneNum
                                  phoneRegistOrNot:(uint32_t)phoneType
                                      block:(EventCallBack)block;
//修改密码
-(void)changePasswordWith:(NSString *)oldPassword
              newPassword:(NSString *)newPassword
                    block:(EventCallBack)block;

//重置密码
-(void)resetpasswordWithPhoneNumStr:(NSString *)phoneNum
                       identifyCode:(NSString *)identify
                             passWd:(NSString *)password
                              block:(EventCallBack)block;

//用户登录
-(void)loginWithAccountType:(uint32_t)accountType
                accountName:(NSString *)accountName
                   password:(NSString *)password
                      block:(EventCallBack)block;

//用户消息
-(void)publishSecretWith:(NSString *)address
          contentJsonStr:(NSString *)content
                   block:(EventCallBack)block;

//用户评论或者赞
-(void)supportOrCommentWith:(uint64_t)feedId
                  commentId:(uint64_t)commentId
                  operation:(uint32_t)operation
                    comment:(NSString *)comment
                      block:(EventCallBack)block;

//批量拉取最近feed
-(void)lastedFeedsWith:(uint32_t)time
             messageId:(uint64_t)messageId
              limitNum:(uint32_t)num
                 block:(EventCallBack)block;

//拉取feed详细信息
-(void)feedDetailInfoWith:(uint64_t)feedId
                    block:(EventCallBack)block;

//上传通讯录
-(void)updateContractListWith:(NSString *)jsonStr
                        block:(EventCallBack)block;
//收藏消息
-(void)collectFeedWith:(uint64_t)feedId
                 block:(EventCallBack)block;

//举报消息
-(void)reportFeedWith:(uint64_t)feedId
           uniqueCode:(uint32_t)num
         reportReason:(NSString *)reason
                block:(EventCallBack)block;

//拉取收藏的消息
-(void)fetchCollectedFeeds:(EventCallBack)block;

//移除消息
-(void)deleteFeedInMainViewWith:(uint64_t)feedId
                          block:(EventCallBack)block;

//拉取引导问题
-(void)fetchGuideQuestionWithWith:(uint32_t)time
                     preMessageId:(uint64_t)messageId
                        limitsNum:(uint32_t)num
                            block:(EventCallBack)block;

//拉取用户朋友数
-(void)fetchNumberOfFriendsWith:(EventCallBack)block;

//意见反馈
-(void)suggestForUsWith:(NSString *)content
                  block:(EventCallBack)block;

//注册APNs Token
-(void)registDeviceToken:(NSString*)token block:(EventCallBack)block;
//取消注册
-(void)unRegistDeviceToken:(NSString*)token block:(EventCallBack)block;

@end
