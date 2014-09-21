//
//  PublishJobViewController.h
//  WeLinked3
//
//  Created by 牟 文斌 on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobInfo.h"
#define kPublishJobSuccess @"kPublishJobSuccess"
#define kUpdateJobSuccess @"kUpdateJobSuccess"

@interface PublishJobViewController : UIViewController
{
    CGPoint offsetPoint;
}
@property(nonatomic, strong) JobInfo *jobInfo;
@property(nonatomic, assign) BOOL isUpdateJob;
@end
