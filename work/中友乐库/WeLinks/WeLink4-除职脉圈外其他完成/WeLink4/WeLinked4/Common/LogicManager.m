//
//  LogicManager.m
//  UnNamed
//
//  Created by yohunl on 13-8-15.
//  Copyright (c) 2013年 jonas. All rights reserved.
//

#import "LogicManager.h"
#import "MessageData.h"
#import "DataBaseManager.h"
#import "NetworkEngine.h"
#import "AppDelegate.h"
#import "PhoneBookInfo.h"
#import "MessageData.h"
#import "Common.h"
#import "MineProfileViewController.h"
#import "OtherProfileViewController.h"
#import "PublicObject.h"
#define REQUESTCODETOKEN @"RequestCodeToken"
#define TOKEN          @"token"

@implementation LogicManager
-(id)init
{
    self = [super init];
    if(self)
    {
        self.enableChatViewRefresh = YES;
    }
    return self;
}
-(id)getPublicObject:(NSString*)code type:(PickerType)type
{
    if(code == nil)
    {
        return nil;
    }
    id result = nil;
//    if(type == Job)
//    {
//        NSArray* arr = [[PublicDataBaseManager sharedInstance] queryWithClass:[JobObject class]
//                                                                    tableName:@"Job"
//                                                                    condition:[NSString stringWithFormat:@" where code='%@' ",code]];
//        if(arr != nil && [arr count]>0)
//        {
//            result = [arr objectAtIndex:0];
//        }
//    }
//    else
    if (type == Industry)
    {
        NSArray* arr = [[PublicDataBaseManager sharedInstance] queryWithClass:[IndustryObject class]
                                                                    tableName:@"Industry"
                                                                    condition:[NSString stringWithFormat:@" where code='%@' ",code]];
        if(arr != nil && [arr count]>0)
        {
            result = [arr objectAtIndex:0];
        }
    }
    else if (type == City)
    {
        NSArray* arr = [[PublicDataBaseManager sharedInstance] queryWithClass:[CityObject class]
                                                                    tableName:@"City"
                                                                    condition:[NSString stringWithFormat:@" where code='%@' ",code]];
        if(arr != nil && [arr count]>0)
        {
            result = [arr objectAtIndex:0];
        }
    }
    return result;
}
-(NSString*)getSalaryK:(int)level
{
    //1 4000以下
    //2 4000-6000
    //3 6000-8000
    //4 8000-10000
    //5 10000-15000
    //6 15000-25000
    //7 25000-50000
    //8 50000以上
    
    if(level == 1)
    {
        return @"4K以下";
    }
    else if (level == 2)
    {
        return @"4K-6K";
    }
    else if (level == 3)
    {
        return @"6K-8K";
    }
    else if (level == 4)
    {
        return @"8K-10K";
    }
    else if (level == 5)
    {
        return @"10K-15K";
    }
    else if (level == 6)
    {
        return @"15K-25K";
    }
    else if (level == 7)
    {
        return @"25K-50K";
    }
    else if (level == 8)
    {
        return @"50K以上";
    }
    return @"";
}
-(NSString*)getSalary:(int)level
{
    //1 4000以下
    //2 4000-6000
    //3 6000-8000
    //4 8000-10000
    //5 10000-15000
    //6 15000-25000
    //7 25000-50000
    //8 50000以上
    if(level == 0)
    {
        return @"面议";
    }
    else if(level == 1)
    {
        return @"4000以下";
    }
    else if (level == 2)
    {
        return @"4000-6000";
    }
    else if (level == 3)
    {
        return @"6000-8000";
    }
    else if (level == 4)
    {
        return @"8000-10000";
    }
    else if (level == 5)
    {
        return @"10000-15000";
    }
    else if (level == 6)
    {
        return @"15000-25000";
    }
    else if (level == 7)
    {
        return @"25000-50000";
    }
    else if (level == 8)
    {
        return @"50000以上";
    }
    return @"";
}
-(NSString*)getJobLevel:(int)level
{
    //1 实习
    //2 初级
    //3 高级
    //4 资深
    //5 主管/经理
    //6 总监/部门负责人
    //7 总裁/副总裁
    if(level == 1)
    {
        return @"实习";
    }
    else if (level == 2)
    {
        return @"初级";
    }
    else if (level == 3)
    {
        return @"高级";
    }
    else if (level == 4)
    {
        return @"资深";
    }
    else if (level == 5)
    {
        return @"主管/经理";
    }
    else if (level == 6)
    {
        return @"总监/部门负责人";
    }
    else if (level == 7)
    {
        return @"总裁/副总裁";
    }
    return @"";
}
-(NSString*)getEducation:(int)education
{
    //1=大专及以下 2=本科 3=硕士 4=博士及以上
    if(education == 1)
    {
        return @"大专及以下";
    }
    else if (education == 2)
    {
        return @"本科";
    }
    else if (education == 3)
    {
        return @"硕士";
    }
    else if (education == 4)
    {
        return @"博士及以上";
    }
    return @"";
}
-(NSString*)getJobYear:(int)index
{
    //    1年以内
    //    1-3年
    //    3-5年
    //    5-10年
    //    10年以上
    if(index == 1)
    {
        return @"1年以内";
    }
    else if (index == 2)
    {
        return @"1-3年";
    }
    else if (index == 3)
    {
        return @"3-5年";
    }
    else if (index == 4)
    {
        return @"5-10年";
    }
    else if (index == 5)
    {
        return @"10年以上";
    }
    return @"";
}
-(id)jsonStringTOObject:(NSString*)value
{
    if(value == nil)
    {
        return nil;
    }
    NSString *postsFromResponse = value;
    NSError* error = nil;
    id data =[NSJSONSerialization JSONObjectWithData:[postsFromResponse dataUsingEncoding:NSUTF8StringEncoding]
                                          options:NSJSONReadingMutableLeaves error:&error];
    if(error != nil)
    {
        data = nil;
        NSLog(@"jsonString to Object error:%@",error);
    }
    return data;
}
-(NSString*)objectToJsonString:(id)object
{
    NSString *json = nil;
    
    if ([NSJSONSerialization isValidJSONObject:object])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if(jsonData != nil)
        {
            json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    else
    {
        NSDictionary* dic = [object serialization];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        if(jsonData != nil)
        {
            json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return json;
}
-(void)setRootViewContrllerWithNavigationBar:(UIViewController*)controller
{
    if(controller == nil)
    {
        return;
    }
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
    //    [navController setNavigationBarHidden:YES];
    [Common setNavigationBarWMStyle];
    AppDelegate* del = (AppDelegate*)([UIApplication sharedApplication].delegate);
    del.window.rootViewController = navController;
    del.window.backgroundColor = [UIColor clearColor];
    //    navController.view.backgroundColor = [UIColor clearColor];
}
-(void)setRootViewContrller:(UIViewController*)controller
{
    if(controller == nil)
    {
        return;
    }
//    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
//    [navController setNavigationBarHidden:YES];
    [Common setNavigationBarWMStyle];
    AppDelegate* del = (AppDelegate*)([UIApplication sharedApplication].delegate);
    del.window.rootViewController = controller;
    del.window.backgroundColor = [UIColor clearColor];
//    navController.view.backgroundColor = [UIColor clearColor];
}
//处理链接
-(BOOL)handleRequest:(NSURLRequest*)request callBack:(EventCallBack)callBack
{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"json"])
    {
        NSString* json = [requestString stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        json = [json URLDecodedString];
        NSDictionary* dic = nil;
        NSError* error = nil;
        dic =[NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                             options:NSJSONReadingMutableLeaves error:&error];
        if(error != nil)
        {
            dic = nil;
        }
        if(dic != nil)
        {
            int event = [[dic objectForKey:@"event"] intValue];
            id data = [dic objectForKey:@"data"];
            
            double delayInSeconds = 0.3f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
            {
                if(callBack)
                {
                    callBack(event,data);
                }
            });
        }

        return NO;
    }
    else
    {
        NSString* host =  [[request URL] host];
        if(host != nil /*&& !*/)
        {
            if([host isEqualToString:@"bigapp.leku.com"])
            {
                //举报
                if(callBack)
                {
                    callBack(-2,nil);
                }
            }
            else
            {
                
                //阅读原文
                if(callBack)
                {
                    callBack(-1,nil);
                }

            }
            return NO;
        }
    }

    return YES;
}

-(id)getSharedDataWithKey:(id)key
{
    NSMutableDictionary* dic = [self getSharedDictionary];
    if(dic != nil)
    {
        return [dic objectForKey:key];
    }
    return nil;
}
-(void)setSharedData:(id)object withKey:(id)key
{
    NSMutableDictionary* dic = [self getSharedDictionary];
    if(dic != nil && object != nil)
    {
        [dic setObject:object forKey:key];
    }
}
-(NSMutableDictionary*)getSharedDictionary
{
    static NSMutableDictionary* dic = nil;
    if(dic == nil)
    {
        dic = [[NSMutableDictionary alloc]init];
    }
    return dic;
}

- (NSData*) base64Decode:(NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil) {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true) {
        if (ixtext >= lentext){
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true;
        }
        
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                } else {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4) {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak) {
                break;
            }
        }
    }
    
    return theData;
}

