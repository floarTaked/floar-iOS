//
//  ProfileInfo.m
//  WeLinked3
//
//  Created by jonas on 2/25/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "ProfileInfo.h"
#import "UserInfo.h"
#import "EducationInfo.h"
#import "LogicManager.h"
#import "WorkInfo.h"
@implementation ProfileInfo
@synthesize DBUid,userInfo,userId,educationArray,workArray,is2Du;
+(NSString*)primaryKey
{
    return @"userId";
}
-(id)init
{
    self = [super init];
    if(self)
    {
        self.DBUid = [UserInfo myselfInstance].userId;
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"user"])
    {
        //转换成UserInfo
        UserInfo* info = [[UserInfo alloc]init];
        [info setValuesForKeysWithDictionary:value];
        userInfo = info;
        [info synchronize:nil];
        self.userId = info.userId;
    }
    else if([key isEqualToString:@"education"])
    {
        NSArray* arr = (NSArray*)value;
        NSString *json = [[LogicManager sharedInstance] objectToJsonString:arr];
        educationString = json;
        NSMutableArray* edArray = [[NSMutableArray alloc]init];
        for(NSDictionary* dic in arr)
        {
            EducationInfo* work = [[EducationInfo alloc]init];
            [work setValuesForKeysWithDictionary:dic];
            [work synchronize:nil];
            [edArray addObject:work];
        }
        self.educationArray = edArray;
    }
    else if ([key isEqualToString:@"job"])
    {
        NSArray* arr = (NSArray*)value;
        NSString *json = [[LogicManager sharedInstance] objectToJsonString:arr];
        workString = json;
        
        NSMutableArray* wkArray = [[NSMutableArray alloc]init];
        for(NSDictionary* dic in arr)
        {
            WorkInfo* work = [[WorkInfo alloc]init];
            [work setValuesForKeysWithDictionary:dic];
            [work synchronize:nil];
            [wkArray addObject:work];
        }
        self.workArray = wkArray;
    }
//    else if ([key isEqualToString:@"sameFriends"])
//    {
//        NSArray* arr = (NSArray*)value;
//        NSString *json = [[LogicManager sharedInstance] objectToJsonString:arr];
//        sameFriendSting = json;
//        NSMutableArray* userArray = [[NSMutableArray alloc]init];
//        for(NSDictionary* dic in arr)
//        {
//            UserInfo* user = [[UserInfo alloc]init];
//            [user setValuesForKeysWithDictionary:dic];
//            [userArray addObject:user];
//        }
//        self.sameFriendArray = userArray;
//    }
    else
    {
        NSLog(@"====undefined key %@",key);
    }
}
-(UserInfo*)userInfo
{
    if(userInfo == nil)
    {
        NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[UserInfo class]
                                                                  tableName:nil
                                                                  condition:[NSString stringWithFormat:@" where userId=%d ",userId]];
        if(arr != nil && [arr count]>0)
        {
            userInfo = [arr objectAtIndex:0];
        }
    }
    return userInfo;
}
-(NSMutableArray*)educationArray
{
    if(educationArray == nil && educationString != nil && [educationString length]>0)
    {
        NSString *postsFromResponse = educationString;
        NSError* error = nil;
        id data =[NSJSONSerialization JSONObjectWithData:[postsFromResponse dataUsingEncoding:NSUTF8StringEncoding]
                                              options:NSJSONReadingMutableLeaves error:&error];
        if(error != nil)
        {
            data = nil;
        }
        
        self.educationArray = [NSMutableArray array];
        for(NSDictionary* dic in data)
        {
            EducationInfo* education = [[EducationInfo alloc]init];
            [education setValuesForKeysWithDictionary:dic];
            [self.educationArray addObject:education];
        }
    }
    return educationArray;
}
-(NSMutableArray*)workArray
{
    if(workArray == nil && workString != nil && [workString length]>0)
    {
        NSString *postsFromResponse = workString;
        NSError* error = nil;
        id data =[NSJSONSerialization JSONObjectWithData:[postsFromResponse dataUsingEncoding:NSUTF8StringEncoding]
                                                 options:NSJSONReadingMutableLeaves error:&error];
        if(error != nil)
        {
            data = nil;
        }
        self.workArray = [NSMutableArray array];
        for(NSDictionary* dic in data)
        {
            WorkInfo* work = [[WorkInfo alloc]init];
            [work setValuesForKeysWithDictionary:dic];
            [self.workArray addObject:work];
        }
    }
    return workArray;
}
//-(NSMutableArray*)sameFriendArray
//{
//    if(sameFriendArray == nil && sameFriendSting != nil && [sameFriendSting length]>0)
//    {
//        NSString *postsFromResponse = sameFriendSting;
//        NSError* error = nil;
//        id data =[NSJSONSerialization JSONObjectWithData:[postsFromResponse dataUsingEncoding:NSUTF8StringEncoding]
//                                                 options:NSJSONReadingMutableLeaves error:&error];
//        if(error != nil)
//        {
//            data = nil;
//        }
//        self.sameFriendArray = [NSMutableArray array];
//        for(NSDictionary* dic in data)
//        {
//            UserInfo* user = [[UserInfo alloc]init];
//            [user setValuesForKeysWithDictionary:dic];
//            [self.sameFriendArray addObject:user];
//        }
//    }
//    return sameFriendArray;
//}
@end
