//
//  TimerDeleteMessageItem.m
//  WeLinked4
//
//  Created by jonas on 6/4/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//
#import "TimerDeleteMessageItem.h"
#define MessageFontSize 16
@implementation TimerDeleteMessageItem
@synthesize data;
-(float)getHeight
{
    float height = [UILabel calculateHeightWith:self.data.text
                                           font:[UIFont systemFontOfSize:MessageFontSize]
                                          width:MessageWidth
                                 lineBreakeMode:NSLineBreakByWordWrapping];
    //    if(height < 50)
    //    {
    //        return 50;
    //    }
    return height + 30;
}
-(void)fillCell:(UITableViewCell*)cell
{
    if(cell == nil)
    {
        return;
    }
    if(self.data.isSender == 0)
    {
        [self buildReceiveCell:cell];
    }
    else
    {
        [self buildSendCell:cell];
    }
    
}
-(void)buildReceiveCell:(UITableViewCell*)cell
{
    UIView* view = (UIView*)[cell.contentView viewWithTag:1];
    if(view == nil)
    {
        view = [[UIView alloc]init];
        view.tag = 1;
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:view];
    }
    EGOImageView* avatarImage = (EGOImageView*)[view viewWithTag:2];
    if(avatarImage == nil)
    {
        avatarImage = [[EGOImageView alloc]init];
        avatarImage.userInteractionEnabled = YES;
        avatarImage.tag = 2;
        //avatarImage.layer.cornerRadius = 20.0;
        avatarImage.layer.masksToBounds = YES;
        avatarImage.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        avatarImage.layer.borderWidth = 1.0;
        [view addSubview:avatarImage];
        avatarImage.frame = CGRectMake(10, 5, 40, 40);
        UITapGestureRecognizer* gues = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoProfile:)];
        [avatarImage addGestureRecognizer:gues];
    }
    UIImageView* backImage = (UIImageView*)[view viewWithTag:3];
    if(backImage == nil)
    {
        backImage = [[UIImageView alloc]init];
        backImage.tag = 3;
        backImage.image = [[UIImage imageNamed:@"messageGray"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
        [view addSubview:backImage];
    }
    
    UILabel* text = (UILabel*)[view viewWithTag:4];
    if(text == nil)
    {
        text = [[UILabel alloc]init];
        text.backgroundColor=[UIColor clearColor];
        text.tag = 4;
        text.numberOfLines = 0;
        text.lineBreakMode = NSLineBreakByWordWrapping;
        text.font = [UIFont systemFontOfSize:MessageFontSize];
        [view addSubview:text];
    }
    
    [avatarImage setImageURL:[NSURL URLWithString:self.data.otherAvatar]];
    text = [text FlexibleHeightWith:self.data.text width:MessageWidth];

    backImage.frame = CGRectMake(55, 5, text.frame.size.width+30, text.frame.size.height+20);
    text.frame = CGRectMake(75, 15, text.frame.size.width, text.frame.size.height);
    view.frame = CGRectMake(0, 0, cell.frame.size.width, backImage.frame.size.height+20);
    
    
    
    UILabel* stateLabel = (UILabel*)[view viewWithTag:5];
    if(stateLabel == nil)
    {
        stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 10)];
        stateLabel.font = getFontWith(NO, 9);
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        [stateLabel setTextColor:colorWithHex(0x555555)];
        stateLabel.tag = 5;
        [view addSubview:stateLabel];
    }
    stateLabel.center = CGPointMake(backImage.center.x+backImage.frame.size.width/2+15, backImage.center.y);
    //0未读 1 已读
    if(self.data.status == 2)
    {
        [stateLabel setText:@"已删除"];
    }
    else
    {
        [stateLabel setText:@""];
        [text setText:self.data.text];
    }
}
-(void)buildSendCell:(UITableViewCell*)cell
{
    UIView* view = (UIView*)[cell.contentView viewWithTag:1];
    if(view == nil)
    {
        view = [[UIView alloc]init];
        view.tag = 1;
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:view];
    }
    EGOImageView* avatarImage = (EGOImageView*)[view viewWithTag:2];
    if(avatarImage == nil)
    {
        avatarImage = [[EGOImageView alloc]init];
        avatarImage.tag = 2;
        //avatarImage.layer.cornerRadius = 20.0;
        avatarImage.layer.masksToBounds = YES;
        avatarImage.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        avatarImage.layer.borderWidth = 1.0;
        [view addSubview:avatarImage];
        avatarImage.frame = CGRectMake(320-50, 5, 40, 40);
        avatarImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* gues = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoProfile:)];
        [avatarImage addGestureRecognizer:gues];
    }
    UIImageView* backImage = (UIImageView*)[view viewWithTag:3];
    if(backImage == nil)
    {
        backImage = [[UIImageView alloc]init];
        backImage.tag = 3;
        backImage.image = [[UIImage imageNamed:@"messageBlue"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
        [view addSubview:backImage];
    }
    
    UILabel* text = (UILabel*)[view viewWithTag:4];
    if(text == nil)
    {
        text = [[UILabel alloc]init];
        text.backgroundColor=[UIColor clearColor];
        text.tag = 4;
        text.numberOfLines = 0;
        text.lineBreakMode = NSLineBreakByWordWrapping;
        text.font = [UIFont systemFontOfSize:MessageFontSize];
    }
    [avatarImage setImageURL:[NSURL URLWithString:[UserInfo myselfInstance].avatar]];
    text = [text FlexibleHeightWith:self.data.text width:MessageWidth];
    [text setText:self.data.text];
    [text sizeToFit];
    backImage.frame = CGRectMake(320-60-text.frame.size.width-23, 5, text.frame.size.width+30, text.frame.size.height+20);
    
    text.frame = CGRectMake(320-55-text.frame.size.width-18, 15, text.frame.size.width, text.frame.size.height);
    [view addSubview:text];
    view.frame = CGRectMake(0, 0, cell.frame.size.width, backImage.frame.size.height+20);
    
    indicatorView = (UIActivityIndicatorView*)[view viewWithTag:5];
    if(indicatorView == nil)
    {
        indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        indicatorView.backgroundColor = [UIColor clearColor];
        indicatorView.tag = 5;
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [view addSubview:indicatorView];
    }
    indicatorView.center = CGPointMake(backImage.frame.origin.x-20, view.frame.size.height/2);
    
    sendFailedButton = (UIButton*)[view viewWithTag:6];
    if(sendFailedButton == nil)
    {
        sendFailedButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        sendFailedButton.hidden = YES;
        [sendFailedButton setBackgroundImage:[UIImage imageNamed:@"sendFailed"] forState:UIControlStateNormal];
        sendFailedButton.backgroundColor = [UIColor clearColor];
        sendFailedButton.tag = 6;
        [view addSubview:sendFailedButton];
    }
    [sendFailedButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    [sendFailedButton addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
    sendFailedButton.center = CGPointMake(backImage.frame.origin.x-20, view.frame.size.height/2);
    
    
    if(self.data.isSender == 2)
    {
        ////0发送 1 接收 2发送中 3 发送失败
        [indicatorView startAnimating];
        sendFailedButton.hidden = YES;
    }
    else if(self.data.isSender == 3)
    {
        [indicatorView stopAnimating];
        sendFailedButton.hidden = NO;
    }
    else
    {
        [indicatorView stopAnimating];
        sendFailedButton.hidden = YES;
        //发送
        UIImageView* statImage = (UIImageView*)[view viewWithTag:7];
        if(statImage == nil)
        {
            statImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"lock%d",self.data.msgType]]];
            statImage.tag = 7;
            [view addSubview:statImage];
        }
        statImage.center = CGPointMake(indicatorView.center.x, indicatorView.center.y-10);
        statImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"lock%d",self.data.msgType]];
        
        
        
        UILabel* stateLabel = (UILabel*)[view viewWithTag:8];
        if(stateLabel == nil)
        {
            stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, statImage.frame.size.width, 10)];
            stateLabel.font = getFontWith(NO, 9);
            stateLabel.backgroundColor = [UIColor clearColor];
            [stateLabel setTextColor:colorWithHex(0x555555)];
            stateLabel.tag = 8;
            [view addSubview:stateLabel];
        }
        stateLabel.center = CGPointMake(indicatorView.center.x, statImage.center.y+statImage.frame.size.height/2+8);
        //0未读 1 已读
        if(self.data.status == 0)
        {
            [stateLabel setText:@"未读"];
        }
        else if (self.data.status == 1)
        {
            [stateLabel setText:@"已读"];
        }
    }
}
-(void)setCallBack:(EventCallBack)callback
{
    call = callback;
}
-(void)showAction:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:@"重新发送？"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"重新发送", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    else if (buttonIndex ==1)
    {
        //resend
        if(call != nil)
        {
            call(EVENT_RESEND,self.data);
        }
    }
}
-(void)gotoProfile:(UITapGestureRecognizer*)guesture
{
    if(call)
    {
        call(EVENT_PRIFILE,self.data);
    }
}
-(void)resend
{
    
}
@end