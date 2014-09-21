//
//  UINavigationBar+Loading.m
//  WeLinked3
//
//  Created by 牟 文斌 on 3/4/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "UINavigationBar+Loading.h"

#define kIndicatorTag 10000

@implementation UINavigationBar (Loading)
- (void)showLoadingIndicator
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

- (void)hideLoadingIndicator
{
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:kIndicatorTag];
    [indicator stopAnimating];
}
@end
