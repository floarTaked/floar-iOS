//
//  WorkViewController.h
//  WeLinked3
//
//  Created by jonas on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkInfo.h"
#import "DatePikerView.h"
#import "UIPlaceHolderTextView.h"
#import "LogicManager.h"
#import "CustomPickerView.h"
@interface WorkViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView* table;
    UILabel* wordCountLabel;
    
    UITextField* companyTextFiled;
    UITextField* postTextFiled;
    UITextField* timeTextFiled;
    UIPlaceHolderTextView* descTextFiled;
    DatePikerView* datePiker;
    CustomPickerView* pikerView;
    EventCallBack callBack;
    BOOL newWork;
}
-(void)setCallback:(EventCallBack)call;
@property(nonatomic,strong)WorkInfo* workInfo;
@property(nonatomic,assign)BOOL editEnable;
@end
