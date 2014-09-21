//
//  MessageListViewController.m
//  Welinked2
//
//  Created by jonas on 12/18/13.
//
//

#import "MessageListViewController.h"
#import "HeartBeatManager.h"
@interface MessageListViewController ()

@end

@implementation MessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back:)];
    [self.navigationItem setTitleViewWithText:@"消息"];
    source = [[NSMutableArray alloc]init];
    nullView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 200)];
    nullView.backgroundColor = [UIColor clearColor];
    UIImageView* image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NullMessage"]];
    image.center = CGPointMake(nullView.frame.size.width/2, nullView.frame.size.height/2);
    [nullView addSubview:image];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0,170, 320, 20)];
    [label setText:@"暂无消息"];
    label.textColor = [UIColor lightGrayColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = getFontWith(NO, 14);
    [nullView addSubview:label];
    [self.view addSubview:nullView];
    nullView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-100);
    nullView.hidden = YES;
    
    [self loadFromDatabase];
    [[HeartBeatManager sharedInstane] registerInvokeMethod:@"msg" callback:^(int event, id object)
     {
         int newMsg = [(NSNumber*)object intValue];
         if(newMsg > 0)
         {
             [[NetworkEngine sharedInstance] receiveUnreadMessage:^(int event, id object)
              {
                  [self loadFromNetwork];
              }];
         }
     }];
    
    
    [[NetworkEngine sharedInstance] receiveAllMessage:^(int event, id object)
    {
        if(event == 1)
        {
            if(object != nil && [object count]>0)
            {
                [self loadFromDatabase];
            }
        }
    }];
}
-(void)loadFromNetwork
{
    [[NetworkEngine sharedInstance] receiveUnreadMessage:^(int event, id object)
     {
         if(event == 1)
         {
             if(object != nil && [object count]>0)
             {
                 [self loadFromDatabase];
             }
         }
     }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadFromDatabase];
    if(timer != nil)
    {
        if([timer isValid])
        {
            [timer invalidate];
        }
    }
    timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(loadFromNetwork) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(timer != nil)
    {
        if([timer isValid])
        {
            [timer invalidate];
        }
        timer = nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadFromDatabase
{
    [source removeAllObjects];
    NSMutableArray * result =  [[UserDataBaseManager sharedInstance]
                                queryWithClass:[MessageData class]
                                tableName:nil select:@" select *, max(createTime) from "
                                condition:[NSString stringWithFormat:@" where userId='%@' group by otherUserId order by createTime desc",[UserInfo myselfInstance].userId]];
    
//    NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil
//                                                                         condition:[NSString stringWithFormat:@" where userId='%@' group by otherUserId order by createTime desc",[UserInfo myselfInstance].userId]];
    if(result != nil && [result count]>0)
    {
        for(MessageData* message in result)
        {
            [source addObject:message];
        }
        nullView.hidden = YES;
    }
    else
    {
        nullView.hidden = NO;
    }
    [table reloadData];
}
#pragma --mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(source != nil)
    {
        return [source count];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CustomCellView*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomWideCellView * cell = [[CustomWideCellView alloc] init];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    MessageData* info = [source objectAtIndex:indexPath.row];
    [self customCell:cell indexPath:indexPath info:info];
    return cell;
}
-(void)customCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath info:(MessageData*)info
{
    EGOImageView* image = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
//    image.layer.cornerRadius = 25;
    image.layer.masksToBounds = YES;
    image.placeholderImage = [UIImage imageNamed:@"defaultHead"];
    [cell.contentView addSubview:image];
    RCLabel* lbl = [[RCLabel alloc]initWithFrame:CGRectMake(75, 7, 180, 55)];
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.contentView addSubview:lbl];
    if(info != nil)
    {
        [image setImageURL:[NSURL URLWithString:info.otherAvatar]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        //colorWithHex(0x3287E6)
        NSMutableString* str = [NSMutableString string];
        [str appendString:[NSString stringWithFormat:@"<p lineSpacing=0><font color='#3287E6' face=FZLTZHK--GBK1-0>%@</font></p>\n",
                           info.otherName]];
        
        NSArray* users = [[UserDataBaseManager sharedInstance]
                          queryWithClass:[UserInfo class]
                          tableName:MyFriendsTable
                          condition:[NSString stringWithFormat:@" where DBUid='%@' and userId = '%@' ",[UserInfo myselfInstance].userId,info.otherUserId]];
        if(users != nil && [users count]>0)
        {
            UserInfo* user  = [users objectAtIndex:0];
            NSString* s = [NSString stringWithFormat:@"%@ %@",user.company,user.job];
            if([s length]>15)
            {
                s = [s substringToIndex:15];
            }
            [str appendString:[NSString stringWithFormat:@"<p lineSpacing=5><font size=12 color='#222222'>%@</font></p>\n",s]];
        }
        else
        {
            [str appendString:@"<p lineSpacing=5><font size=12 color='#222222'>暂无资料</font></p>\n"];
        }
        [str appendString:[NSString stringWithFormat:@"<p lineSpacing=0><font size=12 color='#999999'>%@</font></p>",info.text]];
        [lbl setText:str];
    }
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5, table.frame.size.width, 0.5)];
    line.backgroundColor = colorWithHex(0xE0E0E0);
    [cell.contentView addSubview:line];
    
    TipCountView* tip = [[TipCountView alloc]init];
    tip.frame = CGRectMake(50, 10, tip.frame.size.width, tip.frame.size.height);
    [cell.contentView addSubview:tip];
    int count = [[LogicManager sharedInstance] getUnReadMessageCountWithOtherUser:info.otherUserId];
    [tip setTipCount:count];
    
    UILabel* timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(255, 15, 75, 25)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:info.createTime/1000]];
    [timeLabel setText:text];
    [timeLabel setFont:getFontWith(NO, 10)];
    timeLabel.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:timeLabel];
    
    
    UIButton* deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-80, 0, 80, 70)];
    deleteButton.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:66.0/255.0 blue:63.0/255.0 alpha:1.0];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [cell.contentView addSubview:deleteButton];
    cell.contentView.userInteractionEnabled = YES;
    [deleteButton addTarget:self action:@selector(deleteMessage:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.tag = indexPath.row + 1;
    cell.contentView.tag = indexPath.row + 1;
    
    UISwipeGestureRecognizer* left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    [cell.contentView addGestureRecognizer:left];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer* right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [cell.contentView addGestureRecognizer:right];
}
-(void)deleteMessage:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int tag = btn.tag-1;
    MessageData* info = [source objectAtIndex:tag];
    NSString* otherUserId = info.otherUserId;
    
    [self.navigationController.navigationBar showLoadingIndicator];
    [[NetworkEngine sharedInstance] deleteMessage:otherUserId block:^(int event, id object)
    {
        [self.navigationController.navigationBar hideLoadingIndicator];
        if(event == 1)
        {
            //删除成功
            [MessageData deleteWith:nil condition:[NSString stringWithFormat:@" where DBUid='%@' and otherUserId='%@' ",
                                                   [UserInfo myselfInstance].userId,otherUserId]];
            [self loadFromDatabase];
        }
        else
        {
            //删除失败
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"删除失败" actionText:@"确定"];
        }
    }];

    
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    UIView* view = sender.view;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if(view.frame.origin.x == 0)
        {
            //正常状态
            //执行左划动画
            CGRect frame = view.frame;
            frame.origin.x = -80;
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.frame = frame;
            } completion:^(BOOL finished) {
            }];
        }
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if(view.frame.origin.x < 0)
        {
            //已经在左边
            //执行右划动画
            CGRect frame = view.frame;
            frame.origin.x = 0;
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.frame = frame;
            } completion:^(BOOL finished) {
            }];
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [table deselectRowAtIndexPath:indexPath animated:YES];
    MessageData* info = [source objectAtIndex:indexPath.row];
    ChatViewController* chat = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    chat.otherName = info.otherName;
    chat.otherUserId = info.otherUserId;
    chat.otherAvatar = info.otherAvatar;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}
@end
