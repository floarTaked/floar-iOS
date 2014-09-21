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
#import "WeiboRelationInfo.h"
#import "MessageData.h"
#import "Common.h"
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
    id result = nil;
    if(type == Job)
    {
        NSArray* arr = [[PublicDataBaseManager sharedInstance] queryWithClass:[JobObject class]
                                                                    tableName:@"Job"
                                                                    condition:[NSString stringWithFormat:@" where code='%@' ",code]];
        if(arr != nil && [arr count]>0)
        {
            result = [arr objectAtIndex:0];
        }
    }
    else if (type == Industry)
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
    int length = [data length];
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
    int object = [defaults integerForKey:key];
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
-(int)getUnReadMessageCountWithOtherUser:(NSString*)userId
{
    NSString* sql = @"";
    if(userId != nil && [userId length]>0)
    {
        sql = [NSString stringWithFormat:@" where userId='%@' and otherUserId='%@' and status=0 ",
               [UserInfo myselfInstance].userId,userId];
    }
    else
    {
        sql = [NSString stringWithFormat:@" where userId='%@' and status=0",[UserInfo myselfInstance].userId];
    }
    NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class]
                                                                         tableName:nil
                                                                         condition:sql];
    if(result != nil)
    {
        return [result count];
    }
    return 0;
}
//获取行业图片
-(NSString*)getIndustryImage:(NSString*)industryId
{
    IndustryObject *industry = [[LogicManager sharedInstance] getPublicObject:industryId type:Industry];
    NSString* image = [NSString stringWithFormat:@"img_industry_%@",industry.parentCode];
    return image;
}
#pragma --mark 其他
#pragma --mark Contact Method
-(BOOL)isMyFriend:(NSString*)userId
{
    NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[UserInfo class] tableName:MyFriendsTable condition:[NSString stringWithFormat:@" where DBUid='%@' and userId='%@' ",[UserInfo myselfInstance].userId,userId]];
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
    
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[tmpPeoples count]];
    for(id tmpPerson in tmpPeoples)
    {
//         NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        PhoneBookInfo* bookInfo = [[PhoneBookInfo alloc]init];
        
         NSString* fristName = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonFirstNameProperty));
         NSString* lastName = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonLastNameProperty));
//        book.nickName = (NSString*)ABRecordCopyValue(tmpPerson, kABPersonNicknameProperty);
        NSString* name = [NSString stringWithFormat:@"%@%@",lastName==nil?@"":lastName,fristName==nil?@"":fristName];
//        [dic setObject:name forKey:@"name"];
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
//                book.phone = strippedString;
                if(strippedString != nil && [strippedString length]>0)
                {
//                    [dic setObject:strippedString forKey:@"phone"];
                    bookInfo.phone = strippedString;
                }
            }
        }
        if(bookInfo.name != nil && [bookInfo.name length]>0 && bookInfo.phone != nil && [bookInfo.phone length]>0)
        {
            [bookInfo synchronize:nil];
        }
