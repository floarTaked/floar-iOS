//
//  FriendsViewController.h
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "RCLabel.h"
#import "CustomCellView.h"
#import "UserInfo.h"
#import "LogicManager.h"
#import "EGORefreshTableFooterView.h"
#import "MMPagingScrollView.h"
@interface FriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,MMPagingScrollViewDelegate>
{
    MBProgressHUD* HUD;
    IBOutlet UITableView* friendList;
//    IBOutlet UITableView* companyList;
//    IBOutlet UITableView* postList;
    
//    IBOutlet UIView* segmentNav;
    IBOutlet UIView* tableHeaderView;
//    IBOutlet UIImageView* segementBackground;
//    IBOutlet UIButton* leftButton;
//    IBOutlet UIButton* middleButton;
//    IBOutlet UIButton* rightButton;
    NSMutableArray* unKnowDataSource;
//    int dataType;//0: 全部 1: 公司 2: 职位
//    NSMutableArray* companyDataSource;
//    NSMutableArray* postDataSource;
    int pageNumber;
    EGORefreshTableFooterView* _refreshFooterView;
    MMPagingScrollView *scrollView;
}
@end
