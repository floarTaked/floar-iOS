//
//  NetworkEngine.h
//  UnNamed
//
//  Created by jonas on 8/1/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Card.h"
#import <AFNetworking.h>

typedef void (^ResponseCallBack)(int retcode,id data,NSString*msg);
@interface NetworkEngine :NSObject
{
    AFHTTPRequestOperationManager* server;
}
+(NetworkEngine*)sharedInstance;
-(NSMutableDictionary*)getCommonParamas;
-(void)resolveSimpleResponse:(id)responseObject block:(ResponseCallBack)block;
-(void)resolveResponse:(id)responseObject block:(ResponseCallBack)block;
-(void)resolveJsonResponse:(id)responseObject block:(ResponseCallBack)block;
#pragma --mark 上传图片功能
//带二进制传输
-(void)postWithData:(NSString *)path
               data:(NSData*)data
            dataKey:(NSString*)dataKey
         parameters:(NSDictionary *)parameters
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//带二进制传输多张图
-(void)postWithMultiData:(NSString *)path
          dataWithKeyDic:(NSDictionary*)dataWithKeyDic
              parameters:(NSDictionary *)parameters
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma --mark 公共
-(void)checkVersion:(EventCallBack)block;
-(void)isUpdate:(EventCallBack)block;
-(void)saveToken:(EventCallBack)block;
#pragma --mark 注册
//绑定手机
-(void)bindPhone:(NSString*)phone verifiCode:(NSString*)verifiCode block:(EventCallBack)block;
//上传手机通讯录
-(void)savePhoneFriends:(NSString*)json block:(EventCallBack)block;
//注册用户
-(void)saveInfo1:(id)imageOrPath name:(NSString*)name company:(NSString*)company job:(NSString*)job block:(EventCallBack)block;
//获取验证码
-(void)getVerifiCode:(NSString*)phone block:(EventCallBack)block;

#pragma --mark 好友
//获取好友列表
-(void)getFriends:(EventCallBack)block;
//获取好友申请列表
-(void)getFriendRequest:(EventCallBack)block;
//确认加为好友
-(void)confirmFriend:(int)friendId block:(EventCallBack)block;
//添加好友
-(void)addFriend:(int)otherUserId block:(EventCallBack)block;
//获取共同好友
-(void)getSameFriend:(int)otherUserId block:(EventCallBack)block;
#pragma --mark 消息
//删除消息
-(void)deleteMessage:(int)ideneity block:(EventCallBack)block;
//获取消息状态
-(void)getMessageStatus:(int)ideneity block:(EventCallBack)block;
//获取消息  isAll:0   是所有未读信息  1   是最近20天的全部消息
-(void)getMessages:(NSString*)isAll block:(EventCallBack)block;
//消息发送  msgType：1=普通文本 3=阅后即焚消息
-(void)sendMessage:(int)receiverId content:(NSString*)content msgType:(int)msgType storeSecond:(int)storeSecond block:(EventCallBack)block;
#pragma --mark 用户
//获取我的发布
-(void)getMyPulish:(NSString*)page limit:(NSString*)limit block:(EventCallBack)block;
//Linked in 资料 保存
-(void)saveLinkedIn:(NSString*)name stoken:(NSString*)stoken block:(EventCallBack)block;
//修改头像
-(void)updateImage:(NSData*)image block:(EventCallBack)block;
//修改用户信息
-(void)updateUserInfo:(NSString*)json block:(EventCallBack)block;
//获取用户个人基本信息
-(void)getUserInfo:(EventCallBack)block;
//获取用户主页信息
-(void)getUserProfile:(int)otherUserId block:(EventCallBack)block;
//获取谁看过我
-(void)getVisitorInfo:(NSString*)page limit:(NSString*)limit block:(EventCallBack)block;
#pragma --mark 用户额外信息
//保存教育背景
-(void)saveEducationInfo:(NSString*)json block:(EventCallBack)block;
//删除教育背景
-(void)deleteEducationInfo:(int)identity block:(EventCallBack)block;
//保存工作经历
-(void)saveWorkInfo:(NSString*)json block:(EventCallBack)block;
//删除工作经历
-(void)deleteWorkInfo:(int)identity block:(EventCallBack)block;
#pragma --mark 名片
//注册上传名片
-(void)registerSaveCard:(id)imageOrPath card:(Card*)card cardImage:(id)cardImage block:(EventCallBack)block;
//上传名片
-(void)saveCard:(id)imageOrPath card:(Card*)card cardImage:(id)cardImage block:(EventCallBack)block;
//编辑名片
-(void)updateCard:(id)imageOrPath card:(Card*)card block:(EventCallBack)block;
//删除名片
-(void)deleteCard:(int)cardId block:(EventCallBack)block;
//获取用户保存的名片夹名片
-(void)getUserSaveCards:(EventCallBack)block;
//删除名片
-(void)deleteCardWithCardId:(NSString *)cardId block:(EventCallBack)block;

#pragma mark - 职脉圈
//获取动态流
-(void)getFeedsWithTime:(NSString *)time
                        limit:(int)limit
                        block:(EventCallBack)block;

//动态中评论
-(void)commentActionWithPublisher:(NSString *)publishId
                          comment:(NSString *)comment
                           feedId:(NSString *)feedId
                         targetId:(NSString *)targetId
                            block:(EventCallBack)block;
//发动态
-(void)sendContent:(NSString *)jsonString
                     image:(UIImage *)image
           httpUrl:(NSString *)url
                     block:(EventCallBack)block;
//获取feed评论
-(void)getFeedComment:(NSString *)targetId
                block:(EventCallBack)block;

//获取标签
-(void)getFeedTags:(NSString *)content
             block:(EventCallBack)block;

//发送提问
-(void)postQuestion:(NSString *)json
              block:(EventCallBack)block;

//获取职脉圈问题锁
-(void)getFeedLock:(EventCallBack)block;

@end
