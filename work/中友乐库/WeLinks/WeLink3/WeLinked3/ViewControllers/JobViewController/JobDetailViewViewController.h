//
//  JobDetailViewViewController.h
//  WeLinked3
//
//  Created by 牟 文斌 on 2/28/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobInfo.h"
#import "UIPlaceHolderTextView.h"

#define kDeleteJobSuccess @"kDeleteJobSuccess"

@interface JobDetailViewViewController : UIViewController
{
    CGPoint offsetPoint;
    JobInfo *jobInfo;
    UIPlaceHolderTextView* jobDescription;
}
@property(nonatomic,strong)NSString* jobIdentity;
@property(nonatomic, assign) BOOL isFriendJob;
@property(nonatomic, assign) BOOL needShowShareView;
@end
