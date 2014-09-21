//
//  WorkListViewController.h
//  WeLinked3
//
//  Created by jonas on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileInfo.h"
@interface WorkListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView* table;
}
@property(nonatomic,strong)ProfileInfo* profileInfo;
@property(nonatomic,assign)BOOL editEnable;
@end
