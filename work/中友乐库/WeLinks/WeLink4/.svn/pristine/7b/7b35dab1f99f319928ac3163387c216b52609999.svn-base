//
//  CardDetailViewController.h
//  WeLinked4
//
//  Created by jonas on 5/26/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Card.h"
#import "RCLabel.h"
@interface CardDetailViewController : UIViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    IBOutlet UIImageView* backImageView;
    
    IBOutlet UIImageView* detailImageView;
    IBOutlet UIImageView* cardImageView;
    IBOutlet UIImageView* markImageView;
    
    IBOutlet UIView* detailView;
    IBOutlet UIView* cardView;
    IBOutlet UIView* markView;
    
    
    
    
    //具体界面细节
    IBOutlet EGOImageView* headImageView;
    IBOutlet RCLabel* detailInfo;
    
    //subview of detailImageView
    IBOutlet RCLabel* phoneLabel;
    IBOutlet RCLabel* mailLabel;
    IBOutlet RCLabel* imLabel;
    IBOutlet UILabel* addressLabel;
    
    //subview of cardImageView
    IBOutlet EGOImageView* cardImage;
    
    //subview of markImageView
    IBOutlet UILabel* recentLabel;
    IBOutlet UITextView* descView;
    IBOutlet UILabel* locationLabel;
    IBOutlet UILabel* timeLabel;
    IBOutlet UIView* lacationView;
    
}
@property(nonatomic,strong)Card* cardInfo;
@end
