//
//  Package.m
//  闺秘
//
//  Created by floar on 14-7-2.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "Package.h"
#import "PhoneBookInfo.h"
#import <CoreFoundation/CFByteOrder.h>
//#include "StringHelper.h"
#import "DataBaseManager.h"

@implementation Package

- (id)initWithSubSystem:(SubSystem)systemId withSubProcotol:(uint32_t)subProcotol
{
    self = [super init];
    if (self)
    {
        data = [[NSMutableData alloc] init];
        index = 0;
        [self appendInt32:0];//length
        [self appendInt32:'ZALB'];//MagicNumber
        [self appendInt32:PROJECTID];//ProjectId
        [self appendInt32:systemId];//SubsysId
        [self appendInt32:subProcotol];//ProtocalId
        [self appendInt32:packageSequenceId];//SequenceId
        packageSequenceId++;
    }
    return self;
}

- (instancetype)initWithData:(NSMutableData *)value
{
    self = [super init];
    if (self)
    {
        index = 0;
        data = value;
    }
    return self;
}

#pragma mark - Function

-(NSData *)getData
{
    uint32_t len = [data length] - sizeof(uint32_t);
    uint32_t l = CFSwapInt32HostToBig(len);
    [data replaceBytesInRange:NSMakeRange(0, sizeof(l)) withBytes:&l];
    
//    char buffer[10240];
//    [data getBytes:buffer length:[data length]];
//    auto s = zli::hexShow(buffer, [data length]);
//    NSLog(@"\n%s", s.c_str());
    
    return data;
}
-(void)setProtocalId:(uint32_t)protocalId;
{
    uint32_t proID = CFSwapInt32HostToBig(protocalId);
    [data replaceBytesInRange:NSMakeRange(4 * sizeof(uint32_t), sizeof(proID)) withBytes:&proID];
}
-(uint32_t)getProtocalId
{
    uint32_t value;
    [data getBytes:&value range:NSMakeRange(4 * sizeof(uint32_t), sizeof(uint32_t))];
    value = CFSwapInt32BigToHost(value);
    return value;
}
-(void)reset
{
    index = 6 * sizeof(uint32_t);
}

#pragma mark - readData
-(uint32_t)readInt32
{
    uint32_t value;
    [data getBytes:&value range:NSMakeRange(index, 4)];
    index += sizeof(value);
    value = CFSwapInt32BigToHost(value);
    return value;
}

-(uint64_t)readInt64
{
    uint64_t value;
    [data getBytes:&value range:NSMakeRange(index, 8)];
    value = CFSwapInt64BigToHost(value);
    index += sizeof(value);
    return value;
}

-(NSString *)readString
{
    uint32_t length = [self readInt32];
    NSData *d = [data subdataWithRange:NSMakeRange(index, length)];
    NSString *str = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    index += length;
    return str;
}

#pragma mark - appendData
-(void)appendInt32:(uint32_t)value
{
    value = CFSwapInt32HostToBig(value);
    [data appendBytes:&value length:sizeof(value)];
    index += sizeof(value);
}

-(void)appendInt64:(uint64_t)value
{
    value = CFSwapInt64HostToBig(value);
    [data appendBytes:&value length:sizeof(value)];
    index += sizeof(value);
}

-(void)appendString:(NSString *)value
{
    const char * str = [value UTF8String];
    uint32_t length = strlen(str);
    NSData* d = [NSData dataWithBytes:str length:length];
    [self appendInt32:length];
    [data appendData:d];
    index += length;
}

#pragma mark - 业务逻辑组装socket发送数据
//用户注册
-(void)registWithAccountType:(uint32_t)accountType
                          accountName:(NSString *)accountName
                                 setp:(uint32_t)step
                             identifyCode:(NSString *)code
                             password:(NSString *)password
{
    NSString *pd = [[LogicManager sharedInstance] encodePasswordWithsha1:password];
    
    [self appendInt32:accountType];
    [self appendString:accountName];
    [self appendInt32:step];
    [self appendString:code];
    [self appendString:pd];
}

