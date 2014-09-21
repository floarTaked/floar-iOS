//
//  UIBarButtonItem+WMStyle.m
//  WeMeet
//
//  Created by Riley on 7/22/13.
//  Copyright (c) 2013 Wang Ning. All rights reserved.
//

#import "UIBarButtonItem+WMStyle.h"



@implementation UIBarButtonItem (WMStyle)

+ (UIBarButtonItem *)barButtonItemWithNavigationItemStyle:(WMNavigationItemStyle)style
                                                    title:(NSString *)title
                                                   target:(id)target
                                                 selector:(SEL)selector
{
    if (style == WMNavigationItemStyleLoading)
    {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        [activityIndicator startAnimating];
        return barBtnItem;
    }
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (WMNavigationItemStyleDelete == style)
    {
        [customBtn setBackgroundImage:[UIImage imageNamed:@"delete_n.png"] forState:UIControlStateNormal];
    }
    else
    {
        //        [customBtn setBackgroundImage:[[UIImage imageNamed:@"barBtn_n.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [customBtn setBackgroundImage:[[UIImage imageNamed:@"barBtn_n.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)] forState:UIControlStateNormal];
    }
    //[customBtn setBackgroundImage:[UIImage imageNamed:@"barBtn_n.png"] forState:UIControlStateNormal];
    [customBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (title && title.length > 0)
    {
        CGSize strSize = [title sizeWithFont:[UIFont systemFontOfSize:14.0f]];
        strSize.width += 10;
        strSize.height = 30;
        if (strSize.width < 42)
        {
            strSize.width = 42;
        }
        customBtn.frame = CGRectMake(0, 0, strSize.width, strSize.height);
    }
    else
    {
        customBtn.frame = CGRectMake(0, 0, 58, 30);
    }
    UIImage *btnImg = nil;
    UIImage *btnImg_h = nil;
    if (title && ![title isEqualToString:@""])
    {
        [customBtn setTitle:title forState:UIControlStateNormal];
        [customBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        customBtn.titleLabel.shadowColor = [UIColor lightGrayColor];
        customBtn.titleLabel.shadowOffset = CGSizeMake(0, 1.0);
        customBtn.titleLabel.highlightedTextColor = [UIColor lightGrayColor];
        [customBtn setTitleColor:[UIColor colorWithRed:24/255.0 green:104/255.0 blue:233/255.0 alpha:1] forState:UIControlStateNormal];
    }
    else
    {
        switch (style)
        {
            case WMNavigationItemStyleIndex:
                btnImg = [UIImage imageNamed:@"index_n.png"];
                btnImg_h = [UIImage imageNamed:@"index_h.png"];
                break;
            case WMNavigationItemStyleRefresh:
                btnImg = [UIImage imageNamed:@"refresh_n.png"];
                btnImg_h = [UIImage imageNamed:@"refresh_h.png"];
                break;
            case WMNavigationItemStyleCategory:
                btnImg = [UIImage imageNamed:@"inforRight"];
                btnImg_h = [UIImage imageNamed:@"inforRight"];
                [customBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
                break;
            case WMNavigationItemStyleSetting:
                btnImg = [UIImage imageNamed:@"setting"];
                btnImg_h = [UIImage imageNamed:@"settingSelected"];
                [customBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
                break;
            case WMNavigationItemStyleBack:
                btnImg = [UIImage imageNamed:@"back"];
                btnImg_h = [UIImage imageNamed:@"backSelected"];
                [customBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
                break;
            case WMNavigationItemStyleShare:
                btnImg = [UIImage imageNamed:@"share_n.png"];
                btnImg_h = [UIImage imageNamed:@"share_h.png"];
                break;
            case WMNavigationItemStyleSave:
                btnImg = [UIImage imageNamed:@"save_n.png"];
                btnImg_h = [UIImage imageNamed:@"save_h.png"];
                break;
            case WMNavigationItemStyleConfirm:
                btnImg = [UIImage imageNamed:@"done_n.png"];
                btnImg_h = [UIImage imageNamed:@"done_h.png"];
                break;
            case WMNavigationItemStyleCancel:
                btnImg = [UIImage imageNamed:@"cancel_n.png"];
                btnImg_h = [UIImage imageNamed:@"cancel_h.png"];
                break;
            case WMNavigationItemStyleLogin:
                btnImg = [UIImage imageNamed:@"login_n.png"];
                btnImg_h = [UIImage imageNamed:@"login_h.png"];
                break;
            case WMNavigationItemStyleForward:
                btnImg = [UIImage imageNamed:@"forward_n.png"];
                btnImg_h = [UIImage imageNamed:@"forward_n.png"];
                break;
            case WMNavigationItemStyleProfile:
                btnImg = [UIImage imageNamed:@"profile_n.png"];
                btnImg_h = [UIImage imageNamed:@"profile_h.png"];
                break;
            case WMNavigationItemStyleMore:
                btnImg = [UIImage imageNamed:@"more_n.png"];
                btnImg_h = [UIImage imageNamed:@"more_h.png"];
                break;
            case WMNavigationItemStyleChat:
                btnImg = [UIImage imageNamed:@"chat_n.png"];
                btnImg_h = [UIImage imageNamed:@"chat_h.png"];
                break;
            case WMNavigationItemStyleSearch:
                btnImg = [UIImage imageNamed:@"img_search_n.png"];
                btnImg_h = [UIImage imageNamed:@"img_search_h.png"];
                break;
            case WMNavigationItemStyleNewPost:
                btnImg = [UIImage imageNamed:@"btn_newPost_n.png"];
                btnImg_h = [UIImage imageNamed:@"btn_newPost_h.png"];
                 [customBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
                break;
            default:
                break;
        }
    }
    
    [customBtn setImage:btnImg forState:UIControlStateNormal];
    [customBtn setImage:btnImg_h forState:UIControlStateHighlighted];
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    return barBtnItem;
}

+ (UIBarButtonItem *)backBarButtonItemWithWMStyle
{
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_n.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
    backBarBtn.title = nil;
    return backBarBtn;
}

@end
