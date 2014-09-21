//
//  ListView.h
//  ListView
//
//  Created by jonas on 12/4/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MessageData.h"
#import "SnapMessageItem.h"
#import "SnapMessageData.h"
@interface MessageView : UITableView<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray* source;
    EventCallBack call;
}
@property(nonatomic,strong)NSMutableArray* source;
-(void)setCallBack:(EventCallBack)callBack;
@end
