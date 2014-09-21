//
//  FeedsCommentCell.h
//  WeLinked3
//
//  Created by 牟 文斌 on 2/25/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//


#import "Comment.h"

@interface FeedsCommentCell :UITableViewCell
@property (nonatomic, strong) Comment *comment;

+(float)cellHeightWithComment:(Comment *)comment;
@end
