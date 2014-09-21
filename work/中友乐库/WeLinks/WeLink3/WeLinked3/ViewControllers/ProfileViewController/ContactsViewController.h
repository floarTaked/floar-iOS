//
//  ContactsViewController.h
//  WeLinked3
//
//  Created by jonas on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipCountView.h"
#import "CustomCellView.h"
#import "UserInfo.h"
#import "ChineseToPinyin.h"
#import "HeartBeatManager.h"
@interface ContactsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    IBOutlet UITableView* table;
    IBOutlet UIImageView* noFriendView;
    NSMutableArray* dataSource;
    NSMutableArray* keyArray;
    NSMutableArray* searchResult;
    NSMutableDictionary* friendsData;
    TipCountView* tipCountView;
}
@end
