//
//  CommentListViewController.h
//  WeLinked3
//
//  Created by 牟 文斌 on 3/10/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "Feeds.h"

@interface CommentListViewController : UIViewController
@property (nonatomic, strong) Feeds *feed;
@property (nonatomic, assign) BOOL isFromFeedList;
@property (nonatomic, assign) Article *article;

@property (nonatomic, assign) BOOL isSupport;

@end
