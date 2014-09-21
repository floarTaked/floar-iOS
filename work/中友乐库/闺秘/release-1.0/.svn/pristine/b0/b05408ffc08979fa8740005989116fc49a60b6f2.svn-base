//
//  Common.h
//  ChatView
//
//  Created by jonas on 12/5/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//com.WeLinked.${PRODUCT_NAME:rfc1034identifier}

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EGOImageButton.h>
#import "EGOImageView(Extension).h"
#import "UINavigationItemCustom.h"
#import "CustomCellView.h"
#import <MBProgressHUD.h>
#define NAVBARCOLOR 0x2485ED
#define DeepRedColor 0xD0246C
#define lightRedColor 0xF88BB5
#define CustomGrayColor 0xD21E66
#define USERID @"USERID"

//sina
#define kAppKey         @"3547924220"
#define kWeiboRedirectURL    @"http://api.weibo.com/oauth2/default.html"
#define kWeiboToken     @"weibotoken"
#define kWeiboUid       @"kWeiboUid"
#define kExpirationDate @"expirationDate"


#define SERVERROOTURL @"http://10.10.151.248:8082/api/"
#define IMAGESERVER @"http://121.14.197.30"
#define DOWNLOADIMAGE @"http://121.14.197.30"
//#define SERVERROOTURL @"http://121.14.197.30:8085/api/"
//#define TCPSERVERIP @"10.10.151.238"
//#define TCPSERVERPORT 9998

#define TCPSERVERIP @"121.14.197.30"
#define TCPSERVERPORT 12010

#define APPVERSION @"1.0"
#define NavBarColor 0x5B9FEB
#define ALPHA @"+ABCDEFGHIJKLMNOPQRSTUVWXYZ###"
#define ALPHALEN 27
#define APPID @"834856698"
#define NewFriendsNotification @"NewFriendsNotification"
//无图浏览
#define WITHOUTIMAGE @"WithoutImage"
//推送信息
#define PUSHNOTIFICATION @"PushNotification"  //0推送  1 不推送

#define ServerOK @"ServerOk"
#define NearByFeeds @"NearByFeeds"
#define isOwnLike @"isOwnLike"
#define isOwnComment @"isOwnComment"
#define MyPublishedJob @"MyPublishedJob"
#define MyRecommendJob @"MyRecommendJob"
#define AllFriendsTable  @"AllFriendsTable"
#define MyFriendsTable  @"MyFriendsTable"
#define VisitorFriends @"VisitorFriends"
#define FirstDegreeFriend @"FirstDegreeFriend"//一度好友
#define WeiBoFriend @"WeiBoFriend"//在app里的一度好友

#define SecondDegreeFrendTable @"SecondDegreeFrendTable"
#define NewFriendTable @"NewFriendTable"
#define EnableContacts   @"EnableContacts"

#define kDidSelectJobTitle @"kDidSelectJobTitle"

#define FirstInstall @"FirstInstall"
#define SecretBGImageName @"img_secretCell_background_"

#define FeedLastMessageId @"FeedLastMessageId"
#define QuestionFeedLastMessageId @"QuestionFeedLastMessageId"
#define FirstFeedFetch @"FirstFeedFetch"
#define FirstQuestionFeedFetch @"FirstQuestionFeedFetch"

#define GET_IMAGE(__NAME__,__TYPE__) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:__NAME__ ofType:__TYPE__]]

#define PROJECTID 0x01
//#define SendBlcokPrococalNum 50

typedef enum
{
    UserBasicInfoSubSys = 0x01,
    UserMessageSubsys = 0x02,
    IndentifySubsys = 0x03,
    SensitiveWordSubsys = 0x04,
    FAQSubSys = 0x05,
    SystemOperSubsys = 0x06,
    AddressManagerSubsys = 0x07
}SubSystem;

