//
//  SettingViewController.m
//  UnNamed
//
//  Created by jonas on 8/7/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import <EGOCache.h>
#import "ChatViewController.h"
#import "AppDelegate.h"
#import "SubSettingViewController.h"
#import "CustomCellView.h"
//#import "ProfileViewController.h"
@interface SettingViewController ()
{
}
@end

@implementation SettingViewController
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitleViewWithText:@"设置"];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack
                                                                 title:nil
                                                                target:self
                                                              selector:@selector(back:)];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [table reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        if([UIScreen mainScreen].bounds.size.height >480)
        {
            return 200;
        }
        else
        {
            return 120;
        }
    }
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 4;
    }
    else if(section == 1)
    {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        return 44;
    }
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CustomCellView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString* Identifier = @"Cell";
        CustomMarginCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
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
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"手机号隐私设置";
            [self customLine:cell];
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"用户反馈";
            [self customLine:cell];
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = @"给职脉好评";
            [self customLine:cell];
        }
        else if(indexPath.row == 3)
        {
            cell.textLabel.text = @"关于职脉";
            [self customLine:cell];
        }
        return cell;
    }
    else
    {
        CustomMarginCellView* cell = [[CustomMarginCellView alloc]init];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *tempView = [[UIView alloc] init];
        cell.backgroundView = tempView;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        
        UIButton* logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 0,290,42)];
        [logoutButton setBackgroundImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
        [logoutButton setBackgroundImage:[UIImage imageNamed:@"logoutSelected"] forState:UIControlStateHighlighted];
        [logoutButton.titleLabel setFont:getFontWith(YES, 20)];
        [logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:logoutButton];
        logoutButton.backgroundColor = [UIColor clearColor];
        return cell;
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
-(void)cleanup
{
    [table reloadData];
}
-(void)logout:(id)sender
{
//    if([UserInfo myselfInstance].havePwd == 0)
//    {
//        PasswordViewController* pwd = [[PasswordViewController alloc]initWithNibName:@"PasswordViewController" bundle:nil];
//        pwd.actiontype = 1;
//        [self.navigationController pushViewController:pwd animated:YES];
//    }
//    else
//    {
        [[LogicManager sharedInstance] setPersistenceData:nil withKey:USERID];
        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:0] withKey:getIdentityKey(EnableContacts)];
        [(AppDelegate*)([UIApplication sharedApplication].delegate) login];
//    }
}
#pragma --mark
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                SubSettingViewController* subSetting = [[SubSettingViewController alloc]initWithNibName:@"SubSettingViewController" bundle:nil];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:subSetting animated:YES];
            }
                break;
            case 1:
            {
                //用户反馈
                ChatViewController* chat = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
                chat.otherUserId = @"10000";
                chat.otherName = @"意见反馈";
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chat animated:YES];
            }
                break;
            case 2:
            {
                //给职脉好评
                NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APPID];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
                break;
            case 3:
            {
                //关于职脉
                AboutViewController* about = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:about animated:YES];
            }
                break;
            default:
                break;
        }
    }
}
@end
