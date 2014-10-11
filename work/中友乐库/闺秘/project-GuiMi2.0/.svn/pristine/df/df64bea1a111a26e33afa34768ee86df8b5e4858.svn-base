//
//  LoadMoreView.h
//  Guimi
//
//  Created by jonas on 9/12/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  REFRESH_REGION_HEIGHT 44.0f
@protocol LoadMoreDelegate;
@interface LoadMoreView : UIView
{
    UILabel* loadingLabel;
    UIActivityIndicatorView* indicatorView;
}
@property (nonatomic, assign)   CGFloat upInset;
@property (nonatomic, assign)   BOOL    loading;
@property (nonatomic, assign)   id<LoadMoreDelegate>   delegate;


- (void)scrollViewDidScroll;
- (void)scrollViewDidEndDraging;
-(void)endLoading;
@end

@protocol LoadMoreDelegate <NSObject>
@optional
- (void)loadMoreStart:(LoadMoreView*)loadingView;
@end