//
//  LogicManager.h
//  UnNamed
//
//  Created by yohunl on 13-8-15.
//  Copyright (c) 2013年 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageEditorViewController.h"
#import <WeiboSDK.h>
#import "WXApi.h"
#import "Package.h"
//#import <LIALinkedInHttpClient.h>
//#import <LIALinkedInApplication.h>
#import "Common.h"
#import <CommonCrypto/CommonCrypto.h>
@class MessageData;
@interface LogicManager : NSObject<CLLocationManagerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,WeiboSDKDelegate,WBHttpRequestDelegate,WXApiDelegate>
{
    //PhoneBook
    NSMutableArray* phoneObjectArray;
    NSMutableArray* phoneDicArray;
    //linkedin
//    LIALinkedInHttpClient *linkedinManager;
    CLLocationManager* locationManager;
    int homeTimeLinePage;
    EventCallBack locationCallBack;
    EventCallBack weiboLoginCallBack;
    EventCallBack commentCallBack;
    EventCallBack homeTimelineCallBack;
    
    
    //Image Piker
    UIImagePickerController* imagePicker;
    UIViewController* hostViewController;
    ImageEditorViewController *imageEditor;
    ALAssetsLibrary *library;
    EventCallBack imagePikerCallBack;
}
-(NSString*)objectToJsonString:(id)object;
-(id)jsonStringToObject:(NSString*)value;
-(CGSize)calculateCGSizeWith:(NSString *)text
                      height:(float)height
                       width:(float)width
                        font:(UIFont *)font;


-(void)setRootViewContrllerWithNavigationBar:(UIViewController*)controller;
-(void)setRootViewContrller:(UIViewController*)controller;
-(id)getSharedDataWithKey:(id)key;
-(void)setSharedData:(id)object withKey:(id)key;
- (BOOL) validateEmail:(NSString *)email;
@property(nonatomic,assign)BOOL enableChatViewRefresh;//聊天窗口刷新时 长按时间会失控
//处理链接
-(BOOL)handleRequest:(NSURLRequest*)request callBack:(EventCallBack)callBack;
//处理网络包数据
-(void)handlePackage:(Package *)pack block:(EventCallBack)block;

-(void)setPersistenceData:(id)object withKey:(id)key;
-(id)getPersistenceDataWithKey:(id)key;
-(NSString*)getPersistenceStringWithKey:(id)key;
-(int)getPersistenceIntegerWithKey:(id)key;
-(double)getPersistenceDoubleWithKey:(id)key;
-(float)getPersistenceFloatWithKey:(id)key;
-(uint64_t)getPersistenceUint64WithKey:(id)key;
//判断这个id是否是我的朋友
-(BOOL)isMyFriend:(int)userId;
//判断是不是在app里
//-(BOOL)isInApp:(UserInfo*)userInfo;
-(void)makeUserReLoginAuto;
-(void)logoutInformationshouldHanlde;

//获取通讯录好友
-(void)getContactFriends:(EventCallBack)call;
- (NSData*) base64Decode:(NSString *)string;
- (NSString*) base64Encode:(NSData *)data;
-(BOOL)isMobileNumber:(NSString*)mobileNum;
-(BOOL)checkPassword:(NSString *)pwd;
-(NSString *)encodePasswordWithsha1:(NSString *)password;
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message actionText:(NSString*)actinText;
-(NSString *)encodePasswordWithMD5:(NSString*)password;
-(void)queryLocation:(EventCallBack)callBack;

#pragma --mark 微博
-(void)weiBoLogin:(EventCallBack)block;
//登出微博
- (void)weiBoLogout;
//发微博
//-(void)sendWeiBo:(NSString *)content;
-(void)sendWeiBoWithTitle:(NSString *)title
           desribe:(NSString *)describe
           image:(UIImage *)image
              contentCode:(int)code
                   feedId:(uint64_t)feedId;

//linkedin
//- (LIALinkedInHttpClient *)linkedinManager;
//-(UIView*)getTagView:(UserInfo*)userInfo;

#pragma mark - 微信分享
-(void)sendWechatWithTitle:(NSString *)title
                  describe:(NSString *)describe
                  identify:(NSString *)identify
                     image:(UIImage *)image
                     scene:(int)scene
               contentCode:(int)code
                    feedId:(uint64_t)feedId;

+ (LogicManager*)sharedInstance;
@end
