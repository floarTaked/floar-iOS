//
//  AddContactsViewController.m
//  WeLinked3
//
//  Created by jonas on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "CustomCellView.h"
#import "SearchUserViewController.h"
#import "LogicManager.h"
#import "PhoneBookInfo.h"
#import <MBProgressHUD.h>

#import "WXApi.h"

@interface AddFriendsViewController ()<WXApiDelegate>

@end

@implementation AddFriendsViewController

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
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [self.navigationItem setTitleViewWithText:@"添加联系人"];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back:)];
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleIndex
                                                                  title:@"职脉号添加"
                                                                 target:self
                                                               selector:@selector(addFriend:)];
    
    contactsDataSource = [[NSMutableArray alloc]init];
    weiboDataSource = [[NSMutableArray alloc]init];
    linkedinDataSource = [[NSMutableArray alloc]init];
    contactUsersDic = [[NSMutableDictionary alloc]init];
    CGRect frame = segementView.frame;
    frame.origin.y = 55;
    segementView.frame = frame;
    dataType = 0;
    
    scrollView = [[MMPagingScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height - 44)];
    scrollView.viewList = [NSMutableArray arrayWithObjects:contactList,weiboList,linkedinList,nil];
    scrollView.scrollingDelegate = self;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0f];
    [self.view addSubview:scrollView];
    
    
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    weiboList.tableHeaderView = headerView;
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    contactList.tableHeaderView = headerView;
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    linkedinList.tableHeaderView = headerView;
    
    NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[PhoneBookInfo class] tableName:nil condition:nil];
    if(arr != nil && [arr count]>0)
    {
        [contactsDataSource addObjectsFromArray:arr];
    }
    [self switchDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWXReturnMessage:) name:@"WXHandleResult" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.view addSubview:segementView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [segementView removeFromSuperview];
    [self.navigationController.navigationBar hideLoadingIndicator];
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
-(void)filterContactData
{
    NSMutableArray* arr = [NSMutableArray array];
    for(PhoneBookInfo* info in contactsDataSource)
    {
        NSString* phone = info.phone;
        if([contactUsersDic objectForKey:phone] != nil)
        {
            [arr addObject:info];
        }
    }
    [contactsDataSource removeObjectsInArray:arr];
//    contactsDataSource = [[UserDataBaseManager sharedInstance] queryWithClass:[PhoneBookInfo class]
//                                                                    tableName:nil
//                                                                    condition:[NSString stringWithFormat:@" where 1=1 order by userId desc"]];
}
-(void)switchDataSource
{
    if(dataType == 0)
    {
        [self.navigationController.navigationBar showLoadingIndicator];
        [[NetworkEngine sharedInstance] getContactUser:^(int event, id object)
        {
            [self.navigationController.navigationBar hideLoadingIndicator];
            if(event == 0)
            {
                
            }
            else if (event == 1)
            {
                if(object != nil)
                {
                    contactUsersDic = object;
                }
            }
            [self filterContactData];
            [contactList reloadData];
        }];
    }
    else if (dataType == 1)
    {
        [self.navigationController.navigationBar showLoadingIndicator];
        [[NetworkEngine sharedInstance] getWeiBoFriends:^(int event, id object)
        {
            [self.navigationController.navigationBar hideLoadingIndicator];
            if(event == 0)
            {
                [[LogicManager sharedInstance] showAlertWithTitle:@"" message:@"获取微博好友失败" actionText:@"确定"];
            }
            [self laodFromDataBase];
        }];
    }
    else if (dataType == 2)
    {
        //跳转到微信聊天界面
        [self shareTOWechat:nil];
//        [self.navigationController.navigationBar showLoadingIndicator];
//        [linkedinList reloadData];
//        NSString* accessToken = [[LogicManager sharedInstance] getPersistenceStringWithKey:LINKEDIN_ACCESS_TOKEN];
//        if(accessToken == nil || [accessToken length]<=0)
//        {
//            [[LogicManager sharedInstance].linkedinManager getAuthorizationCode:^(NSString *code)
//            {
//                [[LogicManager sharedInstance].linkedinManager getAccessToken:code success:^(NSDictionary *accessTokenData)
//                {
//                    NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
//                    [[LogicManager sharedInstance] setPersistenceData:accessToken withKey:LINKEDIN_ACCESS_TOKEN];
//                    [self requestFriend];
//                }failure:^(NSError *error){
//                    NSLog(@"Quering accessToken failed %@", error);
//                }];
//            }cancel:^{
//                NSLog(@"Authorization was cancelled by user");
//            }failure:^(NSError *error){
//                NSLog(@"Authorization failed %@", error);
//            }];
//        }
//        else
//        {
//            [self requestFriend];
//        }
//        [self requestProfile];
    }
}
//-(void)requestFriend
//{
//    NSString* accessToken = [[LogicManager sharedInstance] getPersistenceStringWithKey:LINKEDIN_ACCESS_TOKEN];
//    [[LogicManager sharedInstance].linkedinManager GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/connections?oauth2_access_token=%@&format=json",accessToken]
//                                            parameters:nil
//                                               success:^(AFHTTPRequestOperation *operation, NSDictionary *result)
//     {
//         NSLog(@"current user %@", result);
//         [[LogicManager sharedInstance] showAlertWithTitle:nil message:[NSString stringWithFormat:@"%@",result] actionText:@"返回结果"];
//     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"failed to fetch current user %@", error);
//     }];
//}
//- (void)requestProfile
//{
//    NSString* accessToken = [[LogicManager sharedInstance] getPersistenceStringWithKey:LINKEDIN_ACCESS_TOKEN];
//    [[LogicManager sharedInstance].linkedinManager GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken]
//                                            parameters:nil
//                                               success:^(AFHTTPRequestOperation *operation, NSDictionary *result)
//    {
////        {
////            firstName = "\U5e93\U65c5";
////            headline = "--";
////            lastName = "\U4e50";
////            siteStandardProfileRequest =     {
////                url = "http://www.linkedin.com/profile/view?id=332205037&authType=name&authToken=YL6n&trk=api*a3684511*s3755281*";
////            };
////        }
//        NSLog(@"current user %@", result);
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"failed to fetch current user %@", error);
//    }];
//}
-(void)laodFromDataBase
{
    if(dataType == 1)
    {
        NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[UserInfo class]
                                                                  tableName:WeiBoFriend
                                                                  condition:[NSString stringWithFormat:@" where DBUid='%@' order by userId desc",[UserInfo myselfInstance].userId]];
        [weiboDataSource removeAllObjects];
        for (UserInfo* user in arr)
        {
            if(![[LogicManager sharedInstance] isMyFriend:user.userId])
            {
                [weiboDataSource addObject:user];
            }
        }
        [weiboList reloadData];
    }
}
-(IBAction)buttonAction:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    [UIView animateWithDuration:0.3 animations:^
     {
         [scrollView scrollToIndex:btn.tag-1];
     }];
}
-(void)addFriend:(id)sender
{
    SearchUserViewController* mybe = [[SearchUserViewController alloc]initWithNibName:@"SearchUserViewController" bundle:nil];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mybe animated:YES];
}
-(void)connectContact:(id)sender
{
    [MobClick event:SOCIAL8];
    ExtraButton* btn = (ExtraButton*)sender;
    PhoneBookInfo* phone  = btn.extraData;
    if(phone.userId == nil)
    {
        //邀请
        if([MFMessageComposeViewController canSendText])
        {
            messageController = [[MFMessageComposeViewController alloc] init];
            messageController.view.backgroundColor = [UIColor whiteColor];
            messageController.navigationBarHidden = NO;
            messageController.body = [NSString stringWithFormat:@"我是 %@，我正在使用职脉，拓展人脉、找人才、求内推,各种靠谱！我的职脉号：%@，邀请你一起来，下载http://zhimai.me",[UserInfo myselfInstance].name,[UserInfo myselfInstance].userId];
            messageController.recipients = [NSArray arrayWithObjects:phone.phone, nil];
            messageController.messageComposeDelegate = self;
            [self presentViewController:messageController animated:YES completion:nil];
        }
    }
    else
    {
        //建立连接
        [[NetworkEngine sharedInstance] addFriend:phone.userId block:^(int event, id object)
        {
            if(event == 0)
            {
                [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"添加失败" actionText:@"确定"];
            }
            else if (event == 1)
            {
                [[LogicManager sharedInstance] setRelationSatte:phone.userId state:RequestSended];
                [contactList reloadData];
            }
        }];
    }
}
-(void)connectWeibo:(id)sender
{
    [MobClick event:SOCIAL9];
    ExtraButton* btn = (ExtraButton*)sender;
    UserInfo* info = (UserInfo*)btn.extraData;
    if(info.phone != nil && [info.phone length]>0)
    {
        //已经在app里面 建立链接
        [self.navigationController.navigationBar showLoadingIndicator];
        [[NetworkEngine sharedInstance] addFriend:info.userId block:^(int event, id object)
        {
            [self.navigationController.navigationBar hideLoadingIndicator];
            if(event == 0)
            {
                [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"添加失败" actionText:@"确定"];
            }
            else if (event == 1)
            {
                [[LogicManager sharedInstance] setRelationSatte:info.userId state:RequestSended];
                __block UITableView* tb = weiboList;
                HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark"]];
                HUD.labelText = @"申请已发送";
                HUD.detailsLabelText = @"请等待对方回应";
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.completionBlock =
                ^{
                    [tb reloadData];
                };
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
                
                
            }
        }];
    }
    else
    {
        //邀请
//        [[LogicManager sharedInstance] sendWeiBo:[NSString stringWithFormat:@"发微博 @%@",info.name]];
        [self.navigationController.navigationBar showLoadingIndicator];
        NSString* s = [NSString stringWithFormat:@"我是 %@，我正在使用职脉，拓展人脉、找人才、求内推,各种靠谱！我的职脉号：%@，邀请你一起来，下载http://zhimai.me ",[UserInfo myselfInstance].name,[UserInfo myselfInstance].userId];
        [[NetworkEngine sharedInstance] commentWeibo:info.weiboId content:s block:^(int event, id object)
        {
            [self.navigationController.navigationBar hideLoadingIndicator];
            if(event == 0)
            {
                [[LogicManager sharedInstance] showAlertWithTitle:nil message:object actionText:@"确定"];
            }
            else if (event == 1)
            {
                __block UITableView* tb = weiboList;
                [[LogicManager sharedInstance] setRelationSatte:info.userId state:RequestSended];
                HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark"]];
                HUD.labelText = @"对方还没有安装职脉";
                HUD.detailsLabelText = @"已通过微博给他留言";
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.completionBlock =
                ^{
                    [tb reloadData];
                };
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
            }
        }];
//        [[LogicManager sharedInstance] commentLatestWeibo:@"不要担心这只是一个测试" weiboUid:info.weiboId block:^(int event, id object)
//        {

//        }];
    }
}

