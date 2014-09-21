//
//  NewFriendsViewController.h
//  WeLinked3
//
//  Created by jonas on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "RCLabel.h"
#import "ExtraButton.h"
@interface NewFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView* table;
    NSMutableArray* dataSource;
}
@end
