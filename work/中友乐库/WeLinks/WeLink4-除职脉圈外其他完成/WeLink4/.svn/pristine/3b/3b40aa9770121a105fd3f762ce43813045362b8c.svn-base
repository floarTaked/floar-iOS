//
//  MMPagingScrollView.h
//  WeMeet
//
//  Created by 牟 文斌 on 8/14/13.
//  Copyright (c) 2013 Wang Ning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMPagingScrollView;
@protocol MMPagingScrollViewDelegate <NSObject>
@optional
- (void) scrollView:(MMPagingScrollView *)scrollView didScrollToIndex:(NSInteger)index;
- (void) scrollView:(MMPagingScrollView *)scrollView willShowPageAtIndex:(NSInteger)index;
@end

@interface MMPagingScrollView : UIScrollView
@property (nonatomic, retain) NSMutableArray *viewList;
@property (nonatomic, assign) id<MMPagingScrollViewDelegate> scrollingDelegate;
- (id)initWithFrame:(CGRect)frame;
- (void)scrollToIndex:(NSInteger)index;
- (void)setInitialPageIndex:(NSUInteger)index;
@end
