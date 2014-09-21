//
//  UIBarButtonItem+WMStyle.h
//  WeMeet
//
//  Created by Riley on 7/22/13.
//  Copyright (c) 2013 Wang Ning. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum WMNavigationItemStyle_
{
    WMNavigationItemStyleIndex = 0,
    WMNavigationItemStyleRefresh,
    WMNavigationItemStyleSetting,
    WMNavigationItemStyleBack,
    WMNavigationItemStyleShare,
    WMNavigationItemStyleSave,
    WMNavigationItemStyleConfirm,
    WMNavigationItemStyleCancel,
    WMNavigationItemStyleLogin,
    WMNavigationItemStyleDelete,
    WMNavigationItemStyleLanguage,
    WMNavigationItemStyleForward,
    WMNavigationItemStyleLoading,
    WMNavigationItemStyleProfile,
    WMNavigationItemStyleMore,
    WMNavigationItemStyleChat,
    WMNavigationItemStyleCategory,
    WMNavigationItemStyleSearch,
    WMNavigationItemStyleNewPost
} WMNavigationItemStyle;

@interface UIBarButtonItem (WMStyle)

+ (UIBarButtonItem *)barButtonItemWithNavigationItemStyle:(WMNavigationItemStyle)style
                                                    title:(NSString *)title
                                                   target:(id)target
                                                 selector:(SEL)selector;
+ (UIBarButtonItem *)backBarButtonItemWithWMStyle;

@end
