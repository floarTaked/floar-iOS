//
//  LogicManager.h
//  UnNamed
//
//  Created by yohunl on 13-8-15.
//  Copyright (c) 2013年 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageEditorViewController.h"
//#import <LIALinkedInHttpClient.h>
//#import <LIALinkedInApplication.h>
#import "Common.h"
#import "ProfileInfo.h"
#import "CustomPickerView.h"
@class MessageData;
@interface LogicManager : NSObject<CLLocationManagerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
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
-(id)getPublicObject:(NSString*)code type:(PickerType)type;
-(NSString*)getEducation:(int)education;
-(NSString*)getJobYear:(int)index;
-(NSString*)getJobLevel:(int)level;
-(NSString*)getSalary:(int)level;

-(NSString*)getSalaryK:(int)level;
-(NSString*)objectToJsonString:(id)object;
-(id)jsonStringTOObject:(NSString*)value;

-(void)setRootViewContrllerWithNavigationBar:(UIViewController*)controller;
-(void)setRootViewContrller:(UIViewController*)controller;
-(id)getSharedDataWithKey:(id)key;
-(void)setSharedData:(id)object withKey:(id)key;
- (BOOL) validateEmail:(NSString *)email;
@property(nonatomic,assign)BOOL enableChatViewRefresh;//聊天窗口刷新时 长按时间会失控
//处理链接
-(BOOL)handleRequest:(NSURLRequest*)request callBack:(EventCallBack)callBack;
//消息处理
-(int)getUnReadMessageCountWithOtherUser:(int)userId;
-(void)setPersistenceData:(id)object withKey:(id)key;
-(id)getPersistenceDataWithKey:(id)key;
-(NSString*)getPersistenceStringWithKey:(id)key;
-(int)getPersistenceIntegerWithKey:(id)key;
-(double)getPersistenceDoubleWithKey:(id)key;
-(float)getPersistenceFloatWithKey:(id)key;
//判断这个id是否是我的朋友
-(BOOL)isMyFriend:(int)userId;
//判断是不是在app里
-(BOOL)isInApp:(UserInfo*)userInfo;

//获取通讯录好友
-(void)getContactFriends:(EventCallBack)call;
- (NSData*) base64Decode:(NSString *)string;
- (NSString*) base64Encode:(NSData *)data;
-(BOOL)isMobileNumber:(NSString*)mobileNum;
-(BOOL)checkPassword:(NSString *)pwd;
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message actionText:(NSString*)actinText;
-(NSString *)encodePasswordWithMD5:(NSString*)password;
-(void)queryLocation:(EventCallBack)callBack;
//-(void)upgradeDataBase;
-(void)gotoProfile:(UIViewController*)controller userId:(int)userId showBackButton:(BOOL)back;
-(void)gotoProfile:(UIViewController*)controller userId:(int)userId;
//好友关系状态
-(RelationState)getRelationState:(int)userId;
-(void)setRelationSatte:(int)userId state:(RelationState)state;
//linkedin
//- (LIALinkedInHttpClient *)linkedinManager;
-(UIView*)getTagView:(UserInfo*)userInfo;
+ (LogicManager*)sharedInstance;
@end
