//
//  MessageSnapData.m
//  ChatView
//
//  Created by jonas on 12/4/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import "SnapMessageItem.h"

@implementation SnapMessageItem
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
        view.frame = CGRectMake(0, 0, 320, 20);
        [cell.contentView addSubview:view];
    }
    UILabel* label = (UILabel*)[view viewWithTag:2];
    if(label == nil)
    {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        label.tag = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = getFontWith(YES,10);
        label.shadowOffset = CGSizeMake(0, 1);
        label.shadowColor = [UIColor whiteColor];
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.data.createTime]];
    [label setText:text];
}
-(float)getHeight
{
    return 20;
}
@end
