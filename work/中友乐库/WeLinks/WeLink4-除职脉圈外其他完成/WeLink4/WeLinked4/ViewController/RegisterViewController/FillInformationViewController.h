//
//  FillInformationViewController.h
//  WeLinked4
//
//  Created by jonas on 5/19/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EGOImageView.h>
#import <MBProgressHUD.h>
@interface FillInformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UITableView* table;
    UITextField* nameFiled;
    UITextField* companyFiled;
    UITextField* jobFiled;
    EGOImageView* headImageView;
    MBProgressHUD* HUD;
    UIImage* newHeadImage;
}
@end
