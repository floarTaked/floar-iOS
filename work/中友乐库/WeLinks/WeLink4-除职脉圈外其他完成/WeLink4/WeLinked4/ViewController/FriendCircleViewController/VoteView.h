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

typedef enum
{
    voteTypeHttp= 0,
    voteTypeNormal,
    voteTypeRate
}VoteType;

@interface VoteView : UIView<FriendProtocol>

@property (nonatomic, assign) int voteCount;

@property (nonatomic, strong) CustomProcessView *processView;

@property (nonatomic, weak) id<FriendProtocol> deleagate;
//@property (nonatomic, assign) VoteType voteType;

@end
