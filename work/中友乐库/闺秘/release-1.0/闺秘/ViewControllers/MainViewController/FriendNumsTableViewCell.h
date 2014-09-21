//
//  FriendNumsTableViewCell.h
//  闺秘
//
//  Created by floar on 14-7-18.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendNumsTableViewCell : UITableViewCell

@property (nonatomic, assign) void (^handleInviteFriend)(void);

@end
