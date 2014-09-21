//
//  NetworkEngine.m
//  UnNamed
//
//  Created by jonas on 8/1/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import "NetworkEngine.h"
#import "DataBaseManager.h"
#import "MessageData.h"
#import "UserInfo.h"
#import "Card.h"
#import "Feed.h"
#import "Tag.h"
@implementation NetworkEngine
+(NetworkEngine*)sharedInstance
{
    static NetworkEngine* m_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_instance = [[[self class] alloc]init];
    });
    return m_instance;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        server = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:SERVERROOTURL]];
        NSSet* set = server.responseSerializer.acceptableContentTypes;
        set = [set setByAddingObject:@"text/plain"];
        set = [set setByAddingObject:@"text/html"];
        server.responseSerializer.acceptableContentTypes = set;
    }
    return self;
}
-(NSMutableDictionary*)getCommonParamas
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:[UserInfo myselfInstance].userId] forKey:@"userId"];
    [dic setObject:[UserInfo myselfInstance].token==nil?@"":[UserInfo myselfInstance].token forKey:@"token"];
    [dic setObject:@"ios" forKey:@"os"];
    return dic;
}
-(void)resolveSimpleResponse:(id)responseObject block:(ResponseCallBack)block
{
    int retcode = -1;
    NSNumber* data = nil;
    NSString* retCodeStr = [responseObject valueForKey:@"retcode"];
    NSString* dataStr = [responseObject valueForKey:@"data"];
    if(retCodeStr != nil)
    {
        retcode = [retCodeStr intValue];
    }
    if(dataStr != nil)
    {
        data = [NSNumber numberWithInt:[dataStr intValue]];
    }
    NSString* msg = [responseObject objectForKey:@"msg"];
    if(block)
    {
        block(retcode,data,msg);
    }
}
-(void)resolveResponse:(id)responseObject block:(ResponseCallBack)block
{
    int retcode = -1;
    NSString* retCodeStr = [responseObject valueForKey:@"retcode"];
    if(retCodeStr != nil)
    {
        retcode = [retCodeStr intValue];
    }
    id data = [responseObject valueForKey:@"data"];
    NSString* msg = [responseObject objectForKey:@"msg"];
    if(block)
    {
        block(retcode,data,msg);
    }
}
-(void)resolveJsonResponse:(id)responseObject block:(ResponseCallBack)block
{
    int retcode = -1;
    NSString* retCodeStr = [responseObject valueForKey:@"retcode"];
    if(retCodeStr != nil)
    {
        retcode = [retCodeStr intValue];
    }
    id data = nil;
    NSString *postsFromResponse = [responseObject valueForKey:@"data"];
    NSError* error = nil;
    data =[NSJSONSerialization JSONObjectWithData:[postsFromResponse dataUsingEncoding:NSUTF8StringEncoding]
                                          options:NSJSONReadingMutableLeaves error:&error];
    if(error != nil)
    {
        data = nil;
    }
    NSString* msg = [responseObject objectForKey:@"msg"];
    if(block)
    {
        block(retcode,data,msg);
    }
}
#pragma --mark 上传图片功能
//带二进制传输
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
                                                                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:data name:dataKey fileName:@"image.png" mimeType:@"image/jpeg"];
    } error:nil];
	AFHTTPRequestOperation *operation = [server HTTPRequestOperationWithRequest:request success:success failure:failure];
    [server.operationQueue addOperation:operation];
    [operation resume];
}
//带二进制传输多张图
-(void)postWithMultiData:(NSString *)path
          dataWithKeyDic:(NSDictionary*)dataWithKeyDic
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
                                                                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        for(NSString* key in dataWithKeyDic.allKeys)
        {
            [formData appendPartWithFileData:[dataWithKeyDic objectForKey:key]
                                        name:key
                                    fileName:[NSString stringWithFormat:@"%@.png",key] mimeType:@"image/jpeg"];
        }
    } error:nil];
    
	AFHTTPRequestOperation *operation = [server HTTPRequestOperationWithRequest:request success:success failure:failure];
    [server.operationQueue addOperation:operation];
    [operation resume];
}
-(void)checkVersion:(EventCallBack)block
{
    //{
    //    "data":{
    //        "version":"1.1",
    //        "versionDesc":"修复已知bug",
    //        "url":"http://imageapp.leku.com/staticprj/mobilenew/down/welink.apk",
    //        "must":0,
    //        "platform":"android",
    //        "createTime":1390801613000,
    //        "versionId":2
    //    },
    //    "msg":"",
    //    "retcode":"0"
    //}
    NSMutableDictionary* dic = [self getCommonParamas];
    [server POST:@"comm/check-version" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  block(1,data);
              }
              else
              {
                  block(0,msg);
              }
          }];
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
-(void)isUpdate:(EventCallBack)block
{
//    {
//        "data"
//		{
//        newfriend:新的联系人数量
//        msg:消息数量
//        feeds:职脉圈数量
//		},
//        "msg":"",
//        "retcode":"0"
//    }
    
    NSMutableDictionary* dic = [self getCommonParamas];
    [server POST:@"comm/is-update" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  block(1,data);
              }
              else
              {
                  block(0,msg);
              }
          }];
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
-(void)saveToken:(EventCallBack)block
{
    //pushId 推送的token
    NSMutableDictionary* dic = [self getCommonParamas];
    [server POST:@"comm/save-token" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  block(1,data);
              }
              else
              {
                  block(0,msg);
              }
          }];
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
//绑定手机
-(void)bindPhone:(NSString*)phone verifiCode:(NSString*)verifiCode block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:phone==nil?@"":phone forKey:@"phone"];
    [dic setObject:verifiCode==nil?@"":verifiCode forKey:@"verifiCode"];
    
    [server POST:@"register/bind-phone" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
//            retcode == "0 或 2", 0是全新用户, 2是旧的用户;
              if(retcode == 0)
              {
                  [[UserInfo myselfInstance] setValuesForKeysWithDictionary:data];
                  [[UserInfo myselfInstance] synchronize:nil];
                  [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:[UserInfo myselfInstance].userId]
                                                            withKey:USERID];
                  //全新用户
                  block(0,data);
              }
              else if (retcode == 1)
              {
                  //校验不通过
                  block(1,msg);
              }
              else if(retcode == 2)
              {
                  [[UserInfo myselfInstance] setValuesForKeysWithDictionary:data];
                  [[UserInfo myselfInstance] synchronize:nil];
                  [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:[UserInfo myselfInstance].userId]
                                                            withKey:USERID];
                  //旧用户
                  block(2,data);
              }
          }];
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
//上传手机通讯录
-(void)savePhoneFriends:(NSString*)json block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:json==nil?@"":json forKey:@"json"];
    [server POST:@"register/save-phone-friends" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  block(1,data);
              }
              else
              {
                  block(0,msg);
              }
          }];
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
-(void)saveInfo1:(id)imageOrPath name:(NSString*)name company:(NSString*)company job:(NSString*)job block:(EventCallBack)block
{
    //image:用户头像(文件流)
    //headerUrl:头像url
    //name：姓名
    //company：公司
    //job：职位
    //image或headerUrl为二选1.
    
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:name==nil?@"":name forKey:@"name"];
    [dic setObject:company==nil?@"":company forKey:@"company"];
    [dic setObject:job==nil?@"":job forKey:@"job"];
    
    if([imageOrPath isKindOfClass:[NSString class]])
    {
        [dic setObject:imageOrPath forKey:@"headerUrl"];
        [server POST:@"register/save-info-1" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
         {
             [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
              {
                  if(retcode == 0)
                  {
                      [[UserInfo myselfInstance] setValuesForKeysWithDictionary:data];
                      [[UserInfo myselfInstance] synchronize:nil];
                      block(1,[UserInfo myselfInstance]);
                  }
                  else
                  {
                      block(0,msg);
                  }
              }];
         } failure:^(AFHTTPRequestOperation *task, NSError *error) {
             block(0,nil);
         }];
    }
    else if ([imageOrPath isKindOfClass:[NSData class]])
    {
        [self postWithData:[[NSURL URLWithString:@"register/save-info-1" relativeToURL:[NSURL URLWithString:SERVERROOTURL]] absoluteString]
                      data:imageOrPath
                   dataKey:@"image"
                parameters:dic
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
              {
                  if(retcode == 0)
                  {
                      [[UserInfo myselfInstance] setValuesForKeysWithDictionary:data];
                      [[UserInfo myselfInstance] synchronize:nil];
                      block(1,[UserInfo myselfInstance]);
                  }
                  else
                  {
                      block(0,msg);
                  }
              }];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             block(0,error);
         }];
    }
}
//获取验证码
-(void)getVerifiCode:(NSString*)phone block:(EventCallBack)block
{
    block(1,nil);
    return;
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:phone==nil?@"":phone forKey:@"phone"];
    [server GET:@"register/verifi-code" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 block(1,data);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//获取好友列表
-(void)getFriends:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"friend/get-friends" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 NSMutableArray *arr = [[NSMutableArray alloc] init];
                 for (NSDictionary *dict  in data)
                 {
                     UserInfo *contactor = [[UserInfo alloc] init];
                     [contactor setValuesForKeysWithDictionary:dict];
                     [contactor synchronize:MyFriendsTable];
                     [arr addObject:contactor];
                 }
                 block(1,arr);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//获取好友申请列表
-(void)getFriendRequest:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"friend/get-friend-requests" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 block(1,data);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//确认加为好友
-(void)confirmFriend:(int)friendId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:friendId] forKey:@"friendId"];
    [server POST:@"friend/confirm-friend" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 UserInfo* user = [[UserInfo alloc]init];
                 [user setValuesForKeysWithDictionary:data];
                 [user synchronize:MyFriendsTable];
                 block(1,user);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//添加好友
-(void)addFriend:(int)otherUserId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:otherUserId] forKey:@"otherUserId"];
    [server POST:@"friend/send-friend-request" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 block(1,data);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//获取共同好友
-(void)getSameFriend:(int)otherUserId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:otherUserId] forKey:@"otherUserId"];
    [server POST:@"friend/get-same-friends" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  NSMutableArray* arr = [NSMutableArray array];
                  for(NSDictionary* dic in data)
                  {
                      UserInfo*user = [[UserInfo alloc]init];
                      [user setValuesForKeysWithDictionary:dic];
                      [arr addObject:user];
                  }
                  block(1,arr);
              }
              else
              {
                  block(0,msg);
              }
          }];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         block(0,nil);
     }];
}
//删除消息
-(void)deleteMessage:(int)ideneity block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:ideneity] forKey:@"id"];
    [server POST:@"msg/del-msg" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 block(1,data);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//获取消息状态
-(void)getMessageStatus:(int)ideneity block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:ideneity] forKey:@"id"];
    [server GET:@"msg/get-msg-status" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 block(1,data);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//获取消息  isAll:0   是所有未读信息  1   是最近20天的全部消息
-(void)getMessages:(NSString*)isAll block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:isAll==nil?@"":isAll forKey:@"isAll"];
    [server GET:@"msg/get-msgs" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 NSMutableArray* arr = [NSMutableArray array];
                 for(NSDictionary* dic in data)
                 {
                     MessageData* msg = [[MessageData alloc]init];
                     [msg setValuesForKeysWithDictionary:dic];
                     [msg synchronize:nil];
                     [arr addObject:msg];
                 }
                 block(1,arr);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//消息发送  msgType：1=普通文本 3=阅后即焚消息
-(void)sendMessage:(int)receiverId content:(NSString*)content msgType:(int)msgType storeSecond:(int)storeSecond block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:receiverId] forKey:@"receiverId"];
    [dic setObject:content==nil?@"":content forKey:@"content"];
    [dic setObject:[NSNumber numberWithInt:msgType] forKey:@"msgType"];
    [dic setObject:[NSNumber numberWithInt:storeSecond] forKey:@"storeSecond"];
    [server POST:@"msg/send-msg" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 MessageData* message = [[MessageData alloc]init];
                 [message setValuesForKeysWithDictionary:data];
                 [message synchronize:nil];
                 block(1,message);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//获取我的发布
-(void)getMyPulish:(NSString*)page limit:(NSString*)limit block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:page==nil?@"":page forKey:@"page"];
    [dic setObject:limit==nil?@"":limit forKey:@"limit"];
    [server GET:@"user/getPulishByUserId" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 block(1,data);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//Linked in 资料 保存
-(void)saveLinkedIn:(NSString*)name stoken:(NSString*)stoken block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:name==nil?@"":name forKey:@"name"];
    [dic setObject:stoken==nil?@"":stoken forKey:@"stoken"];
    [server GET:@"user/save-linked-in" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 block(1,data);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//修改头像
-(void)updateImage:(NSData*)image block:(EventCallBack)block
{
    if(image == nil)
    {
         block(0,@"图片为空");
        return;
    }
    NSMutableDictionary* dic = [self getCommonParamas];
    [self postWithData:[[NSURL URLWithString:@"user/update-image" relativeToURL:[NSURL URLWithString:SERVERROOTURL]] absoluteString]
                  data:image
               dataKey:@"image"
            parameters:dic
               success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  //[[UserInfo myselfInstance] setValuesForKeysWithDictionary:data];
                  //[[UserInfo myselfInstance] synchronize:nil];
                  [UserInfo myselfInstance].avatar = (NSString*)data;
                  [[UserInfo myselfInstance] synchronize:nil];
                  block(1,[UserInfo myselfInstance]);
              }
              else
              {
                  block(0,msg);
              }
          }];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         block(0,error);
     }];
}
//修改用户信息
-(void)updateUserInfo:(NSString*)json block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:json==nil?@"":json forKey:@"json"];
    [server POST:@"user/update-user-info" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 [[UserInfo myselfInstance] setValuesForKeysWithDictionary:data];
                 [[UserInfo myselfInstance] synchronize:nil];
                 block(1,nil);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//获取用户个人基本信息
-(void)getUserInfo:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"user/user-info" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 block(1,data);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//获取用户主页信息
-(void)getUserProfile:(int)otherUserId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:otherUserId] forKey:@"otherUserId"];
    [server GET:@"user/user-profile" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 ProfileInfo* profile = [[ProfileInfo alloc]init];
                 [profile setValuesForKeysWithDictionary:data];
                 [profile synchronize:nil];
                 block(1,profile);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//获取谁看过我
-(void)getVisitorInfo:(NSString*)page limit:(NSString*)limit block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:page==nil?@"":page forKey:@"page"];
    [dic setObject:limit==nil?@"":limit forKey:@"limit"];
    
    [server GET:@"user/vistor-info" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
         {
             if(retcode == 0)
             {
                 NSMutableArray *array = [[NSMutableArray alloc] init];
                 for (NSDictionary *dict in data)
                 {
                     UserInfo *user = [[UserInfo alloc] init];
                     [user setValuesForKeysWithDictionary:dict];
                     [user synchronize:VisitorFriends];
                     [array addObject:user];
                 }
                 block(1,array);
             }
             else
             {
                 block(0,msg);
             }
         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
#pragma --mark 用户额外信息
//保存教育背景
-(void)saveEducationInfo:(NSString*)json block:(EventCallBack)block
{
    if(json != nil)
    {
        json = [json stringByReplacingOccurrencesOfString:@"identity" withString:@"id"];
    }
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:json==nil?@"":json forKey:@"json"];
    [server POST:@"resume/save-education" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  block(1,data);
              }
              else
              {
                  block(0,msg);
              }
          }];
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
//删除教育背景
-(void)deleteEducationInfo:(int)identity block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:identity==0?@"":[NSNumber numberWithInt:identity] forKey:@"id"];
    [server POST:@"resume/delete-education" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  block(1,data);
              }
              else
              {
                  block(0,msg);
              }
          }];
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
//保存工作经历
-(void)saveWorkInfo:(NSString*)json block:(EventCallBack)block
{
    if(json != nil)
    {
        json = [json stringByReplacingOccurrencesOfString:@"identity" withString:@"id"];
    }
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:json==nil?@"":json forKey:@"json"];
    [server POST:@"resume/save-job" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  block(1,data);
              }
              else
              {
                  block(0,msg);
              }
          }];
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
//删除工作经历
-(void)deleteWorkInfo:(int)identity block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:identity==0?@"":[NSNumber numberWithInt:identity] forKey:@"id"];
    [server POST:@"resume/delete-job" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  block(1,data);
              }
              else
              {
                  block(0,msg);
              }
          }];
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
#pragma mark - 名片夹
//注册上传名片
-(void)registerSaveCard:(id)imageOrPath card:(Card*)card cardImage:(id)cardImage block:(EventCallBack)block
{
    //image:用户头像(文件流)/headerUrl:头像url
    //name：姓名
    //company：公司
    //job：职位
    //phone ：多个电话，格式:移动电话,工作电话，其他号码
    //email：电子邮件
    //companyAddress：公司地址
    //account：即时通信账号
    //cardPosition：名片的位置
    //cardImage:名片文件
    if(card == nil || cardImage == nil)
    {
        return;
    }
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:card.name==nil?@"":card.name forKey:@"name"];
    [dic setObject:card.company==nil?@"":card.company forKey:@"company"];
    [dic setObject:card.job==nil?@"":card.job forKey:@"job"];
    [dic setObject:card.phone==nil?@"":card.phone forKey:@"phone"];
    [dic setObject:card.email==nil?@"":card.email forKey:@"email"];
    [dic setObject:card.companyAddress==nil?@"":card.companyAddress forKey:@"companyAddress"];
    [dic setObject:card.account==nil?@"":card.account forKey:@"account"];
    [dic setObject:card.cardPosition==nil?@"":card.cardPosition forKey:@"cardPosition"];
    
    if([imageOrPath isKindOfClass:[NSString class]])
    {
        [dic setObject:imageOrPath forKey:@"headerUrl"];
        [self postWithData:[[NSURL URLWithString:@"register/save-card-info" relativeToURL:[NSURL URLWithString:SERVERROOTURL]] absoluteString]
                      data:cardImage
                   dataKey:@"cardImage"
                parameters:dic
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
              {
                  if(retcode == 0)
                  {
                      [[UserInfo myselfInstance] setValuesForKeysWithDictionary:data];
                      [[UserInfo myselfInstance] synchronize:nil];
                      block(1,[UserInfo myselfInstance]);
                  }
                  else
                  {
                      block(0,msg);
                  }
              }];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             block(0,nil);
         }];
    }
    else if ([imageOrPath isKindOfClass:[NSData class]])
    {
        [self postWithMultiData:[[NSURL URLWithString:@"register/save-card-info" relativeToURL:[NSURL URLWithString:SERVERROOTURL]] absoluteString]
                 dataWithKeyDic:[NSDictionary dictionaryWithObjectsAndKeys:imageOrPath,@"image",cardImage,@"cardImage", nil]
                     parameters:dic
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
              {
                  if(retcode == 0)
                  {
                      [[UserInfo myselfInstance] setValuesForKeysWithDictionary:data];
                      [[UserInfo myselfInstance] synchronize:nil];
                      block(1,[UserInfo myselfInstance]);
                  }
                  else
                  {
                      block(0,msg);
                  }
              }];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             block(0,error);
         }];
    }
}


