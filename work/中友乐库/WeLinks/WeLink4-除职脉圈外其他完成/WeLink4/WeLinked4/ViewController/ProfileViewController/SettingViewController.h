//
//  SettingViewController.h
//  UnNamed
//
//  Created by jonas on 8/7/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkEngine.h"
#import "DataBaseManager.h"
#import "EGOImageView.h"
#import "AboutViewController.h"
#import "CustomCellView.h"

@interface SettingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView* table;
}
-(void)cleanup;
@end
