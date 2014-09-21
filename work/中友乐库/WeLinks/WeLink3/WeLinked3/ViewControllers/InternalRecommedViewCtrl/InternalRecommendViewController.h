//
//  InternalRecommendViewController.h
//  WeLinked3
//
//  Created by 牟 文斌 on 2/24/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendInfo.h"
@interface InternalRecommendViewController : UIViewController
{
    CGPoint offsetPoint;
    BOOL mask;
    UITableViewCellAccessoryType  accessoryType;
    UILabel* countLabel;
}
@property (nonatomic, strong) NSString *recommendID;
@property (nonatomic, strong) RecommendInfo *recommendInfo;
@end
