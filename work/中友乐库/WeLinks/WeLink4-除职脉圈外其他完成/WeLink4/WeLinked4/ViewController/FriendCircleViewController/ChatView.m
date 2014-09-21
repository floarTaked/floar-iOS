//
//  chatView.m
//  WeLinked4
//
//  Created by floar on 14-5-29.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "ChatView.h"
#import "RCLabel.h"

@implementation ChatView
{
    CGRect lrect;
    
    RCLabel *rcLabel;
    UIView *shareView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lrect = frame;
    }
    return self;
}

-(void)setCommentArray:(NSMutableArray *)commentArray
{
    if (commentArray != nil && commentArray.count > 0)
    {
        for (int i = 0; i < commentArray.count; i++)
        {
            rcLabel = [[RCLabel alloc] initWithFrame:CGRectMake(15, 30*i, 290, 20)];
            [rcLabel setText:[NSString stringWithFormat:@"<font size=12 color='#999999'>%@</font>",[commentArray objectAtIndex:i]]];
            rcLabel.backgroundColor = [UIColor redColor];
            [self addSubview:rcLabel];
        }
        
        [self createCommentView:CGRectMake(15, CGRectGetMaxY(rcLabel.frame)+10, 290, 58)];
        
    }
    else if (commentArray.count == 0)
    {
        [self createCommentView:CGRectMake(15, 0, 290, 58)];
    }
    
    self.frame = CGRectMake(lrect.origin.x, lrect.origin.y, 320, CGRectGetMaxY(shareView.frame)+5);
}

-(void)createCommentView:(CGRect)rect
{
    shareView = [[UIView alloc] initWithFrame:rect];
//    shareView.backgroundColor = [UIColor orangeColor];
    
    UIView* line = [shareView viewWithTag:300];
    if(line == nil)
    {
        line = [[UIView alloc]initWithFrame:CGRectMake(-15, 0, 320, 0.5)];
        line.backgroundColor = colorWithHex(0xCCCCCC);
//        line.backgroundColor = [UIColor redColor];
        line.tag = 300;
        [shareView addSubview:line];
    }

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, CGRectGetMaxY(line.frame)+10, 140, 38);
    [shareBtn setImage:[UIImage imageNamed:@"btn_share_n"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"btn_share_h"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:shareBtn];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(150, CGRectGetMaxY(line.frame)+10, 140, 38);
    [commentBtn setImage:[UIImage imageNamed:@"btn_comment_n"] forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"btn_comment_h"] forState:UIControlStateHighlighted];
    [commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:commentBtn];
    
    [self addSubview:shareView];
}

-(void)shareAction:(UIButton *)btn
{
    
}

-(void)commentAction:(UIButton *)btn
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
