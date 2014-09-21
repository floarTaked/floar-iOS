//
//  MessageListViewController.h
//  Welinked2
//
//  Created by jonas on 12/18/13.
//
//

#import "MessageData.h"

#import "NetworkEngine.h"
#import "CustomCellView.h"
#import "RCLabel.h"
#import "DataBaseManager.h"

#import "ChatViewController.h"
#import "TipCountView.h"
@interface MessageListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView* table;
    NSMutableArray* source;
    NSTimer* timer;
    UIView* nullView;
}
@end