- (NSString*) base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    int length = (int)[data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }     
    return result;
}

- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma --mark PersistenceData
-(NSString*)getPersistenceStringWithKey:(id)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* object = [defaults stringForKey:key];
    return object;
}
-(int)getPersistenceIntegerWithKey:(id)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int object = (int)[defaults integerForKey:key];
    return object;
}
-(double)getPersistenceDoubleWithKey:(id)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    double object = [defaults doubleForKey:key];
    return object;
}
-(float)getPersistenceFloatWithKey:(id)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    float object = [defaults floatForKey:key];
    return object;
}

-(void)setPersistenceData:(id)object withKey:(id)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}
-(id)getPersistenceDataWithKey:(id)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    id object = [defaults objectForKey:key];
    return object;
}
//消息处理
-(int)getUnReadMessageCountWithOtherUser:(int)userId
{
    NSString* sql = @"";
    if(userId > 0)
    {
        sql = [NSString stringWithFormat:@" where userId=%d and otherUserId=%d and status=0 ",
               [UserInfo myselfInstance].userId,userId];
    }
    else
    {
        sql = [NSString stringWithFormat:@" where userId=%d and status=0",[UserInfo myselfInstance].userId];
    }
    NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class]
                                                                         tableName:nil
                                                                         condition:sql];
    if(result != nil)
    {
        return (int)[result count];
    }
    return 0;
}
#pragma --mark 其他
#pragma --mark Contact Method
-(BOOL)isMyFriend:(int)userId
{
    NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[UserInfo class] tableName:MyFriendsTable condition:[NSString stringWithFormat:@" where DBUid=%d and userId=%d ",[UserInfo myselfInstance].userId,userId]];
    if(arr != nil && [arr count]>0)
    {
        return YES;
    }
    return NO;
}
//判断是不是在app里
-(BOOL)isInApp:(UserInfo*)userInfo
{
    NSString* phone = userInfo.phone;
    if(phone == nil || [phone length]<=0)
    {
        //不再app里面
        return NO;
    }
    else
    {
        //在app里面
        return YES;
    }
}
-(void)getContactFriends:(EventCallBack)call
{
    if(phoneObjectArray != nil && [phoneObjectArray count]>0)
    {
        call(1,[NSDictionary dictionaryWithObjectsAndKeys:phoneDicArray,@"dic",phoneObjectArray,@"object", nil]);
        return;
    }
    else
    {
        phoneObjectArray = [[NSMutableArray alloc]init];
    }
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0)
    {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        tmpAddressBook =ABAddressBookCreateWithOptions(nil,nil);
    }
    //取得本地所有联系人记录
    
    if (tmpAddressBook==nil)
    {
        if(call)
        {
            //没有权限
            call(-1,nil);
        }
        return;
    };
    NSArray* tmpPeoples = (NSArray*)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(tmpAddressBook));
    
    phoneDicArray = [NSMutableArray arrayWithCapacity:[tmpPeoples count]];
    for(id tmpPerson in tmpPeoples)
    {
         NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        PhoneBookInfo* bookInfo = [[PhoneBookInfo alloc]init];
        
         NSString* fristName = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonFirstNameProperty));
         NSString* lastName = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonLastNameProperty));
