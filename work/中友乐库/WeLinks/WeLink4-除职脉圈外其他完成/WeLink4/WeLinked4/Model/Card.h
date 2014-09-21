//
//  Card.h
//  WeLinked4
//
//  Created by floar on 14-5-15.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "NSObjectExtention.h"
@interface Card : NSObjectExtention
{
    NSMutableArray* _phoneArray;
    NSMutableArray* _emailArray;
}
@property (nonatomic, assign) int DBUid;//区分数据库归属
@property (nonatomic, assign) int cardId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar; //头像
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *companyAddress;
@property (nonatomic, strong) NSString *account;//即时通讯账号
@property (nonatomic, strong) NSString *cardPosition;  //GPS位置
@property (nonatomic, strong) NSString *descriptions;  //备注
@property (nonatomic, strong) NSString *cardImageUrl;//名片图片

@property (nonatomic, strong) NSMutableArray *phoneArray;
@property (nonatomic, strong) NSMutableArray *emailArray;
-(void)fillWithVcardDic:(NSDictionary*)dic;
@end