#pragma MessageUI delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
            
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


-(void)switchTableView:(int)tag
{
    if(tag == 1)
    {
        //通讯录
        segementBackground.image = [UIImage imageNamed:@"friendTab1"];
        dataType = 0;
    }
    else if(tag == 2)
    {
        //微博
        segementBackground.image = [UIImage imageNamed:@"friendTab2"];
        dataType = 1;
    }
    else if(tag == 3)
    {
        //微信
        segementBackground.image = [UIImage imageNamed:@"friendTab3"];
        dataType = 2;
    }
    [self switchDataSource];
}
#pragma --mark MMPagingScrollViewDelegate
- (void) scrollView:(MMPagingScrollView *)scrollView willShowPageAtIndex:(NSInteger)index
{
    [self switchTableView:(int)index+1];
}
#pragma --mark UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == contactList)
    {
        return [contactsDataSource count];
    }
    else if (tableView == weiboList)
    {
        return [weiboDataSource count];
    }
    else if (tableView == linkedinList)
    {
        return [linkedinDataSource count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == contactList)
    {
        return [self buildCell1:tableView cellForRowAtIndexPath:indexPath];
    }
    else if (tableView == weiboList)
    {
        return [self buildCell2:tableView cellForRowAtIndexPath:indexPath];
    }
    else if (tableView == linkedinList)
    {
        return [self buildCell3:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UITableViewCell*)buildCell1:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* Identifier = @"Cell1";
    CustomMarginCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil)
    {
        cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = cellBackgroundView;
        
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = getFontWith(YES, 13);
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = getFontWith(NO, 12);
        cell.detailTextLabel.textColor = colorWithHex(0x3287E6);
    }
    cell.textLabel.text = @"";
    cell.imageView.image = nil;
    cell.detailTextLabel.text = @"";
    
    PhoneBookInfo* phone = (PhoneBookInfo*)[contactsDataSource objectAtIndex:indexPath.row];
    if(phone != nil)
    {
        cell.textLabel.text = phone.name;
        ExtraButton* button = (ExtraButton*)[cell.contentView viewWithTag:10];
        if(button == nil)
        {
            button = [[ExtraButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-80, 18, 65, 24)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
            button.tag = 10;
            [button addTarget:self action:@selector(connectContact:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
        }
        if(phone.userId !=nil && [phone.userId length]>0)
        {
            //已经在app里面 建立链接
            RelationState state = [[LogicManager sharedInstance] getRelationState:phone.userId];
            if(state == RequestSended)
            {
                [button setTitle:@"建立联系" forState:UIControlStateNormal];
                [button setBackgroundImage:nil forState:UIControlStateNormal];
                button.backgroundColor = colorWithHex(0xCCCCCC);
                button.enabled = NO;
            }
            else if (state == Stranger)
            {
                [button setTitle:@"建立联系" forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"connectFriend"] forState:UIControlStateNormal];
                button.enabled = YES;
            }
        }
        else
        {
            //邀请
            RelationState state = [[LogicManager sharedInstance] getRelationState:phone.userId];
            if(state == RequestSended)
            {
                [button setTitle:@"邀请" forState:UIControlStateNormal];
                [button setBackgroundImage:nil forState:UIControlStateNormal];
                button.backgroundColor = colorWithHex(0xCCCCCC);
                button.enabled = NO;
            }
            else if (state == Stranger)
            {
                [button setTitle:@"邀请" forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"inviteFriendBack"] forState:UIControlStateNormal];
                button.enabled = YES;
            }
        }
        button.extraData = phone;
        [self customLine:cell height:60];
    }
    return cell;
}
-(UITableViewCell*)buildCell2:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* Identifier = @"Cell2";
    CustomMarginCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil)
    {
        cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = cellBackgroundView;
        
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = getFontWith(YES, 13);
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = getFontWith(NO, 12);
        cell.detailTextLabel.textColor = colorWithHex(0x3287E6);
    }
    cell.textLabel.text = @"";
    cell.imageView.image = nil;
    cell.detailTextLabel.text = @"";
    
    
    
    UserInfo* info = [weiboDataSource objectAtIndex:indexPath.row];
    EGOImageView* image = (EGOImageView*)[cell.contentView viewWithTag:2];
    if(image == nil)
    {
        image = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        image.tag = 2;
        image.placeholderImage = [UIImage imageNamed:@"defaultHead"];
        [cell.contentView addSubview:image];
    }
    
    UILabel* name = (UILabel*)[cell.contentView viewWithTag:3];
    if(name == nil)
    {
        name = [[UILabel alloc]initWithFrame:CGRectMake(60, 12, cell.contentView.frame.size.width-100, 21)];
        name.backgroundColor = [UIColor clearColor];
        [name setFont:[UIFont systemFontOfSize:14]];
        name.tag = 3;
        [cell.contentView addSubview:name];
    }
    
    RCLabel* lbl = (RCLabel*)[cell.contentView viewWithTag:4];
    if(lbl == nil)
    {
        lbl = [[RCLabel alloc]initWithFrame:CGRectMake(60, 33, cell.contentView.frame.size.width-140, 20)];
        lbl.backgroundColor= [UIColor clearColor];
        [cell.contentView addSubview:lbl];
        lbl.tag = 4;
    }
    if(info != nil)
    {
        [name setText:info.name];
        [image setImageURL:[NSURL URLWithString:info.avatar]];
        [lbl setText:[NSString stringWithFormat:@"<font size=12 color='#999999'>%@  %@</font>",info.company,info.job]];
    }
    ExtraButton* button = (ExtraButton*)[cell.contentView viewWithTag:5];
    if(button == nil)
    {
        button = [[ExtraButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-75,17, 65, 24)];
        button.tag = 5;
        button.backgroundColor = [UIColor lightGrayColor];
        button.adjustsImageWhenHighlighted = YES;
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button addTarget:self action:@selector(connectWeibo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        cell.contentView.userInteractionEnabled = YES;
        button.extraData = info;
    }
    if(info.phone != nil && [info.phone length]>0)
    {
        //已经在app里面 建立链接
        RelationState state = [[LogicManager sharedInstance] getRelationState:info.userId];
        if(state == RequestSended)
        {
            [button setTitle:@"建立联系" forState:UIControlStateNormal];
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            button.backgroundColor = colorWithHex(0xCCCCCC);
            button.enabled = NO;
        }
        else if (state == Stranger)
        {
            [button setTitle:@"建立联系" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"connectFriend"] forState:UIControlStateNormal];
            button.enabled = YES;
        }
    }
    else
    {
        //邀请
        RelationState state = [[LogicManager sharedInstance] getRelationState:info.userId];
        if(state == RequestSended)
        {
            [button setTitle:@"邀请" forState:UIControlStateNormal];
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            button.backgroundColor = colorWithHex(0xCCCCCC);
            button.enabled = NO;
        }
        else if (state == Stranger)
        {
            [button setTitle:@"邀请" forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"inviteFriendBack"] forState:UIControlStateNormal];
            button.enabled = YES;
        }
    }
    [self customLine:cell height:60];
    return cell;
}
-(UITableViewCell*)buildCell3:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* Identifier = @"Cell3";
    CustomCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil)
    {
        cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = cellBackgroundView;
        
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = getFontWith(YES, 13);
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = getFontWith(NO, 12);
        cell.detailTextLabel.textColor = colorWithHex(0x3287E6);
    }
    cell.textLabel.text = @"";
    cell.imageView.image = nil;
    cell.detailTextLabel.text = @"";
    
