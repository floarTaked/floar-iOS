//
//  CommentCellView.h
//  Guimi
//
//  Created by jonas on 9/15/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
@interface CommentCellView : UIView
{
    IBOutlet UIView* backView;
    IBOutlet UIImageView* image;
    IBOutlet UILabel* content;
    IBOutlet UILabel* desc;
    IBOutlet UIButton* likeButton;
}
@property(nonatomic,strong)Comment* comment;
@end
