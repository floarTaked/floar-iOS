//
//  ProfileViewController.m
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "CustomCellView.h"
#import "NetworkEngine.h"
#import "ChatViewController.h"
#import "CommonFriendsViewController.h"
#import "WeiBoProfileViewController.h"
#import "WorkListViewController.h"
#import "EducationListViewController.h"
@interface OtherProfileViewController ()
{
}
@end

@implementation OtherProfileViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    
    haveSameFriend = NO;
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack
                                                                 title:nil
                                                                target:self
                                                              selector:@selector(back:)];
    [self.navigationItem setTitleViewWithText:@"人脉详情"];
    self.wantsFullScreenLayout = YES;
    UIView* head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, headView.frame.size.width, headView.frame.size.height)];
    head.backgroundColor = [UIColor clearColor];
    table.tableHeaderView = head;
    
    UIView* foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, 20)];
    foot.backgroundColor = [UIColor clearColor];
    table.tableFooterView = foot;
    
    
    headView.frame = CGRectMake(-10, 0, headView.frame.size.width, headView.frame.size.height);
    [table addSubview:headView];
    NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[ProfileInfo class]
                                                              tableName:nil
                                                              condition:[NSString stringWithFormat:@" where DBUid='%@' and userId='%@'",[UserInfo myselfInstance].userId ,self.userId]];
    
    if(arr != nil && [arr count]>0)
    {
        profileInfo = [arr objectAtIndex:0];
        [self fillHeadView];
    }
    [[NetworkEngine sharedInstance] getProfileInfo:self.userId block:^(int event, id object)
     {
         if(event == 0)
         {
             HUD.labelText = @"获取数据失败";
             [HUD hide:YES afterDelay:1];
         }
         else if (event == 1)
         {
             [HUD hide:YES];
             profileInfo = (ProfileInfo*)object;
             [self fillHeadView];
         }
     }];
}
-(IBAction)buttonAction:(id)sender
{
    if(profileInfo == nil || profileInfo.userInfo == nil)
    {
        return;
    }
    RelationState state = [[LogicManager sharedInstance] getRelationState:self.userId];
    if(state == Friends)
    {
        //发消息
        ChatViewController* chat = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
        chat.otherName = profileInfo.userInfo.name;
        chat.otherUserId = self.userId;
        chat.otherAvatar = profileInfo.userInfo.avatar;
        [self.navigationController pushViewController:chat animated:YES];
    }
    else if(state == Stranger)
    {
        if(![[LogicManager sharedInstance] isInApp:profileInfo.userInfo])
        {
            [MobClick event:SOCIAL6];
            [self.navigationController.navigationBar showLoadingIndicator];
            
            NSString* s = [NSString stringWithFormat:@"我是 %@，我正在使用职脉，拓展人脉、找人才、求内推,各种靠谱！我的职脉号：%@，邀请你一起来，下载http://zhimai.me ",[UserInfo myselfInstance].name,[UserInfo myselfInstance].userId];
            [[NetworkEngine sharedInstance] commentWeibo:profileInfo.userInfo.weiboId content:s block:^(int event, id object)
             {
                 [self.navigationController.navigationBar hideLoadingIndicator];
                 if(event == 0)
                 {
                     [[LogicManager sharedInstance] showAlertWithTitle:nil message:object actionText:@"确定"];
                 }
                 else if (event == 1)
                 {
                     [[LogicManager sharedInstance] setRelationSatte:profileInfo.userInfo.userId state:RequestSended];
                     HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark"]];
                     HUD.labelText = @"对方还没有安装职脉";
                     HUD.detailsLabelText = @"已通过微博给他留言";
                     HUD.mode = MBProgressHUDModeCustomView;
                     HUD.completionBlock =
                     ^{
                         [(UIButton*)sender setBackgroundImage:[UIImage imageNamed:@"connectTaFinished"] forState:UIControlStateNormal];
                         [(UIButton*)sender setBackgroundImage:[UIImage imageNamed:@"connectTaFinished"] forState:UIControlStateHighlighted];
                         [(UIButton*)sender setEnabled:NO];
                         [(UIButton*)sender setHighlighted:YES];
                     };
                     [HUD show:YES];
                     [HUD hide:YES afterDelay:1];
                     [MobClick event:SOCIAL7];
                 }
             }];
        }
        else
        {
            //建立联系
            [self.navigationController.navigationBar showLoadingIndicator];
            [[NetworkEngine sharedInstance] addFriend:self.userId block:^(int event, id object)
             {
                 [MobClick event:SOCIAL5];
                 [self.navigationController.navigationBar hideLoadingIndicator];
                 if(event == 0)
                 {
                     [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"加好友失败" actionText:@"确定"];
                 }
                 else if (event == 1)
                 {
                     [[LogicManager sharedInstance] setRelationSatte:self.userId state:RequestSended];
                     HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark"]];
                     HUD.labelText = @"申请已发送";
                     HUD.detailsLabelText = @"请等待对方回应";
                     HUD.mode = MBProgressHUDModeCustomView;
                     HUD.completionBlock =
                     ^{
                         [(UIButton*)sender setEnabled:NO];
                         [(UIButton*)sender setHighlighted:YES];
                     };
                     [HUD show:YES];
                     [HUD hide:YES afterDelay:1];
                 }
             }];
        }
    }
}
-(void)fillHeadView
{
    RelationState state = [[LogicManager sharedInstance] getRelationState:self.userId];
    if(state == Friends)
    {
        [actionButton setBackgroundImage:[UIImage imageNamed:@"sendMessage"] forState:UIControlStateNormal];
        [actionButton setBackgroundImage:[UIImage imageNamed:@"sendMessageSelected"] forState:UIControlStateHighlighted];
    }
    else
    {
        if(![[LogicManager sharedInstance] isInApp:profileInfo.userInfo])
        {
            [actionButton setBackgroundImage:[UIImage imageNamed:@"connectTa"] forState:UIControlStateNormal];
            [actionButton setBackgroundImage:[UIImage imageNamed:@"connectTaSelected"] forState:UIControlStateHighlighted];
        }
        else
        {
            [actionButton setBackgroundImage:[UIImage imageNamed:@"connect"] forState:UIControlStateNormal];
            [actionButton setBackgroundImage:[UIImage imageNamed:@"connectSelected"] forState:UIControlStateHighlighted];
        }
        if(state == RequestSended)
        {
            [actionButton setEnabled:NO];
            [actionButton setHighlighted:YES];
            
            [actionButton setBackgroundImage:[UIImage imageNamed:@"connectTaFinished"] forState:UIControlStateNormal];
            [actionButton setBackgroundImage:[UIImage imageNamed:@"connectTaFinished"] forState:UIControlStateHighlighted];
        }
    }
    
    [headImageView setImageURL:[NSURL URLWithString:profileInfo.userInfo.avatar]];
    NSMutableString* str = [[NSMutableString alloc]init];
    [str appendFormat:@"<p lineSpacing=5 ><font color='#464646' face='FZLTZHK--GBK1-0' size=16>%@</font></p>",profileInfo.userInfo.name];
    [str appendFormat:@"\n<p lineSpacing=5 ><font size=12>%@</font></p>",profileInfo.userInfo.company];
    [str appendFormat:@"\n<p lineSpacing=5 ><font size=12>%@</font></p>",profileInfo.userInfo.job];
    [str appendFormat:@"\n<p lineSpacing=5 ><font size=12>职脉号:%@</font></p>",profileInfo.userInfo.userId];
    [descLabel setText:str];
    CityObject* city = [[LogicManager sharedInstance] getPublicObject:profileInfo.userInfo.city type:City];
    [locationLabel setText:city.fullName];
    
    if(profileInfo.sameFriendArray != nil && [profileInfo.sameFriendArray count]>0)
    {
        haveSameFriend = YES;
    }
    else
    {
        haveSameFriend = NO;
    }
    [table reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView*)getAvatarListView
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 55)];
    v.backgroundColor = [UIColor clearColor];
    
    int count = 0;
    for(UserInfo* info in profileInfo.sameFriendArray)
    {
        EGOImageView* image = [[EGOImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        image.center = CGPointMake(25+ count* 39, 55/2);
        image.imageURL = [NSURL URLWithString:info.avatar];
        [v addSubview:image];
        count++;
        if(count >= 7)
        {
            UIImageView* moreView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"moreFriendMask"]];
            moreView.center = image.center;
            [v addSubview:moreView];
            break;
        }
    }
    return v;
}
#pragma --mark TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            if(!haveSameFriend)
            {
                return 0;
            }
            else
            {
                return 2;
            }
        }
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 5;
            break;
        case 3:
            return 3;
            break;
        case 4:
            if(profileInfo.userInfo.tags == nil || [profileInfo.userInfo.tags length]<=0)
            {
                return 0;
            }
            else
            {
                return 2;
            }
            break;
        case 5:
            if(profileInfo.userInfo.blog == nil || [profileInfo.userInfo.blog length]<=0)
            {
                return 0;
            }
            else
            {
                return 2;
            }
            break;
        default:
            return 0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 30;
    }
    else
    {
        if(indexPath.section == 1 && indexPath.row == 1)
        {
            if(profileInfo.userInfo.phoneStatus == 1)
            {
                //隐藏手机号
                return 0;
            }
        }
        if(indexPath.section == 4)
        {
            UIView* v = [[LogicManager sharedInstance] getTagView:profileInfo.userInfo];
            return v.frame.size.height;
        }
        return 55;
    }
    return 0;
}
- (CustomCellView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        NSString* Identifier = @"SectionHeader";
        CustomCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        if(indexPath.section == 0)
        {
            cell.textLabel.text = @"共同好友";
        }
        else if(indexPath.section == 1)
        {
            cell.textLabel.text = @"联系方式";
        }
        else if(indexPath.section == 2)
        {
            cell.textLabel.text = @"职业信息";
        }
        else if(indexPath.section == 3)
        {
            cell.textLabel.text = @"教育背景";
        }
        else if(indexPath.section == 4)
        {
            cell.textLabel.text = @"职脉标签";
        }
        else if(indexPath.section == 5)
        {
            cell.textLabel.text = @"博客";
        }
        cell.textLabel.textColor = colorWithHex(0x666666);
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        return cell;
    }
    else
    {
        CustomCellView* cell = nil;
        NSString* Identifier = @"Cell";
        if(indexPath.section == 0 || indexPath.section == 4)
        {
            if(indexPath.section == 0)
            {
                Identifier = @"SameFriend";
            }
            else if(indexPath.section == 4)
            {
                Identifier = @"TagCell";
            }
            
            cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
                cellBackgroundView.backgroundColor = [UIColor whiteColor];
                cell.backgroundView = cellBackgroundView;
                cell.backgroundColor = [UIColor whiteColor];
                cell.accessoryView.frame = CGRectMake(0, cell.accessoryView.frame.origin.y, cell.accessoryView.frame.size.width, cell.accessoryView.frame.size.height);
            }
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
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
        }
        
        if(indexPath.section == 0)
        {
            UIView* v = [cell.contentView viewWithTag:100];
            if(v == nil)
            {
                v = [self getAvatarListView];
                v.tag = 100;
                [cell.contentView addSubview:v];
            }
            return cell;
        }
        else if(indexPath.section == 1)
        {
            if(indexPath.row == 1)
            {
                if(profileInfo.userInfo.phoneStatus != 1)
                {
                    cell.textLabel.text = @"手机";
                    cell.imageView.image = [UIImage imageNamed:@"phoneIcon"];
                    [self customLine:cell];
                    cell.detailTextLabel.text = profileInfo.userInfo.phone;
                }
            }
            else if(indexPath.row == 2)
            {
                cell.textLabel.text = @"邮箱";
                cell.imageView.image = [UIImage imageNamed:@"emailIcon"];
                [self customLine:cell];
                cell.detailTextLabel.text = profileInfo.userInfo.email;
            }
            else if(indexPath.row == 3)
            {
                cell.textLabel.text = @"微博";
                cell.imageView.image = [UIImage imageNamed:@"weiboIcon"];
                cell.detailTextLabel.text = profileInfo.userInfo.weiboName;
            }
        }
        else if (indexPath.section == 2)
        {
            if(indexPath.row == 1)
            {
                cell.textLabel.text = @"行业";
                cell.imageView.image = [UIImage imageNamed:@"indusIcon"];
                [self customLine:cell];
                cell.accessoryType = UITableViewCellAccessoryNone;
                IndustryObject* ind = [[LogicManager sharedInstance] getPublicObject:profileInfo.userInfo.industryId type:Industry];
                if(ind != nil)
                {
                    cell.detailTextLabel.text = ind.name;
                }
            }
            else if(indexPath.row == 2)
            {
                cell.textLabel.text = @"级别";
                cell.imageView.image = [UIImage imageNamed:@"degIcon"];
                [self customLine:cell];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.detailTextLabel.text = [[LogicManager sharedInstance] getJobLevel:profileInfo.userInfo.jobLevel];
            }
            else if(indexPath.row == 3)
            {
                cell.textLabel.text = @"工作年限";
                cell.imageView.image = [UIImage imageNamed:@"workyearIcon"];
                [self customLine:cell];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.detailTextLabel.text = [[LogicManager sharedInstance] getJobYear:profileInfo.userInfo.jobYear];
            }
            else if(indexPath.row == 4)
            {
                cell.textLabel.text = @"工作经历";
                cell.imageView.image = [UIImage imageNamed:@"workexpIcon"];
                if(profileInfo.workArray != nil && [profileInfo.workArray count]>0)
                {
                    WorkInfo* work = [profileInfo.workArray objectAtIndex:0];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@等%d个工作",work.companyName,[profileInfo.workArray count]];
                }
            }
        }
        else if (indexPath.section == 3)
        {
            if(indexPath.row == 1)
            {
                cell.textLabel.text = @"学历";
                cell.imageView.image = [UIImage imageNamed:@"studyIcon"];
                [self customLine:cell];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[LogicManager sharedInstance] getEducation:profileInfo.userInfo.education]];

                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else if(indexPath.row == 2)
            {
                cell.textLabel.text = @"教育经历";
                cell.imageView.image = [UIImage imageNamed:@"studyexpIcon"];
                if(profileInfo.educationArray != nil && [profileInfo.educationArray count]>0)
                {
                    EducationInfo* education = [profileInfo.educationArray objectAtIndex:0];
                    cell.detailTextLabel.text =
                    [NSString stringWithFormat:@"%@等%d个工作",education.school,(int)[profileInfo.educationArray count]];
                }
            }
        }
        else if (indexPath.section == 4)
        {
            UIView* v = [cell.contentView viewWithTag:200];
            if(v == nil)
            {
                v = [[LogicManager sharedInstance] getTagView:profileInfo.userInfo];
                v.tag = 200;
                [cell.contentView addSubview:v];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
        else if (indexPath.section == 5)
        {
            cell.textLabel.text = @"地址";
            cell.detailTextLabel.textColor = colorWithHex(0x999999);
            cell.detailTextLabel.text = profileInfo.userInfo.blog;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(profileInfo == nil || profileInfo.userInfo == nil)
    {
        return;
    }
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        NSString* phone = profileInfo.userInfo.phone;
        if(phone == nil || [phone length]<=0)
        {
            return;
        }
        BOOL canCall = YES;
        NSString *deviceType = [UIDevice currentDevice].model;
        if([deviceType  isEqualToString:@"iPod touch"]||
           [deviceType  isEqualToString:@"iPad"]||
           [deviceType  isEqualToString:@"iPhone Simulator"])
        {
            canCall = NO;
        }
        
        
        if([MFMessageComposeViewController canSendText] && canCall)
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"打电话",@"发短信",nil];
            actionSheet.tag = 1;
            [actionSheet showInView:self.view];
        }
        else
        {
            if(canCall)
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"取消"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"打电话",nil];
                actionSheet.tag = 2;
                [actionSheet showInView:self.view];
            }
            else if ([MFMessageComposeViewController canSendText])
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"取消"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"发短信",nil];
                actionSheet.tag = 3;
                [actionSheet showInView:self.view];
            }
        }
    }
    else if(indexPath.section == 1 && indexPath.row == 2)
    {
        NSString* email = profileInfo.userInfo.email;
        if(email == nil || [email length]<=0)
        {
            return;
        }
        if([MFMailComposeViewController canSendMail])
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"发邮件",nil];
            actionSheet.tag = 4;
            [actionSheet showInView:self.view];
        }
    }
    else if(indexPath.section == 0 && indexPath.row == 1)
    {
        CommonFriendsViewController* commm = [[CommonFriendsViewController alloc]initWithNibName:@"CommonFriendsViewController" bundle:nil];
        commm.dataSource = profileInfo.sameFriendArray;
        [self.navigationController pushViewController:commm animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 3)
    {
        if(profileInfo.userInfo.weiboId != nil && [profileInfo.userInfo.weiboId length]>0)
        {
            WeiBoProfileViewController* profile = [[WeiBoProfileViewController alloc]init];
            profile.weiboId = profileInfo.userInfo.weiboId;
            profile.titleString = profileInfo.userInfo.name;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:profile animated:YES];
        }
    }
    else if (indexPath.section == 2 && indexPath.row == 4)
    {
        if(profileInfo.workArray != nil && [profileInfo.workArray count]>0)
        {
            WorkListViewController* workList = [[WorkListViewController alloc]initWithNibName:@"WorkListViewController" bundle:nil];
            workList.profileInfo = profileInfo;
            workList.editEnable = NO;
            [self.navigationController pushViewController:workList animated:YES];
        }
    }
    else if (indexPath.section == 3 && indexPath.row == 2)
    {
        if(profileInfo.educationArray != nil && [profileInfo.educationArray count]>0)
        {
            EducationListViewController* educationList = [[EducationListViewController alloc]initWithNibName:@"EducationListViewController" bundle:nil];
            educationList.profileInfo = profileInfo;
            educationList.editEnable = NO;
            [self.navigationController pushViewController:educationList animated:YES];
        }
    }
    else if (indexPath.section == 5 && indexPath.row == 1)
    {
        WebViewViewController *view = [[WebViewViewController alloc] init];
        view.request = [NSURLRequest requestWithURL:[NSURL URLWithString:profileInfo.userInfo.blog]];
        [self.navigationController pushViewController:view animated:YES];
    }
}
-(void)customLine:(UITableViewCell*)cell
{
    if(cell == nil || cell.contentView == nil)
    {
        return;
    }
    UIView* line = [cell.contentView viewWithTag:2];
    if(line == nil)
    {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, 54.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = colorWithHex(0xCCCCCC);
        line.tag = 2;
        [cell.contentView addSubview:line];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1)
    {
        NSString* phone = profileInfo.userInfo.phone;
        if(phone == nil || [phone length]<=0)
        {
            return;
        }
        if(buttonIndex == 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
        }
        else if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phone]]];
        }
    }
    else if (actionSheet.tag == 2)
    {
        NSString* phone = profileInfo.userInfo.phone;
        if(phone == nil || [phone length]<=0)
        {
            return;
        }
        if(buttonIndex == 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
        }
    }
    else if (actionSheet.tag == 3)
    {
        NSString* phone = profileInfo.userInfo.phone;
        if(phone == nil || [phone length]<=0)
        {
            return;
        }
        if(buttonIndex == 0)
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phone]]];
        }
    }
    else if (actionSheet.tag == 4)
    {
        NSString* email = profileInfo.userInfo.email;
        if(email == nil || [email length]<=0)
        {
            return;
        }
        if(buttonIndex == 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",email]]];
        }
    }
}
#pragma --mark
@end