//        book.nickName = (NSString*)ABRecordCopyValue(tmpPerson, kABPersonNicknameProperty);
        NSString* name = [NSString stringWithFormat:@"%@%@",lastName==nil?@"":lastName,fristName==nil?@"":fristName];
        [dic setObject:name forKey:@"name"];
        bookInfo.name = name;
//        ABMultiValueRef tmpEmails = ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonEmailProperty);
//        for(NSInteger j = 0; j<ABMultiValueGetCount(tmpEmails); j++)
//        {
//            book.email = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(tmpEmails, j));
//        }
        
        ABMultiValueRef tmpPhones = ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        {
            NSString* phone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(tmpPhones, j));
            if(phone != nil)
            {
                NSMutableString *strippedString = [NSMutableString stringWithCapacity:phone.length];
                NSScanner *scanner = [NSScanner scannerWithString:phone];
                NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"+0123456789"];
                while ([scanner isAtEnd] == NO)
                {
                    NSString *buffer;
                    if([scanner scanCharactersFromSet:numbers intoString:&buffer])
                    {
                        [strippedString appendString:buffer];
                    }
                    else
                    {
                        [scanner setScanLocation:([scanner scanLocation] + 1)];
                    }
                }
                if(strippedString != nil && [strippedString length]>0)
                {
                    [dic setObject:strippedString forKey:@"phone"];
                    bookInfo.phone = strippedString;
                }
            }
        }
