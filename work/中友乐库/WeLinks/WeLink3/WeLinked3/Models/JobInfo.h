//
//  JobInfo.h
//  WeLinked3
//
//  Created by 牟 文斌 on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "NSObjectExtention.h"
@interface JobInfo : NSObjectExtention
@property(nonatomic,strong)NSString* DBUid;//区分数据库归属
@property(nonatomic,strong)NSString* identity;
@property(nonatomic,strong)NSString* company;//公司
@property(nonatomic,strong)NSString* jobCode;//职位
@property(nonatomic,strong)NSString* locationCode;//办公地点
@property(nonatomic,assign)int       jobLevel;//级别
@property(nonatomic,assign)int       howLong;//工龄
@property(nonatomic,assign)int       salaryLevel;//薪酬
@property(nonatomic,assign)int       education;//学历
@property(nonatomic,strong)NSString* describes;//职位描述
@property(nonatomic,strong)NSString* industryId;//行业
@property(nonatomic,strong)NSString* subIndustryId;
@property(nonatomic,strong)NSString* jobImage;
@property(nonatomic,strong)NSString* poster;//发布者
@property(nonatomic,strong)NSString* posterId;
@property(nonatomic,assign)NSTimeInterval    publishTime;
@property(nonatomic,strong)NSString *posterImg;
@property(nonatomic,assign)int isFriendJob;
@property(nonatomic,assign)int past;//是否过期  默认是 0 过期为1
@end
