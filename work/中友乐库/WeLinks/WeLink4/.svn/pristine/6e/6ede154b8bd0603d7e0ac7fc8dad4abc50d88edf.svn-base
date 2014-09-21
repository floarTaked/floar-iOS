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
#import "LogicManager.h"
#define MessageWidth 200
//1=普通文本 2通知消息 3=阅后即焚消息 4=定时删除消息
typedef enum
{
    SnapMessage,
    TextMesage,
    TipMessage,
    DeleteMessage,
    TimerDeleteMessage,
    ImageMessage
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
//"content":"{\"text\":\"我已经同意添加你为联系人，现在可以开始对话了\"}",
//"createTime":1399516094000,
//"receiveTime"：1399517019000,
//"storeSecond"：600
//"id":21326,
//"isSender":1,
//"msgType":2,
//"otherAvatar":"http://photo.leku.com/e/lekumobile/8555/160x160/201405-84f44992_8913_48d7_8417_9dbe08caa044.jpg",
//"otherName":"测试1222&",
//"otherUserId":658455,
//"status":0,
//"userId":265958，
//"job":经理,
//"company":乐酷
@property(nonatomic,assign)int DBUid;
@property(nonatomic,strong)NSString* contentString;
@property(nonatomic,strong)NSString* text;
@property(nonatomic,assign)NSTimeInterval createTime;
@property(nonatomic,assign)NSTimeInterval receiveTime;
@property(nonatomic,assign)int storeSecond;
@property(nonatomic,assign)int identity;
@property(nonatomic,assign)int isSender;//1=是发送者 0=是接收者 2发送中 3 发送失败
@property(nonatomic,assign)MessageType msgType;//1=普通文本 2=通知消息 3=阅后即焚消息,4=定时删除,5=好友请求,
@property(nonatomic,strong)NSString* otherAvatar;
@property(nonatomic,strong)NSString* otherName;
@property(nonatomic,assign)int otherUserId;
@property(nonatomic,assign)int status;//0未读 1 已读 2=已删除
@property(nonatomic,assign)int userId;
@property(nonatomic,strong)NSString* job;
@property(nonatomic,strong)NSString* company;
@property(nonatomic,strong)NSDictionary* extraData;


-(void)setCallBack:(EventCallBack)callback;
-(id<MessageAdapterProtocol>)getAdapter;
@end