typedef enum
{
    SendIdentifyCode = 0x01,
    CheckIdentifyCode = 0x02,
    OldUserLoginCode = 0x03,
    MainViewSecretContentCode = 0x04,
    PublishSecretCode = 0x05,
    SupportFeedCode = 0x06,
    CancleSupportFeedCode = 0x07,
    SupportCommentCode = 0x08,
    CancleSupportCommentCode = 0x09,
    CommentFeedCode = 0x0a,
    FeedDetailCode = 0x0b,
    ChangePasswordCode = 0x0c,
    CollectFeedCode = 0x0d,
    CanlceCollectFeedCode = 0x0e,
    ReportFeedCode = 0x0f,
    FetchCollectedFeedsCode = 0x10,
    DeleteFeedInMainViewCode = 0x11,
    FetchGuideQuestionCode = 0x12,
    FetchNumberOfFriendsCode = 0x13,
    SuggestionsForUsCode = 0x14,
    UpdatePhoneBookCode = 0x15
}UniqueCode;

typedef enum
{
    NoCheckErrorCode = 0,
    IdentifyCodeCheckError = 0x01,
    PasswordCheckError = 0x02
}CheckErrorCode;

@interface Common : NSObject
typedef enum
{
    Stranger,//陌生人
    RequestSended,//已发送加好友请求
    Friends,//已是好友
} RelationState;

typedef void (^EventCallBack)(int event,id object);

void runOnMainQueueWithoutDeadlocking(void (^block)(void));
void runOnAsynQueue(void (^block)(void));
UIFont* getFontWith(BOOL bold,int size);
UIColor* colorWithHex(int value);
NSString* getIdentityKey(NSString* key);

NSTimeInterval getDateTimeIntervalWithYearMonth(int year,int month);
NSTimeInterval getDateTimeIntervalWithYearMonthDay(int year,int month,int day);
NSString* formatDateMonth(NSDate* dateTime);
NSString* formatDateShort(NSDate* dateTime);
NSString* formatDateWith(NSDate* dateTime,BOOL word);
NSString* formatDate(NSDate* dateTime);

+ (void)setNavigationBarWMStyle;
+(NSString *)timeIntervalStringFromTime:(NSTimeInterval)timeInterval;

//float getMargin();
BOOL isSystemVersionIOS7();
@end
@interface UILabel(Flexible)
-(UILabel*)FlexibleWidthWith:(NSString*)text height:(float)height;
-(UILabel*)FlexibleHeightWith:(NSString*)text width:(float)width;
+(float)calculateHeightWith:(NSString*)text font:(UIFont*)font width:(float)width lineBreakeMode:(NSLineBreakMode)mode;
+(float)calculateWidthWith:(NSString*)text font:(UIFont*)font height:(float)height lineBreakeMode:(NSLineBreakMode)mode;
+(CGSize)calculateCGSizeWith:(NSString *)text
                      height:(float)height
                       width:(float)width
                        font:(UIFont *)font;
@end

@interface UIImage (Resize)
-(UIImage*)resizeWithSize:(CGSize)targetSize;
@end

@interface UIImageView (AnimationBetweenLeftAndRight)

-(void)AnimationLeftAndRight:(int)originalX;

@end


@interface UIView (Animate)
-(void)beginRotate:(CGFloat)duration block:(EventCallBack)block;
-(void)endRotate:(CGFloat)duration block:(EventCallBack)block;
@end
@interface NSString (URL)
- (NSString *)URLEncodedString;
- (NSString*)URLDecodedString;
- (BOOL)startWithHTTP;
@end

@interface UIView (Feed)

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;

@property (nonatomic, retain) id userObject;

@end


CGFloat DegreesToRadians(CGFloat degrees);
CGFloat RadiansToDegrees(CGFloat radians);
@interface UIImage (Rotate)
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
@end;
@interface MBProgressHUD (Extension)
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay complete:(MBProgressHUDCompletionBlock)complete;
@end

@interface NSString (Extension)
-(NSString*)cleanup:(NSArray*)arr;
@end