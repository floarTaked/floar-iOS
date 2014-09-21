//
//  SelectFriendCell.h
//  WeLinked3
//
//  Created by 牟 文斌 on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@class SelectFriendCell;
@protocol SelectFriendCellDelegate <NSObject>

- (void)selectCell:(SelectFriendCell *)cell;

@end

@interface SelectFriendCell : UITableViewCell
@property (nonatomic, weak) id<SelectFriendCellDelegate> delegate;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, assign) BOOL selectFriend;
@end
