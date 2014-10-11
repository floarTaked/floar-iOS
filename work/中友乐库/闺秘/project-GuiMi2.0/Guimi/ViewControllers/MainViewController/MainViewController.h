//
//  MainViewController.h
//  Guimi
//
//  Created by jonas on 9/11/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "LoadingTableView.h"
#define ItemCount 10
@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LoadingTableViewDelegate>
{
    NSMutableArray* dataSource;
    NSMutableArray* viewSource;
    
    uint64_t minId;
    uint64_t maxId;
}
+(MainViewController*)sharedInstance;
@property(nonatomic,strong)IBOutlet LoadingTableView* mainTableView;
@end
