//
//  NewFriendViewController.m
//  WeLinked4
//
//  Created by jonas on 5/30/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "NewFriendViewController.h"
#import "RCLabel.h"
#import "UserInfo.h"
#import "LogicManager.h"
#import "DataBaseManager.h"
#import "ExtraButton.h"
#import "NetworkEngine.h"
#import "MessageData.h"
@interface NewFriendViewController ()

@end

@implementation NewFriendViewController

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
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView* head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    head.backgroundColor = [UIColor clearColor];
    table.tableHeaderView = head;
    [self.navigationItem setTitleString:@"新的联系人"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
                                imageSelected:[UIImage imageNamed:@"backSelected"]
                                        title:nil
                                        inset:UIEdgeInsetsMake(0, -20, 0, 0)
                                       target:self
                                     selector:@selector(back:)];
    
    NSString* sql = [NSString stringWithFormat:@" where DBUid=%d and userId = %d and msgType=5 order by createTime desc",
                      [UserInfo myselfInstance].userId,
                      [UserInfo myselfInstance].userId];
    dataSource = [[UserDataBaseManager sharedInstance] queryWithClass:[MessageData class] tableName:nil condition:sql];
    for(MessageData* data in dataSource)
    {
        if(data.status != 1)
        {
            data.status = 1;
            [data synchronize:nil];
        }
    }
    [table reloadData];
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
#pragma --mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(dataSource != nil)
    {
        return [dataSource count];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CustomWideCellView*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomWideCellView * cell = [[CustomWideCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    MessageData* info = [dataSource objectAtIndex:indexPath.row];
    [self customCell:cell indexPath:indexPath info:info];
    return cell;
}
-(void)customCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath info:(MessageData*)request
{
    EGOImageView* image = [[EGOImageView alloc]initWithFrame:CGRectMake(15, 10, 60, 60)];
    //    image.layer.cornerRadius = 25;
    image.layer.masksToBounds = YES;
    image.placeholderImage = [UIImage imageNamed:@"defaultHead"];
    [cell.contentView addSubview:image];
    RCLabel* lbl = [[RCLabel alloc]initWithFrame:CGRectMake(85, 15, 180, 60)];
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    [cell.contentView addSubview:lbl];
    if(request != nil)
    {
        [image setImageURL:[NSURL URLWithString:request.otherAvatar]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        //colorWithHex(0x3287E6)
        NSMutableString* str = [NSMutableString string];
        [str appendString:[NSString stringWithFormat:@"<p lineSpacing=4><font size=14 color='#3287E6' face=FZLTZHK--GBK1-0>%@</font></p>\n",request.otherName]];
        NSString* s = @"";
        if(request.job == nil || [request.job length]<=0)
        {
            s = [NSString stringWithFormat:@"%@",request.company];
        }
        else
        {
            s = [NSString stringWithFormat:@"%@ | %@",request.job,request.company];
        }
        if([s length]>15)
        {
            s = [s substringToIndex:15];
        }
        [str appendString:[NSString stringWithFormat:@"<p lineSpacing=4><font size=14 color='#999999'>%@</font></p>\n",s]];
        [str appendString:[NSString stringWithFormat:@"<p lineSpacing=0><font size=14 color='#999999'>%@</font></p>",request.text]];
        [lbl setText:str];
    }
    
    
    ExtraButton* addButton = [[ExtraButton alloc]initWithFrame:CGRectMake(240, 28, 65, 24)];
    if(![[LogicManager sharedInstance] isMyFriend:request.otherUserId])
    {
        [addButton setImage:[UIImage imageNamed:@"btn_invite_n"] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"btn_invite_h"] forState:UIControlStateHighlighted];
        addButton.enabled = YES;
    }
    else
    {
        [addButton setImage:[UIImage imageNamed:@"btn_invite_h"] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"btn_invite_h"] forState:UIControlStateHighlighted];
        addButton.enabled = NO;
    }
    [cell.contentView addSubview:addButton];
    [addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    addButton.extraData = request;
    
    
    ExtraButton* deleteButton = [[ExtraButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-80, 0, 80, 80)];
    deleteButton.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:66.0/255.0 blue:63.0/255.0 alpha:1.0];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [cell.contentView addSubview:deleteButton];
    cell.contentView.userInteractionEnabled = YES;
    [deleteButton addTarget:self action:@selector(deleteRequest:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.extraData = request;
    
    UISwipeGestureRecognizer* left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    [cell.contentView addGestureRecognizer:left];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer* right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [cell.contentView addGestureRecognizer:right];
}
-(void)addFriend:(id)sender
{
    ExtraButton* btn = (ExtraButton*)sender;
    MessageData* info = btn.extraData;
    int friendId = info.otherUserId;
    [[NetworkEngine sharedInstance] confirmFriend:friendId block:^(int event, id object)
    {
        if(event == 0)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"操作失败,请检查网络" actionText:@"确定"];
        }
        else if (event == 1)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"已添加" actionText:@"确定"];
            [table reloadData];
        }
    }];
}
-(void)deleteRequest:(id)sender
{
    ExtraButton* btn = (ExtraButton*)sender;
    MessageData* info = btn.extraData;
    int friendId = info.otherUserId;
    
    [MessageData deleteWith:nil condition:[NSString stringWithFormat:@" where DBUid=%d and friendId=%d ",
                                             [UserInfo myselfInstance].userId,friendId]];
    [table reloadData];
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
}

@end