//上传名片
-(void)saveCard:(id)imageOrPath card:(Card*)card cardImage:(id)cardImage block:(EventCallBack)block
{
    //image:用户头像(文件流)/headerUrl:头像url
    //name：姓名
    //company：公司
    //job：职位
    //phone ：多个电话，格式:移动电话,工作电话，其他号码
    //email：电子邮件
    //companyAddress：公司地址
    //account：即时通信账号
    //cardPosition：名片的位置
    //cardImage:名片文件
    if(card == nil || cardImage == nil)
    {
        return;
    }
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:card.name==nil?@"":card.name forKey:@"name"];
    [dic setObject:card.company==nil?@"":card.company forKey:@"company"];
    [dic setObject:card.job==nil?@"":card.job forKey:@"job"];
    [dic setObject:card.phone==nil?@"":card.phone forKey:@"phone"];
    [dic setObject:card.email==nil?@"":card.email forKey:@"email"];
    [dic setObject:card.companyAddress==nil?@"":card.companyAddress forKey:@"companyAddress"];
    [dic setObject:card.account==nil?@"":card.account forKey:@"account"];
    [dic setObject:card.cardPosition==nil?@"":card.cardPosition forKey:@"cardPosition"];
    
    if([imageOrPath isKindOfClass:[NSString class]])
    {
        [dic setObject:imageOrPath forKey:@"headerUrl"];
        [self postWithData:[[NSURL URLWithString:@"card/save-card-info" relativeToURL:[NSURL URLWithString:SERVERROOTURL]] absoluteString]
                      data:cardImage
                   dataKey:@"cardImage"
                parameters:dic
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
             {
                 if(retcode == 0)
                 {
                     Card* c = [[Card alloc]init];
                     [c setValuesForKeysWithDictionary:data];
                     [c synchronize:nil];
                     block(1,c);
                 }
                 else
                 {
                     block(0,msg);
                 }
             }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            block(0,nil);
        }];
    }
    else if ([imageOrPath isKindOfClass:[NSData class]])
    {
        [self postWithMultiData:[[NSURL URLWithString:@"card/save-card-info" relativeToURL:[NSURL URLWithString:SERVERROOTURL]] absoluteString]
                 dataWithKeyDic:[NSDictionary dictionaryWithObjectsAndKeys:imageOrPath,@"image",cardImage,@"cardImage", nil]
                     parameters:dic
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
             {
                 if(retcode == 0)
                 {
                     Card* c = [[Card alloc]init];
                     [c setValuesForKeysWithDictionary:data];
                     [c synchronize:nil];
                     block(1,c);
                 }
                 else
                 {
                     block(0,msg);
                 }
             }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            block(0,error);
        }];
    }
}
//编辑名片
-(void)updateCard:(id)imageOrPath card:(Card*)card block:(EventCallBack)block
{
    //image:用户头像(文件流)/headerUrl:头像url
    //name：姓名
    //company：公司
    //job：职位
    //phone ：多个电话，格式:移动电话,工作电话，其他号码
    //email：电子邮件
    //companyAddress：公司地址
    //account：即时通信账号
    //cardPosition：名片的位置
    //cardImage:名片文件
    if(card == nil || imageOrPath == nil)
    {
        return;
    }
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:card.cardId] forKey:@"id"];
    [dic setObject:card.name==nil?@"":card.name forKey:@"name"];
    [dic setObject:card.company==nil?@"":card.company forKey:@"company"];
    [dic setObject:card.job==nil?@"":card.job forKey:@"job"];
    [dic setObject:card.phone==nil?@"":card.phone forKey:@"phone"];
    [dic setObject:card.email==nil?@"":card.email forKey:@"email"];
    [dic setObject:card.companyAddress==nil?@"":card.companyAddress forKey:@"companyAddress"];
    [dic setObject:card.account==nil?@"":card.account forKey:@"account"];
    [dic setObject:card.cardPosition==nil?@"":card.cardPosition forKey:@"cardPosition"];
    
    if([imageOrPath isKindOfClass:[NSString class]])
    {
        [dic setObject:imageOrPath forKey:@"headerUrl"];
        [server POST:@"card/update-card-info" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
             {
                 if(retcode == 0)
                 {
                     Card* c = [[Card alloc]init];
                     [c setValuesForKeysWithDictionary:data];
                     [c synchronize:nil];
                     block(1,c);
                 }
                 else
                 {
                     block(0,msg);
                 }
             }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(0,nil);
        }];
    }
    else if ([imageOrPath isKindOfClass:[NSData class]])
    {
        [self postWithData:[[NSURL URLWithString:@"card/update-card-info" relativeToURL:[NSURL URLWithString:SERVERROOTURL]] absoluteString]
                      data:imageOrPath
                   dataKey:@"image"
                parameters:dic
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
              {
                  if(retcode == 0)
                  {
                      Card* c = [[Card alloc]init];
                      [c setValuesForKeysWithDictionary:data];
                      [c synchronize:nil];
                      block(1,c);
                  }
                  else
                  {
                      block(0,msg);
                  }
              }];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             block(0,nil);
         }];
    }
}
//删除名片
-(void)deleteCard:(int)cardId block:(EventCallBack)block
{
    NSMutableDictionary *dict = [self getCommonParamas];
    [dict setObject:[NSNumber numberWithInt:cardId] forKey:@"id"];
    [server POST:@"card/delete-card" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg) {
            if (0 == retcode)
            {
                block(1,nil);
            }
            else
            {
                block(0,msg);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//获取用户保存的名片
-(void)getUserSaveCards:(EventCallBack)block
{
    NSMutableDictionary *dict = [self getCommonParamas];
    [server GET:@"card/card-people-info" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg) {
            if (0 == retcode)
            {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (NSDictionary *dict  in data)
                {
                    Card *card = [[Card alloc] init];
                    [card setValuesForKeysWithDictionary:dict];
                    [card synchronize:nil];
                    [arr addObject:card];
                }
                block(1,arr);
            }
            else
            {
                block(0,msg);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//删除名片
-(void)deleteCardWithCardId:(NSString *)cardId block:(EventCallBack)block
{
    NSMutableDictionary *dict = [self getCommonParamas];
    [dict setObject:(cardId==nil?@"":cardId) forKey:@"id"];
    [server GET:@"card/delete-card" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg) {
            if (0 == retcode)
            {
                block(1,data);
            }
            else
            {
                block(0,msg);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}

#pragma mark - 职脉圈
//获取动态流
-(void)getFeedsWithTime:(NSString *)time limit:(int)limit block:(EventCallBack)block
{
    NSMutableDictionary *dict = [self getCommonParamas];
    [dict setObject:(time == nil?@"":time) forKey:@"time"];
    [dict setObject:(limit == 0)?@"":[NSNumber numberWithInt:limit] forKey:@"limit"];
    [server GET:@"feed/get-feeds-normal" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg) {
            if (0 == retcode)
            {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in data)
                {
                    Feed *feed = [[Feed alloc] init];
                    [feed setValuesForKeysWithDictionary:dict];
                    [array addObject:feed];
                    [feed synchronize:nil];
                }
                block(1,array);
            }
            else
            {
                block(0,msg);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//动态中评论
-(void)commentActionWithPublisher:(NSString *)publishId comment:(NSString *)comment feedId:(NSString *)feedId targetId:(NSString *)targetId block:(EventCallBack)block
{
    NSMutableDictionary *dict = [self getCommonParamas];
    [dict setObject:(publishId == nil?@"":publishId) forKey:@"otherUserId"];
    [dict setObject:(comment == nil?@"":comment) forKey:@"comment"];
    [dict setObject:(feedId == nil)?@"":feedId forKey:@"feedId"];
    [dict setObject:(targetId == nil)?@"":targetId forKey:@"targetId"];
    [server GET:@"article/comment-feed" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg) {
            if (0 == retcode)
            {
                block(1,data);
            }
            else
            {
                block(0,msg);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
//发动态
-(void)sendContent:(NSString *)jsonString image:(UIImage *)image httpUrl:(NSString *)url block:(EventCallBack)block
{
    NSMutableDictionary *dict = [self getCommonParamas];
    [dict setObject:(jsonString == nil?@"":jsonString) forKey:@"json"];
    [dict setObject:(url == nil?@"":url) forKey:@"httpUrl"];
    id imageData = [NSNull null];
    if (image)
    {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        float radio = 200000.0/data.length;
        imageData = UIImageJPEGRepresentation(image, radio);
        
        [self postWithData:[[NSURL URLWithString:@"dynamic/add" relativeToURL:[NSURL URLWithString:SERVERROOTURL]] absoluteString]
                      data:imageData
                   dataKey:@"image"
                parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self resolveResponse:dict block:^(int retcode, id data, NSString *msg) {
                        if (0 == retcode)
                        {
                            block(1,data);
                        }
                        else
                        {
                            block(0,msg);
                        }
                    }];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    block(0,nil);
                }];
    }
    else
    {
        [server POST:@"dynamic/add" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg) {
                if (0 == retcode)
                {
                    block(1,data);
                }
                else
                {
                    block(0,msg);
                }
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(0,nil);
        }];
    }
}
//获取feed评论
-(void)getFeedComment:(NSString *)targetId block:(EventCallBack)block
{
    NSMutableDictionary *dict = [self getCommonParamas];
    [dict setObject:(targetId == nil?@"":targetId) forKey:@"targetId"];
    [server GET:@"article/get-feed-comments" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg) {
            if (0 == retcode)
            {
                block(1,data);
            }
            else
            {
                block(0,msg);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}

//获取标签
-(void)getFeedTags:(NSString *)content block:(EventCallBack)block
{
    NSMutableDictionary *dict = [self getCommonParamas];
    [dict setObject:(content == nil?@"":content) forKey:@"content"];
    [server POST:@"tag/match" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg) {
            if (0 == retcode)
            {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in data)
                {
                    Tag *tag = [[Tag alloc] init];
                    [tag setValuesForKeysWithDictionary:dict];
                    [array addObject:tag];
                }
                block(1,array);
            }
            else
            {
                block(0,msg);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        block(0,nil);
    }];
}

//发送提问
-(void)postQuestion:(NSString *)json block:(EventCallBack)block
{
    NSMutableDictionary *dict = [self getCommonParamas];
    [dict setObject:(json == nil?@"":json) forKey:@"json"];
    [server POST:@"question/add" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg) {
            if (0 == retcode)
            {
                block(1,data);
            }
            else
            {
                block(0,msg);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}

//获取职脉圈问题锁
-(void)getFeedLock:(EventCallBack)block
{
    NSMutableDictionary *dict = [self getCommonParamas];
    [server GET:@"feed/get-feed-lock" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg) {
            if (0 == retcode)
            {
                NSDictionary *dict = (NSDictionary *)data;
                NSMutableArray *lockArray = [[NSMutableArray alloc] init];
                [lockArray addObject:[dict objectForKey:@"lock1"]];
                [lockArray addObject:[dict objectForKey:@"lock2"]];
                block(1,lockArray);
            }
            else
            {
                block(0,msg);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(0,nil);
    }];
}
@end
