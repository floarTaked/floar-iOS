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
#import "LogicManager.h"
#import "Article.h"
#import "JobInfo.h"

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
        
        
        weiboServer = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:WEIBOAPIROOT]];
        set = server.responseSerializer.acceptableContentTypes;
        set = [set setByAddingObject:@"text/plain"];
        set = [set setByAddingObject:@"text/html"];
        weiboServer.responseSerializer.acceptableContentTypes = set;
        
    }
    return self;
}
-(NSMutableDictionary*)getCommonParamas
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:[UserInfo myselfInstance].userId==nil?@"":[UserInfo myselfInstance].userId forKey:@"userId"];
    [dic setObject:[UserInfo myselfInstance].token==nil?@"":[UserInfo myselfInstance].token forKey:@"token"];
    [dic setObject:@"ios" forKey:@"os"];
    [dic setObject:APPVERSION forKey:@"v"];
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
//    NSMutableURLRequest *request = [server.requestSerializer multipartFormRequestWithMethod:@"POST"
//                                                                                   URLString:path
//                                                                                  parameters:dic
//                                                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                                                                       [formData appendPartWithFileData:data name:dataKey fileName:@"image.png" mimeType:@"image/jpeg"];
//                                                                   }];
	AFHTTPRequestOperation *operation = [server HTTPRequestOperationWithRequest:request success:success failure:failure];
    [server.operationQueue addOperation:operation];
    [operation resume];
}
#pragma --mark 注册与登录
-(void)getVerifiCode:(NSString*)phone block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:phone==nil?@"":phone forKey:@"phone"];
    [server GET:@"/register/verifi-code" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//微博登录
-(void)weiboLogin:(EventCallBack)block
{
    [[LogicManager sharedInstance] weiBoLogin:^(int event, id object)
    {
        if(event == 0)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:@"" message:@"登录失败" actionText:@"确定"];
            if(block)
            {
                block(0,nil);
            }
        }
        else if (event == 1)
        {
            NSString* weiboId = [(NSDictionary*)object objectForKey:@"weiboUID"];
            NSString* weiboToken = [(NSDictionary*)object objectForKey:@"accessToken"];
            NSNumber* weiboTokenTime = [(NSDictionary*)object objectForKey:@"weiboTokenTime"];
            
            NSString* token = [UserInfo myselfInstance].token;
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            [dic setObject:weiboId==nil?@"":weiboId forKey:@"weiboId"];
            [dic setObject:weiboToken==nil?@"":weiboToken forKey:@"weiboToken"];
            [dic setObject:weiboTokenTime==nil?@"":weiboTokenTime forKey:@"weiboTokenTime"];
            [dic setObject:token==nil?@"":token forKey:@"phoneToken"];
            [dic setObject:@"ios" forKey:@"os"];
            
            [server GET:@"/register/login" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
             {
                 [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
                  {
                      if(retcode == 0)
                      {
                          [[UserInfo myselfInstance] setValuesForKeysWithDictionary:data];
                          [[UserInfo myselfInstance] synchronize:nil];
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
    }];
}
//绑定手机号
-(void)bindPhone:(NSString*)phone verifiCode:(NSString*)verifiCode block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:phone==nil?@"":phone forKey:@"phone"];
    [dic setObject:verifiCode==nil?@"":verifiCode forKey:@"verifiCode"];
    [server GET:@"/register/bind-phone" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  [[UserInfo myselfInstance] setValuesForKeysWithDictionary:data];
                  [[UserInfo myselfInstance] synchronize:nil];
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
//保存用户资料
//image:用户头像(文件流)/headerUrl:头像url name：姓名 company：公司 job：职位 city:城市
-(void)saveUserInfoWithUrl:(NSString*)headerUrl name:(NSString*)name company:(NSString*)company city:(NSString*)city job:(NSString*)job block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:headerUrl==nil?@"":headerUrl forKey:@"headerUrl"];
    [dic setObject:name==nil?@"":name forKey:@"name"];
    [dic setObject:company==nil?@"":company forKey:@"company"];
    [dic setObject:city==nil?@"":city forKey:@"city"];
    [dic setObject:job==nil?@"":job forKey:@"job"];
    [server POST:@"/register/save-info-1" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//保存用户资料
-(void)saveUserInfoWithData:(NSData*)image name:(NSString*)name company:(NSString*)company city:(NSString*)city job:(NSString*)job block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:name==nil?@"":name forKey:@"name"];
    [dic setObject:company==nil?@"":company forKey:@"company"];
    [dic setObject:city==nil?@"":city forKey:@"city"];
    [dic setObject:job==nil?@"":job forKey:@"job"];
    
    [self postWithData:[[NSURL URLWithString:@"/register/save-info-1" relativeToURL:[NSURL URLWithString:SERVERROOTURL]] absoluteString]
                  data:image
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
//上传手机通讯录
-(void)uploadContact:(NSString*)json block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:json==nil?@"":json forKey:@"json"];
    [server POST:@"/register/save-phone-friends" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
#pragma --mark 用户
//获取用户基本资料
-(void)getUserInfo:(NSString*)otherUserId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:otherUserId==nil?@"":otherUserId forKey:@"otherUserId"];
    [server GET:@"/user/user-info" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//获取用户profile资料
-(void)getProfileInfo:(NSString*)otherUserId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:otherUserId==nil?@"":otherUserId forKey:@"otherUserId"];
    [server GET:@"/user/user-profile" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
//修改用户信息
-(void)saveProfileInfo:(NSString*)json block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:json==nil?@"":json forKey:@"json"];
    [server GET:@"/user/update-user-info" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  [[UserInfo myselfInstance] setValuesForKeysWithDictionary:data];
                  [[UserInfo myselfInstance] synchronize:nil];
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
//修改头像
-(void)uploadAvatar:(NSData*)imageData block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [self postWithData:[[NSURL URLWithString:@"/user/update-image" relativeToURL:[NSURL URLWithString:SERVERROOTURL]] absoluteString]
                  data:imageData
               dataKey:@"image"
            parameters:dic
               success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  NSString* imagePath = (NSString*)data;
                  [UserInfo myselfInstance].avatar = imagePath;
                  [[UserInfo myselfInstance] synchronize:nil];
                  block(1,data);
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
#pragma --mark 用户额外信息
//保存教育背景
-(void)saveEducationInfo:(NSString*)json block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:json==nil?@"":json forKey:@"json"];
    [server GET:@"/resume/save-education" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
-(void)deleteEducationInfo:(NSString*)identity block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:identity==nil?@"":identity forKey:@"id"];
    [server GET:@"/resume/delete-education" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:json==nil?@"":json forKey:@"json"];
    [server GET:@"/resume/save-job" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
-(void)deleteWorkInfo:(NSString*)identity block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:identity==nil?@"":identity forKey:@"id"];
    [server GET:@"/resume/delete-job" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

#pragma mark -- 资讯
//获取分类列表
-(void)getCategoryListWithType:(NSString *)type black:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:type forKey:@"type"];
    [server GET:@"/collection/get-industrys" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//获取已订阅信息列表-资讯首页
-(void)getSubcribedCategoryList:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/collection/get-subscribe-collections" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
    {
        [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
        {
            if (0 == retcode)
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

//获取文章源列表并带上是否订阅的消息
-(void)getArticleSourceList:(NSString*)parentId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:parentId==nil?@"":parentId forKey:@"parentId"];
    [server GET:@"/collection/get-collections-with-sub" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//订阅
-(void)subscribe:(NSString*)identity block:(EventCallBack)block
{
    //拼接参数
    NSMutableDictionary* dic = [self getCommonParamas];
    //再次自定义拼接参数---detailSubscription对应cell里面的id
    
    [dic setObject:identity==nil?@"":identity forKey:@"id"];
    //向服务器发送请求带上拼接好的参数---对应的接口文档要求传入的参数
    
    [server GET:@"/collection/subscribe" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//取消订阅
-(void)unSubscribe:(NSString*)identity block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:identity==nil?@"":identity forKey:@"id"];
    [server GET:@"/collection/del-subscribe" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//获取文章列表（老版本）
-(void)getArticleList:(NSString*)colId withAritcle:(NSString *)articleId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:colId==nil?@"":colId forKey:@"colId"];
    [dic setObject:articleId==nil?@"":articleId forKey:@"articleId"];
    [server GET:@"/article/get-articles-by-colllection" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//获取文章列表（Timeline）
-(void)getArticleList:(NSString *)colId withTime:(NSString *)time block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:colId==nil?@"":colId forKey:@"colId"];
    [dic setObject:time==nil?@"":time forKey:@"gettime"];
    [server GET:@"/article/get-articles-by-colllection-withDate" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//获取文章详细信息
-(void)getArticleInfo:(NSString*)articleId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:articleId==nil?@"7593":articleId forKey:@"articleId"];
    [server GET:@"/article/article" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  if(data != nil && [data isKindOfClass:[NSDictionary class]])
                  {
                      Article* article = [[Article alloc]init];
                      [article setValuesForKeysWithDictionary:data];
                      [article synchronize:nil];
                      block(1,article);
                  }
                  else
                  {
                      block(0,nil);
                  }
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

//获取文章评论列表和赞的列表
-(void)getArcticleCommentListWithArticleID:(NSString *)articleID Block:(EventCallBack)block
{
    if (!articleID) {
        return;
    }
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:articleID forKey:@"articleId"];
    [server GET:@"/article/get-comments" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//获取职位评论和赞
-(void)getJobCommentAndSupport:(NSString *)jobId Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:jobId forKey:@"targetId"];
    [server GET:@"/article/get-feed-comments" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//获取用户自己发送消息的评论和赞
-(void)getUserPostCommentAndSupport:(NSString *)targetId Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:targetId forKey:@"targetId"];
    [server GET:@"/article/get-feed-comments" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//评论一个文章
- (void)addNewCommentWithArticleID:(NSString *)articleID Comment:(NSString *)comment Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:articleID forKey:@"articleId"];
    [dic setObject:comment forKey:@"comment"];
    [server GET:@"/article/comment-article" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//赞(取消赞)一个文章
-(void)supportArticleWithArticleID:(NSString *)articleID andType:(NSString *)type Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:articleID forKey:@"articleId"];
    [dic setObject:type forKey:@"type"];
    [server GET:@"/article/zan-article" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//分享文章到WeLink
-(void)shareArticleToWeLinkWithArticleId:(NSString *)articleId Block:(EventCallBack)block
{
    NSMutableDictionary *dic = [self getCommonParamas];
    [dic setObject:articleId forKey:@"articleId"];
    [server GET:@"/article/share-article" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//搜索文章源
-(void)searchArticleByKeyWord:(NSString *)keyWord Block:(EventCallBack)block
{
    NSMutableDictionary *dic = [self getCommonParamas];
    [dic setObject:keyWord forKey:@"keyword"];
    [server GET:@"/collection/search-collections" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

#pragma mark - 动态
//获取动态列表
- (void)getFeedsListWithBlock:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:@"0" forKey:@"autoId"];
    [dic setObject:@"0" forKey:@"time"];
    [server GET:@"/article/get-feeds" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//获取更多动态
- (void)getNextFeedsWithLastFeed:(Feeds *)feed Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:feed.autoId?feed.autoId : @"0" forKey:@"autoId"];
    [dic setObject:[NSNumber numberWithDouble:feed.createTime] forKey:@"time"];
    [server GET:@"/article/get-feeds" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//赞一条动态
- (void)supportFeed:(Feeds *)feed type:(int)type Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:feed.feedsId forKey:@"feedId"];
    [dic setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:feed.feedsType] forKey:@"feedType"];
    if (feed.feedsType == FeedsArticle) {
        NSError* error = nil;
        id data = nil;
        if (feed.targetContent.length) {
            data = [NSJSONSerialization JSONObjectWithData:[feed.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableLeaves error:&error];
        }
        Article *article = [[Article alloc] init];
        
        [article setValuesForKeysWithDictionary:data];
        [dic setObject:article.articleID forKey:@"targetId"];
    }else if(feed.feedsType == FeedsJob)
    {
        NSError* error = nil;
        id data = nil;
        if (feed.targetContent.length) {
            data = [NSJSONSerialization JSONObjectWithData:[feed.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableLeaves error:&error];
        }
        JobInfo *jobInfo = [[JobInfo alloc] init];
        
        [jobInfo setValuesForKeysWithDictionary:data];
        [dic setObject:jobInfo.identity forKey:@"targetId"];
    }
    
    
    [server GET:@"/article/zan-feed" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//发一条新动态
- (void)addNewFeedWithContent:(NSString *)content Image:(UIImage *)image Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    if (content.length) {
        [dic setObject:content forKey:@"content"];
    }
    id imageData = [NSNull null];
    if (image) {
        NSData *data = UIImageJPEGRepresentation(image, 1);
        float radio = 200000.0 / data.length ;
        imageData = UIImageJPEGRepresentation(image,radio);
    }
    [dic setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000] forKey:@"createTime"];
    
    if (image) {
        [self postWithData:[[NSURL URLWithString:@"/article/send-feed" relativeToURL:[NSURL URLWithString:SERVERROOTURL]] absoluteString]
                      data:imageData
                   dataKey:@"image"
                parameters:dic
                   success:^(AFHTTPRequestOperation *task, id responseObject)
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
    }else{
        [server GET:@"/article/send-feed" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
    
    
}

//评论一条动态
- (void)addNewCommentAtFeed:(Feeds *)feed Comment:(NSString *)comment Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:feed.feedsId forKey:@"feedId"];
    [dic setObject:[NSNumber numberWithInt:feed.feedsType] forKey:@"feedType"];
    if (feed.feedsType == FeedsArticle) {
        NSError* error = nil;
        id data = nil;
        if (feed.targetContent.length) {
            data = [NSJSONSerialization JSONObjectWithData:[feed.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableLeaves error:&error];
        }
        Article *article = [[Article alloc] init];
        
        [article setValuesForKeysWithDictionary:data];
        [dic setObject:article.articleID forKey:@"targetId"];
    }else if(feed.feedsType == FeedsJob)
    {
        NSError* error = nil;
        id data = nil;
        if (feed.targetContent.length) {
            data = [NSJSONSerialization JSONObjectWithData:[feed.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableLeaves error:&error];
        }
        JobInfo *jobInfo = [[JobInfo alloc] init];
        
        [jobInfo setValuesForKeysWithDictionary:data];
        [dic setObject:jobInfo.identity forKey:@"targetId"];
    }
    [dic setObject:comment forKey:@"comment"];
    [server GET:@"/article/comment-feed" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

#pragma mark - 职位
//获取我发布的职位列表
-(void)getMyPublishedPost:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/facade/getJobsByUserId" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  NSMutableArray* arr = [NSMutableArray array];
                  for(NSDictionary* d in data)
                  {
                      JobInfo* job = [[JobInfo alloc]init];
                      [job setValuesForKeysWithDictionary:d];
                      [job synchronize:MyPublishedJob];
                      [arr addObject:job];
                  }
                  block(1,arr);
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
//获取我推荐的职位列表
-(void)getMyPublishedRecommendPost:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/facade/getRecommendedsByUserId" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  NSMutableArray* arr = [NSMutableArray array];
                  for(NSDictionary* d in data)
                  {
                      RecommendInfo* info = [[RecommendInfo alloc]init];
                      [info setValuesForKeysWithDictionary:d];
                      [info synchronize:MyRecommendJob];
                      [arr addObject:info];
                  }
                  block(1,arr);
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
//发新职位
- (void)postNewJob:(JobInfo *)jobInfo Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:jobInfo.company==nil?@"":jobInfo.company forKey:@"company"];
    [dic setObject:[NSNumber numberWithInt:jobInfo.education] forKey:@"education"];
    [dic setObject:[NSNumber numberWithInt:jobInfo.howLong] forKey:@"howLong"];
    [dic setObject:jobInfo.industryId==nil?@"":jobInfo.industryId forKey:@"industryId"];
    [dic setObject:jobInfo.subIndustryId==nil?@"":jobInfo.subIndustryId forKey:@"subIndustryId"];
    [dic setObject:jobInfo.jobCode==nil?@"":jobInfo.jobCode forKey:@"jobCode"];
    [dic setObject:[NSNumber numberWithInt:jobInfo.jobLevel] forKey:@"jobLevel"];
    [dic setObject:jobInfo.locationCode==nil?@"":jobInfo.locationCode forKey:@"locationCode"];
    [dic setObject:[UserInfo myselfInstance].name forKey:@"poster"];
    [dic setObject:[UserInfo myselfInstance].userId forKey:@"posterId"];
    [dic setObject:[NSNumber numberWithInt:jobInfo.salaryLevel] forKey:@"salaryLevel"];
    if (jobInfo.describes != nil)
    {
        [dic setObject:jobInfo.describes forKey:@"describes"];
    }
    [server GET:@"/facade/publishJob" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  JobInfo* job = [[JobInfo alloc]init];
                  [job setValuesForKeysWithDictionary:data];
                  block(1,job);
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

//求内推
- (void)requestInternalRecommend:(RecommendInfo *)recommendInfo Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    if (recommendInfo.company1) {
        [dic setObject:recommendInfo.company1 forKey:@"company1"];
    }
    if (recommendInfo.company2) {
        [dic setObject:recommendInfo.company2 forKey:@"company2"];
    }
    if (recommendInfo.company3) {
        [dic setObject:recommendInfo.company3 forKey:@"company3"];
    }

    [dic setObject:recommendInfo.currentCompany==nil?@"":recommendInfo.currentCompany forKey:@"currentCompany"];
    [dic setObject:recommendInfo.currentJob==nil?@"":recommendInfo.currentJob forKey:@"currentJob"];
    [dic setObject:[NSNumber numberWithInt:recommendInfo.currentLevel] forKey:@"currentLevel"];
    [dic setObject:[NSNumber numberWithInt:recommendInfo.education] forKey:@"education"];
    [dic setObject:[NSNumber numberWithInt:recommendInfo.howLong] forKey:@"howLong"];
    [dic setObject:recommendInfo.industryId==nil?@"":recommendInfo.industryId forKey:@"industryId"];
    [dic setObject:recommendInfo.subIndustryId==nil?@"":recommendInfo.subIndustryId forKey:@"subIndustryId"];
    [dic setObject:recommendInfo.jobCode==nil?@"":recommendInfo.jobCode forKey:@"jobCode"];
    [dic setObject:recommendInfo.locationCode==nil?@"":recommendInfo.locationCode forKey:@"locationCode"];
    [dic setObject:[UserInfo myselfInstance].name forKey:@"poster"];
    [dic setObject:[UserInfo myselfInstance].userId forKey:@"posterId"];
    if (recommendInfo.descriptions)
    {
        [dic setObject:recommendInfo.descriptions forKey:@"descriptions"];
    }
    
    
    [server GET:@"/facade/publishRecommended" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  RecommendInfo* info = [[RecommendInfo alloc]init];
                  [info setValuesForKeysWithDictionary:data];
                  [info synchronize:MyRecommendJob];
                  block(1,info);
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
//获取单个内推信息
-(void)getRecommendedInfo:(NSString*)recommendedId block:(EventCallBack)block
{
    //getRecommended
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:recommendedId==nil?@"":recommendedId forKey:@"recommendedId"];
    [server GET:@"/facade/getRecommended" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  RecommendInfo* info = [[RecommendInfo alloc]init];
                  [info setValuesForKeysWithDictionary:data];
                  block(1,info);
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
//获取人脉职位
- (void)getFriendJobListWithPage:(int)page Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageNo"];
    [server GET:@"/facade/getJobs-os" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//获取公司职位
- (void)getCompanyJobListWithPage:(int)page Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:page] forKey:@"pageNo"];
    [server GET:@"/facade/getCompanyJobs-os" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//获取内推好友列表,多个公司用逗号隔开
- (void)getInternalRecommendFriendListWithRecommend:(RecommendInfo *)recommendInfo Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    NSString *company = @"";
    for (int i = 0; i < 3; i ++) {
        switch (i) {
            case 0:
                if (![recommendInfo.company1 isEqualToString:@"待补充"]) {
                    company = [NSString stringWithFormat:@"%@,",recommendInfo.company1];
                }
                break;
            case 1:
                if (![recommendInfo.company2 isEqualToString:@"待补充"]) {
                    company = [NSString stringWithFormat:@"%@%@,",company,recommendInfo.company2];
                }
                break;
            case 2:
                if (![recommendInfo.company3 isEqualToString:@"待补充"]) {
                    company = [NSString stringWithFormat:@"%@%@,",company,recommendInfo.company3];
                }
                break;
                
            default:
                break;
        }
    }
    if (company.length > 2) {
        company = [company substringToIndex:company.length - 2];
    }
    [dic setObject:company forKey:@"company"];
    [server GET:@"/facade/recommendFriendsByCompany" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//获取发布职位可推荐好友列表
- (void)getPublishJobFriendListWithJobID:(NSString *)jobId Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:jobId forKey:@"job"];
    [server GET:@"/facade/recommendFriendsByJob" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  if(data != nil && [data isKindOfClass:[NSArray class]])
                  {
                      block(1,data);
                  }
                  else
                  {
                      block(0,nil);
                  }
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

//获取职位信息
- (void)getJobDetailWithJobID:(NSString *)jobId Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:jobId forKey:@"jobId"];
    [server GET:@"/facade/getJob" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  if(data != nil && [data isKindOfClass:[NSDictionary class]])
                  {
                      block(1,data);
                  }
                  else
                  {
                      block(0,nil);
                  }
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

//推荐给好友职位或者推荐信息
- (void)recommendToFriend:(NSArray *)friends recommendID:(NSString *)recommendID isInternalRecommend:(BOOL)isInternalRecommend FromCompany:(BOOL)fromCompany isFirstRecommend:(BOOL)isFirstRecommend Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    NSString *friendIDs = @"";
    for (UserInfo *user in friends) {
        friendIDs = [NSString stringWithFormat:@"%@,%@",friendIDs,user.userId];
    }
    if (friendIDs.length > 1) {
        friendIDs = [friendIDs substringFromIndex:1];
    }
    [dic setObject:friendIDs forKey:@"ids"];
    
    if (isInternalRecommend) {
        [dic setObject:recommendID forKey:@"recommendedId"];
        
    }else{
        if (fromCompany) {
            [dic setObject:recommendID forKey:@"recommendedId"];
            [dic setObject:@"1" forKey:@"fromCompany"];
        }else{
            [dic setObject:recommendID forKey:@"jobId"];
        }
        
    }
    if (isFirstRecommend) {
        [dic setObject:@"1" forKey:@"isFirstRecommend"];
    }
    
    [server GET:@"/facade/recommendToFriends" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//筛选职位
- (void)selectJobWithJobInfo:(JobInfo *)jobInfo Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:jobInfo.salaryLevel] forKey:@"salaryLevel"];
    [dic setObject:jobInfo.industryId forKey:@"industryId"];
    [dic setObject:jobInfo.jobCode forKey:@"jobCode"];
    [dic setObject:jobInfo.locationCode forKey:@"locationCode"];
    
    [server GET:@"/facade/selectJob" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

//编辑职位
- (void)upDateJobWithJobInfo:(JobInfo *)jobInfo Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:jobInfo.company==nil?@"":jobInfo.company forKey:@"company"];
    [dic setObject:[NSNumber numberWithInt:jobInfo.education] forKey:@"education"];
    [dic setObject:[NSNumber numberWithInt:jobInfo.howLong] forKey:@"howLong"];
    [dic setObject:jobInfo.industryId==nil?@"":jobInfo.industryId forKey:@"industryId"];
    [dic setObject:jobInfo.subIndustryId==nil?@"":jobInfo.subIndustryId forKey:@"subIndustryId"];
    [dic setObject:jobInfo.jobCode==nil?@"":jobInfo.jobCode forKey:@"jobCode"];
    [dic setObject:[NSNumber numberWithInt:jobInfo.jobLevel] forKey:@"jobLevel"];
    [dic setObject:jobInfo.locationCode==nil?@"":jobInfo.locationCode forKey:@"locationCode"];
    [dic setObject:[UserInfo myselfInstance].name forKey:@"poster"];
    [dic setObject:[UserInfo myselfInstance].userId forKey:@"posterId"];
    [dic setObject:[NSNumber numberWithInt:jobInfo.salaryLevel] forKey:@"salaryLevel"];
    [dic setObject:jobInfo.identity forKey:@"identity"];
    if (jobInfo.describes != nil)
    {
        [dic setObject:jobInfo.describes forKey:@"describes"];
    }
    
    [server GET:@"/facade/updateJob" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//将职位设为过期
- (void)deleteJobWithJobInfo:(JobInfo *)jobInfo Block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:jobInfo.identity forKey:@"identity"];
    [server GET:@"/facade/pastJob" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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

#pragma mark -
//评论一条微博
-(void)commentWeibo:(NSString*)weiboId content:(NSString*)content block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:weiboId==nil?@"":weiboId forKey:@"weiboId"];
    [dic setObject:content==nil?@"":content forKey:@"content"];
    [server GET:@"/comm/comment-weibo" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//检查更新
-(void)checkVersion:(NSString*)versionId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:versionId==nil?@"":versionId forKey:@"versionId"];
    [server GET:@"/comm/check-version" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//保存手机token
-(void)savePhoneToken:(NSString*)token block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:token==nil?@"":token forKey:@"pushId"];
    [server GET:@"/comm/save-token" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//检查数据更新
-(void)checkUpdate:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/comm/is-update" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
#pragma --mark 人脉
//搜索
-(void)searchFriends:(NSString*)keyWord block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:keyWord forKey:@"keyWord"];
    [server GET:@"/facade/searchFriends" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  NSMutableArray* arr = [NSMutableArray array];
                  for(NSDictionary* dic in data)
                  {
                      UserInfo* user = [[UserInfo alloc]init];
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
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
//获取好友申请列表
-(void)getFriendRequestList:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/friend/get-friend-requests" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  NSMutableArray* arr = [NSMutableArray array];
                  for(NSDictionary* dic in data)
                  {
                      UserInfo* user = [[UserInfo alloc]init];
                      [user setValuesForKeysWithDictionary:dic];
                      [user synchronize:NewFriendTable];
                      [arr addObject:user];
                  }
                  block(1,arr);
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
//申请加为好友
-(void)addFriend:(NSString*)friendId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:friendId forKey:@"friendId"];
    [server GET:@"/friend/add-friend" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//获取通讯录中用户
-(void)getContactUser:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/friend/phone-friends" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//在app里的微博好友
-(void)getWeiBoFriends:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/facade/getWeiboFriends" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  NSMutableArray* arr = [NSMutableArray array];
                  for(NSDictionary* dic in data)
                  {
                      UserInfo* info = [[UserInfo alloc]init];
                      [info setValuesForKeysWithDictionary:dic];
                      [info synchronize:WeiBoFriend];
                      [arr addObject:info];
                  }
                  block(1,arr);
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
//一度好友
-(void)getAllFriends:(NSString*)pageNumber block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:pageNumber==nil?@"":pageNumber forKey:@"pageNo"];
    [server GET:@"/facade/getRelations" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  NSMutableArray* arr = [NSMutableArray array];
                  for(NSDictionary* dic in data)
                  {
                      UserInfo* info = [[UserInfo alloc]init];
                      [info setValuesForKeysWithDictionary:dic];
                      [info synchronize:AllFriendsTable];
                      [arr addObject:info];
                  }
                  block(1,arr);
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
//按职位分组
-(void)groupByJob:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/facade/getJobTitleInFriends" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//按公司分组
-(void)groupByCompany:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/facade/getJobCompanysInFriends" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//获取某个公司的职位
-(void)getUserByCompany:(NSString*)compantName block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:compantName==nil?@"":compantName forKey:@"company"];
    [server GET:@"/facade/getUsersByCompanyInFriends" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  NSMutableArray* arr = [NSMutableArray array];
                  for(NSDictionary* dic in data)
                  {
                      UserInfo* info  = [[UserInfo alloc]init];
                      [info setValuesForKeysWithDictionary:dic];
                      [arr addObject:info];
                  }
                  block(1,arr);
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
//获得好友列表
-(void)getMyFriends:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/friend/get-friends" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  NSMutableArray* arr = [NSMutableArray array];
                  for(NSDictionary* dic in data)
                  {
                      UserInfo* user  = [[UserInfo alloc]init];
                      [user setValuesForKeysWithDictionary:dic];
                      [user synchronize:MyFriendsTable];
                      [arr addObject:user];
                  }
                  block(1,arr);
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

//确认加为好友
-(void)acceptConectRequest:(NSString*)friendId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:friendId==nil?@"":friendId forKey:@"friendId"];
    [server GET:@"/friend/confirm-friend" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
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
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
#pragma --mark 发送消息
//删除消息
-(void)deleteMessage:(NSString*)senderId block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:senderId==nil?@"":senderId forKey:@"senderId"];
    [server GET:@"/msg/del-msgs" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  block(1,nil);
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
-(void)sendMessage:(NSString*)receiverId content:(NSString*)content block:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:receiverId==nil?@"":receiverId forKey:@"receiverId"];
    [dic setObject:content==nil?@"":content forKey:@"content"];
    [server GET:@"/msg/send-msg" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
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
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         block(0,nil);
     }];
}
//获取未读消息
-(void)receiveUnreadMessage:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/msg/get-msgs" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  if(data != nil)
                  {
                      NSMutableArray* arr = [NSMutableArray array];
                      for(NSDictionary* dic in data)
                      {
                          if(dic != nil)
                          {
                              MessageData* message = [[MessageData alloc]init];
                              [message setValuesForKeysWithDictionary:dic];
                              [message synchronize:nil];
                              [arr addObject:message];
                          }
                      }
                      block(1,arr);
                  }
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
//获取所有消息
-(void)receiveAllMessage:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [dic setObject:[NSNumber numberWithInt:1] forKey:@"isAll"];
    [server GET:@"/msg/get-msgs" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg)
          {
              if(retcode == 0)
              {
                  if(data != nil)
                  {
                      NSMutableArray* arr = [NSMutableArray array];
                      for(NSDictionary* dic in data)
                      {
                          if(dic != nil)
                          {
                              MessageData* message = [[MessageData alloc]init];
                              [message setValuesForKeysWithDictionary:dic];
                              
                              NSArray* existArray = [[UserDataBaseManager sharedInstance]
                                                     queryWithClass:[MessageData class]
                                                     tableName:nil
                                                     condition:[NSString stringWithFormat:@" where identity=%d",message.identity]];
                              if(existArray != nil && [existArray count]>0)
                              {
                                  MessageData* exist = [existArray objectAtIndex:0];
                                  message.status = exist.status;
                              }
                              [message synchronize:nil];
                              [arr addObject:message];
                          }
                      }
                      block(1,arr);
                  }
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
//数据更新
-(void)updateData:(EventCallBack)block
{
    NSMutableDictionary* dic = [self getCommonParamas];
    //newfriend:新的联系人 friends:联系人列表 msg:消息 feeds:职脉圈
    [server GET:@"/comm/is-update" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
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
//保存设备token
-(void)saveDeviceToken
{
    NSMutableDictionary* dic = [self getCommonParamas];
    [server GET:@"/comm/save-token" parameters:dic success:^(AFHTTPRequestOperation *task, id responseObject)
     {
         [self resolveResponse:responseObject block:^(int retcode, id data, NSString *msg){}];
     } failure:^(AFHTTPRequestOperation *task, NSError *error) {}];
}
@end
