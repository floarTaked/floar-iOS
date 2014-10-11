//
//  UserInfo.m
//  UnNamed
//
//  Created by jonas on 8/1/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//
//

#import "UserInfo.h"
#import "DataBaseManager.h"
#import "LogicManager.h"
@implementation UserInfo
@synthesize DBUid,userId,userKey,userAPNsToken;
-(id)init
{
    self = [super init];
    if(self)
    {
        int uid = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID];
        self.DBUid = uid;
    }
    return self;
}

+(NSString*)primaryKey
{
    return @"userId";
}

-(BOOL)synchronize:(NSString*)tableName
{
    if(self == [UserInfo myselfInstance])
    {
        [UserInfo myselfInstance].DBUid = 0;

        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithUnsignedLongLong:self.userId] withKey:USERID];
    }
    return [super synchronize:tableName];
}
+(UserInfo*)myselfInstance
{
    static UserInfo* m_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* uid = [[LogicManager sharedInstance] getPersistenceStringWithKey:USERID];
        if(uid == nil || [uid length]<=0)
        {
            m_instance = [[UserInfo alloc]init];
        }
        else
        {
            NSString* conditionString = nil;
            if(uid != nil && [uid length] > 0)
            {
                conditionString = [NSString stringWithFormat:@" where userId = '%@' ",uid];
            }
            NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[UserInfo class] tableName:nil condition:conditionString];
            if(arr != nil && [arr count]>0)
            {
                m_instance = [arr objectAtIndex:0];
            }
            else
            {
                m_instance = [[UserInfo alloc]init];
            }
        }
    });
    return m_instance;
}
@end
