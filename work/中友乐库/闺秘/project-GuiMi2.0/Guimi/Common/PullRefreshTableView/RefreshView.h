//
//  RefreshView.h
//  Guimi
//
//  Created by jonas on 9/12/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RefreshDelegate;

@interface RefreshView : UIView
{
    UIImageView     *_refleshView;
    UIScrollView    *_scrollView;
}
@property (nonatomic, assign)   CGFloat upInset;
@property (nonatomic, assign)   BOOL    loading;
@property (nonatomic, strong, readonly) UIImageView *refleshView;
@property (nonatomic, assign)   id<RefreshDelegate>   delegate;


- (void)scrollViewDidScroll;
- (void)scrollViewDidEndDraging;
- (void)endRefresh;
@end


@protocol RefreshDelegate <NSObject>
@optional
- (void)refreshStart:(RefreshView*)refreshView;
@end