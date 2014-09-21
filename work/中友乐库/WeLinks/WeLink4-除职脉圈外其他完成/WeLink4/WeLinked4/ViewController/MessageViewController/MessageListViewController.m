//
//  MessageListViewController.m
//  Welinked2
//
//  Created by jonas on 12/18/13.
//
//

#import "MessageListViewController.h"
#import "HeartBeatManager.h"
#import "ContactsViewController.h"
#import "InviteFriendsViewController.h"
#import "TipCountView.h"
#import "NewFriendViewController.h"
#import "NetworkEngine.h"
#import "ExtraButton.h"
@interface MessageListViewController ()

@end

@implementation MessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tabBarItem.image = [UIImage imageNamed:@"msg"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"msgSelected"];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        self.title = nil;
        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorWithHex(NAVBARCOLOR),
                                                 UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"contacts"]
                                imageSelected:[UIImage imageNamed:@"contacts"]
                                        title:nil
                                        inset:UIEdgeInsetsMake(0, -30, 0, 0)
                                       target:self
                                     selector:@selector(goToLinkersViewCtl)];
    [self.navigationItem setRightBarButtonItem:[UIImage imageNamed:@"addContacts"]
                                 imageSelected:[UIImage imageNamed:@"addContacts"]
                                         title:nil
                                         inset:UIEdgeInsetsMake(0, 0, 0, -30)
                                        target:self
                                      selector:@selector(gotoInviteViewCtl)];
    [self.navigationItem setTitleString:@"消息"];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
    NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class]
                                                              tableName:nil
                                                              condition:[NSString stringWithFormat:@" where userId=%d ",[UserInfo myselfInstance].userId]];
    if(arr == nil || [arr count]<=0)
    {
        [self.navigationController.navigationBar showLoading];
        [[NetworkEngine sharedInstance] getMessages:@"1" block:^(int event, id object)
        {
            [self.navigationController.navigationBar hideLoading];
            if(event == 1)
            {
                if(object != nil && [object count]>0)
                {
                    [self loadFromDatabase];
                }
            }
        }];
    }
    else
    {
        [self loadFromDatabase];
    }
    [[HeartBeatManager sharedInstane] registerInvokeMethod:@"msg" callback:^(int event, id object)
     {
         int newMsg = [(NSNumber*)object intValue];
         if(newMsg > 0)
         {
             //isAll：1   是最近20天的全部消息  0   是所有未读信息
             [self loadFromNetwork];
         }
     }];
}
-(void)gotoContacts:(id)sender
{
    
}
-(void)addFriend:(id)sender
{
    
}
-(void)loadFromNetwork
{
    [[NetworkEngine sharedInstance] getMessages:@"0" block:^(int event, id object)
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
                                condition:[NSString stringWithFormat:@" where userId=%d and msgType<5 group by otherUserId order by createTime desc",[UserInfo myselfInstance].userId]];
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
        return [source count]+1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Head"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [self customHead:cell];
        return cell;
    }
    else
    {
        CustomWideCellView * cell = [[CustomWideCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        MessageData* info = [source objectAtIndex:indexPath.row-1];
        [self customCell:cell indexPath:indexPath info:info];
        return cell;
    }
}
-(void)customHead:(UITableViewCell*)cell
{
    UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 60, 60)];
    image.layer.masksToBounds = YES;
    image.image = [UIImage imageNamed:@"shareCard"];
    [cell.contentView addSubview:image];
    
    RCLabel* lbl = [[RCLabel alloc]initWithFrame:CGRectMake(85, 20, 180, 60)];
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.contentView addSubview:lbl];
    [lbl setBackgroundColor:[UIColor clearColor]];
    
    NSMutableString* str = [NSMutableString string];
    [str appendString:@"<p lineSpacing=3><font color='#000000' size=14 face=FZLTZHK--GBK1-0>新的联系人</font></p>\n"];
    NSString* sql2 = [NSString stringWithFormat:@" where DBUid=%d and userId = %d and msgType=5 order by createTime desc limit 1 offset 0",
                     [UserInfo myselfInstance].userId,
                     [UserInfo myselfInstance].userId];
    
    NSArray* dataArray = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil condition:sql2];
    MessageData* data = nil;
    if(dataArray != nil && [dataArray count]>0)
    {
        data = [dataArray objectAtIndex:0];
    }
    if(data != nil)
    {
        [str appendString:[NSString stringWithFormat:@"<p lineSpacing=5><font size=12 color='#999999'>%@申请加你为联系人</font></p>\n",
                           data.otherName]];
    }
    else
    {
        [str appendString:@"<p lineSpacing=5><font size=12 color='#999999'>暂无联系人申请</font></p>\n"];
    }
    [lbl setText:str];
    
    NSString* sql = [NSString stringWithFormat:@" where DBUid=%d and userId=%d and status=0 and msgType=5 ",
                     [UserInfo myselfInstance].userId,
                     [UserInfo myselfInstance].userId];
    NSArray* unReadRequest = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil condition:sql];
    TipCountView* tip = [[TipCountView alloc]init];
    tip.center = CGPointMake(image.frame.origin.x + image.frame.size.width-2, image.frame.origin.y+2);
    [cell.contentView addSubview:tip];
    [tip setTipCount:[unReadRequest count]];
    
    UILabel* timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(255, 5, 75, 25)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:data.createTime/1000]];
    [timeLabel setText:text];
    [timeLabel setFont:getFontWith(NO, 10)];
    timeLabel.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:timeLabel];
}
-(void)customCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath info:(MessageData*)info
{
    EGOImageView* image = [[EGOImageView alloc]initWithFrame:CGRectMake(15, 10, 60, 60)];
//    image.layer.cornerRadius = 25;
    image.layer.masksToBounds = YES;
    image.placeholderImage = [UIImage imageNamed:@"defaultHead"];
    [cell.contentView addSubview:image];
    RCLabel* lbl = [[RCLabel alloc]initWithFrame:CGRectMake(85, 10, 180, 60)];
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.contentView addSubview:lbl];
    if(info != nil)
    {
        [image setImageURL:[NSURL URLWithString:info.otherAvatar]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        //colorWithHex(0x3287E6)
        NSMutableString* str = [NSMutableString string];
        [str appendString:[NSString stringWithFormat:@"<p lineSpacing=4><font size=14 color='#3287E6' face=FZLTZHK--GBK1-0>%@</font></p>\n",info.otherName]];
        NSString* s = @"";
        if(info.job == nil || [info.job length]<=0)
        {
            s = [NSString stringWithFormat:@"%@",info.company];
        }
        else
        {
            s = [NSString stringWithFormat:@"%@ | %@",info.job,info.company];
        }
        if([s length]>15)
        {
            s = [s substringToIndex:15];
        }
        [str appendString:[NSString stringWithFormat:@"<p lineSpacing=4><font size=14 color='#999999'>%@</font></p>\n",s]];
        [str appendString:[NSString stringWithFormat:@"<p lineSpacing=0><font size=14 color='#999999'>%@</font></p>",info.text]];
        [lbl setText:str];
    }
    
    TipCountView* tip = [[TipCountView alloc]init];
    tip.center = CGPointMake(image.frame.origin.x + image.frame.size.width-2, image.frame.origin.y+2);
    [cell.contentView addSubview:tip];
    int count = [[LogicManager sharedInstance] getUnReadMessageCountWithOtherUser:info.otherUserId];
    [tip setTipCount:count];
    
    UILabel* timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(255, 5, 75, 25)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:info.createTime/1000]];
    [timeLabel setText:text];
    [timeLabel setFont:getFontWith(NO, 10)];
    timeLabel.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:timeLabel];
    
    
    ExtraButton* deleteButton = [[ExtraButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-80, 0, 80, 80)];
    deleteButton.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:66.0/255.0 blue:63.0/255.0 alpha:1.0];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [cell.contentView addSubview:deleteButton];
    cell.contentView.userInteractionEnabled = YES;
    [deleteButton addTarget:self action:@selector(deleteMessage:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.extraData = info;
    
    UISwipeGestureRecognizer* left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    [cell.contentView addGestureRecognizer:left];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer* right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [cell.contentView addGestureRecognizer:right];
}
-(void)deleteMessage:(id)sender
{
    ExtraButton* btn = (ExtraButton*)sender;
    MessageData* info = (MessageData*)btn.extraData;
    int otherUserId = info.otherUserId;
    [[NetworkEngine sharedInstance] deleteMessage:otherUserId block:^(int event, id object)
    {
        if(event == 1)
        {
            //删除成功
            [MessageData deleteWith:nil condition:[NSString stringWithFormat:@" where DBUid=%d and otherUserId=%d ",
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
    if(indexPath.row == 0)
    {
        NewFriendViewController* newFriend = [[NewFriendViewController alloc]initWithNibName:@"NewFriendViewController" bundle:nil];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newFriend animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else
    {
        MessageData* info = [source objectAtIndex:indexPath.row-1];
        ChatViewController* chat = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
        chat.otherName = info.otherName;
        chat.otherUserId = info.otherUserId;
        chat.otherAvatar = info.otherAvatar;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - 跳转
-(void)goToLinkersViewCtl
{
    ContactsViewController *contact = [[ContactsViewController alloc] init];
    contact.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contact animated:YES];
}

-(void)gotoInviteViewCtl
{
    InviteFriendsViewController *invite = [[InviteFriendsViewController alloc] init];
    invite.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:invite animated:YES];
}

@end
