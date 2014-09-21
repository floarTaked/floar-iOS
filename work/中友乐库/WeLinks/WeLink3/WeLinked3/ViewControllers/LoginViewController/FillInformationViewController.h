//
//  FillInformationViewController.h
//  WeLinked3
//
//  Created by jonas on 3/5/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerView.h"
#import "NetworkEngine.h"
#import "AutoScrollUITextField.h"
#import <EGOImageView.h>
#import <MBProgressHUD.h>
@interface FillInformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD* HUD;
    IBOutlet UITableView* table;
    CustomPickerView* pikerView;
    UITextField* nameTextFiled;
    UITextField* companyTextFiled;
    UIImage* newHeadImage;
    EGOImageView* headImageView;
}
@end
