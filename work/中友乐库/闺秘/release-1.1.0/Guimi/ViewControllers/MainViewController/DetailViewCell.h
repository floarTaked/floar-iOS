//
//  DetailViewCell.h
//  闺秘
//
//  Created by floar on 14-7-14.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface DetailViewCell : UITableViewCell

@property (nonatomic, strong) Comment *comment;
@property (nonatomic, assign) CGSize contentSize;

@end
