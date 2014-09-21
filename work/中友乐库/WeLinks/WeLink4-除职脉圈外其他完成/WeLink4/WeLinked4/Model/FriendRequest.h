//
//  FriendRequest.h
//  WeLinked4
//
//  Created by jonas on 5/30/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "NSObjectExtention.h"
//"userId":用户id,Integer
//"friendId":朋友id,Integer
//"friendName":朋友姓名,
//"friendAvatar":朋友头像,
//"friendCompany":朋友公司,
//"friendJob":朋友职位,
//"createTime":创建时间,
//"status":0
@interface FriendRequest : NSObjectExtention
@property(nonatomic,assign)int            DBUid;
@property(nonatomic,assign)int            userId;
@property(nonatomic,assign)int            friendId;
@property(nonatomic,strong)NSString*      friendName;
@property(nonatomic,strong)NSString*      friendAvatar;
@property(nonatomic,strong)NSString*      friendCompany;
@property(nonatomic,strong)NSString*      friendJob;
@property(nonatomic,assign)NSTimeInterval createTime;
@property(nonatomic,assign)int            status;
@end