//        NSString* strippedString = [dic objectForKey:@"phone"];
//        if(strippedString != nil && [strippedString length]>0)
//        {
//            [array addObject:dic];
//        }
//        [addressBook addObject:book];
//        [book synchronize:nil];
    }
    if(call)
    {
        call(1,nil);
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
    CC_MD5_Update(&ctx, (const void *)orgMsg, strlen(orgMsg));
    
    // Places the MD2 message digest in md
    CC_MD5_Final(md, &ctx);
    
    CC_MD5(orgMsg, strlen(orgMsg), result);
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
//-(void)upgradeDataBase
//{
//    NSString* prevVersion = [[LogicManager sharedInstance] getPersistenceStringWithKey:@"version"];
//    float prev = 0;
//    if(prevVersion != nil)
//    {
//        prev = [prevVersion floatValue];
//    }
//    float current = [APPVERSION floatValue];
//    if(prev < current)
//    {
//        NSMutableArray* versionArray = [[NSMutableArray alloc]init];
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SQLUpgrage" ofType:@"plist"];
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//        if(data)
//        {
//            for(NSString* key in data)
//            {
//                float k = [key floatValue];
//                if(k>prev && k <= current)
//                {
//                    [versionArray addObject:key];
//                }
//            }
//        }
//        [versionArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
//        {
//            float object1 = [obj1 floatValue];
//            float object2 = [obj2 floatValue];
//            if(object1 > object2)
//            {
//                return NSOrderedDescending;
//            }
//            else
//            {
//                return NSOrderedAscending;
//            }
//        }];
//        for (NSString* key in versionArray)
//        {
//            NSDictionary* versionDic = [data objectForKey:key];
//            for(NSString* className in versionDic)
//            {
//                if([[UserDataBaseManager sharedInstance] tableExists:[className uppercaseString]])
//                {
//                    NSDictionary* classDic = [versionDic objectForKey:className];
//                    NSDictionary* addDic = [classDic objectForKey:@"add"];
//                    NSDictionary* deleteDic = [classDic objectForKey:@"delete"];
//                    for(NSString* column in addDic)
//                    {
//                        if(![[UserDataBaseManager sharedInstance] columnExists:className columnName:column])
//                        {
//                            [[UserDataBaseManager sharedInstance] executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ add COLUMN %@ %@;",[className uppercaseString],column,[addDic objectForKey:column]]];
//                        }
//                    }
//                    for (NSString* column in deleteDic)
//                    {
//                        if([[UserDataBaseManager sharedInstance] columnExists:className columnName:column])
//                        {
//                            [[UserDataBaseManager sharedInstance] executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ DROP COLUMN %@;",[className uppercaseString],column]];
//                        }
//                    }
//                }
//            }
//        }
////        [[LogicManager sharedInstance] setPersistenceData:APPVERSION withKey:@"version"];
//    }
//}
-(void)gotoProfile:(UIViewController*)controller userId:(NSString*)userId showBackButton:(BOOL)back
{
    if(controller !=nil && userId != nil )
    {
        if([userId isEqualToString:[UserInfo myselfInstance].userId])
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
-(void)gotoProfile:(UIViewController*)controller userId:(NSString*)userId
{
    [[LogicManager sharedInstance] gotoProfile:controller userId:userId showBackButton:NO];
}
//好友关系状态
-(RelationState)getRelationState:(NSString*)userId
{
    NSMutableDictionary* dic = [[LogicManager sharedInstance] getSharedDictionary];
    NSMutableDictionary* relationState = [dic objectForKey:@"relationState"];
    if(relationState == nil)
    {
        relationState = [[NSMutableDictionary alloc]init];
        [dic setObject:relationState forKey:@"relationState"];
    }
    if(userId == nil || [userId length]<=0)
    {
        return Stranger;
    }
    if([[LogicManager sharedInstance] isMyFriend:userId])
    {
        return Friends;
    }
    NSNumber* state = [relationState objectForKey:userId];
    if(state != nil)
    {
        return (RelationState)[state intValue];
    }
    else
    {
        return Stranger;
    }
}
-(void)setRelationSatte:(NSString*)userId state:(RelationState)state
{
    NSMutableDictionary* dic = [[LogicManager sharedInstance] getSharedDictionary];
    NSMutableDictionary* relationState = [dic objectForKey:@"relationState"];
    if(relationState == nil)
    {
        relationState = [[NSMutableDictionary alloc]init];
        [dic setObject:relationState forKey:@"relationState"];
    }
    if(userId == nil || [userId length]<=0)
    {
        return;
    }
    [relationState setObject:[NSNumber numberWithInt:state] forKey:userId];
}
#pragma --mark 微博
//登录微博
-(void)weiBoLogin:(EventCallBack)block
{
    weiboLoginCallBack = block;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}
//登出微博
- (void)weiBoLogout
{
    NSString* token = [[LogicManager sharedInstance] getPersistenceStringWithKey:kWeiboToken];
    if(token != nil)
    {
        [WeiboSDK logOutWithToken:token delegate:[LogicManager sharedInstance] withTag:@"user1"];
    }
    
}

////发评论到最新一条微博
//-(void)commentLatestWeibo:(NSString*)content weiboUid:(NSString*)weiboUid block:(EventCallBack)block
//{
//    commentCallBack = block;
//    NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[WeiboRelationInfo class]
//                                                              tableName:nil
//                                                              condition:[NSString stringWithFormat:@" where weiboUid='%@' ",weiboUid]];
//    if(arr != nil && [arr count]>0)
//    {
//        WeiboRelationInfo* info = [arr objectAtIndex:0];
//        NSString* sinaAccessToken = [[LogicManager sharedInstance] getPersistenceStringWithKey:kWeiboToken];
//        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
//        [parameters setObject:info.weiboId forKey:@"id"];
//        [parameters setObject:content forKey:@"comment"];
//        [WBHttpRequest requestWithAccessToken:sinaAccessToken
//                                          url:@"https://api.weibo.com/2/comments/create.json"
//                                   httpMethod:@"POST"
//                                       params:parameters
//                                     delegate:[LogicManager sharedInstance]
//                                      withTag:@"create"];
//    }
//    
//}
//获取我的主页的微博
//-(void)getHomeTimeline:(EventCallBack)block
//{
//    homeTimelineCallBack = block;
//    homeTimeLinePage = 1;
//    [self getHomeTimelineWithPage:homeTimeLinePage];
//}
-(void)getAllLatestWeibo
{
    homeTimeLinePage = 1;
    [self getAllLatestWeiboWithPage:homeTimeLinePage];
}
//获取双向关注用户的最新微博
-(void)getAllLatestWeiboWithPage:(int)page
{
    NSString* sinaAccessToken = [[LogicManager sharedInstance] getPersistenceStringWithKey:kWeiboToken];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"1" forKey:@"trim_user"];
    [parameters setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [parameters setObject:@"100" forKey:@"count"];
    [WBHttpRequest requestWithAccessToken:sinaAccessToken
                                      url:@"https://api.weibo.com/2/statuses/bilateral_timeline.json"
                               httpMethod:@"GET"
                                   params:parameters
                                 delegate:[LogicManager sharedInstance]
                                  withTag:@"bilateral_timeline"];
}
//获取我的页面的所有微博
//-(void)getHomeTimelineWithPage:(int)page
//{
//    NSString* sinaAccessToken = [[LogicManager sharedInstance] getPersistenceStringWithKey:kWeiboToken];
//    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:@"1" forKey:@"trim_user"];
//    [parameters setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
//    [parameters setObject:@"100" forKey:@"count"];
//    [WBHttpRequest requestWithAccessToken:sinaAccessToken
//                                      url:@"https://api.weibo.com/2/statuses/home_timeline.json"
//                               httpMethod:@"GET"
//                                   params:parameters
//                                 delegate:[LogicManager sharedInstance]
//                                  withTag:@"user_timeline"];
//}
//-(void)sendWeiBo:(NSString*)content
-(void)sendWeiBo:(NSString *)articleId title:(NSString *)title image:(NSString *)imageString
{
    if ([WeiboSDK isWeiboAppInstalled])
    {
        //文字
        WBMessageObject *message = [WBMessageObject message];
//        message.text = content;
        message.text = title;
        
        
        
        //消息中图片内容和多媒体内容不能共存
        //消息的图片内容中，图片数据不能为空并且大小不能超过10M
        //图片
//        WBImageObject *image = [WBImageObject object];
//        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Default" ofType:@"png"]];
//        message.imageObject = image;
        
        
        //多媒体
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
//        webpage.title = @"分享网页标题";
        webpage.title = title;
        webpage.description = [NSString stringWithFormat:@"分享网页内容简介-%.0f", [[NSDate date] timeIntervalSince1970]];
//        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
        webpage.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]];
//        webpage.webpageUrl = @"http://sina.cn?a=1";
        webpage.webpageUrl = [NSString stringWithFormat:@"%@/html/article?id=%@",SERVERROOTURL,articleId];
        message.mediaObject = webpage;
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:request];
    }
    else
    {
        BOOL bText = YES;
        NSString* sinaAccessToken = [[LogicManager sharedInstance] getPersistenceStringWithKey:kWeiboToken];
        if (bText)
        {
            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
//            [parameters setObject:content forKey:@"status"];
            [parameters setObject:title forKey:@"status"];
            [WBHttpRequest requestWithAccessToken:sinaAccessToken
                                              url:[NSString stringWithFormat:@"%@",@"https://api.weibo.com/2/statuses/update.json"]
                                       httpMethod:@"POST"
                                           params:parameters
                                         delegate:[LogicManager sharedInstance]
                                          withTag:@"update"];
            
        }
        else
        {
            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
//            [parameters setObject:content forKey:@"status"];
            [parameters setObject:title forKey:@"status"];
            [parameters setObject:@"图片"forKey:@"pic"]; //jpeg的 NSData 格式,
            [WBHttpRequest requestWithAccessToken:sinaAccessToken
                                              url:[NSString stringWithFormat:@"%@",@"https://api.weibo.com/2/statuses/upload.json"]
                                       httpMethod:@"POST"
                                           params:parameters
                                         delegate:[LogicManager sharedInstance]
                                          withTag:@"upload"];
            
        }
    }
}
//微博回调
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        //ProvideMessageForWeiboViewController *controller = [[[ProvideMessageForWeiboViewController alloc] init] autorelease];
        //[self.viewController presentModalViewController:controller animated:YES];
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        //发送消息给需要返回消息的页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WBHandleResult" object:response];
        //        NSString *title = @"发送结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        int returnCode = (int)response.statusCode;
        NSString* weiboUID = [(WBAuthorizeResponse *)response userID];
