//
//  ProfileViewController.m
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "MineProfileViewController.h"
#import "MessageListViewController.h"
#import "OtherProfileViewController.h"
#import "WhoSeeMeViewController.h"
#import "EditInformationViewController.h"
#import "LogicManager+ImagePiker.h"

@implementation MineProfileViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tabBarItem.image = [UIImage imageNamed:@"me"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"meSelected"];
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
    HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    
    self.wantsFullScreenLayout = YES;
    
    UIView* foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, 20)];
    foot.backgroundColor = [UIColor clearColor];
    table.tableFooterView = foot;
    
    headView.frame = CGRectMake(0, 0, headView.frame.size.width, headView.frame.size.height);
    [self.navigationItem setRightBarButtonItem:[UIImage imageNamed:@"setting"]
                                 imageSelected:[UIImage imageNamed:@"settingSelected"]
                                         title:nil
                                         inset:UIEdgeInsetsMake(0, 0, 0, 0)
                                        target:self
                                      selector:@selector(gotoSetting:)];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAvatar:)];
    tap.numberOfTapsRequired = 1;
    [headImageView addGestureRecognizer:tap];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 50;
    headImageView.layer.borderWidth = 2;
    headImageView.layer.borderColor = [colorWithHex(0x99D5EC) CGColor];
    
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editInfo:)];
    tap.numberOfTapsRequired = 1;
    [headView addGestureRecognizer:tap];
    [self.navigationItem setTitleString:self.tabBarItem.title];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [table addGestureRecognizer:tap];
    headImageView.placeholderImage = [UIImage imageNamed:@"defaultHead2"];
//    pikerView = [CustomPickerView sharedInstance];
//    [self.navigationController.view addSubview:pikerView];
//    //newfriend:新的联系人 friends:联系人列表 msg:消息 feeds:职脉圈
//    [[HeartBeatManager sharedInstane] registerInvokeMethod:@"msg" callback:^(int event, id object)
//     {
//         int newMsg = [(NSNumber*)object intValue];
//         if(newMsg > 0)
//         {
//             [[NetworkEngine sharedInstance] receiveUnreadMessage:^(int event, id object)
//              {
//                  int unRead = [[LogicManager sharedInstance] getUnReadMessageCountWithOtherUser:nil];
//                  [messageTipCountView setTipCount:unRead];
//              }];
//         }
//         else
//         {
//             int unRead = [[LogicManager sharedInstance] getUnReadMessageCountWithOtherUser:nil];
//             [messageTipCountView setTipCount:unRead];
//         }
//     }];
//    [[HeartBeatManager sharedInstane] registerInvokeMethod:@"newfriend" callback:^(int event, id object)
//     {
//         int newfriend = [(NSNumber*)object intValue];
//         [contactTipCountView setTipCount:newfriend];
//     }];
//    [[HeartBeatManager sharedInstane] registerInvokeMethod:@"friends" callback:^(int event, id object){}];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar hideLoadingIndicator];
}
-(void)showBackButton
{
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
                                imageSelected:[UIImage imageNamed:@"backSelected"]
                                        title:nil
                                        inset:UIEdgeInsetsMake(0, -10, 0, 0)
                                       target:self
                                     selector:@selector(back:)];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[ProfileInfo class]
                                                              tableName:nil
                                                              condition:[NSString stringWithFormat:@" where DBUid=%d and userId=%d",[UserInfo myselfInstance].userId ,[UserInfo myselfInstance].userId]];
    
    if(arr != nil && [arr count]>0)
    {
        profileInfo = [arr objectAtIndex:0];
        profileInfo.userInfo = [UserInfo myselfInstance];
        [self fillHeadView];
        [table reloadData];
    }
    
