//
//  MessageCollectionCell.h
//  闺秘
//
//  Created by floar on 14-6-25.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "Notice.h"
#import "UserInfo.h"
@interface MessageCollectionCell : UICollectionViewCell
{
    IBOutlet UIImageView* zanImageView;
    IBOutlet UIImageView* commentImageView;
}
@property (nonatomic, strong) Feed *cellFeed;

@end