//        NSDictionary* userInfo = response.userInfo;
//        NSDictionary* requestUserInfo = response.requestUserInfo;
        NSDate* expirationDate = [(WBAuthorizeResponse *)response expirationDate];
        NSString* accessToken = [(WBAuthorizeResponse*)response accessToken];
        if(returnCode == 1)
        {
            if(weiboLoginCallBack)
            {
                weiboLoginCallBack(0,nil);
            }
            return;
        }
        else
        {
            if(expirationDate != nil && response != nil)
            {
                [[LogicManager sharedInstance] setPersistenceData:expirationDate withKey:kExpirationDate];
            }
            else
            {
                if(weiboLoginCallBack)
                {
                    weiboLoginCallBack(0,nil);
                }
                return;
            }
            if(response != nil && weiboUID != nil)
            {
                [[LogicManager sharedInstance] setPersistenceData:weiboUID withKey:kWeiboUid];
            }
            else
            {
                if(weiboLoginCallBack)
                {
                    weiboLoginCallBack(0,nil);
                }
                return;
            }
            if(response != nil && accessToken != nil)
            {
                [[LogicManager sharedInstance] setPersistenceData:accessToken withKey:kWeiboToken];
            }
            else
            {
                if(weiboLoginCallBack)
                {
                    weiboLoginCallBack(0,nil);
                }
                return;
            }
            if(weiboLoginCallBack)
            {
                weiboLoginCallBack(1,[NSDictionary dictionaryWithObjectsAndKeys:accessToken,@"accessToken",
                                      weiboUID,@"weiboUID",
                                      [NSNumber numberWithDouble:[expirationDate timeIntervalSince1970]*1000],@"weiboTokenTime",
                                      nil]);
            }
        }
    }
}
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
//    if([request.tag isEqualToString:@"user_timeline"])
//    {
//        NSDictionary* dic = [[LogicManager sharedInstance] jsonStringTOObject:result];
//        if(dic != nil)
//        {
//            NSArray* arr = [dic objectForKey:@"statuses"];
//            if(arr != nil && [arr count]>0)
//            {
//                for(NSDictionary* d in arr)
//                {
//                    WeiboRelationInfo* info  = [[WeiboRelationInfo alloc]init];
//                    [info setValuesForKeysWithDictionary:d];
//                    [info synchronize:nil];
//                    NSArray* getArr = [[UserDataBaseManager sharedInstance] queryWithClass:[WeiboRelationInfo class]
//                                                                                 tableName:nil
//                                                                                 condition:[NSString stringWithFormat:@" where weiboUid='%@'",info.weiboUid]];
//                    if(getArr != nil && [getArr count]>0)
//                    {
//                        WeiboRelationInfo* existInfo = [getArr objectAtIndex:0];
//                        if(existInfo.createTime < info.createTime)
//                        {
//                            [info synchronize:nil];
//                        }
//                    }
//                    else
//                    {
//                        [info synchronize:nil];
//                    }
//                }
////                NSLog(@"======%d",homeTimeLinePage);
//                homeTimeLinePage++;
//                if(homeTimelineCallBack)
//                {
//                    homeTimelineCallBack(1,[NSNumber numberWithInt:1]);
//                }
//                [self getHomeTimelineWithPage:homeTimeLinePage];
//            }
//            else
//            {
//                if(homeTimelineCallBack)
//                {
//                    homeTimelineCallBack(0,nil);
//                }
//            }
//        }
//        else
//        {
//            if(homeTimelineCallBack)
//            {
//                homeTimelineCallBack(0,nil);
//            }
//        }
//    }
//    else
    
    if ([request.tag isEqualToString:@"create"])
    {
        NSDictionary* dic = [[LogicManager sharedInstance] jsonStringTOObject:result];
        if(dic != nil)
        {
            NSString* errorString = [dic objectForKey:@"error"];
            if(errorString != nil && [errorString length]>0)
            {
                if(commentCallBack)
                {
                    commentCallBack(0,errorString);
                }
            }
            else
            {
                if(commentCallBack)
                {
                    commentCallBack(1,nil);
                }
            }
        }
    }
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
    if(weiboLoginCallBack)
    {
        weiboLoginCallBack(0,nil);
    }
}
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
