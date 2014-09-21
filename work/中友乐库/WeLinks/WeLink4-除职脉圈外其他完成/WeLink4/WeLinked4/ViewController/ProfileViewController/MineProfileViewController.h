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
#import "SettingViewController.h"
#import <MBProgressHUD.h>
@interface MineProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    IBOutlet EGOImageView* headImageView;
    IBOutlet RCLabel* descLabel;
    IBOutlet UIView* headView;
    IBOutlet UITableView* table;
    
    IBOutlet UIView* activeView;
    IBOutlet UIActivityIndicatorView* indicator;
    ProfileInfo* profileInfo;
    
//    CustomPickerView* pikerView;
    MBProgressHUD* HUD;
    
//    TipCountView* messageTipCountView;
//    TipCountView* contactTipCountView;
}
-(void)showBackButton;
@end
