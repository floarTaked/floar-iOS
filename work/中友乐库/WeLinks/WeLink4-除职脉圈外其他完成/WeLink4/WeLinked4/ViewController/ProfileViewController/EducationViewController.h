//
//  EducationViewController.h
//  WeLinked3
//
//  Created by jonas on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EducationInfo.h"
#import "DatePikerView.h"
#import "UIPlaceHolderTextView.h"
#import "CustomPickerView.h"
@interface EducationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView* table;
    UITextField* timeTextFiled;
    UIPlaceHolderTextView* descTextView;
    UITextField* educationTextFiled;
    UITextField* specialTextFiled;
    UITextField* schoolTextFiled;
    UILabel* wordCountLabel;
    DatePikerView* datePiker;
    CustomPickerView* pikerView;
    BOOL newEducation;
    EventCallBack callBack;
}
-(void)setCallback:(EventCallBack)call;
@property(nonatomic,strong)EducationInfo* educationInfo;
@property(nonatomic,assign)BOOL editEnable;
@end
