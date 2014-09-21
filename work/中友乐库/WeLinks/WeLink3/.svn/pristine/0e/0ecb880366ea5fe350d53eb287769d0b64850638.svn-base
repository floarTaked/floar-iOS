//
//  NewFeedViewController.h
//  WeLinked3
//
//  Created by 牟 文斌 on 3/4/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feeds.h"
@class NewFeedViewController;
@protocol NewFeedViewControllerDelegate<NSObject>
- (void)newFeedViewController:(NewFeedViewController *)viewController AddNewFeedsSuccess:(Feeds *)feed;

@end

@interface NewFeedViewController : UIViewController
@property (nonatomic ,weak) id<NewFeedViewControllerDelegate> delegate;

@end
