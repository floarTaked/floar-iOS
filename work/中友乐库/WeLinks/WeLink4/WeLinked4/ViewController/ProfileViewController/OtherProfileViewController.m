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
#import "WorkInfo.h"
#import "EducationInfo.h"
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
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
                                imageSelected:[UIImage imageNamed:@"backSelected"]
                                        title:nil
                                        inset:UIEdgeInsetsMake(0, -20, 0, 0)
                                       target:self
                                     selector:@selector(back:)];
    [self.navigationItem setTitleString:@"人脉详情"];
    self.wantsFullScreenLayout = YES;
    UIView* head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, headView.frame.size.width, headView.frame.size.height+20)];
    head.backgroundColor = [UIColor clearColor];
    table.tableHeaderView = head;
    
    UIView* foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, 20)];
    foot.backgroundColor = [UIColor clearColor];
    table.tableFooterView = foot;
    
    
    headView.frame = CGRectMake(0, 0, headView.frame.size.width, headView.frame.size.height);
    [table addSubview:headView];
    
    headImageView.placeholderImage = [UIImage imageNamed:@"defaultHead"];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 50;
    headImageView.layer.borderWidth = 2;
    headImageView.layer.borderColor = [colorWithHex(0x99D5EC) CGColor];
    
    if([[LogicManager sharedInstance] isMyFriend:self.userId])
    {
        phoneButton.hidden = NO;
        messageButton.hidden = NO;
        emailButton.hidden = NO;
        addFriendButton.hidden = YES;
    }
    else
    {
        phoneButton.hidden = YES;
        messageButton.hidden = YES;
        emailButton.hidden = YES;
        addFriendButton.hidden = NO;
        
        
        
        RelationState state = [[LogicManager sharedInstance] getRelationState:self.userId];
        if(state == Stranger)
        {
            addFriendButton.enabled = YES;
        }
        else if (state == RequestSended)
        {
            addFriendButton.enabled = NO;
        }
        else if (state == Friends)
        {
            addFriendButton.enabled = NO;
        }
    }
    
    NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[ProfileInfo class]
                                                              tableName:nil
                                                              condition:[NSString stringWithFormat:@" where DBUid=%d and userId=%d",[UserInfo myselfInstance].userId ,self.userId]];
    
    if(arr != nil && [arr count]>0)
    {
        profileInfo = [arr objectAtIndex:0];
        [self fillHeadView];
    }
    [[NetworkEngine sharedInstance] getUserProfile:self.userId block:^(int event, id object)
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
    UIButton* btn = (UIButton*)sender;
    int tag = (int)btn.tag;
    if(profileInfo == nil || profileInfo.userInfo == nil)
    {
        return;
    }
    if(tag == 1)
    {
        NSString* phone = profileInfo.userInfo.phone;
        if(phone == nil || [phone length]<=0)
        {
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
    }
    else if(tag == 2)
    {
        NSString* phone = profileInfo.userInfo.phone;
        if(phone == nil || [phone length]<=0)
        {
            return;
        }
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phone]]];
    }
    else if (tag == 3)
    {
        NSString* email = profileInfo.userInfo.email;
        if(email == nil || [email length]<=0)
        {
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",email]]];
    }
    else if (tag == 4)
    {
        //已是好友  发消息
        //ChatViewController* chat = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
        //chat.otherName = profileInfo.userInfo.name;
        //chat.otherUserId = self.userId;
        //chat.otherAvatar = profileInfo.userInfo.avatar;
        //[self.navigationController pushViewController:chat animated:YES];
        [[NetworkEngine sharedInstance] addFriend:self.userId block:^(int event, id object)
        {
            if(event == 0)
            {
                [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"添加失败,请检查网路" actionText:@"确定"];
            }
            else if (event == 1)
            {
                [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"请求已发出,请等待对方确认" actionText:@"确定"];
                [[LogicManager sharedInstance] setRelationSatte:self.userId state:RequestSended];
                addFriendButton.enabled = NO;
            }
        }];
    }
}
-(void)fillHeadView
{
    [headImageView setImageURL:[NSURL URLWithString:profileInfo.userInfo.avatar]];
    NSMutableString* str = [[NSMutableString alloc]init];
    NSString* name = profileInfo.userInfo.name;
    if(name != nil && [name length]>8)
    {
        name = [name substringToIndex:8];
    }
    //    [str appendFormat:@"<p lineSpacing=5 ><font color='#464646' face='FZLTZHK--GBK1-0' size=16>%@</font></p>",name];
    //    [str appendFormat:@"\n<p lineSpacing=5 ><font size=12>%@</font></p>",profileInfo.userInfo.company];
    //    [str appendFormat:@"\n<p lineSpacing=5 ><font size=12>%@</font></p>",profileInfo.userInfo.job];
    //    [str appendFormat:@"\n<p lineSpacing=5 ><font size=12>职脉号:%@</font></p>",profileInfo.userInfo.userId];
    
    [str appendFormat:@"<p lineSpacing=5 ><font color='#FFFFFF' face='FZLTZHK--GBK1-0' size=25>%@</font></p>",profileInfo.userInfo.name];
    [str appendFormat:@"\n<p><font color='#FFFFFF' face='FZLTZHK--GBK1-0' size=13>职脉号:%d</font></p>",profileInfo.userInfo.userId];
    [str appendFormat:@"\n<p><font color='#FFFFFF' size=12>%@</font></p>",profileInfo.userInfo.jobCode];
    [str appendFormat:@"\n<p><font color='#FFFFFF' size=12>%@</font></p>",profileInfo.userInfo.company];
    [descLabel setText:str];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma --mark TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 4;
            break;
        case 3:
            return 3;
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
        if(indexPath.section != 0)
        {
            return 30;
        }
    }
    else
    {
        return 44;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && indexPath.section != 0)
    {
        NSString* Identifier = @"SectionHeader";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        if(indexPath.section == 1)
        {
            cell.imageView.image = [UIImage imageNamed:@"skillInfo"];
        }
        else if(indexPath.section == 2)
        {
            cell.imageView.image = [UIImage imageNamed:@"detailInfo"];
        }
        else if(indexPath.section == 3)
        {
           cell.imageView.image = [UIImage imageNamed:@"socialInfo"];
        }
        cell.textLabel.textColor = colorWithHex(0x666666);
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        return cell;
    }
    else
    {
        UITableViewCell* cell = nil;
        if (indexPath.section == 3)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3"];
            cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell3"];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"Cell"];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = cellBackgroundView;
        
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = getFontWith(YES, 13);
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = getFontWith(NO, 13);
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        
        cell.textLabel.text = @"";
        cell.imageView.image = nil;
        cell.detailTextLabel.text = @"";
        
        if(indexPath.section == 0)
        {
            cell.textLabel.text = @"简介";
            cell.detailTextLabel.text = profileInfo.userInfo.descriptions;
        }
        else if (indexPath.section == 1)
        {
            if(indexPath.row == 1)
            {
                cell.textLabel.text = @"所在行业";
                cell.detailTextLabel.text = profileInfo.userInfo.jobCode;
                [self customLine:cell];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else if(indexPath.row == 2)
            {
                cell.textLabel.text = @"职业标签";
                cell.detailTextLabel.text = profileInfo.userInfo.tags;
                [self customLine:cell];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else if(indexPath.row == 3)
            {
                cell.textLabel.text = @"业务标签";
                cell.detailTextLabel.text = profileInfo.userInfo.jobTags;
                [self customLine:cell];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.section == 2)
        {
            if(indexPath.row == 1)
            {
                cell.textLabel.text = @"所在地";
                cell.detailTextLabel.text = profileInfo.userInfo.city;
                [self customLine:cell];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else if(indexPath.row == 2)
            {
                cell.textLabel.text = @"工作经历";
                if(profileInfo.workArray != nil && [profileInfo.workArray count]>0)
                {
                    WorkInfo* info = [profileInfo.workArray objectAtIndex:0];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@等%d个经历",
                                                 info.jobTitle==nil?@"":info.jobTitle,
                                                 [profileInfo.workArray count]];
                }
                else
                {
                    cell.detailTextLabel.text = @"暂无经历";
                }
                [self customLine:cell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if(indexPath.row == 3)
            {
                cell.textLabel.text = @"学历经历";
                
                
                if(profileInfo.educationArray != nil && [profileInfo.educationArray count]>0)
                {
                    EducationInfo* info = [profileInfo.educationArray objectAtIndex:0];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@等%d个经历",
                                                 info.school==nil?@"":info.school,
                                                 [profileInfo.educationArray count]];
                }
                else
                {
                    cell.detailTextLabel.text = @"暂无学历";
                }
                [self customLine:cell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else if (indexPath.section == 3)
        {
            UILabel* lbl = (UILabel*)[cell.contentView viewWithTag:10];
            if(lbl == nil)
            {
                lbl = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 100, cell.contentView.frame.size.height)];
                lbl.tag = 10;
                [cell.contentView addSubview:lbl];
                lbl.backgroundColor = [UIColor clearColor];
                lbl.font = getFontWith(NO, 13);
                lbl.textAlignment = NSTextAlignmentLeft;
                lbl.textColor = [UIColor lightGrayColor];
            }
            if(indexPath.row == 1)
            {
                cell.textLabel.text = @"新浪微博";
                lbl.text = profileInfo.userInfo.weiboName;
                lbl.textAlignment = NSTextAlignmentLeft;
                [self customLine:cell];
                cell.imageView.image = [UIImage imageNamed:@"weibo"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if(indexPath.row == 2)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Linked in"];
                lbl.text = profileInfo.userInfo.linkedInName;
                lbl.textAlignment = NSTextAlignmentLeft;
                cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
                [self customLine:cell];
                cell.imageView.image = [UIImage imageNamed:@"linkedInInfo"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
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
    
    if(indexPath.section == 0 && indexPath.row == 1)
    {
//        CommonFriendsViewController* commm = [[CommonFriendsViewController alloc]initWithNibName:@"CommonFriendsViewController" bundle:nil];
//        commm.dataSource = profileInfo.sameFriendArray;
//        [self.navigationController pushViewController:commm animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 3)
    {
    }
    else if (indexPath.section == 2 && indexPath.row == 4)
    {
//        if(profileInfo.workArray != nil && [profileInfo.workArray count]>0)
//        {
//            WorkListViewController* workList = [[WorkListViewController alloc]initWithNibName:@"WorkListViewController" bundle:nil];
//            workList.profileInfo = profileInfo;
//            workList.editEnable = NO;
//            [self.navigationController pushViewController:workList animated:YES];
//        }
    }
    else if (indexPath.section == 3 && indexPath.row == 2)
    {
//        if(profileInfo.educationArray != nil && [profileInfo.educationArray count]>0)
//        {
//            EducationListViewController* educationList = [[EducationListViewController alloc]initWithNibName:@"EducationListViewController" bundle:nil];
//            educationList.profileInfo = profileInfo;
//            educationList.editEnable = NO;
//            [self.navigationController pushViewController:educationList animated:YES];
//        }
    }
    else if (indexPath.section == 5 && indexPath.row == 1)
    {
//        WebViewViewController *view = [[WebViewViewController alloc] init];
//        view.request = [NSURLRequest requestWithURL:[NSURL URLWithString:profileInfo.userInfo.blog]];
//        [self.navigationController pushViewController:view animated:YES];
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
        line = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = colorWithHex(0xCCCCCC);
        line.tag = 2;
        [cell.contentView addSubview:line];
    }
}
#pragma --mark
@end
