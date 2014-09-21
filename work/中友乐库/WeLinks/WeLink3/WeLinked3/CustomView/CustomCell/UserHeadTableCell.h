//
//  UserHeadTableCell.h
//  WeLinked3
//
//  Created by 牟 文斌 on 2/28/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "CustomCellView.h"
@class UserHeadTableCell;
@protocol UserHeadTableCellDelegate <NSObject>
@optional
- (void)userHeadTableCell:(UserHeadTableCell *)cell DidSelectUserAtIndex:(int)index;

@end

@interface UserHeadTableCell : CustomMarginCellView
@property (nonatomic, strong) NSMutableArray *friendList;
@property (nonatomic, weak) id<UserHeadTableCellDelegate> delegate;

@end