//修改密码
-(void)changePasswordWithUserId:(uint64_t)userId
                             userKey:(NSString *)userKey
                         oldPassword:(NSString *)oldPassword
                         newPassword:(NSString *)newPassword
{
    NSString *oldPd = [[LogicManager sharedInstance] encodePasswordWithsha1:oldPassword];
    NSString *newPd = [[LogicManager sharedInstance] encodePasswordWithsha1:newPassword];
    
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendString:oldPd];
    [self appendString:newPd];
}

//用户登录
-(void)loginWithAccountType:(uint32_t)accountType
                         accountName:(NSString *)accountName
                            password:(NSString *)password
{
    NSString *pd = [[LogicManager sharedInstance] encodePasswordWithsha1:password];
    
    [self appendInt32:accountType];
    [self appendString:accountName];
    [self appendString:pd];
}

//用户消息
-(void)publishSecretWithUserId:(uint64_t)userId
                         userKey:(NSString *)userKey
                  addressJsonStr:(NSString *)address
                  contentJsonStr:(NSString *)content
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendString:address];
    [self appendString:content];
}

//用户评论或者赞
-(void)supportOrCommentWithUserId:(uint64_t)userId
                               userKey:(NSString *)userKey
                                feedId:(uint64_t)feedId
                             commentId:(uint64_t)commentId
                             operation:(uint32_t)operation
                               comment:(NSString *)comment
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendInt64:feedId];
    [self appendInt64:commentId];
    [self appendInt32:operation];
    [self appendString:comment];
}

//批量拉取最近feed
-(void)lastedFeedsWithUserId:(uint64_t)userId
                          userKey:(NSString *)userKey
                   lastFentchTime:(uint32_t)time
                   messageId:(uint64_t)messageId
                    limitNum:(uint32_t)num
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendInt32:time];
    [self appendInt64:messageId];
    [self appendInt32:num];
}

//拉取feed详细信息
-(void)feedDetailInfoWithUserId:(uint64_t)userId
                             userKey:(NSString *)userKey
                              feedId:(uint64_t)feedId
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendInt64:feedId];
}

//上传通讯录
-(void)updateContractListWithUserId:(uint64_t)userId
                            userKey:(NSString *)userKey
                  phoneBookJsonStr:(NSString *)jsonStr
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendString:jsonStr];
}

//分享到自己圈子
-(void)shareForOwnCircleWithUserId:(uint64_t)userId
                           userKey:(NSString *)userKey
                            feedId:(uint64_t)feedId
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendInt64:feedId];
}
//收藏消息
-(void)collectFeedWithUserId:(uint64_t)userId
                     userKey:(NSString *)userKey
                      feedId:(uint64_t)feedId
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendInt64:feedId];
}

//移除收藏消息
-(void)removeCellectedFeedWithUserId:(uint64_t)userId
                             userKey:(NSString *)userKey
                              feedId:(uint64_t)feedId
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendInt64:feedId];
}
//拉取地点附近信息
-(void)fetchFeedsNearByWithUserId:(uint64_t)userId
                          userKey:(NSString *)userKey
                  locationJsonStr:(NSString *)locationJson
                        fetchTime:(uint32_t)time
                   fetchMessageId:(uint64_t)messageId
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendString:locationJson];
    [self appendInt32:time];
    [self appendInt64:messageId];
}
//举报消息
-(void)reportFeedWithUserId:(uint64_t)userId
                    userKey:(NSString *)userKey
                     feedId:(uint64_t)feedId
                 uniqueCode:(uint32_t)num
               reportReason:(NSString *)reason
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendInt64:feedId];
    [self appendInt32:num];
    [self appendString:reason];
}

-(void)fetchCollectedFeedsUserId:(uint64_t)userId userKey:(NSString *)userKey
{
    [self appendInt64:userId];
    [self appendString:userKey];
}

-(void)deleteFeedInMainViewWithUserId:(uint64_t)userId
                              userKey:(NSString *)userKey
                               feedId:(uint64_t)feedId
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendInt64:feedId];
}

