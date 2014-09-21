//
//  LogicManager.m
//  UnNamed
//
//  Created by yohunl on 13-8-15.
//  Copyright (c) 2013年 jonas. All rights reserved.
//

#import "LogicManager.h"
#import "DataBaseManager.h"
#import "AppDelegate.h"
#import "PhoneBookInfo.h"
#import "Common.h"
#import "WXApiObject.h"
#import "UserInfo.h"
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
        DLog(@"jsonString to Object error:%@",error);
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

-(CGSize)calculateCGSizeWith:(NSString *)text
                      height:(float)height
                       width:(float)width
                        font:(UIFont *)font
{
    CGSize size = CGSizeZero;
    
    if (isSystemVersionIOS7())
    {
        size = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    }
    else
    {
        size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, height)];
    }
    return size;
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

-(BOOL)handleSocketResult:(uint32_t)result withErrorCode:(CheckErrorCode)errorCode
{
    if (result == 0)
    {
        DLog(@"数据ok");
        return YES;
    }
    else if (result == -1 && errorCode == NoCheckErrorCode)
    {
        [self showAlertWithTitle:nil message:@"服务不支持" actionText:@"确定"];
    }
    else if (result == -1 && errorCode == IdentifyCodeCheckError)
    {
        [self showAlertWithTitle:nil message:@"验证码错误" actionText:@"确定"];
    }
    else if (result == -1 && errorCode == PasswordCheckError)
    {
        [self showAlertWithTitle:nil message:@"密码错误" actionText:@"确定"];
    }
    else if (result == -2 && errorCode == NoCheckErrorCode)
    {
        [self showAlertWithTitle:nil message:@"请求参数错误" actionText:@"确定"];
    }
    else if (result == -3 && errorCode == NoCheckErrorCode)
    {
        [self showAlertWithTitle:nil message:@"未授权,请退出重新登陆" actionText:@"确定"];
    }
    else
    {
        DLog(@"resutl --- error");
    }
    return NO;
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

-(uint64_t)getPersistenceUint64WithKey:(id)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    uint64_t object = (uint64_t)[defaults objectForKey:key];
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

#pragma --mark 其他
#pragma --mark Contact Method
-(BOOL)isMyFriend:(int)userId
{
    NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[UserInfo class] tableName:MyFriendsTable condition:[NSString stringWithFormat:@" where DBUid=%llu and userId=%d ",[UserInfo myselfInstance].userId,userId]];
    if(arr != nil && [arr count]>0)
    {
        return YES;
    }
    return NO;
}
//判断是不是在app里
#if 0
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
#endif
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
                    bookInfo.phone = [strippedString doubleValue];
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
-(NSMutableString *)encodePassword:(NSString *)password
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"leku.gm.!@#$%"];
    [str appendString:password];
    
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(NSString *)encodePasswordWithsha1:(NSString *)password
{
    NSMutableString *str = [self encodePassword:password];
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
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
        if ([CLLocationManager locationServicesEnabled])
        {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
            locationManager.distanceFilter = 1000;
        }
        else
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"请开启定位服务" actionText:@"确定"];
        }
    }
    [locationManager startUpdatingLocation];
}
// 代理方法实现
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    double latitude = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if (error == nil)
        {
            if (placemarks != nil && placemarks.count > 0)
            {
                CLPlacemark *mark = [placemarks objectAtIndex:0];
                NSString *city = mark.locality;
                if (city != nil && city.length > 0)
                {
                    city = [city substringWithRange:NSMakeRange(0, city.length-1)];
                }
                if (locationCallBack != nil)
                {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:city forKey:@"city"];
                    [dict setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
                    [dict setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
                    locationCallBack(1,dict);
                }
            }
        }
        else
        {
            if(locationCallBack != nil)
            {
                locationCallBack(0,nil);
            }
        }
    }];
    [locationManager stopUpdatingLocation];
}

#if 0
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
#endif

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
    DLog(@"%@",error);
    if(locationCallBack != nil)
    {
        locationCallBack(0,nil);
    }
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
//登陆微博
-(void)weiBoLogin:(EventCallBack)block
{
    weiboLoginCallBack = block;
    
    WBAuthorizeRequest *authorRequest = [WBAuthorizeRequest request];
    authorRequest.redirectURI = kWeiboRedirectURL;
    authorRequest.scope = @"all";
    [WeiboSDK sendRequest:authorRequest];
}
//登出微博
- (void)weiBoLogout
{
    NSString *token = [[LogicManager sharedInstance] getPersistenceStringWithKey:kWeiboToken];
    if (token != nil)
    {
        [WeiboSDK logOutWithToken:token delegate:[LogicManager sharedInstance] withTag:@"user1"];
    }
}
//发微博
-(void)sendWeiBoWithTitle:(NSString *)title
                  desribe:(NSString *)describe
                    image:(UIImage *)image
{
    if ([WeiboSDK isWeiboAppInstalled])
    {
        
        WBMessageObject *message = [WBMessageObject message];

        NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
        
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        webpage.title = title;
        webpage.description = describe;
        webpage.thumbnailData = imgData;
        webpage.webpageUrl = @"www.baidu.com";
        message.mediaObject = webpage;
        
        WBSendMessageToWeiboRequest *sendRequest = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:sendRequest];
    }
    else
    {
        BOOL flag = YES;
        NSString *sinaAccessToken = [[LogicManager sharedInstance]getPersistenceStringWithKey:kWeiboToken];
        if (flag)
        {
            NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
            [parametersDict setObject:title forKey:@"status"];
            [WBHttpRequest requestWithAccessToken:sinaAccessToken
                                              url:[NSString stringWithFormat:@"%@",@"https://api.weibo.com/2/statuses/update.json"]
                                       httpMethod:@"POST"
                                           params:parametersDict
                                         delegate:[LogicManager sharedInstance]
                                          withTag:@"update"];
        }
        else
        {
            NSMutableDictionary* parametersDict = [NSMutableDictionary dictionary];
            //            [parameters setObject:content forKey:@"status"];
            [parametersDict setObject:title forKey:@"status"];
            [parametersDict setObject:@"图片"forKey:@"pic"]; //jpeg的 NSData 格式,
            [WBHttpRequest requestWithAccessToken:sinaAccessToken
                                              url:[NSString stringWithFormat:@"%@",@"https://api.weibo.com/2/statuses/upload.json"]
                                       httpMethod:@"POST"
                                           params:parametersDict
                                         delegate:[LogicManager sharedInstance]
                                          withTag:@"upload"];
        }
    }
}

//微博回调
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:[WBProvideMessageForWeiboRequest class]])
    {
        
    }
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]])
    {
        //发送消息给需要返回消息的页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WBHandleResult" object:response];
    }
    else if ([response isKindOfClass:[WBAuthorizeResponse class]])
    {
        int returnCode = (int)response.statusCode;
        NSString* weiboUID = [(WBAuthorizeResponse *)response userID];
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

-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    
}

-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
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

#pragma mark - 微信分享
-(void)sendWechatWithTitle:(NSString *)title
                  describe:(NSString *)describe
                  identify:(NSString *)identify
                     image:(UIImage *)image
                     scene:(int)scene
{
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
   
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = describe;
    [message setThumbData:imgData];
    [message setThumbImage:image];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = @"http://www.qq.com";
    
    Byte* pBuffer = (Byte *)malloc(1024*100);
    memset(pBuffer, 0, 1024*100);
    NSData* data = [NSData dataWithBytes:pBuffer length:1024*100];
    free(pBuffer);
    
    ext.fileData = data;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
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
