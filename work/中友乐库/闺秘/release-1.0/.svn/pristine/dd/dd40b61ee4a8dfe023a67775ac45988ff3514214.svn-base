//
//  PullingRefreshTableView.m
//  SlimeRefresh
//
//  Created by 牟 文斌 on 9/7/13.
//  Copyright (c) 2013 zrz. All rights reserved.
//

#import "PullRefreshTableView.h"
#import "SRRefreshView.h"
#import "EGORefreshTableFooterView.h"

#define kPROffsetY 60.f

@interface PullRefreshTableView()<SRRefreshDelegate,EGORefreshTableDelegate>
{
    SRRefreshView *_slimeView;
    EGORefreshTableFooterView* _refreshFooterView;
    BOOL _footerLoading;
}

@end

@implementation PullRefreshTableView
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

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.contentSize"];
}


- (void)initUI
{
    _slimeView = [[SRRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor darkGrayColor];
    _slimeView.slime.skinColor = [UIColor lightGrayColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor darkGrayColor];
    _slimeView.backgroundColor = [UIColor clearColor];
//    _slimeView.showSuccessLable = YES;
    [self addSubview:_slimeView];
    
    _refreshFooterView = [[EGORefreshTableFooterView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-REFRESH_REGION_HEIGHT,
                                                                                    self.frame.size.width, REFRESH_REGION_HEIGHT)];
    _refreshFooterView.delegate = self;
    _refreshFooterView.backgroundColor = [UIColor clearColor];
    [self addSubview:_refreshFooterView];
    _refreshFooterView.loading = NO;
    _refreshFooterView.hidden = NO;
    _footerLoading = NO;
    
    [self addObserver:self forKeyPath:@"self.contentSize" options:NSKeyValueObservingOptionNew context:nil];

}
- (void)setShowSuccessLabel:(BOOL)showSuccessLabel
{
    _showSuccessLabel = showSuccessLabel;
//    _slimeView.showSuccessLable = _showSuccessLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setShowFooter:(BOOL)showFooter
{
    _showFooter = showFooter;
    _refreshFooterView.hidden = !_showFooter;
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if ([_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartRefreshing:)]) {
        [_pullingDelegate pullingTableViewDidStartRefreshing:self];
    }
}


- (void)tableViewDidScroll:(UIScrollView *)scrollView
{
    [self bringSubviewToFront:_slimeView];
    [_slimeView scrollViewDidScroll];
//    CGPoint offset = scrollView.contentOffset;
//    CGSize size = scrollView.frame.size;
//    CGSize contentSize = scrollView.contentSize;
//    float yMargin = offset.y - contentSize.height + size.height;
//    if (contentSize.height > self.height && yMargin > 0 ) {
//         [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
//    }
    _refreshFooterView.y = MAX(scrollView.contentSize.height, self.height);
    if (scrollView.contentSize.height < self.height) {
        _refreshFooterView.hidden = YES;
    }else{
        _refreshFooterView.hidden = NO;
    }
//    if (yMargin > kPROffsetY && !_footerLoading) {
//        _footerLoading = YES;
//        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartLoading:)]) {
//            [_pullingDelegate pullingTableViewDidStartLoading:self];
//        }
//
//    }
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidEndDraging];
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)tableViewDidFinishedLoading
{
    [_slimeView endRefresh];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    _refreshFooterView.loading = NO;
    _footerLoading = NO;
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if (!_footerLoading) {
        _footerLoading = YES;
        //如果是4inch加上这个判断，下拉加载更多失效
//        if (self.contentSize.height < self.height) {
//            _footerLoading = NO;
//            return;
//        }
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartLoading:)]) {
            [_pullingDelegate pullingTableViewDidStartLoading:self];
        }
        
    }
}
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
	if(_refreshFooterView)
    {
        return _refreshFooterView.loading;
    }
	return NO;
}
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	return [NSDate date];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.contentSize"]) {
         _refreshFooterView.y = MAX(self.contentSize.height, self.height);
        _refreshFooterView.hidden = !self.contentSize.height > self.height ;
    }
}
@end
