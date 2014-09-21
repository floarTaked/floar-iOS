//
//  ImageMessageItem.m
//  WeLinked4
//
//  Created by jonas on 5/20/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//
#import "ImageMessageItem.h"
#define MessageFontSize 16
@implementation ImageMessageItem
@synthesize data;
-(float)getHeight
{
    return 100+30;
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
    [avatarImage setImageURL:[NSURL URLWithString:self.data.otherAvatar]];
    
    imageView = (EGOImageView*)[view viewWithTag:3];
    if(imageView == nil)
    {
        imageView = [[EGOImageView alloc]initWithFrame:CGRectMake(avatarImage.frame.origin.x+avatarImage.frame.size.width + 20,
                                                                  0, 100, 100)];
        imageView.tag = 3;
        [view addSubview:imageView];
        UITapGestureRecognizer* gues = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContent:)];
        [avatarImage addGestureRecognizer:gues];
    }
    [[EGOImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:self.data.otherAvatar]
                                             completion:^(UIImage *image, NSURL *imageURL, NSError *error)
    {
        if(image)
        {
            CGSize imageSize = image.size;
            if(imageSize.height > 100.0)
            {
                imageSize.width = (imageSize.width*100.0/imageSize.height);
                imageSize.height = 100.0;
            }
            else if (imageSize.width > 100.0)
            {
                imageSize.height = (imageSize.height) *100.0/imageSize.width;
                imageSize.width = 100.0;
            }
            imageView.image = image;
            CALayer *mask = [CALayer layer];
            UIImage* stretchableImage = [UIImage imageNamed:@"receiveImageMask"];
            mask.contents = (id)[stretchableImage CGImage];
            mask.contentsScale = [UIScreen mainScreen].scale;
            mask.contentsCenter = CGRectMake(20.0/stretchableImage.size.width,
                                             30.0/stretchableImage.size.height,
                                             1.0/stretchableImage.size.width,
                                             1.0/stretchableImage.size.height);
            mask.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
            imageView.layer.mask = mask;
            imageView.layer.masksToBounds = YES;
            imageView.frame = CGRectMake(avatarImage.frame.origin.x+avatarImage.frame.size.width + 10,
                                         0, imageSize.width, imageSize.height);
        }
    }];
    view.frame = CGRectMake(0, 0, cell.frame.size.width, imageView.frame.size.height+20);
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
    [avatarImage setImageURL:[NSURL URLWithString:[UserInfo myselfInstance].avatar]];
    
    imageView = (EGOImageView*)[view viewWithTag:3];
    if(imageView == nil)
    {
        imageView = [[EGOImageView alloc]initWithFrame:CGRectMake(320-60-avatarImage.frame.size.width-10, 5, 100, 100)];
        imageView.tag = 3;
        [view addSubview:imageView];
        UITapGestureRecognizer* gues = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContent:)];
        [avatarImage addGestureRecognizer:gues];
    }
    
    
    [[EGOImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:[UserInfo myselfInstance].avatar]
                                             completion:^(UIImage *image, NSURL *imageURL, NSError *error)
     {
         if(image)
         {
             CGSize imageSize = image.size;
             if(imageSize.height > 100.0)
             {
                 imageSize.width = (imageSize.width*100.0/imageSize.height);
                 imageSize.height = 100.0;
             }
             else if (imageSize.width > 100.0)
             {
                 imageSize.height = (imageSize.height) *100.0/imageSize.width;
                 imageSize.width = 100.0;
             }
             imageView.image = image;
             CALayer *mask = [CALayer layer];
             UIImage* stretchableImage = [UIImage imageNamed:@"sendImageMask"];
             mask.contents = (id)[stretchableImage CGImage];
             mask.contentsScale = [UIScreen mainScreen].scale;
             mask.contentsCenter = CGRectMake(20.0/stretchableImage.size.width,
                                              30.0/stretchableImage.size.height,
                                              1.0/stretchableImage.size.width,
                                              1.0/stretchableImage.size.height);
             mask.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
             imageView.layer.mask = mask;
             imageView.layer.masksToBounds = YES;
             imageView.frame = CGRectMake(320-60-avatarImage.frame.size.width-10, 5, imageSize.width, imageSize.height);
         }
     }];
    view.frame = CGRectMake(0, 0, cell.frame.size.width, imageView.frame.size.height+20);
    
    indicatorView = (UIActivityIndicatorView*)[view viewWithTag:5];
    if(indicatorView == nil)
    {
        indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        indicatorView.backgroundColor = [UIColor clearColor];
        indicatorView.tag = 5;
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [view addSubview:indicatorView];
    }
    indicatorView.center = CGPointMake(imageView.frame.origin.x-20, view.frame.size.height/2);
    
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
    sendFailedButton.center = CGPointMake(imageView.frame.origin.x-20, view.frame.size.height/2);
    
    
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
-(void)tapContent:(UITapGestureRecognizer*)guesture
{
    if(call)
    {
        call(EVENT_TAPCONTENT,self.data);
    }
}
-(void)resend
{
    
}
@end
