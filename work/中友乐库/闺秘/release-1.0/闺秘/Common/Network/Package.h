//
//  Package.h
//  闺秘
//
//  Created by floar on 14-7-2.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogicManager.h"
#import "UserInfo.h"
#import "Feed.h"
#import "Comment.h"

static int packageSequenceId = 0;
@interface Package : NSObject
{
    NSMutableData *data;
    int index;
}

//subProcotol根据文档手动填写
- (id)initWithSubSystem:(SubSystem)SubsystemId withSubProcotol:(uint32_t)subProcotol;
- (id)initWithData:(NSMutableData *)value;
-(NSData *)getData;
-(void)reset;


-(uint32_t)readInt32;
-(uint64_t)readInt64;
-(NSString *)readString;

-(void)appendInt32:(uint32_t)value;
-(void)appendInt64:(uint64_t)value;
-(void)appendString:(NSString *)value;


-(void)setProtocalId:(uint32_t)protocalId;
-(uint32_t)getProtocalId;


#pragma mark - 业务逻辑组装socket发送数据
//用户注册
-(void)registWithAccountType:(uint32_t)accountType
                                   accountName:(NSString *)accountName
                                          setp:(uint32_t)step
                                      identifyCode:(NSString *)code
                                    password:(NSString *)password;
//修改密码
-(void)changePasswordWithUserId:(uint64_t)userId
                             userKey:(NSString *)userKey
                         oldPassword:(NSString *)oldPassword
                         newPassword:(NSString *)newPassword;

//用户登录
-(void)loginWithAccountType:(uint32_t)accountType
                         accountName:(NSString *)accountName
                            password:(NSString *)password;

//用户消息
-(void)publishSecretWithUserId:(uint64_t)userId
                         userKey:(NSString *)userKey
                         addressJsonStr:(NSString *)address
                  contentJsonStr:(NSString *)content;

//用户评论或者赞
-(void)supportOrCommentWithUserId:(uint64_t)userId
                               userKey:(NSString *)userKey
                                feedId:(uint64_t)feedId
                             commentId:(uint64_t)commentId
                             operation:(uint32_t)operation
                               comment:(NSString *)comment;

//批量拉取最近feed
-(void)lastedFeedsWithUserId:(uint64_t)userId
                           userKey:(NSString *)userKey
                    lastFentchTime:(uint32_t)time
                   messageId:(uint64_t)messageId
                    limitNum:(uint32_t)num;

//拉取feed详细信息
-(void)feedDetailInfoWithUserId:(uint64_t)userId
                             userKey:(NSString *)userKey
                              feedId:(uint64_t)feedId;

//上传通讯录
-(void)updateContractListWithUserId:(uint64_t)userId
                            userKey:(NSString *)userKey
                  phoneBookJsonStr:(NSString *)jsonStr;

//分享到自己圈子
-(void)shareForOwnCircleWithUserId:(uint64_t)userId
                           userKey:(NSString *)userKey
                            feedId:(uint64_t)feedId;
//收藏消息
-(void)collectFeedWithUserId:(uint64_t)userId
                     userKey:(NSString *)userKey
                      feedId:(uint64_t)feedId;

//移除收藏消息
-(void)removeCellectedFeedWithUserId:(uint64_t)userId
                             userKey:(NSString *)userKey
                              feedId:(uint64_t)feedId;
//拉取地点附近信息
-(void)fetchFeedsNearByWithUserId:(uint64_t)userId
                          userKey:(NSString *)userKey
                  locationJsonStr:(NSString *)locationJson
                        fetchTime:(uint32_t)time
                   fetchMessageId:(uint64_t)messageId;

//举报消息
-(void)reportFeedWithUserId:(uint64_t)userId
                    userKey:(NSString *)userKey
                     feedId:(uint64_t)feedId
                 uniqueCode:(uint32_t)num
               reportReason:(NSString *)reason;

//拉取收藏的消息
-(void)fetchCollectedFeedsUserId:(uint64_t)userId
                         userKey:(NSString *)userKey;

//移除消息
-(void)deleteFeedInMainViewWithUserId:(uint64_t)userId
                              userKey:(NSString *)userKey
                               feedId:(uint64_t)feedId;

//拉取引导问题
-(void)fetchGuideQuestionWithWithUserId:(uint64_t)userId
                                userKey:(NSString *)userKey
                              fetchTime:(uint32_t)time
                           preMessageId:(uint64_t)messageId
                              limitsNum:(uint32_t)num;

//拉取用户朋友数
-(void)fetchNumberOfFriendsWithUserId:(uint64_t)userId
                              userKey:(NSString *)userKey;

//意见反馈
-(void)suggestForUsWithUserId:(uint64_t)userId
                      userKey:(NSString *)userKey
               suggestContent:(NSString *)content;

#pragma mark - 业务逻辑处理网络返回socket数据包
//用户注册
-(BOOL)handleRegist:(Package *)pack WithWrite:(BOOL)write withErrorCode:(CheckErrorCode)code;
//修改密码
-(BOOL)handleChangePassword:(Package *)pack withErrorCode:(CheckErrorCode)code;
//用户登录
-(BOOL)handleLogin:(Package *)pack withErrorCode:(CheckErrorCode)code;
//用户消息
-(BOOL)handlePublishSecret:(Package *)pack withErrorCode:(CheckErrorCode)code;
//用户评论或者赞
-(BOOL)handleSupportOrComment:(Package *)pack withErrorCode:(CheckErrorCode)code;
//批量拉取最近feed
-(BOOL)handleFetchFeeds:(Package *)pack withErrorCode:(CheckErrorCode)code;
//拉取feed详细信息
-(Feed *)handleFeedDetail:(Package *)pack withErrorCode:(CheckErrorCode)code;
//长传通讯录
-(BOOL)handleUpdateContractList:(Package *)pack withErrorCoed:(CheckErrorCode)code;
//分享到自己圈子
-(BOOL)handleShareForOwnCircle:(Package *)pack withErrorCode:(CheckErrorCode)code;
//收藏消息
-(BOOL)handleCollectFeed:(Package *)pack withErrorCode:(CheckErrorCode)code;
//移除收藏消息
-(BOOL)handleRemoveCollectedFeed:(Package *)pack withErrorCode:(CheckErrorCode)code;
//拉取地点附近信息
-(NSArray *)handleFetchNearByFeeds:(Package *)pack withErrorCode:(CheckErrorCode)code;
//举报消息
-(BOOL)handleReportFeed:(Package *)pack withErrorCode:(CheckErrorCode)code;
//拉取收藏的消息
-(BOOL)handleFetchCollectedFeeds:(Package *)pack withErrorCode:(CheckErrorCode)code;
//移除消息
-(BOOL)handleDeleteFeedInMainView:(Package *)pack withErrorCode:(CheckErrorCode)code;
//拉取引导问题
-(BOOL)handleFetchGuideQuestion:(Package *)pack withErrorCode:(CheckErrorCode)code;
//拉取用户朋友数
-(uint32_t)handleFetchNumberOfFriends:(Package *)pack withErrorCode:(CheckErrorCode)code;
//意见反馈
-(BOOL)handleSuggestForUs:(Package *)pack withErrorCode:(CheckErrorCode)code;

@end