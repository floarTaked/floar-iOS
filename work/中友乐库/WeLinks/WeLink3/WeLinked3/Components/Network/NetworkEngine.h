//
//  NetworkEngine.h
//  UnNamed
//
//  Created by jonas on 8/1/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "LogicManager.h"
#import <AFNetworking.h>
#import "Feeds.h"
#import "JobInfo.h"
#import "RecommendInfo.h"

typedef void (^ResponseCallBack)(int retcode,id data,NSString*msg);
@interface NetworkEngine :NSObject
{
    AFHTTPRequestOperationManager* server;
    AFHTTPRequestOperationManager* weiboServer;
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
#pragma --mark 注册与登录
//获取手机验证码
-(void)getVerifiCode:(NSString*)phone block:(EventCallBack)block;
-(void)weiboLogin:(EventCallBack)block;
-(void)bindPhone:(NSString*)phone verifiCode:(NSString*)verifiCode block:(EventCallBack)block;
//保存用户资料
-(void)saveUserInfoWithUrl:(NSString*)headerUrl name:(NSString*)name company:(NSString*)company city:(NSString*)city job:(NSString*)job block:(EventCallBack)block;
-(void)saveUserInfoWithData:(NSData*)image name:(NSString*)name company:(NSString*)company city:(NSString*)city job:(NSString*)job block:(EventCallBack)block;
//上传手机通讯录
-(void)uploadContact:(NSString*)json block:(EventCallBack)block;
#pragma --mark 用户
//获取用户基本资料
-(void)getUserInfo:(NSString*)otherUserId block:(EventCallBack)block;
//获取用户profile资料
-(void)getProfileInfo:(NSString*)otherUserId block:(EventCallBack)block;
//修改用户信息
-(void)saveProfileInfo:(NSString*)json block:(EventCallBack)block;
//修改头像
-(void)uploadAvatar:(NSData*)imageData block:(EventCallBack)block;

#pragma --mark 用户额外信息
//保存教育背景
-(void)saveEducationInfo:(NSString*)json block:(EventCallBack)block;
//删除教育背景
-(void)deleteEducationInfo:(NSString*)identity block:(EventCallBack)block;
//保存工作经历
-(void)saveWorkInfo:(NSString*)json block:(EventCallBack)block;
//删除工作经历
-(void)deleteWorkInfo:(NSString*)identity block:(EventCallBack)block;
#pragma --mark 资讯
//获取分类列表
-(void)getCategoryListWithType:(NSString *)type black:(EventCallBack)block;
//获取已订阅信息列表-资讯首页
-(void)getSubcribedCategoryList:(EventCallBack)block;
//获取文章源列表并带上是否订阅的消息
-(void)getArticleSourceList:(NSString*)parentId block:(EventCallBack)block;
//订阅
-(void)subscribe:(NSString*)identity block:(EventCallBack)block;
//取消订阅
-(void)unSubscribe:(NSString*)identity block:(EventCallBack)block;
//更新后的获取文章列表（添加了文章底部的参数）
-(void)getArticleList:(NSString*)colId withAritcle:(NSString *)articleId block:(EventCallBack)block;

//timeline获取问题列表，传入时间如果是当前的就是更新，如果是上一批数据（头一天）的文章time就是下拉获取更多
-(void)getArticleList:(NSString *)colId withTime:(NSString *)time block:(EventCallBack)block;

//获取文章详细信息
-(void)getArticleInfo:(NSString*)articleId block:(EventCallBack)block;
//获取文章评论列表和赞的列表
-(void)getArcticleCommentListWithArticleID:(NSString *)articleID Block:(EventCallBack)block;
//评论一个文章
-(void)addNewCommentWithArticleID:(NSString *)articleID Comment:(NSString *)comment Block:(EventCallBack)block;
//赞（取消赞）一个文章
-(void)supportArticleWithArticleID:(NSString *)articleID andType:(NSString *)type Block:(EventCallBack)block;
//分享文章到WeLink
-(void)shareArticleToWeLinkWithArticleId:(NSString *)articleId Block:(EventCallBack)block;
//搜索文章源
-(void)searchArticleByKeyWord:(NSString *)keyWord Block:(EventCallBack)block;
//获取职位评论和赞
-(void)getJobCommentAndSupport:(NSString *)jobId Block:(EventCallBack)block;
//获取用户自己发送信息的评论和赞
-(void)getUserPostCommentAndSupport:(NSString *)targetId Block:(EventCallBack)block;

#pragma mark - 职位
//获取我发布的职位列表
-(void)getMyPublishedPost:(EventCallBack)block;
//获取我推荐的职位列表
-(void)getMyPublishedRecommendPost:(EventCallBack)block;
//发新职位
- (void)postNewJob:(JobInfo *)jobInfo Block:(EventCallBack)block;
//求内推
- (void)requestInternalRecommend:(RecommendInfo *)recommendInfo Block:(EventCallBack)block;
//获取单个内推信息
-(void)getRecommendedInfo:(NSString*)recommendedId block:(EventCallBack)block;
//获取人脉职位
- (void)getFriendJobListWithPage:(int)page Block:(EventCallBack)block;
//获取公司职位
- (void)getCompanyJobListWithPage:(int)page Block:(EventCallBack)block;
//获取内推好友列表,多个公司用逗号隔开
- (void)getInternalRecommendFriendListWithRecommend:(RecommendInfo *)recommendInfo Block:(EventCallBack)block;
//获取发布职位可推荐好友列表
- (void)getPublishJobFriendListWithJobID:(NSString *)jobId Block:(EventCallBack)block;
//获取职位信息
- (void)getJobDetailWithJobID:(NSString *)jobId Block:(EventCallBack)block;
//推荐给好友职位或者推荐信息
- (void)recommendToFriend:(NSArray *)friends recommendID:(NSString *)recommendID isInternalRecommend:(BOOL)isInternalRecommend FromCompany:(BOOL)fromCompany isFirstRecommend:(BOOL)isFirstRecommend Block:(EventCallBack)block;
//筛选职位
- (void)selectJobWithJobInfo:(JobInfo *)jobInfo Block:(EventCallBack)block;
//编辑职位
- (void)upDateJobWithJobInfo:(JobInfo *)jobInfo Block:(EventCallBack)block;
//将职位设为过期
- (void)deleteJobWithJobInfo:(JobInfo *)jobInfo Block:(EventCallBack)block;
#pragma mark - 动态
//获取动态列表
- (void)getFeedsListWithBlock:(EventCallBack)block;
//获取更多动态
- (void)getNextFeedsWithLastFeed:(Feeds *)feed Block:(EventCallBack)block;
//赞一条动态 type 1为赞 2为取消赞
- (void)supportFeed:(Feeds *)feed type:(int)type Block:(EventCallBack)block;
//发一条新动态
- (void)addNewFeedWithContent:(NSString *)content Image:(UIImage *)image Block:(EventCallBack)block;
//评论一条动态
- (void)addNewCommentAtFeed:(Feeds *)feed Comment:(NSString *)comment Block:(EventCallBack)block;
#pragma --mark 公共
//评论一条微博
-(void)commentWeibo:(NSString*)weiboId content:(NSString*)content block:(EventCallBack)block;
//检查更新
-(void)checkVersion:(NSString*)versionId block:(EventCallBack)block;
//保存手机token
-(void)savePhoneToken:(NSString*)token block:(EventCallBack)block;
//检查数据更新
-(void)checkUpdate:(EventCallBack)block;
#pragma --mark 人脉
//搜索
-(void)searchFriends:(NSString*)keyWord block:(EventCallBack)block;
//获取好友申请列表
-(void)getFriendRequestList:(EventCallBack)block;
//申请加为好友
-(void)addFriend:(NSString*)friendId block:(EventCallBack)block;
//获取通讯录中用户
-(void)getContactUser:(EventCallBack)block;
//在app里的微博好友
-(void)getWeiBoFriends:(EventCallBack)block;
//一度好友
-(void)getAllFriends:(NSString*)pageNumber block:(EventCallBack)block;
//按职位分组
-(void)groupByJob:(EventCallBack)block;
//按公司分组
-(void)groupByCompany:(EventCallBack)block;
//获取某个公司的职位
-(void)getUserByCompany:(NSString*)compantName block:(EventCallBack)block;
//获得好友列表
-(void)getMyFriends:(EventCallBack)block;
//确认加为好友
-(void)acceptConectRequest:(NSString*)friendId block:(EventCallBack)block;

#pragma --mark 发送消息
-(void)sendMessage:(NSString*)receiverId content:(NSString*)content block:(EventCallBack)block;
//删除消息
-(void)deleteMessage:(NSString*)senderId block:(EventCallBack)block;
//获取未读消息
-(void)receiveUnreadMessage:(EventCallBack)block;
//获取所有消息
-(void)receiveAllMessage:(EventCallBack)block;
//数据更新
-(void)updateData:(EventCallBack)block;
//保存设备token
-(void)saveDeviceToken;
@end