//        if(bookInfo.name != nil && [bookInfo.name length]>0 && bookInfo.phone != nil && [bookInfo.phone length]>0)
//        {
//            [bookInfo synchronize:nil];
//        }
        NSString* strippedString = [dic objectForKey:@"phone"];
        if(strippedString != nil && [strippedString length]>0)
        {
            [phoneDicArray addObject:dic];
            [phoneObjectArray addObject:bookInfo];
        }
    }
    if(call)
    {
        call(1,[NSDictionary dictionaryWithObjectsAndKeys:phoneDicArray,@"dic",phoneObjectArray,@"object", nil]);
    }
}
-(BOOL)checkPassword:(NSString *)pwd
{
    if(pwd == nil || [pwd length]<=0)
    {
        return NO;
    }
    NSString *regex = @"^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$";
    NSPredicate *password = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [password evaluateWithObject:pwd];
}
-(BOOL)isMobileNumber:(NSString*)mobileNum
{
    /**
     *手机号码
     13(0-9)
     15(0-9)
     18(0-9)
     */
    NSString*MOBILE=@"^1(3[0-9]|5[0-9]|8[0-9])\\d{8}$";
    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message actionText:(NSString*)actinText
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:actinText
                                         otherButtonTitles:nil, nil];
    [alert show];
}

