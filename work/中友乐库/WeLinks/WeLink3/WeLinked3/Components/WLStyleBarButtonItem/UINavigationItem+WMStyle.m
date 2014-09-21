//
//  UINavigationItem+WMStyle.m
//  WeMeet
//
//  Created by Riley on 7/22/13.
//  Copyright (c) 2013 Wang Ning. All rights reserved.
//

#import "UINavigationItem+WMStyle.h"


@implementation UINavigationItem (WMStyle)

- (void)setLeftBarButtonItemWithWMNavigationItemStyle:(WMNavigationItemStyle)style
                                                title:(NSString *)title
                                               target:(id)target
                                             selector:(SEL)selector
{
    self.leftBarButtonItem = [UIBarButtonItem barButtonItemWithNavigationItemStyle:style title:title target:target selector:selector];
    if (title.length > 0) {
        if ([self.leftBarButtonItem.customView isKindOfClass:[UIButton class]] && isSystemVersionIOS7()) {
            [(UIButton *)self.leftBarButtonItem.customView setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        }
    }
}

- (void)setRightBarButtonItemWithWMNavigationItemStyle:(WMNavigationItemStyle)style
                                                 title:(NSString *)title
                                                target:(id)target
                                              selector:(SEL)selector
{
    self.rightBarButtonItem = [UIBarButtonItem barButtonItemWithNavigationItemStyle:style title:title target:target selector:selector];
    if (title.length > 0) {
        if ([self.rightBarButtonItem.customView isKindOfClass:[UIButton class]] && isSystemVersionIOS7()) {
            [(UIButton *)self.rightBarButtonItem.customView setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
        }
    }
}

- (void)setBackBarButtonItemWMStyle
{
    if (!self.hidesBackButton) {
        self.backBarButtonItem = [UIBarButtonItem backBarButtonItemWithWMStyle];
    }
}

- (void)setTitleViewWithText:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    titleLabel.textColor = [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    //    titleLabel.shadowColor = [UIColor blackColor];
    //    titleLabel.shadowOffset = CGSizeMake(0, 1.0);
    [titleLabel sizeToFit];
    self.titleView = titleLabel;
}

@end
