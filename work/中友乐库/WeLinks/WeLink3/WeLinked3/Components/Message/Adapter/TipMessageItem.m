//
//  MessageTipMessageData.m
//  ChatView
//
//  Created by jonas on 12/16/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import "TipMessageItem.h"
@implementation TipMessageItem
@synthesize data;
-(void)fillCell:(UITableViewCell*)cell
{
    if(cell == nil)
    {
        return;
    }
    UIView* view = (UIView*)[cell.contentView viewWithTag:1];
    if(view == nil)
    {
        view = [[UIView alloc]init];
        view.tag = 1;
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:view];
    }
    UILabel *label = (UILabel*)[view viewWithTag:2];
    if(label == nil)
    {
        label = [[UILabel alloc] init];
        label.tag = 2;
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.highlightedTextColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [label setTextColor:[UIColor whiteColor]];
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }
    UIImageView* back = (UIImageView*)[view viewWithTag:3];
    if(back == nil)
    {
        back = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"tipMessageback"]
                                                               stretchableImageWithLeftCapWidth:10 topCapHeight:5]];
        back.tag = 3;
        
        [view addSubview:back];
        [view bringSubviewToFront:label];
    }
    
    float height = [UILabel calculateHeightWith:self.data.text
                                           font:[UIFont systemFontOfSize:10]
                                          width:MessageWidth
                                 lineBreakeMode:NSLineBreakByWordWrapping];
    
    label.frame = CGRectMake(0, 0,MessageWidth , height);
    view.frame = CGRectMake(0, 0, 320, height+10);
    back.frame = CGRectMake(0, 0, MessageWidth+10, view.frame.size.height);
    CGPoint center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    back.center = center;
    label.center = center;
    [label setText:self.data.text];
}
-(float)getHeight
{
    float height = [UILabel calculateHeightWith:self.data.text
                                           font:[UIFont systemFontOfSize:10]
                                          width:MessageWidth
                                 lineBreakeMode:NSLineBreakByWordWrapping];
    return height+20;
}
@end
