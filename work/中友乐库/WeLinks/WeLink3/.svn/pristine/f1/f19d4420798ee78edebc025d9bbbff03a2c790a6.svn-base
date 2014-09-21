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
#import "RCLabel.h"
#import "ProfileInfo.h"
@interface OtherProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    IBOutlet EGOImageView* headImageView;
    IBOutlet RCLabel* descLabel;
    IBOutlet UIView* headView;
    IBOutlet UILabel* locationLabel;
    IBOutlet UITableView* table;
    IBOutlet UIButton* actionButton;
    ProfileInfo* profileInfo;
    MBProgressHUD* HUD;
    BOOL haveSameFriend;
}
@property(nonatomic,strong)NSString* userId;
@end
