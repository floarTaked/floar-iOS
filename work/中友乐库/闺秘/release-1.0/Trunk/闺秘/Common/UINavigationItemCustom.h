//
//  UINavigationItem+WMStyle.h
//  WeMeet
//
//  Created by Riley on 7/22/13.
//  Copyright (c) 2013 Wang Ning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
@interface UINavigationBar (Loading)

- (void)showLoading;
- (void)hideLoading;
@end

@interface UINavigationItem (WMStyle)
-(void)setLeftBarButtonItem:(UIImage*)image
              imageSelected:(UIImage*)imageSelected
                      title:(NSString *)title
                      inset:(UIEdgeInsets)inset
                     target:(id)target
                   selector:(SEL)selector;

-(void)setRightBarButtonItem:(UIImage*)image
               imageSelected:(UIImage*)imageSelected
                       title:(NSString *)title
                       inset:(UIEdgeInsets)inset
                      target:(id)target
                    selector:(SEL)selector;
- (void)setTitleString:(NSString *)title;
@end
