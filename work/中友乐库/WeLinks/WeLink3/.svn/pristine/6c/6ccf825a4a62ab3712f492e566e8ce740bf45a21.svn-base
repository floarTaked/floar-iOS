//
//  MessageData.h
//  Welinked2
//
//  Created by jonas on 12/17/13.
//
//

#import "NSObjectExtention.h"
#import "NetworkEngine.h"
#import "NSObjectExtention.h"
#import "Common.h"

#define MessageWidth 200
typedef enum
{
    SnapMessage,
    TextMesage,
    TipMessage,
    PostRecommendedMessage,//求内推
    ForwardingPostMessage,//求推荐二度好友
    PostMessage,//招聘人才
}MessageType;
typedef enum
{
    EVENT_SCROLL,
    EVENT_LOADMORE,
    EVENT_TOUCH,
    EVENT_RESEND,
    EVENT_PRIFILE,
    EVENT_TAPCONTENT
}Event;
@class MessageData;
@protocol MessageAdapterProtocol<NSObject>
@property(nonatomic,strong)MessageData* data;
-(void)fillCell:(UITableViewCell*)cell;
-(float)getHeight;

@optional
-(void)setCallBack:(EventCallBack)callback;
@end

@interface MessageData : NSObjectExtention
{
    id<MessageAdapterProtocol> adapter;
}
@property(nonatomic,strong)NSString* DBUid;
@property(nonatomic,strong)NSString* text;
@property(nonatomic,assign)NSTimeInterval createTime;
@property(nonatomic,assign)int identity;
@property(nonatomic,assign)int isSender;//0发送 1 接收 2发送中 3 发送失败
@property(nonatomic,assign)MessageType msgType;//1=普通文本 2=通知消息 3=求内推 4=推荐职位 5=求推荐二度好友
@property(nonatomic,strong)NSString* otherAvatar;
@property(nonatomic,strong)NSString* otherName;
@property(nonatomic,strong)NSString* otherUserId;
@property(nonatomic,assign)int status;//0未读 1 已读
@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSString* contentString;
@property(nonatomic,strong)NSDictionary* extraData;


-(void)setCallBack:(EventCallBack)callback;
-(id<MessageAdapterProtocol>)getAdapter;
@end
