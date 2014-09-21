//
//  ProfileViewController.h
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"
#import "ProfileInfo.h"
#import "OtherProfileViewController.h"
#import "LogicManager.h"
#import "ImageEditorViewController.h"
#import "EditInformationViewController.h"
#import "SettingViewController.h"
#import "ContactsViewController.h"
#import "MyPublishViewController.h"
#import "WorkInfo.h"
#import "EducationInfo.h"
#import "CustomPickerView.h"
#import "UINavigationBar+Loading.h"
#import "PublicObject.h"
#import <MBProgressHUD.h>
#import "WebViewViewController.h"
#import "TagViewController.h"
@interface MineProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    IBOutlet EGOImageView* headImageView;
    IBOutlet RCLabel* descLabel;
    IBOutlet UIImageView* camImage;
    IBOutlet UIView* headView;
    IBOutlet UILabel* locationLabel;
    IBOutlet UITableView* table;
    
    IBOutlet UIView* activeView;
    IBOutlet UIActivityIndicatorView* indicator;
    ProfileInfo* profileInfo;
    
    CustomPickerView* pikerView;
    MBProgressHUD* HUD;
    
    TipCountView* messageTipCountView;
    TipCountView* contactTipCountView;
}
-(void)showBackButton;
@end
