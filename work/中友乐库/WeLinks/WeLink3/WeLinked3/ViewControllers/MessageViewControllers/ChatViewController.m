//
//  ChatViewController.m
//  Welinked2
//
//  Created by jonas on 12/17/13.
//
//

#import "ChatViewController.h"
#import "TextMessageItem.h"
#import "SnapMessageData.h"
#import "JobDetailViewViewController.h"
#import "RecommendFriendListViewController.h"
#import "InternalRecommendViewController.h"
@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize otherUserId,otherAvatar,otherName;
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
    topTime = 0;
    buttomTime = 0;
    scrollToBottomState = 4;
	[self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back:)];
    [self.navigationItem setTitleViewWithText:self.otherName];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer* guesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:guesture];
    
    guesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    [list addGestureRecognizer:guesture];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    inputBack.image = [[UIImage imageNamed:@"chatInputFrame"] stretchableImageWithLeftCapWidth:5 topCapHeight:3];
    inputBackground.image = [[UIImage imageNamed:@"chatInputBack"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    __weak ChatViewController* slf = self;
    [list setCallBack:^(int event, id object)
    {
        [slf fireEvent:event object:object];
    }];
}
-(void)fireEvent:(int)event object:(id)object
{
    UITableView* tbl = (UITableView*)object;
    if(event == EVENT_SCROLL)
    {
        //scroll
        if(tbl.contentOffset.y > tbl.contentSize.height - tbl.frame.size.height)
        {
            //滑到底部 强制滑动
            scrollToBottomState = 2;
        }
    }
    else if (event == EVENT_LOADMORE)
    {
        //loadmore
//        [nav startActivity];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self loadMore];
        });
    }
    else if (event == EVENT_TOUCH)
    {
        if(tbl.contentOffset.y > tbl.contentSize.height - tbl.frame.size.height)
        {
            //滑到底部 强制滑动
            scrollToBottomState = 2;
        }
        else
        {
            //强制不滑动
            scrollToBottomState = 3;
        }
    }
    else if (event == EVENT_RESEND)
    {
        MessageData* data = (MessageData*)object;
        [self resendMessage:data];
    }
    else if (event == EVENT_PRIFILE)
    {
        MessageData*data = (MessageData*)object;
        if(data != nil)
        {
            //0发送 1 接收 2发送中 3 发送失败
            if(data.isSender == 1)
            {
                [[LogicManager sharedInstance] gotoProfile:self userId:data.otherUserId];
            }
            else
            {
                [[LogicManager sharedInstance] gotoProfile:self userId:data.userId showBackButton:YES];
            }
        }
    }
    else if (event == EVENT_TAPCONTENT)
    {
        //PostRecommendedMessage,//求内推
        //ForwardingPostMessage,//求推荐二度好友
        //PostMessage,//推荐职位
        MessageData*data = (MessageData*)object;
        if(data != nil)
        {
            if(data.extraData != nil)
            {
                NSDictionary* dic = data.extraData;
                if(dic != nil)
                {
                    
                    id iden = [dic objectForKey:@"identity"];
                    if(iden == nil)
                    {
                        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"数据错误" actionText:@"确定"];
                        return;
                    }
                    NSString* identity = @"";
                    if([iden isKindOfClass:[NSNumber class]])
                    {
                        identity = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"identity"] intValue]];
                    }
                    else if([iden isKindOfClass:[NSString class]])
                    {
                        identity = iden;
                    }
                    
                    if(data.msgType == PostMessage)//招聘人才
                    {
                        RecommendFriendListViewController* control = [[RecommendFriendListViewController alloc]initWithNibName:@"RecommendFriendListViewController" bundle:nil];
                        control.jobID = identity;
                        [self.navigationController pushViewController:control animated:YES];
                    }
                    else if(data.msgType == PostRecommendedMessage)//求内推
                    {
                        InternalRecommendViewController *reconmand = [[InternalRecommendViewController alloc] init];
                        reconmand.recommendID = identity;
                        [self.navigationController pushViewController:reconmand animated:YES];
                    }
                    else if (data.msgType == ForwardingPostMessage)
                    {
                        JobDetailViewViewController* detail = [[JobDetailViewViewController alloc]init];
                        detail.jobIdentity = identity;
                        [self.navigationController pushViewController:detail animated:YES];
                    }
                }
            }
        }
    }
}
-(void)customActionButton:(int)type
{
    if(type == 0)
    {
        // 建立连接
        actionButton.titleLabel.text = @"建立连接";
        [actionButton setBackgroundImage:[UIImage imageNamed:@"connectFriend"] forState:UIControlStateNormal];
    }
    else if (type == 1)
    {
        //请求已发送
        actionButton.titleLabel.text = @"请求已发送";
        [actionButton setBackgroundImage:[UIImage imageNamed:@"connectFriend"] forState:UIControlStateNormal];
    }
}
-(void)scrollToBottom:(BOOL)animated
{
    if(scrollToBottomState == 3)
    {
        //不滑动
        return;
    }
    CGPoint offset;
    if(list.contentSize.height > list.frame.size.height)
    {
        offset = CGPointMake(0, list.contentSize.height-list.frame.size.height);
    }
    else
    {
        offset = CGPointMake(0, 0);
    }
    if(scrollToBottomState == 4)
    {
        scrollToBottomState = 2;
        [list setContentOffset:offset animated:NO];
    }
    else
    {
        [list setContentOffset:offset animated:animated];
    }
}
-(void)resendMessage:(MessageData*)message
{
    message.isSender = 2;
    [list reloadData];
    [[NetworkEngine sharedInstance] sendMessage:message.otherUserId content:message.text block:^(int event, id object)
     {
         if(event == 0)
         {
             //sendStatus;//0发送 1 接收 2发送中 3 发送失败
             message.isSender = 3;
             [message synchronize:nil];
             [list reloadData];
         }
         else if (event == 1)
         {
             [MessageData deleteWith:nil condition:[NSString stringWithFormat:@" where userId = '%@' and otherUserId = '%@' and identity = %d ",[UserInfo myselfInstance].userId,self.otherUserId,message.identity]];
             //发送成功
             [self reloadFromDatabase];
         }
     }];
}
- (IBAction)sayPressed:(id)sender
{
    NSString* s = textField.text;
    if(s == nil || [s length]<=0)
    {
        return;
    }
    else
    {
        NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
        s = [s  stringByTrimmingCharactersInSet:whitespace];
        if(s == nil || [s length]<=0)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"不能发送空白消息" actionText:@"确定"];
            return;
        }
    }
    __block MessageData* msg = [[MessageData alloc]init];
    msg.userId = [UserInfo myselfInstance].userId;
    msg.isSender = 2;//发送中    //0发送 1 接收 2发送中 3 发送失败
    msg.text = textField.text;
    msg.contentString = [NSString stringWithFormat:@"{\"text\":\"%@\"}",msg.text];
    msg.otherUserId = self.otherUserId;
    msg.otherAvatar = self.otherAvatar;
    msg.otherName = self.otherName;
    msg.msgType = TextMesage;
    msg.createTime = [[NSDate date] timeIntervalSince1970]*1000;
    [self setSendMessage:msg];
    [msg synchronize:nil];
    
    [list.source addObject:msg];
    [list reloadData];
    [self scrollToBottom:YES];
    [[NetworkEngine sharedInstance] sendMessage:self.otherUserId content:msg.text block:^(int event, id object)
    {
        if(event == 0)
        {
            //sendStatus;//0发送 1 接收 2发送中 3 发送失败
            msg.isSender = 3;
            [msg synchronize:nil];
            [list reloadData];
        }
        else if (event == 1)
        {
            //0发送 1 接收 2发送中 3 发送失败
            [MessageData deleteWith:nil condition:[NSString stringWithFormat:@" where userId = '%@' and otherUserId = '%@' and identity = %d ",[UserInfo myselfInstance].userId,self.otherUserId,msg.identity]];
            //发送成功
            [self reloadFromDatabase];
        }
    }];
    textField.text = @"";
}
-(void)setSendMessage:(MessageData*)msg
{
    NSString* conditionString = [NSString stringWithFormat:@" order by identity limit 1 offset 0 "];
    NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class]
                                                                         tableName:nil
                                                                         condition:conditionString];
    int idenity = 0;
    
    if(result != nil && [result count]>0)
    {
        MessageData* obj = [result objectAtIndex:0];
        if(obj.identity < 0)
        {
            idenity = obj.identity-1;
        }
        else
        {
            idenity = idenity -1;
        }
    }
    else
    {
        idenity = idenity -1;
    }
    msg.identity = idenity;
}
-(void)resetTime
{
    NSString* conditionString = [NSString stringWithFormat:@" where userId = '%@' and otherUserId = '%@' order by createTime desc limit 1 offset 0",[UserInfo myselfInstance].userId,self.otherUserId];
    NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil condition:conditionString];
    if(result != nil && [result count]>0)
    {
        MessageData* msg = [result objectAtIndex:0];
        buttomTime = msg.createTime;
        topTime = buttomTime+1;
    }
}
-(void)reloadFromDatabase
{
    [list.source removeAllObjects];
    [self resetTime];
    NSString* conditionString = [NSString stringWithFormat:@" where userId = '%@' and otherUserId = '%@' and createTime < %f  order by createTime desc limit 10 offset 0",[UserInfo myselfInstance].userId,self.otherUserId,topTime];
    NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil condition:conditionString];
    if(result != nil && [result count]>0)
    {
        MessageData* msg = [result lastObject];
        topTime = msg.createTime;
        BOOL maskEnable = NO;
        if(self.otherUserId != nil && [self.otherUserId isEqualToString:@"10000"])
        {
            maskEnable = NO;
        }
        else
        {
            if(![[LogicManager sharedInstance] isMyFriend:self.otherUserId])
            {
                maskEnable = YES;
            }
            else
            {
                maskEnable = NO;
            }
        }
        for (MessageData* data in result)
        {
//            if(!maskEnable)
            {
                if(data.status == 0)
                {
                    data.status = 1;
                    [data synchronize:nil];
                }
                if(data.isSender == 2)
                {
                    [self resendMessage:data];
                }
            }
            [list.source addObject:data];
        }
        [list reloadData];
    }
    [self scrollToBottom:YES];
}
-(void)loadLatest
{
    NSString* conditionString = [NSString stringWithFormat:@" where userId = '%@' and otherUserId = '%@' and createTime > %f  order by createTime",[UserInfo myselfInstance].userId,self.otherUserId,buttomTime];
    NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil condition:conditionString];
    if(result != nil && [result count]>0)
    {
        MessageData* msg = [result objectAtIndex:0];
        if(msg != nil)
        {
            buttomTime = msg.createTime;
        }
        
        for (MessageData* data in result)
        {
            if(data.status == 0)
            {
                data.status = 1;
                [data synchronize:nil];
            }
            [list.source addObject:data];
        }
        [list reloadData];
    }
    [self scrollToBottom:YES];
}
-(void)loadMore
{
    NSString* conditionString = [NSString stringWithFormat:@" where userId = '%@' and otherUserId = '%@' and createTime < %f  order by createTime desc limit 10 offset 0",[UserInfo myselfInstance].userId,self.otherUserId,topTime];
    NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil condition:conditionString];
    if(result != nil && [result count]>0)
    {
        MessageData* msg = [result lastObject];
        topTime = msg.createTime;
        
        for (MessageData* data in result)
        {
            if(data.status == 0)
            {
                data.status = 1;
                [data synchronize:nil];
            }
            [list.source addObject:data];
        }
        CGPoint offset = [list contentOffset];
        CGSize oldSize = list.contentSize;
        [list reloadData];
        CGSize newSize = list.contentSize;
        offset.y = newSize.height-oldSize.height;
        if (offset.y > [list contentSize].height)
        {
            offset.y = 0;
        }
        [list setContentOffset:offset animated:NO];
    }
