//
//  SplashViewController.h
//  WeLinked4
//
//  Created by jonas on 5/12/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController
{
    IBOutlet UIImageView* bkImageView;
    IBOutlet UIButton* start;
    BOOL selected;
}
+(SplashViewController*)sharedInstance;
@end
