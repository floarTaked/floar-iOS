//
//  CommentCell.h
//  WeLinked3
//
//  Created by 牟 文斌 on 3/10/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "CustomCellView.h"
#import "Comment.h"

@interface CommentCell : CustomMarginCellView
@property (nonatomic, strong) Comment *comment;

+ (float)cellHeightWithComment:(Comment *)comment;

@end