-(void)fetchGuideQuestionWithWithUserId:(uint64_t)userId
                                userKey:(NSString *)userKey
                              fetchTime:(uint32_t)time
                           preMessageId:(uint64_t)messageId
                              limitsNum:(uint32_t)num
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendInt32:time];
    [self appendInt64:messageId];
    [self appendInt32:num];
}

-(void)fetchNumberOfFriendsWithUserId:(uint64_t)userId
                              userKey:(NSString *)userKey
{
    [self appendInt64:userId];
    [self appendString:userKey];
}

-(void)suggestForUsWithUserId:(uint64_t)userId
                      userKey:(NSString *)userKey
               suggestContent:(NSString *)content
{
    [self appendInt64:userId];
    [self appendString:userKey];
    [self appendString:content];
}


#pragma mark - 业务逻辑处理网络返回socket数据包
-(BOOL)handleRegist:(Package *)pack WithWrite:(BOOL)write withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        if (write)
        {
            UserInfo *user = [UserInfo myselfInstance];
            user.userId = [pack readInt64];
            user.userKey = [pack readString];
            [user synchronize:nil];
        }
        return YES;
    }
    return NO;
}

-(BOOL)handleChangePassword:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        UserInfo *user = [UserInfo myselfInstance];
        user.userKey = [pack readString];
        [user synchronize:nil];
        return YES;
    }
    return NO;
}

-(BOOL)handleLogin:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        UserInfo *user = [UserInfo myselfInstance];
        user.userId = [pack readInt64];
        user.userKey = [pack readString];
        [user synchronize:nil];
        return YES;
    }
    return NO;
}

-(BOOL)handlePublishSecret:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        uint64_t feedId = [pack readInt64];
        DLog(@"发布消息成功feedId:%llu",feedId);
        return YES;
    }
    return NO;
}

-(BOOL)handleSupportOrComment:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        uint64_t feedId = [pack readInt64];
        uint64_t commentId = [pack readInt64];
//        NSLog(@"评论feed成功，feedId%llu:commentId%llu",feedId,commentId);
        DLog(@"评论feed成功，feedId%llu:commentId%llu",feedId,commentId);
        return YES;
    }
    return NO;
}

-(BOOL)handleFetchFeeds:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        uint64_t endMessageId = [pack readInt64];
        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithUnsignedLongLong:endMessageId] withKey:FeedLastMessageId];
        uint32_t num = [pack readInt32];
//        NSLog(@"length:%d endMessageId:%llu",num,endMessageId);
        DLog(@"length:%d endMessageId:%llu",num,endMessageId);
        for (int i = 0;i < num; i++)
        {
            Feed *feed = [[Feed alloc] init];
            feed.feedId = [pack readInt64];
            feed.contentJson = [pack readString];
            feed.likeNum = [pack readInt32];
            feed.isOwnZanFeed = [pack readInt32];
            feed.commentNum = [pack readInt32];
            feed.addressStr = [pack readString];
            [self handleContentJson:feed.contentJson feed:feed];
            [feed synchronize:nil];
        }
        return YES;
    }
    return NO;
}

-(Feed *)handleFeedDetail:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    Feed *feed = [[Feed alloc] init];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        
        feed.likeNum = [pack readInt32];
        feed.isOwnZanFeed = [pack readInt32];
        feed.commentNum = [pack readInt32];
        uint32_t num = feed.commentNum;
        
        for (int i = 0; i < num; i++)
        {
            Comment *comment = [[Comment alloc] init];
            comment.feedId = [pack readInt64];
            comment.commentId = [pack readInt64];
            comment.comment = [pack readString];
            comment.floorNum = [pack readInt32];
            comment.avatarId = [pack readInt32];
            comment.likeNum = [pack readInt32];
            comment.isOwnZanComment = [pack readInt32];
            comment.createTime = [pack readInt32];
            [comment synchronize:nil];
        }
    }
    return feed;
}

//长传通讯录
-(BOOL)handleUpdateContractList:(Package *)pack withErrorCoed:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        return YES;
    }
    return NO;
}

//分享到自己圈子
-(BOOL)handleShareForOwnCircle:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
//        uint64_t newFeedId = [pack readInt64];
        return YES;
    }
    return NO;

}

