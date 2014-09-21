//
//  InviteFriendsViewController.m
//  WeLinked4
//
//  Created by floar on 14-5-16.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "addFriendViewController.h"
#import "PhoneBookInfo.h"
#import "UINavigationItemCustom.h"
#import "ExtraButton.h"
#import "UserInfo.h"
#import "LogicManager.h"
@interface InviteFriendsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *inviteArray;
}

@property (weak, nonatomic) IBOutlet UITableView *inviteTableView;

@end

@implementation InviteFriendsViewController

@synthesize inviteTableView;

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
    [self.navigationItem setTitleString:@"邀请"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
                                imageSelected:[UIImage imageNamed:@"backSelected"]
                                        title:nil
                                        inset:UIEdgeInsetsMake(0, -20, 0, 0)
                                       target:self
                                     selector:@selector(gotoBack)];
    
    [self.navigationItem setRightBarButtonItem:nil
                                 imageSelected:nil
                                         title:@"职脉号添加"
                                         inset:UIEdgeInsetsZero
                                        target:self
                                      selector:@selector(addFriendByWeLinkNum)];
    inviteTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [[LogicManager sharedInstance] getContactFriends:^(int event, id object)
    {
        if(event == 1 && object != nil)
        {
            inviteArray = [(NSDictionary*)object objectForKey:@"object"];
            [inviteTableView reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return [inviteArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *header = @"header";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:header];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:header];
            }
            [self customHeaderCell:cell];
            return cell;
        }
        else
        {
            static NSString *head = @"head";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:head];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:head];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = colorWithHex(0xE5E5E5);
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 83, 11)];
            img.image = [UIImage imageNamed:@"img_invite_message"];
            [cell.contentView addSubview:img];
            return cell;
        }

    }
    else
    {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        if (indexPath.section == 1)
        {
            PhoneBookInfo *phoneBook = [inviteArray objectAtIndex:indexPath.row];
            [self customNormalCell:cell withphoneBookName:phoneBook];
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 60;
        }
        else
        {
            return 30;
        }
    }
    else
    {
        return 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
//            [self shareTOWechat:nil];
        }
        else
        {
            return;
        }
    }
    else
    {
        return;
    }
}

-(void)customHeaderCell:(UITableViewCell *)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:30];
    if (image == nil)
    {
        image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        image.tag = 30;
        image.image = [UIImage imageNamed:@"img_wechat_message"];
        [cell.contentView addSubview:image];
    }
    UILabel *inviteWechatLabel = (UILabel *)[cell.contentView viewWithTag:40];
    if (inviteWechatLabel == nil)
    {
        inviteWechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, cell.contentView.center.y, 200, 40)];
        inviteWechatLabel.text = @"邀请微信好友";
        inviteWechatLabel.font = getFontWith(YES, 17);
        [inviteWechatLabel sizeToFit];
        inviteWechatLabel.tag = 40;
        [cell.contentView addSubview:inviteWechatLabel];
    }
}

-(void)customNormalCell:(UITableViewCell *)cell withphoneBookName:(PhoneBookInfo *)phoneBook
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = getFontWith(NO, 14);
    ExtraButton *selectBtn = (ExtraButton *)[cell.contentView viewWithTag:20];
    if (selectBtn == nil)
    {
        selectBtn = [[ExtraButton alloc]initWithFrame:CGRectMake(cell.contentView.width-10-65, 30-12, 65, 24)];
        selectBtn.tag = 20;
        [selectBtn setImage:[UIImage imageNamed:@"btn_invite_n"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"btn_invite_h"] forState:UIControlStateHighlighted];
        [selectBtn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:selectBtn];
    }
    if (phoneBook != nil)
    {
        selectBtn.extraData = phoneBook;
        cell.textLabel.text = phoneBook.name;
    }
}
#pragma --mark MessageUI delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"error");
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    if(messageController != nil)
    {
        [messageController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UINavigationItemAction
-(void)gotoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addFriendByWeLinkNum
{
    addFriendViewController *addFriend = [[addFriendViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addFriend animated:YES];
}

-(void)cellBtnAction:(id)sender
{
    ExtraButton* btn = (ExtraButton*)sender;
    if(btn)
    {
        PhoneBookInfo* phone  = btn.extraData;
        //邀请
        if([MFMessageComposeViewController canSendText])
        {
            messageController = [[MFMessageComposeViewController alloc] init];
            messageController.view.backgroundColor = [UIColor whiteColor];
            messageController.navigationBarHidden = NO;
            messageController.body = [NSString stringWithFormat:@"我是 %@，我正在使用职脉，拓展人脉、找人才、求内推,各种靠谱！我的职脉号:%d，邀请你一起来，下载http://zhimai.me",[UserInfo myselfInstance].name,[UserInfo myselfInstance].userId];
            messageController.recipients = [NSArray arrayWithObjects:phone.phone, nil];
            messageController.messageComposeDelegate = self;
            [self presentViewController:messageController animated:YES completion:nil];
        }
        else
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"你的设备不支持发送短信" actionText:@"确定"];
        }
    }
}

//微信邀请
#if 0
-(void)shareTOWechat:(UIImage*)image
{
    NSString *identify = @"文章Id";
    NSString *title = @"文章title";
    NSString *describe = @"职脉";
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = describe;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [NSString stringWithFormat:@"%@/html/article?id=%@",SERVERROOTURL,identify];
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

-(void)handleWXReturnMessage:(NSNotification *)note
{
    SendMessageToWXResp *result = [note object];
    
    if ([result isKindOfClass:[SendMessageToWXResp class]])
    {
        if (result.errCode == -2)
        {
            [self performSelector:@selector(HUDCustomAction:) withObject:@"已取消分享" afterDelay:0.9];
        }
        else if (result.errCode == -3)
        {
            [self performSelector:@selector(HUDCustomAction:) withObject:@"网络不好,分享失败" afterDelay:0.9];
        }
        else if (result.errCode == 0)
        {
            [self performSelector:@selector(HUDCustomAction:) withObject:@"分享成功" afterDelay:0.9];
        }
        else if (result.errCode == -4)
        {
            [self performSelector:@selector(HUDCustomAction:) withObject:@"微信未授权" afterDelay:0.9];
        }
        else if (result.errCode == WXErrCodeCommon)
        {
            [self performSelector:@selector(HUDCustomAction:) withObject:@"信息错误" afterDelay:0.9];
        }
        else
        {
            [self performSelector:@selector(HUDCustomAction:) withObject:@"微信不支持" afterDelay:0.9];
        }
    }
    [scrollView scrollToIndex:1];
    
}
#endif

@end
