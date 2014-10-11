//
//  QuestionFeedTableViewCell.h
//  闺秘
//
//  Created by floar on 14-7-18.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface QuestionFeedTableViewCell : UITableViewCell

@property (nonatomic, strong) Feed *questionFeed;
@property (nonatomic, copy) void (^handlePublishSecretFromCell)(void);
@property (nonatomic, copy) void (^handleInviteFriendAnswer)(void);

@end
