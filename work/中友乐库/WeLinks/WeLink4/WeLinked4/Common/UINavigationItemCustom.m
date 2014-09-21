//
//  UINavigationItem+WMStyle.m
//  WeMeet
//
//  Created by Riley on 7/22/13.
//  Copyright (c) 2013 Wang Ning. All rights reserved.
//

#import "UINavigationItemCustom.h"
#define kIndicatorTag 10000

@implementation UINavigationBar (Loading)
- (void)showLoading
{
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:kIndicatorTag];
    if(indicator == nil)
    {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.x = 60;
        indicator.y = 10;
        indicator.hidesWhenStopped = YES;
        indicator.tag = kIndicatorTag;
        [self addSubview:indicator];
    }
    [indicator startAnimating];
}

- (void)hideLoading
{
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:kIndicatorTag];
    [indicator stopAnimating];
}
@end


@implementation UINavigationItem (WMStyle)

-(UIBarButtonItem*)getUIBarButtonItem:(UIImage*)image
                        imageSelected:(UIImage*)imageSelected
                                title:(NSString*)title
                                inset:(UIEdgeInsets)inset
                               target:(id)target
                             selector:(SEL)selector
{
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
        if(image != nil)
        {
            customBtn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
        else
        {
            customBtn.frame = CGRectMake(0, 0, 58, 30);
        }
    }
    if (title && ![title isEqualToString:@""])
    {
        [customBtn setTitle:title forState:UIControlStateNormal];
        [customBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        customBtn.titleLabel.shadowColor = [UIColor lightGrayColor];
        customBtn.titleLabel.shadowOffset = CGSizeMake(0, 1.0);
//        customBtn.titleLabel.highlightedTextColor = [UIColor lightGrayColor];
        [customBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [customBtn setTitleColor:colorWithHex(0x66FFFF) forState:UIControlStateNormal];
    }
    else
    {
        [customBtn setContentEdgeInsets:inset];
        [customBtn setImage:image forState:UIControlStateNormal];
        [customBtn setImage:imageSelected forState:UIControlStateHighlighted];
    }
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    return barBtnItem;
}
-(void)setLeftBarButtonItem:(UIImage*)image
              imageSelected:(UIImage*)imageSelected
                      title:(NSString *)title
                      inset:(UIEdgeInsets)inset
                     target:(id)target
                   selector:(SEL)selector
{
    self.leftBarButtonItem = [self getUIBarButtonItem:image imageSelected:imageSelected
                                                title:title inset:inset
                                               target:target selector:selector];
    if (title.length > 0)
    {
        if ([self.leftBarButtonItem.customView isKindOfClass:[UIButton class]] && isSystemVersionIOS7())
        {
            [(UIButton *)self.leftBarButtonItem.customView setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        }
    }
}
-(void)setRightBarButtonItem:(UIImage*)image
               imageSelected:(UIImage*)imageSelected
                       title:(NSString *)title
                       inset:(UIEdgeInsets)inset
                      target:(id)target
                    selector:(SEL)selector
{
    self.rightBarButtonItem = [self getUIBarButtonItem:image imageSelected:imageSelected
                                                 title:title inset:inset
                                                target:target selector:selector];
    if (title.length > 0)
    {
        if ([self.rightBarButtonItem.customView isKindOfClass:[UIButton class]] && isSystemVersionIOS7())
        {
            [(UIButton *)self.rightBarButtonItem.customView setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
        }
    }
}

- (void)setTitleString:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = getFontWith(YES, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    //    titleLabel.shadowColor = [UIColor blackColor];
    //    titleLabel.shadowOffset = CGSizeMake(0, 1.0);
    [titleLabel sizeToFit];
    self.titleView = titleLabel;
}

@end
