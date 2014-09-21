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
#import "ImageViewController.h"
@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize otherUserId,otherAvatar,otherName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        msgType = 1;
    }
    return self;
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"检测到截屏  ios6");
}
- (void)userDidTakeScreenshot:(NSNotification *)notification
{
    if(notification)
    {
        UIApplication* app = [notification object];
        if(app == [UIApplication sharedApplication])
        {
            NSLog(@"检测到截屏  ios7 application:%@",app);
        }
    }
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(isSystemVersionIOS7())
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidTakeScreenshot:)
                                                     name:UIApplicationUserDidTakeScreenshotNotification
                                                   object:nil];
    }
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
                                imageSelected:[UIImage imageNamed:@"backSelected"]
                                        title:nil
                                        inset:UIEdgeInsetsMake(0, -10, 0, 0)
                                       target:self
                                     selector:@selector(back:)];
    topTime = 0;
    buttomTime = 0;
    scrollToBottomState = 4;
    storeSecond = 5;
    
    [self.navigationItem setTitleString:self.otherName];
    
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
        [self.navigationController.navigationBar showLoading];
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
            if(data.isSender == 1)
            {
                self.hidesBottomBarWhenPushed = YES;
                [[LogicManager sharedInstance] gotoProfile:self userId:data.userId showBackButton:YES];
            }
            else
            {
                self.hidesBottomBarWhenPushed = YES;
                [[LogicManager sharedInstance] gotoProfile:self userId:data.otherUserId showBackButton:YES];
            }
        }
    }
    else if (event == EVENT_TAPCONTENT)
    {
        MessageData*data = (MessageData*)object;
        if(data != nil)
        {
            if(data.msgType == ImageMessage)
            {
                NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class]
                                                                          tableName:nil
                                                                          condition:[NSString stringWithFormat:@" where DBUid=%d and otherUserId = %d and msgType=%d",[UserInfo myselfInstance].userId,data.otherUserId,ImageMessage]];
                
                if(arr != nil && [arr count]>0)
                {
                    NSMutableArray* array = [[NSMutableArray alloc]init];
                    [array addObject:@"http://ww3.sinaimg.cn/bmiddle/005tNQILjw1egkpfmzmpgj30c80dggnp.jpg"];
                    [array addObject:@"http://ww2.sinaimg.cn/bmiddle/005tNQILjw1egkpfmwlz1j30c80dsgn7.jpg"];
                    [array addObject:@"http://ww1.sinaimg.cn/bmiddle/005tNQILjw1egkpfn6ezmj30c80d5ac1.jpg"];
                    [array addObject:@"http://ww3.sinaimg.cn/bmiddle/005tNQILjw1egkpfn8a7sj30c80dk75y.jpg"];
                    [array addObject:@"http://ww1.sinaimg.cn/bmiddle/005tNQILjw1egkpfne7yqj30c80d90u3.jpg"];
                    [array addObject:@"http://ww1.sinaimg.cn/bmiddle/005tNQILjw1egkpfnv4s9j30c80dddh2.jpg"];
                    [array addObject:@"http://ww3.sinaimg.cn/bmiddle/005tNQILjw1egkpfo551hj30c80dbjt4.jpg"];
                    [array addObject:@"http://ww1.sinaimg.cn/bmiddle/005tNQILjw1egkpfo4rhsj30c80dbac8.jpg"];
                    [array addObject:@"http://ww2.sinaimg.cn/bmiddle/005tNQILjw1egkpfohfc3j30c80e3q44.jpg"];
                }
            }
        }
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
    [[NetworkEngine sharedInstance] sendMessage:self.otherUserId
                                        content:message.text
                                        msgType:message.msgType
                                    storeSecond:storeSecond
                                          block:^(int event, id object)
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
            [MessageData deleteWith:nil condition:[NSString stringWithFormat:@" where userId = %d and otherUserId = %d and identity = %d ",[UserInfo myselfInstance].userId,self.otherUserId,message.identity]];
            //发送成功
            [self reloadFromDatabase];
        }
    }];
}
-(void)showSecure:(UIButton*)clickButton
{
    if(clickButton == nil)
    {
        return;
    }
    CGPoint point = [clickButton convertPoint:clickButton.frame.origin toView:self.view];
    point.y -= clickButton.frame.size.height-40;
    CGRect frame = CGRectMake(popFrame.origin.x, point.y - popFrame.size.height, popFrame.size.width, popFrame.size.height);
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         popView.frame = frame;
                     } completion:^(BOOL finished) {
                         popShowed = YES;
                         if(msgType == 4)
                         {
                             [UIView animateWithDuration:0.2 animations:^{
                                 timeView.hidden = NO;
                             }];
                         }
                     }];
}
-(void)hideSecure:(UIButton*)clickButton
{
    if(clickButton == nil)
    {
        return;
    }
    CGPoint point = [self.view convertPoint:clickButton.frame.origin fromView:clickButton];
    point.y -= clickButton.frame.size.height-40;
    CGRect frame = CGRectMake(popFrame.origin.x, point.y, 0, 0);
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         popView.frame = frame;
                     } completion:^(BOOL finished) {
                         popShowed = NO;
                     }];
}
-(void)hideTime:(UIButton*)clickButton
{
    if(clickButton == nil)
    {
        return;
    }
    CGPoint point = [self.view convertPoint:clickButton.frame.origin fromView:clickButton];
    point.y -= clickButton.frame.size.height;
    CGRect frame = CGRectMake(popFrame.origin.x, point.y, 0, 0);
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         popView.frame = frame;
                     } completion:^(BOOL finished) {
                         popShowed = NO;
                     }];
}
-(IBAction)switchTime:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int t = (int)btn.tag;
    switch (t)
    {
        case 1:
        {
            storeSecond = 5 * 60;
        }
            break;
        case 2:
        {
            storeSecond = 15 * 60;
        }
            break;
        case 3:
        {
            storeSecond = 60 * 60;
        }
            break;
        case 4:
        {
            storeSecond = 12 * 60 * 60;
        }
            break;
        default:
            break;
    }
    for(int i = 1;i<5;i++)
    {
        UIButton* b = (UIButton*)[timeView viewWithTag:i];
        if(b != nil)
        {
            [b setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
    [btn setBackgroundImage:[UIImage imageNamed:@"lockBack2"] forState:UIControlStateNormal];
    timeView.hidden = YES;
    [self hideTime:secureButton];
    [secureButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"lock%d",msgType]]
                  forState:UIControlStateNormal];
}
-(IBAction)switchSecure:(id)sender
{
    //msgType;//1=普通文本 3=阅后即焚消息 4=定时删除消息
    UIButton* btn = (UIButton*)sender;
    msgType = (int)btn.tag;
    for(int i = 1;i<5;i++)
    {
        UIButton* b = (UIButton*)[popView viewWithTag:i];
        if(b != nil)
        {
            [b setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
    if(msgType == 5)
    {
        msgType = 1;
        [btn setBackgroundImage:[UIImage imageNamed:@"lockBack1"] forState:UIControlStateNormal];
    }
    else if(msgType == 1 || msgType == 3)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"lockBack2"] forState:UIControlStateNormal];
    }
    else if (msgType == 4)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"lockBack3"] forState:UIControlStateNormal];
    }
    
    if(msgType != 4)
    {
        storeSecond = 5;
        timeView.hidden = YES;
        [self hideSecure:secureButton];
        [secureButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"lock%d",msgType]]
                      forState:UIControlStateNormal];
    }
    else
    {
        timeView.hidden = NO;
    }
}
- (IBAction)lockPressed:(id)sender
{
    UIButton* secure = (UIButton*)sender;
    if(!popShowed)
    {
        [self showSecure:secure];
    }
    else
    {
        timeView.hidden = YES;
        [self hideSecure:secure];
    }
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
    msg.msgType = msgType;
    msg.createTime = [[NSDate date] timeIntervalSince1970]*1000;
    [self setSendMessage:msg];
    [msg synchronize:nil];
    
    [list.source addObject:msg];
    [list reloadData];
    [self scrollToBottom:YES];
    sendButton.enabled = NO;
    [[NetworkEngine sharedInstance] sendMessage:self.otherUserId
                                        content:msg.text
                                        msgType:msgType
                                    storeSecond:storeSecond
                                          block:^(int event, id object)
    {
        sendButton.enabled = YES;
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
            [MessageData deleteWith:nil condition:[NSString stringWithFormat:@" where userId = %d and otherUserId = %d and identity = %d ",[UserInfo myselfInstance].userId,self.otherUserId,msg.identity]];
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
    NSString* conditionString = [NSString stringWithFormat:@" where userId = %d and otherUserId = %d order by createTime desc limit 1 offset 0",[UserInfo myselfInstance].userId,self.otherUserId];
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
    NSString* conditionString = [NSString stringWithFormat:@" where userId = %d and otherUserId = %d and createTime < %f  order by createTime desc limit 10 offset 0",[UserInfo myselfInstance].userId,self.otherUserId,topTime];
    NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil condition:conditionString];
    if(result != nil && [result count]>0)
    {
        MessageData* msg = [result lastObject];
        topTime = msg.createTime;
        [self processState:result];
        for (MessageData* data in result)
        {
            if(data.isSender == 2)
            {
                [self resendMessage:data];
            }
        }
        [list reloadData];
    }
    [self scrollToBottom:YES];
}
-(void)loadLatest
{
    NSString* conditionString = [NSString stringWithFormat:@" where userId = %d and otherUserId = %d and createTime > %f  order by createTime",[UserInfo myselfInstance].userId,self.otherUserId,buttomTime];
    NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil condition:conditionString];
    if(result != nil && [result count]>0)
    {
        MessageData* msg = [result objectAtIndex:0];
        if(msg != nil)
        {
            buttomTime = msg.createTime;
        }
        [self processState:result];
        [list reloadData];
    }
    [self scrollToBottom:YES];
}
-(void)loadMore
{
    NSString* conditionString = [NSString stringWithFormat:@" where userId = %d and otherUserId = %d and createTime < %f  order by createTime desc limit 10 offset 0",[UserInfo myselfInstance].userId,self.otherUserId,topTime];
    NSMutableArray * result = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil condition:conditionString];
    if(result != nil && [result count]>0)
    {
        MessageData* msg = [result lastObject];
        topTime = msg.createTime;
        [self processState:result];
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
    [self.navigationController.navigationBar hideLoading];
}
-(void)loadFromNetwork
{
    [[NetworkEngine sharedInstance] getMessages:@"0" block:^(int event, id object)
     {
         if(event == 1)
         {
             [self loadLatest];
         }
         else
         {
             [self processState:nil];
         }
     }];
}
-(void)processState:(NSArray*)result
{
    if(result != nil && [result count]>0)
    {
        [list.source addObjectsFromArray:result];
    }
    for (MessageData* data in list.source)
    {
        //1=普通文本 3=阅后即焚消息 4=定时删除消息
        if(data.msgType == 4)
        {
            //定时消息
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            if(now - data.receiveTime/1000 > data.storeSecond)
            {
                //超时 删除消息
                [MessageData executeWithSet:@" set status=2"
                                  condition:[NSString stringWithFormat:@" where identity=%d",data.identity]
                                  tableName:nil];
            }
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitleString:self.otherName];
    [self reloadFromDatabase];
    popFrame = popView.frame;
    CGRect frame = CGRectMake(20, popView.frame.origin.y + popView.frame.size.height,0, 0);
    popView.frame = frame;
    
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    
    for (MessageData* data in list.source)
    {
        if(data.msgType == 3 && data.isSender == 0)
        {
            //接收的阅后删除消息
            
            if(data.status != 2)
            {
                //0未读 1 已读 2=已删除
//                data.status = 2;//删除
//                [data synchronize:nil];
                [MessageData executeWithSet:@" set status=2"
                                  condition:[NSString stringWithFormat:@" where identity=%d",data.identity]
                                  tableName:nil];
            }
        }
    }
    [self processState:list.source];
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
        
        
        frame = popView.frame;
        frame.origin.y = frame.origin.y - kbSize.height;
        popView.frame = frame;
        
        
        frame = timeView.frame;
        frame.origin.y = frame.origin.y - kbSize.height;
        timeView.frame = frame;
        
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
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
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
        
        frame = popView.frame;
        frame.origin.y = frame.origin.y + kbSize.height;
        popView.frame = frame;
        
        frame = timeView.frame;
        frame.origin.y = frame.origin.y + kbSize.height;
        timeView.frame = frame;
        
    } completion:^(BOOL finished) {
    }];
}
@end