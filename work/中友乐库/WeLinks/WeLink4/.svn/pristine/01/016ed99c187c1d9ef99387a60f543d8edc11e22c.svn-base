//
//  ProfileViewController.h
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MBProgressHUD.h>
#import <EGOImageView.h>
#import "RCLabel.h"
#import "ProfileInfo.h"
@interface OtherProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet EGOImageView* headImageView;
    IBOutlet RCLabel* descLabel;
    IBOutlet UIView* headView;
    IBOutlet UITableView* table;
    IBOutlet UIButton* phoneButton;
    IBOutlet UIButton* messageButton;
    IBOutlet UIButton* emailButton;
    IBOutlet UIButton* addFriendButton;
    
    ProfileInfo* profileInfo;
    MBProgressHUD* HUD;
    BOOL haveSameFriend;
}
@property(nonatomic,assign)int userId;
@end
