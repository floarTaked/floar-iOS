//
//  PullingRefreshTableView.m
//  SlimeRefresh
//
//  Created by 牟 文斌 on 9/7/13.
//  Copyright (c) 2013 zrz. All rights reserved.
//

#import "LoadingTableView.h"
#import "RefreshView.h"
#import "LoadMoreView.h"
#define kPROffsetY 60.f

@interface LoadingTableView()<RefreshDelegate,LoadMoreDelegate>
{
    RefreshView *_refreshView;
    LoadMoreView* _loadMoreView;
}

@end

@implementation LoadingTableView
- (void)awakeFromNib
{
    [self initUI];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    _refreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    _refreshView.delegate = self;
    _refreshView.upInset = 0;
    _refreshView.backgroundColor = [UIColor clearColor];
    [self addSubview:_refreshView];
    
    _loadMoreView = [[LoadMoreView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-REFRESH_REGION_HEIGHT,
                                                                  self.frame.size.width, REFRESH_REGION_HEIGHT)];
    _loadMoreView.delegate = self;
    [self addSubview:_loadMoreView];
    _loadMoreView.loading = NO;
    _loadMoreView.hidden = NO;
}
- (void)setShowFooter:(BOOL)showFooter
{
    _loadMoreView.hidden = !showFooter;
}



#pragma mark - Scroll delegate
- (void)tableViewDidScroll:(UIScrollView *)scrollView
{
    [self bringSubviewToFront:_refreshView];
    [_refreshView scrollViewDidScroll];
    [_loadMoreView scrollViewDidScroll];
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView
{
    [_refreshView scrollViewDidEndDraging];
    [_loadMoreView scrollViewDidEndDraging];
}

- (void)tableViewDidFinishedLoading
{
    [_refreshView endRefresh];
    [_loadMoreView endLoading];
}
#pragma mark - Refresh delegate

- (void)refreshStart:(RefreshView *)refreshView
{
    if ([_pullingDelegate respondsToSelector:@selector(didStartRefreshing:)])
    {
        [_pullingDelegate didStartRefreshing:self];
    }
}
#pragma mark -
#pragma mark LoadMoreDelegate Methods
-(void)loadMoreStart:(LoadMoreView *)loadingView
{
    if ([_pullingDelegate respondsToSelector:@selector(didStartLoading:)])
    {
        [_pullingDelegate didStartLoading:self];
    }
}
@end
