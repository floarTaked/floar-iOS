//
//  MMPagingScrollView.m
//  WeMeet
//
//  Created by 牟 文斌 on 8/14/13.
//  Copyright (c) 2013 Wang Ning. All rights reserved.
//

#import "MMPagingScrollView.h"

#define PADDING                 10
#define PAGE_INDEX_TAG_OFFSET   1000
#define PAGE_INDEX(page)        ([(page) tag] - PAGE_INDEX_TAG_OFFSET)

@interface MMPagingScrollView()<UIScrollViewDelegate>

@property (nonatomic, assign) CGRect visibleRect;
- (void)tilePages;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (UIView *)pageDisplayedAtIndex:(NSUInteger)index;
//- (UIView *)pageDisplayingPhoto:(id<MWPhoto>)photo;
- (UIView *)dequeueRecycledPage;
- (void)configurePage:(UIView *)page forIndex:(NSUInteger)index;
//- (void)didStartViewingPageAtIndex:(NSUInteger)index;
@end

@implementation MMPagingScrollView
{
    // Paging
	NSMutableSet *_visiblePages, *_recycledPages;
	NSUInteger _currentPageIndex;
	NSUInteger _pageIndexBeforeRotation;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[self frameForPagingScrollView:frame]];
    if (self) {
        // Initialization code
        self.visibleRect = frame;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
        self.delegate = self;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
         [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    self.viewList = nil;
    [self removeObserver:self forKeyPath:@"frame"];
    [super dealloc];
}

#pragma mark - data

-(void)setViewList:(NSMutableArray *)viewList
{
    if (_viewList != viewList) {
        [_viewList release];
        _viewList = [viewList retain];
    }
    self.contentSize = [self contentSizeForPagingScrollView];
//    [self tilePages];
    [self addAllPages];
}

#pragma mark - Frame Calculations

- (CGRect)frameForPagingScrollView:(CGRect)frame
{
//    CGRect frame = self.visibleRect;// [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    
    CGRect bounds = self.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = self.bounds;
    return CGSizeMake(bounds.size.width * self.viewList.count, bounds.size.height);
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index {
	CGFloat pageWidth = self.bounds.size.width;
	CGFloat newOffset = index * pageWidth;
	return CGPointMake(newOffset, 0);
}

#pragma mark - Paging
- (void)tilePages {
	
	// Calculate which pages should be visible
	// Ignore padding as paging bounces encroach on that
	// and lead to false page loads
	CGRect visibleBounds = self.bounds;
	int iFirstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+PADDING*2) / CGRectGetWidth(visibleBounds));
	int iLastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-PADDING*2-1) / CGRectGetWidth(visibleBounds));
    if (iFirstIndex < 0) iFirstIndex = 0;
    if (iFirstIndex > _viewList.count - 1) iFirstIndex = _viewList.count - 1;
    if (iLastIndex < 0) iLastIndex = 0;
    if (iLastIndex > _viewList.count - 1) iLastIndex = _viewList.count - 1;
	
	// Recycle no longer needed pages
    NSInteger pageIndex;
	for (UIView *page in _visiblePages) {
        pageIndex = PAGE_INDEX(page);
		if (pageIndex < (NSUInteger)iFirstIndex || pageIndex > (NSUInteger)iLastIndex) {
			[_recycledPages addObject:page];
			[page removeFromSuperview];
		}
	}
	[_visiblePages minusSet:_recycledPages];
    while (_recycledPages.count > 2) // Only keep 2 recycled pages
        [_recycledPages removeObject:[_recycledPages anyObject]];
	
	// Add missing pages
	for (NSUInteger index = (NSUInteger)iFirstIndex; index <= (NSUInteger)iLastIndex; index++) {
		if (![self isDisplayingPageForIndex:index]) {
            
            // Add new page
			UIView *page = [self dequeueRecycledPage];
			if (!page) {
				page = [self.viewList objectAtIndex:index];
			}
			[self configurePage:page forIndex:index];
			[_visiblePages addObject:page];
			[self addSubview:page];
            if ([_scrollingDelegate respondsToSelector:@selector(scrollView:willShowPageAtIndex:)]) {
                [_scrollingDelegate scrollView:self willShowPageAtIndex:index];
            }
		}
	}
	
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
	for (UIView *page in _visiblePages)
		if (PAGE_INDEX(page) == index) return YES;
	return NO;
}

- (UIView *)pageDisplayedAtIndex:(NSUInteger)index {
	UIView *thePage = nil;
	for (UIView *page in _visiblePages) {
		if (PAGE_INDEX(page) == index) {
			thePage = page; break;
		}
	}
	return thePage;
}


- (void)configurePage:(UIView *)page forIndex:(NSUInteger)index {
	page.frame = [self frameForPageAtIndex:index];
    page.tag = PAGE_INDEX_TAG_OFFSET + index;
}

- (UIView *)dequeueRecycledPage {
	UIView *page = [_recycledPages anyObject];
	if (page) {
		[[page retain] autorelease];
		[_recycledPages removeObject:page];
	}
	return page;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	// Tile pages
	
	
	// Calculate current page
	CGRect visibleBounds = self.bounds;
	int index = (int)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
	if (index > self.viewList.count - 1) index = self.viewList.count - 1;
	_currentPageIndex = index;
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self tilePages];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	// Update nav when page changes

    [self tilePages];
    CGRect visibleBounds = self.bounds;
	int index = (int)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
	if (index > self.viewList.count - 1) index = self.viewList.count - 1;
		
    if ([_scrollingDelegate respondsToSelector:@selector(scrollView:didScrollToIndex:)]) {
        [_scrollingDelegate scrollView:self didScrollToIndex:index];
    }
}

- (void)scrollToIndex:(NSInteger)index
{
    _currentPageIndex = index;
    [self jumpToPageAtIndex:index];
    [self tilePages];
}

- (void)setInitialPageIndex:(NSUInteger)index {
    // Validate
    if (index >= self.viewList.count) index = self.viewList.count-1;
    _currentPageIndex = index;
    [self tilePages];
    
    [self jumpToPageAtIndex:index];
    
}

- (void)jumpToPageAtIndex:(NSUInteger)index {
	 [self loadAdjacentPhotosIfNecessary:index];
	// Change page
	if (index < self.viewList.count) {
		CGRect pageFrame = [self frameForPageAtIndex:index];
		self.contentOffset = CGPointMake(pageFrame.origin.x - PADDING, 0);
	}
}

- (void)addAllPages
{
    for (int i = 0; i < _viewList.count; i ++) {
        UIView *page = [self dequeueRecycledPage];
        if (!page) {
            page = [self.viewList objectAtIndex: i];
        }
        [self configurePage:page forIndex:i];
        [_visiblePages addObject:page];
        [self addSubview:page];
    }
}

- (void)loadAdjacentPhotosIfNecessary:(NSInteger)index
{
//    load pre page
    if (index - 1 >= 0) {
        UIView *page = [self dequeueRecycledPage];
        if (!page) {
            page = [self.viewList objectAtIndex:index - 1];
        }
        [self configurePage:page forIndex:index - 1];
        [_visiblePages addObject:page];
        [self addSubview:page];
    }
//    load next page
    if (index < _viewList.count - 1) {
        UIView *page = [self dequeueRecycledPage];
        if (!page) {
            page = [self.viewList objectAtIndex:index + 1];
        }
        [self configurePage:page forIndex:index + 1];
        [_visiblePages addObject:page];
        [self addSubview:page];
    }
    
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.contentSize = [self contentSizeForPagingScrollView];
}
@end