//    [nav stopActivity];
}
-(void)loadFromNetwork
{
    [[NetworkEngine sharedInstance] receiveUnreadMessage:^(int event, id object)
     {
         if(event == 1)
         {
             [self loadLatest];
         }
     }];
}
-(IBAction)connect:(id)sender
{
    [[NetworkEngine sharedInstance] acceptConectRequest:self.otherUserId block:^(int event, id object)
    {
        if(event == 0)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"添加失败" actionText:@"确定"];
        }
        else if (event == 1)
        {
            [self loadMaskView];
        }
    }];
}
-(void)loadMaskView
{
    BOOL maskEnable = NO;
    if(self.otherUserId != nil && [self.otherUserId isEqualToString:@"10000"])
    {
        maskEnable = NO;
    }
    else
    {
        if(![[LogicManager sharedInstance] isMyFriend:self.otherUserId])
        {
            maskEnable = YES;
        }
        else
        {
            maskEnable = NO;
        }
    }
    
    if(maskEnable)
    {
        //不是好友
        
        NSString* conditionString = [NSString stringWithFormat:@" where userId = '%@' and otherUserId = '%@' and status=0",[UserInfo myselfInstance].userId,self.otherUserId];
        NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil condition:conditionString];
        if(result != nil && [result count]>0)
        {
            MessageData* data = (MessageData*)[result objectAtIndex:0];
            if(data.msgType >= PostRecommendedMessage)
            {
                if(data.isSender == 1)
                {
                    //接收
                    [actionButton setTitle:@"建立连接" forState:UIControlStateNormal];
                    [actionButton setBackgroundImage:[UIImage imageNamed:@"connectFriend"] forState:UIControlStateNormal];
                    actionButton.enabled = YES;
                }
                else
                {
                    [actionButton setTitle:@"请求已发送" forState:UIControlStateNormal];
                    actionButton.backgroundColor = [UIColor grayColor];
                    actionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
                    [actionButton setBackgroundImage:nil forState:UIControlStateNormal];
                    actionButton.enabled = NO;
                }
            }
        }
        
        maskView.hidden = NO;
        actionView.hidden = NO;
        headImageView.imageURL = [NSURL URLWithString:self.otherAvatar];
        NSMutableString* str = [[NSMutableString alloc]init];
        [str appendFormat:@"<p><font color='#464646' face='FZLTZHK--GBK1-0' size=14>%@</font></p>",self.otherName];
        [str appendFormat:@"\n<p lineSpacing=5><font size=11>Ta不是你的联系人,添加后就可以开始沟通</font></p>"];
        [descLabel setText:str];
    }
    else
    {
        maskView.hidden = YES;
        actionView.hidden = YES;
        if(timer != nil)
        {
            if([timer isValid])
            {
                [timer invalidate];
            }
        }
        timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(loadFromNetwork) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitleViewWithText:self.otherName];
    [self reloadFromDatabase];
    [self loadMaskView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)hideKeyboard:(UITapGestureRecognizer*)guesture
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sayPressed:nil];
    return YES;
}
#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    scrollToBottomState = 2;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        CGRect frame = textInputView.frame;
        frame.origin.y = self.view.frame.size.height - kbSize.height - frame.size.height;
        textInputView.frame = frame;
        
        frame = list.frame;
        frame.size.height = self.view.frame.size.height- kbSize.height-textInputView.frame.size.height;
        list.frame = frame;
        [self scrollToBottom:NO];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    scrollToBottomState = 2;
    NSDictionary* info = [aNotification userInfo];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        CGRect frame = textInputView.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        textInputView.frame = frame;
        [self scrollToBottom:NO];
        frame = list.frame;
        frame.size.height = self.view.frame.size.height-textInputView.frame.size.height;
        list.frame = frame;
    } completion:^(BOOL finished) {
    }];
}
@end