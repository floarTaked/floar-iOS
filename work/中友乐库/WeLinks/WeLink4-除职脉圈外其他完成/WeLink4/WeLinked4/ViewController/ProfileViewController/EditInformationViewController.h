//
//  EditInformationViewController.h
//  WeLinked4
//
//  Created by jonas on 5/22/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
#import "ProfileInfo.h"
#import "DatePikerView.h"
#import "CustomPickerView.h"
@interface EditInformationViewController : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    IBOutlet UITableView* table;
    UITextField* nameFiled;
    UITextField* companyFiled;
    UITextField* postFiled;
    UITextField* mailFiled;
    UITextField* addressFiled;
    
    EGOImageView* headImageView;
    
    DatePikerView* datePiker;
    CustomPickerView* pikerView;
    
    UIImage* newHeadImage;
}
@property(nonatomic,strong)ProfileInfo* profileInfo;
@end
