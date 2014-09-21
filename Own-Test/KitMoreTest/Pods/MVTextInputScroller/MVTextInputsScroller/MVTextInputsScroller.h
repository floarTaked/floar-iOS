//
// Created by Andrea Bizzotto on 25/03/2014.
// Copyright (c) 2014 musevisions. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Class to automatically handle the scrolling of content on a UIScrollView so that any selected
 input fields are always visible on screen
 */

@interface MVTextInputsScroller : NSObject

- (id)initWithScrollView:(UIScrollView *)scrollView;

// To be called within [dealloc] method of client calling code. Ensures observers are unregistered safely internally before tear-down.
- (void)unregister;
@end