#if 0
    NSDictionary* dic = [linkedinDataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
    ExtraButton* btn = (ExtraButton*)[cell.contentView viewWithTag:10];
    if(btn == nil)
    {
        btn = [[ExtraButton alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-80, 18, 65, 24)];
        [btn setBackgroundImage:[UIImage imageNamed:@"inviteFriendBack"] forState:UIControlStateNormal];
        [btn setTitle:@"邀请" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        btn.tag = 10;
        [btn addTarget:self action:@selector(inviteContactFriend:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    btn.extraData = dic;
#endif
    
    [self customLine:cell height:60];
    return cell;
}
-(void)customLine:(UITableViewCell*)cell height:(float)height
{
    if(cell == nil || cell.contentView == nil)
    {
        return;
    }
    UIView* line = [cell.contentView viewWithTag:100];
    if(line == nil)
    {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, height-0.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = colorWithHex(0xCCCCCC);
        line.tag = 100;
        [cell.contentView addSubview:line];
    }
}
-(void)inviteContactFriend:(id)sender
{
    ExtraButton* btn = (ExtraButton*)sender;
    NSDictionary* dic = (NSDictionary*)btn.extraData;
    if(dic)
    {
        
    }
}

-(void)shareTOWechat:(UIImage*)image
{
    //分享到朋友圈次数
    [MobClick event:CONTACTS7];
    
//    NSString* identify = _article.articleID;
    NSString *identify = @"文章Id";
    NSString *title = @"文章title";
//    NSString* title = _article.title;
    //    NSString* describe = _article.summary;
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

-(void)HUDCustomAction:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.margin = 10.f;
    hud.yOffset = -30.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

@end
