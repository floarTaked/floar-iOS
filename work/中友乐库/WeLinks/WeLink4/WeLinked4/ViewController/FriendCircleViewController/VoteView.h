//
//  VoteView.h
//  WeLinked4
//
//  Created by floar on 14-5-30.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendProtocol.h"
#import "CustomProcessView.h"


@interface VoteView : UIView<FriendProtocol>

@property (nonatomic, assign) int voteCount;

@property (nonatomic, strong) CustomProcessView *processView;

@property (nonatomic, weak) id<FriendProtocol> deleagate;
//@property (nonatomic, assign) FeedType feedType;

@end
