//
//  PullingRefreshTableView.h
//  SlimeRefresh
//
//  Created by 牟 文斌 on 9/7/13.
//  Copyright (c) 2013 zrz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PullRefreshTableView;
@protocol PullRefreshTableViewDelegate <NSObject>

@required
- (void)pullingTableViewDidStartRefreshing:(PullRefreshTableView *)tableView;

@optional
//Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullRefreshTableView *)tableView;
//Implement the follows to set date you want,Or Ignore them to use current date
- (NSDate *)pullingTableViewRefreshingFinishedDate;
- (NSDate *)pullingTableViewLoadingFinishedDate;
@end

@interface PullRefreshTableView : UITableView
@property (nonatomic, assign) id<PullRefreshTableViewDelegate> pullingDelegate;
@property (nonatomic, assign) BOOL showFooter;
@property (nonatomic, assign) BOOL showSuccessLabel;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;

- (void)tableViewDidFinishedLoading;

@end