//    [[HeartBeatManager sharedInstane] queryNetwork];
//    
//    [self.navigationController.navigationBar showLoadingIndicator];
    [[NetworkEngine sharedInstance] getUserProfile:[UserInfo myselfInstance].userId block:^(int event, id object)
     {
//         [self.navigationController.navigationBar hideLoadingIndicator];
         if(event == 0)
         {
             [[LogicManager sharedInstance] showAlertWithTitle:@"" message:@"读取信息失败" actionText:@"确定"];
         }
         else if (event == 1)
         {
             profileInfo = (ProfileInfo*)object;
             if(profileInfo.userInfo != nil)
             {
                 [profileInfo.userInfo synchronize:nil];
             }
             [self fillHeadView];
             [table reloadData];
         }
     }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        [self.view endEditing:YES];
        return NO;
    }
    return  YES;
}
-(void)endEdit:(UITapGestureRecognizer*)gues
{
    [self.view endEditing:YES];
}
-(void)gotoSetting:(id)sender
{
//    OtherProfileViewController* other = [[OtherProfileViewController alloc]initWithNibName:@"OtherProfileViewController" bundle:nil];
//    other.userId = [UserInfo myselfInstance].userId;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:other animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
    
    SettingViewController* setting = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setting animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)editInfo:(UITapGestureRecognizer*)gues
{
//    EditInformationViewController* edit = [[EditInformationViewController alloc]initWithNibName:@"EditInformationViewController" bundle:nil];
//    edit.profileInfo = profileInfo;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:edit animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}
-(void)uploadAvatar:(UIImage*)image
{
//    NSData* avatarData = UIImageJPEGRepresentation(image,0.4);
//    activeView.hidden = NO;
//    [indicator startAnimating];
//    [[NetworkEngine sharedInstance] uploadAvatar:avatarData block:^(int event, id object)
//    {
//        [indicator stopAnimating];
//        activeView.hidden = YES;
//        if(event == 0)
//        {
//            [[LogicManager sharedInstance] showAlertWithTitle:@"" message:@"上传失败" actionText:@"确定"];
//        }
//        else if (event == 1)
//        {
//            [[LogicManager sharedInstance] showAlertWithTitle:@"" message:@"上传成功" actionText:@"确定"];
////            [headImageView setImageURL:[NSURL URLWithString:object]];
//            [headImageView setImage:image];
//        }
//    }];
}
-(void)changeAvatar:(UITapGestureRecognizer*)gues
{
    [[LogicManager sharedInstance] getImage:self block:^(int event, id object)
     {
         if(object != nil)
         {
             [self uploadAvatar:object];
         }
     }];
}
-(void)save:(id)value key:(NSString*)key
{
//    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:value==nil?@"":value,key==nil?@"":key, nil];
//    NSString *json = [[LogicManager sharedInstance] objectToJsonString:dic];
//    [self.navigationController.navigationBar showLoadingIndicator];
//    [[NetworkEngine sharedInstance] saveProfileInfo:json block:^(int event, id object)
//    {
//        [self.navigationController.navigationBar hideLoadingIndicator];
//        if(event == 0)
//        {
//            [[LogicManager sharedInstance] showAlertWithTitle:@"" message:@"修改失败" actionText:@"确定"];
//        }
//        else if (event == 1)
//        {
//            if(object != nil)
//            {
//                profileInfo.userInfo = [UserInfo myselfInstance];
//            }
//        }
//    }];
}
-(void)clearState
{
    [self.view endEditing:YES];
//    [pikerView hide];
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [pikerView hide];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clearState];
    return YES;
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
    
    
    [str appendFormat:@"<p lineSpacing=5 ><font color='#FFFFFF' face='FZLTZHK--GBK1-0' size=25>%@</font></p>",name];
    [str appendFormat:@"\n<p lineSpacing=2 ><font color='#FFFFFF' face='FZLTZHK--GBK1-0' size=16>职脉号:%d</font></p>",
     profileInfo.userInfo.userId];
    [str appendFormat:@"\n<p lineSpacing=2 ><font color='#FFFFFF' size=14>%@</font></p>",profileInfo.userInfo.jobCode];
    [str appendFormat:@"\n<p lineSpacing=2 ><font color='#FFFFFF' size=14>%@</font></p>",profileInfo.userInfo.company];
    
    [descLabel setText:str];
//    CityObject* city = [[LogicManager sharedInstance] getPublicObject:profileInfo.userInfo.city type:City];
//    [locationLabel setTextColor:colorWithHex(0x999999)];
//    [locationLabel setText:city.fullName];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma --mark TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return headView.frame.size.height;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0.6;
    }
    else if(section == 1)
    {
        return 20;
    }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString* Identifier = @"headCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow3"]];
            UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cellBackgroundView.backgroundColor = [UIColor whiteColor];
            cell.backgroundView = cellBackgroundView;
            [cell.contentView addSubview:headView];
        }
        return cell;
    }
    else
    {
        static NSString* Identifier = @"Cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow1"]];
            
            UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cellBackgroundView.backgroundColor = [UIColor whiteColor];
            cell.backgroundView = cellBackgroundView;
            
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.font =  getFontWith(YES, 15);
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.font = getFontWith(NO, 12);
            cell.detailTextLabel.textColor = colorWithHex(0x3287E6);
        }
        cell.textLabel.text = @"";
        cell.imageView.image = nil;
        cell.detailTextLabel.text = @"";
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"分享名片";
            cell.imageView.image = [UIImage imageNamed:@"shareCard"];
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Linked in资料";
            cell.imageView.image = [UIImage imageNamed:@"linkedInInfo"];
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = @"我的发布";
            cell.imageView.image = [UIImage imageNamed:@"myPublish"];
        }
        else if(indexPath.row == 3)
        {
            cell.textLabel.text = @"谁看过我";
            cell.imageView.image = [UIImage imageNamed:@"lookMe"];
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        EditInformationViewController* edit = [[EditInformationViewController alloc]initWithNibName:@"EditInformationViewController" bundle:nil];
        edit.profileInfo = profileInfo;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:edit animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {

        }
        else if (indexPath.row == 1)
        {
            
        }
        else if (indexPath.row == 2)
        {
            
        }
        else
        {
            WhoSeeMeViewController *seeMe = [[WhoSeeMeViewController alloc] initWithNibName:NSStringFromClass([WhoSeeMeViewController class]) bundle:nil];
            seeMe.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:seeMe animated:YES];
            
        }
    }
}
@end
