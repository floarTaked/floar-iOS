//
//  CommentCellView.m
//  Guimi
//
//  Created by jonas on 9/15/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "CommentCellView.h"

@implementation CommentCellView
@synthesize comment;
-(void)awakeFromNib
{
    [super awakeFromNib];
    content.font = [UIFont systemFontOfSize:14];
    desc.font = [UIFont systemFontOfSize:12];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(IBAction)click:(id)sender
{
    
}
-(void)setComment:(Comment *)cmt
{
    comment = cmt;
    if (comment.isOwnZanComment == 0)
    {
        [likeButton setImage:[UIImage imageNamed:@"btn_comment_like"] forState:UIControlStateNormal];
    }
    else if (comment.isOwnZanComment == 1)
    {
        [likeButton setImage:[UIImage imageNamed:@"btn_support_yes"] forState:UIControlStateNormal];
    }
    else if (comment.isOwnZanComment == 0xFFFFFFFF)
    {
        [likeButton setImage:[UIImage imageNamed:@"btn_comment_like"] forState:UIControlStateNormal];
    }
    float height = [UILabel calculateHeightWith:comment.comment
                                           font:[UIFont systemFontOfSize:14]
                                          width:content.frame.size.width
                                 lineBreakeMode:NSLineBreakByWordWrapping];
    
    
    if(height > content.frame.size.height)
    {
        float diffHeight = height - content.frame.size.height;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                                self.frame.size.width, self.frame.size.height + diffHeight);
        backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y,
                                    backView.frame.size.width, backView.frame.size.height + diffHeight);
        
        content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y,
                                   content.frame.size.width, content.frame.size.height + diffHeight);
        
        
        desc.frame = CGRectMake(desc.frame.origin.x, desc.frame.origin.y + diffHeight,
                                      desc.frame.size.width, desc.frame.size.height);
    }
    desc.text = @"100楼 ; 3小时前 ; 作者";
}
@end
