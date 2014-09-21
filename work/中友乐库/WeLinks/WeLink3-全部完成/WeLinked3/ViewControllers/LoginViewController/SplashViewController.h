//
//  SplashViewController.h
//  UnNamed
//
//  Created by jonas on 9/4/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgreementViewController.h"
#import "LoginViewController.h"
#import <iCarousel/iCarousel.h>
@interface SplashViewController : UIViewController<iCarouselDataSource,iCarouselDelegate>
{
    int currentIndex;
    IBOutlet iCarousel* list;
    IBOutlet UIPageControl* pageControl;
    int pageIndex;
    NSMutableArray* items;
}
+(SplashViewController*)sharedInstance;
@end
