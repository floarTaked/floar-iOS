//
//  NewFriendViewController.h
//  WeLinked4
//
//  Created by jonas on 5/30/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView* table;
    NSMutableArray* dataSource;
}
@end