//收藏消息
-(BOOL)handleCollectFeed:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
//        NSLog(@"收藏成功");
        return YES;
    }
    return NO;

}

//移除收藏消息
-(BOOL)handleRemoveCollectedFeed:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        NSLog(@"移除消息成功");
        return YES;
    }
    return NO;

}

//拉取地点附近信息
-(NSArray *)handleFetchNearByFeeds:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        uint64_t messageEndId = [pack readInt64];
        uint32_t feedsNum = [pack readInt32];
        DLog(@"messageId:%llu---条数:%d",messageEndId,feedsNum);
        for (int i = 0; i < feedsNum; i++)
        {
            Feed *feed = [[Feed alloc] init];
            feed.feedId = [pack readInt64];
            feed.contentJson = [pack readString];
            [self handleContentJson:feed.contentJson feed:feed];
            feed.likeNum = [pack readInt32];
            feed.commentNum = [pack readInt32];
            feed.addressStr = [pack readString];
            [arr addObject:feed];
            [feed synchronize:nil];
        }
    }
    return arr;
}

//举报消息
-(BOOL)handleReportFeed:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
//        NSLog(@"举报成功");
        return YES;
    }
    return NO;
}

//拉取收藏的消息
-(BOOL)handleFetchCollectedFeeds:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        uint32_t count = [pack readInt32];
        for (int i = 0; i < count; i++)
        {
            Feed *feed = [[Feed alloc] init];
            feed.feedId = [pack readInt64];
            feed.contentJson = [pack readString];
            [self handleContentJson:feed.contentJson feed:feed];
            feed.likeNum = [pack readInt32];
            feed.isOwnZanFeed = [pack readInt32];
            feed.commentNum = [pack readInt32];
            feed.addressStr = [pack readString];
            [feed synchronize:@"FEEDCOLLECT"];
        }
        return YES;
    }
    return NO;
}

//移除消息
-(BOOL)handleDeleteFeedInMainView:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
//        NSLog(@"移除消息成功");
        return YES;
    }
    return NO;

}
//拉取引导问题
-(BOOL)handleFetchGuideQuestion:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        uint64_t preMessageId = [pack readInt64];
        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithUnsignedLongLong:preMessageId] withKey:QuestionFeedLastMessageId];
        uint32_t num = [pack readInt32];
        for (int i = 0; i < num; i++)
        {
            Feed *feed = [[Feed alloc] init];
            feed.feedId = [pack readInt64];
            NSString *content = [pack readString];
            [self handleContentJson:content feed:feed];
            [feed synchronize:@"QUESTIONFEED"];
        }
        return YES;
    }
    return NO;
}
//拉取用户朋友数
-(uint32_t)handleFetchNumberOfFriends:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
        
        uint32_t num = [pack readInt32];
        return num;
    }
    return -1;
}
//意见反馈
-(BOOL)handleSuggestForUs:(Package *)pack withErrorCode:(CheckErrorCode)code
{
    [pack reset];
    uint32_t result = [pack readInt32];
    if ([[LogicManager sharedInstance] handleSocketResult:result withErrorCode:code])
    {
//        NSLog(@"意见反馈成功");
        return YES;
    }
    return NO;
}



#pragma mark - handleJson
-(void)handleContentJson:(NSString *)jsonStr feed:(Feed *)feed
{
    if (jsonStr != nil && jsonStr.length > 0)
    {
        NSDictionary *dict = [[LogicManager sharedInstance] jsonStringTOObject:jsonStr];
        feed.contentStr = [dict objectForKey:@"content"];
        NSString *netImageStr = [dict objectForKey:@"img"];
        
        NSRange range = [netImageStr rangeOfString:@"http"];
        if (range.location == NSNotFound)
        {
            
            NSArray *arr = [netImageStr componentsSeparatedByString:@":"];
            
            feed.imageStr = [NSString stringWithFormat:@"img_secretCell_background_%d",[[arr lastObject] intValue]];
        }
        else
        {
            feed.imageStr = netImageStr;
        }
    }
}

@end