-(NSString *)encodePasswordWithMD5:(NSString*)password
{
    CC_MD5_CTX ctx;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    unsigned char md[CC_MD5_DIGEST_LENGTH] = {'0'};
    
    // Initalize Context
    CC_MD5_Init(&ctx);
    
    const char *orgMsg = [password UTF8String];
    
    // Set up hashed data
    CC_MD5_Update(&ctx, (const void *)orgMsg, (unsigned int)strlen(orgMsg));
    
    // Places the MD2 message digest in md
    CC_MD5_Final(md, &ctx);
    
    CC_MD5(orgMsg, (unsigned int)strlen(orgMsg), result);
    NSMutableString *encodedStr = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [encodedStr appendFormat:@"%02X", result[i]];
    return [encodedStr lowercaseString];
}
#pragma --marl 获取经纬度
-(void)queryLocation:(EventCallBack)callBack
{
    locationCallBack = callBack;
    if(locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        locationManager.distanceFilter = 1000;
    }
    [locationManager startUpdatingLocation];
}
// 代理方法实现
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:
     ^(NSArray* placemarks, NSError* error)
    {
        if(error == nil)
        {
            if (placemarks != nil && [placemarks count] > 0)
            {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                //            NSString *country = placemark.ISOcountryCode;
                NSString *city = placemark.locality;
                //            NSLog(@"===city:%@,country:%@",city,country);
                if(locationCallBack != nil)
                {
                    locationCallBack(1,city);
                }
            }
        }
        else
        {
            if(locationCallBack != nil)
            {
                locationCallBack(0,error);
            }
        }
    }];
    [locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
    NSLog(@"%@",error);
    if(locationCallBack != nil)
    {
        locationCallBack(0,error);
    }
}
-(void)gotoProfile:(UIViewController*)controller userId:(int)userId showBackButton:(BOOL)back
{
    if(controller !=nil && userId > 0 )
    {
        if(userId == [UserInfo myselfInstance].userId)
        {
            MineProfileViewController* mine = [[MineProfileViewController alloc]initWithNibName:@"MineProfileViewController" bundle:nil];
            
            if(back && [mine respondsToSelector:@selector(showBackButton)])
            {
                [mine showBackButton];
            }
            [controller.navigationController pushViewController:mine animated:YES];
        }
        else
        {
            OtherProfileViewController* other = [[OtherProfileViewController alloc]initWithNibName:@"OtherProfileViewController" bundle:nil];
            other.userId = userId;
            [controller.navigationController pushViewController:other animated:YES];
        }
        
    }
}
-(void)gotoProfile:(UIViewController*)controller userId:(int)userId
{
    [[LogicManager sharedInstance] gotoProfile:controller userId:userId showBackButton:NO];
}
//好友关系状态
-(RelationState)getRelationState:(int)userId
{
    NSMutableDictionary* dic = [[LogicManager sharedInstance] getSharedDictionary];
    NSMutableDictionary* relationState = [dic objectForKey:@"relationState"];
    if(relationState == nil)
    {
        relationState = [[NSMutableDictionary alloc]init];
        [dic setObject:relationState forKey:@"relationState"];
    }
    if(userId <=0)
    {
        return Stranger;
    }
    if([[LogicManager sharedInstance] isMyFriend:userId])
    {
        return Friends;
    }
    NSNumber* state = [relationState objectForKey:[NSNumber numberWithInt:userId]];
    if(state != nil)
    {
        return (RelationState)[state intValue];
    }
    else
    {
        return Stranger;
    }
}
-(void)setRelationSatte:(int)userId state:(RelationState)state
{
    NSMutableDictionary* dic = [[LogicManager sharedInstance] getSharedDictionary];
    NSMutableDictionary* relationState = [dic objectForKey:@"relationState"];
    if(relationState == nil)
    {
        relationState = [[NSMutableDictionary alloc]init];
        [dic setObject:relationState forKey:@"relationState"];
    }
    if(userId <= 0)
    {
        return;
    }
    [relationState setObject:[NSNumber numberWithInt:state] forKey:[NSNumber numberWithInt:userId]];
}
#pragma --mark 微博
//#pragma --mark Linkedin
//- (LIALinkedInHttpClient *)linkedinManager
//{
//    if(linkedinManager == nil)
//    {
//        LIALinkedInApplication* application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.ancientprogramming.com/liaexample"
//                                                                                        clientId:LINKEDIN_CLIENT_ID
//                                                                                    clientSecret:LINKEDIN_CLIENT_SECRET
//                                                                                           state:@"DCEEFWF45453sdffef424"
//                                                                                   grantedAccess:@[@"r_fullprofile", @"r_network"]];
//        linkedinManager = [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
//    }
//    return linkedinManager;
//}
-(UIView*)getTagView:(UserInfo*)userInfo
{
    float HEIGHT = 23;
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, HEIGHT)];
    float width = 10;
    float height = 16;
    CGRect frame = v.frame;
    NSArray* strings = nil;
    if(userInfo.tags != nil && [userInfo.tags length]>0)
    {
        strings = [userInfo.tags componentsSeparatedByString:@","];
    }
    for(NSString* s in strings)
    {
        if(s == nil || [s length]<=0)
        {
            continue;
        }
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, HEIGHT)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = getFontWith(NO, 11);
        label.backgroundColor = colorWithHex(0x2485ED);
        label.textColor = [UIColor whiteColor];
        label = [label FlexibleWidthWith:s height:HEIGHT];
        CGRect labelFrame = label.frame;
        labelFrame.size.width += 10;
        labelFrame.size.height = HEIGHT;
        label.frame = labelFrame;
        
        if(width + label.frame.size.width > frame.size.width-10)
        {
            frame.size.height += HEIGHT+5;
            width = 10 + label.frame.size.width/2;
            height += HEIGHT+5;
            label.center = CGPointMake(width, height);
            width += label.frame.size.width/2+10;
        }
        else
        {
            width += label.frame.size.width/2;
            label.center = CGPointMake(width, height);
            width += label.frame.size.width/2 + 10;
        }
        [v addSubview:label];
    }
    frame.size.height += 10;
    v.frame = frame;
    return v;
}
#pragma --mark 单例
+(LogicManager*)sharedInstance
{
    static LogicManager* m_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_instance = [[[self class] alloc]init];
    });
    return m_instance;
}

@end
