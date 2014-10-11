//
//  SplashViewController.h
//  WeLinked4
//
//  Created by jonas on 5/12/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>
@interface SplashViewController : UIViewController<UIScrollViewDelegate,iCarouselDataSource,iCarouselDelegate>
{
    int currentIndex;
    IBOutlet iCarousel* list;
    IBOutlet UIPageControl* pageControl;
    IBOutlet UIButton* leftButton;
    IBOutlet UIButton* rightButton;
    IBOutlet UIButton* startButton;
    int pageIndex;
    NSMutableArray* items;
}
+(SplashViewController*)sharedInstance;
@end
