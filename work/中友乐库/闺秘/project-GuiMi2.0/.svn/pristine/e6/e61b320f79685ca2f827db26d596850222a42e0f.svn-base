//
//  PullingRefreshTableView.h
//  SlimeRefresh
//
//  Created by 牟 文斌 on 9/7/13.
//  Copyright (c) 2013 zrz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoadingTableView;
@protocol LoadingTableViewDelegate <NSObject>
@required
- (void)didStartRefreshing:(LoadingTableView *)tableView;
- (void)didStartLoading:(LoadingTableView *)tableView;
@end

@interface LoadingTableView : UITableView
{
    
}
@property (nonatomic, assign) id<LoadingTableViewDelegate> pullingDelegate;
- (void)tableViewDidScroll:(UIScrollView *)scrollView;
- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;
- (void)tableViewDidFinishedLoading;
@end
