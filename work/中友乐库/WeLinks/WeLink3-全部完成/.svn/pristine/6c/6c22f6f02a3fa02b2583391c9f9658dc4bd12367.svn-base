//
//  AddContactsViewController.h
//  WeLinked3
//
//  Created by jonas on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MBProgressHUD.h>
#import "MMPagingScrollView.h"
@interface AddFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MMPagingScrollViewDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UITableView* contactList;
    IBOutlet UITableView* weiboList;
    IBOutlet UITableView* linkedinList;
    
    
    IBOutlet UIView* segementView;
    IBOutlet UIImageView* segementBackground;
    int dataType;
    
    NSMutableArray* contactsDataSource;
    NSMutableArray* weiboDataSource;
    NSMutableArray* linkedinDataSource;
    
    
    NSMutableDictionary* contactUsersDic;
    MMPagingScrollView *scrollView;
    MFMessageComposeViewController *messageController;
    
    
    MBProgressHUD* HUD;
}
@end
