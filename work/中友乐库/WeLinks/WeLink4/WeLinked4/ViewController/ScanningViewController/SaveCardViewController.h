//
//  SaveCardViewController.h
//  WeLinked4
//
//  Created by jonas on 5/16/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import <EGOImageView.h>
#import "Card.h"
#import <MBProgressHUD.h>
@interface SaveCardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    MBProgressHUD* HUD;
    IBOutlet UIView* mainView;
    IBOutlet UIView* cardView;
    IBOutlet UIImageView* cardImage;
    IBOutlet UITableView* table;
    EGOImageView* headImageView;
    UIImage* newHeadImage;
    
    UITextField* nameFiled;
    UITextField* compFiled;
    UITextField* jobFiled;
    UITextField* addressFiled;
    UITextField* IMFiled;
    UITextField* posFiled;
}
@property(nonatomic,assign)BOOL fillInfo;
@property(nonatomic,strong)UIImage* cardCheckImage;
@property(nonatomic,strong)Card* cardInfo;
@end
