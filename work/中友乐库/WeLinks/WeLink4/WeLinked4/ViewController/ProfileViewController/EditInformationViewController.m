//
//  EditInformationViewController.m
//  WeLinked4
//
//  Created by jonas on 5/22/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "EditInformationViewController.h"
#import "UserInfo.h"
#import "PublicObject.h"
#import "WorkInfo.h"
#import "EducationInfo.h"
#import "WorkListViewController.h"
#import "EducationListViewController.h"
#import "NetworkEngine.h"
#import "LogicManager.h"
#import "Common.h"
#import <NSDate+Calendar.h>
#import <MBProgressHUD.h>
#import "LogicManager+ImagePiker.h"
#import "TagViewController.h"
#import "TextViewViewController.h"
#import "LogicManager+ImagePiker.h"

@implementation EditInformationViewController
@synthesize profileInfo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getValue
{
    profileInfo.userInfo.name = nameFiled.text;
    profileInfo.userInfo.company = companyFiled.text;
    profileInfo.userInfo.jobCode = postFiled.text;
    profileInfo.userInfo.email = mailFiled.text;
    profileInfo.userInfo.city = addressFiled.text;
}
-(void)save:(id)sender
{
    [self getValue];
    if(![self check])
    {
        return;
    }
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         profileInfo.userInfo.name,@"name",
                         profileInfo.userInfo.company,@"company",
                         profileInfo.userInfo.jobCode,@"jobCode",
                         profileInfo.userInfo.descriptions,@"descriptions",
                         profileInfo.userInfo.industryId,@"industryId",
                         profileInfo.userInfo.tags,@"tags",
                         profileInfo.userInfo.jobTags,@"jobTags",
                         [NSNumber numberWithDouble:profileInfo.userInfo.birthday],@"birthday",
                         profileInfo.userInfo.email,@"email",
                         profileInfo.userInfo.city,@"city",
                         nil];
    NSString* json = [[LogicManager sharedInstance] objectToJsonString:dic];
    [self.navigationController.navigationBar showLoading];
    [[NetworkEngine sharedInstance] updateUserInfo:json block:^(int event, id object)
    {
        [self.navigationController.navigationBar hideLoading];
        if(event == 0)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:@"修改失败" message:(NSString*)object actionText:@"确定"];
        }
        else if (event == 1)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"修改成功" actionText:@"确定"];
        }
    }];
}
-(BOOL)check
{
    if(profileInfo.userInfo.name == nil || [profileInfo.userInfo.name length]<=0)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"请填写姓名" actionText:@"确定"];
        return NO;
    }
    if(profileInfo.userInfo.company == nil || [profileInfo.userInfo.company length]<=0)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"请填写公司" actionText:@"确定"];
        return NO;
    }
    if(profileInfo.userInfo.jobCode == nil || [profileInfo.userInfo.jobCode length]<=0)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"请填写职位" actionText:@"确定"];
        return NO;
    }
    return YES;
}
-(void)saveAvatar:(UIImage*)image
{
    NSData* avatarData = nil;
    if(newHeadImage != nil)
    {
        avatarData = UIImageJPEGRepresentation(newHeadImage,0.4);
    }
    if(avatarData == nil)
    {
        return;
    }
    [self.navigationController.navigationBar showLoading];
    [[NetworkEngine sharedInstance] updateImage:avatarData block:^(int event, id object)
    {
        [self.navigationController.navigationBar hideLoading];
        if(event == 0)
        {
            
        }
        else if (event == 1)
        {
            profileInfo.userInfo = (UserInfo*)object;
            [table reloadData];
        }
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
                                imageSelected:[UIImage imageNamed:@"backSelected"]
                                        title:nil
                                        inset:UIEdgeInsetsMake(0, -10, 0, 0)
                                       target:self
                                     selector:@selector(back:)];
    [self.navigationItem setTitleString:@"编辑个人资料"];
    [self.navigationItem setRightBarButtonItem:nil
                                 imageSelected:nil
                                         title:@"保存"
                                         inset:UIEdgeInsetsMake(0, -30, 0, 0)
                                        target:self
                                      selector:@selector(save:)];
    datePiker = [DatePikerView sharedInstance];
    [self.navigationController.view addSubview:datePiker];
    pikerView = [CustomPickerView sharedInstance];
    [self.navigationController.view addSubview:pikerView];
    
    [self.navigationController.navigationBar showLoading];
    [[NetworkEngine sharedInstance] getUserProfile:[UserInfo myselfInstance].userId block:^(int event, id object)
     {
         [self.navigationController.navigationBar hideLoading];
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
             [table reloadData];
         }
     }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [table reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)endEdit:(UITapGestureRecognizer*)gues
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma --mark TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 7;
    }
    else if (section == 1)
    {
        return 4;
    }
    else if (section == 2)
    {
        return 6;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 30;
    }
    else if (indexPath.section == 0)
    {
        if(indexPath.row == 1)
        {
            return 70;
        }
        else if (indexPath.row == 6)
        {
            if(profileInfo.userInfo.descriptions != nil && [profileInfo.userInfo.descriptions length]>0)
            {
                float height = [UILabel calculateHeightWith:profileInfo.userInfo.descriptions
                                                       font:getFontWith(NO, 13)
                                                      width:200
                                             lineBreakeMode:NSLineBreakByWordWrapping];
                return height + 30;
                
            }
            else
            {
                return 40;
            }
        }
    }
    return 40;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return [self customImageCell:table indexPath:indexPath];
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        return [self customCell3:tableView indexPath:indexPath];
    }
    else
    {
        if((indexPath.section == 0 && indexPath.row == 6)||
           (indexPath.section == 0 && indexPath.row == 3)||
           (indexPath.section == 1 && indexPath.row>0) ||
           (indexPath.section == 2 && indexPath.row == 1) ||
           (indexPath.section == 2 && indexPath.row>3))
        {
            return [self customCell1:tableView indexPath:indexPath];
        }
        else
        {
            return [self customCell2:tableView indexPath:indexPath];
        }
    }
}
-(UITableViewCell*)customImageCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString* headCell = @"headCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:headCell];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:headCell];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackgroundView.backgroundColor = colorWithHex(0xF1F1F1);
        cell.backgroundView = cellBackgroundView;
        cell.backgroundColor = [UIColor clearColor];
    }
    if(isSystemVersionIOS7())
    {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if(indexPath.section == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"basicInfo"];
    }
    else if (indexPath.section == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"skillInfo"];
    }
    else if (indexPath.section == 2)
    {
        cell.imageView.image = [UIImage imageNamed:@"detailInfo"];
    }
    return cell;
}
-(UITableViewCell*)customCell1:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString* LabelCell = @"LabelCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:LabelCell];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LabelCell];
        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = cellBackgroundView;
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font =  getFontWith(NO, 13);
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow1"]];
    if(isSystemVersionIOS7())
    {
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    UILabel*lbl = (UILabel*)[cell.contentView viewWithTag:100];
    if(lbl == nil)
    {
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 210, 40)];
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
        lbl.numberOfLines = 0;
        lbl.font = getFontWith(NO, 13);
        lbl.textColor = [UIColor lightGrayColor];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.tag = 100;
        [cell.contentView addSubview:lbl];
    }
    lbl.frame = CGRectMake(80, 0, 210, 40);
    if(indexPath.section == 0)
    {
        if (indexPath.row == 3)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
            cell.textLabel.text = @"手机";
            lbl.textColor = colorWithHex(0x3287E6);
            [lbl setText:profileInfo.userInfo.phone];
        }
        else if (indexPath.row == 6)
        {
            cell.textLabel.text = @"简介";
            
            if(profileInfo.userInfo.descriptions != nil && [profileInfo.userInfo.descriptions length]>0)
            {
                lbl.frame = CGRectMake(80, 0, 210, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
                lbl.textColor = colorWithHex(0x3287E6);
                [lbl setText:profileInfo.userInfo.descriptions];
            }
            else
            {
                lbl.textColor = [UIColor lightGrayColor];
                [lbl setText:@"你所从事的领域..."];
            }
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 1)
        {
            cell.textLabel.text = @"所在行业";
            IndustryObject *industry = [[LogicManager sharedInstance] getPublicObject:profileInfo.userInfo.industryId type:Industry];
            if(industry != nil)
            {
                lbl.textColor = colorWithHex(0x3287E6);
                [lbl setText:[NSString stringWithFormat:@"%@ %@",industry.parentName,industry.name]];
            }
            else
            {
                lbl.textColor = [UIColor lightGrayColor];
                [lbl setText:@"选择所在行业"];
            }
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"职业标签";
            NSString* tags = [UserInfo myselfInstance].jobTags;
            if(tags != nil && [tags length]>0)
            {
                NSArray* arr = [tags componentsSeparatedByString:@","];
                int count = 0;
                for(NSString* s in arr)
                {
                    if(s != nil && [s length]>0)
                    {
                        count++;
                    }
                }
                if(count > 0)
                {
                    lbl.textColor = colorWithHex(0x3287E6);
                    lbl.text = [NSString stringWithFormat:@"%@等%d个标签",[arr objectAtIndex:0],count];
                }
                else
                {
                    lbl.textColor = [UIColor lightGrayColor];
                    lbl.text = @"选择职业标签";
                }
            }
            else
            {
                lbl.textColor = [UIColor lightGrayColor];
                lbl.text = @"选择职业标签";
            }
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.text = @"业务标签";
            NSString* tags = [UserInfo myselfInstance].tags;
            if(tags != nil && [tags length]>0)
            {
                NSArray* arr = [tags componentsSeparatedByString:@","];
                int count = 0;
                for(NSString* s in arr)
                {
                    if(s != nil && [s length]>0)
                    {
                        count++;
                    }
                }
                if(count > 0)
                {
                    lbl.textColor = colorWithHex(0x3287E6);
                    lbl.text = [NSString stringWithFormat:@"%@等%d个标签",[arr objectAtIndex:0],count];
                }
                else
                {
                    lbl.textColor = [UIColor lightGrayColor];
                    lbl.text = @"选择业务标签";
                }
            }
            else
            {
                lbl.textColor = [UIColor lightGrayColor];
                lbl.text = @"选择业务标签";
            }
            if(isSystemVersionIOS7())
            {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }
    }
    else if (indexPath.section == 2)
    {
        if(indexPath.row == 1)
        {
            cell.textLabel.text = @"生日";
            if(profileInfo.userInfo.birthday >0)
            {
                lbl.textColor = colorWithHex(0x3287E6);
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:profileInfo.userInfo.birthday/1000];
                [lbl setText:[NSString stringWithFormat:@"%d年%d月%d日",date.year,date.month,date.day]];
            }
            else
            {
                lbl.textColor = [UIColor lightGrayColor];
                [lbl setText:@"选填"];
            }
        }
        else if (indexPath.row == 4)
        {
            cell.textLabel.text = @"工作经历";
            
            if(profileInfo.workArray != nil && [profileInfo.workArray count]>0)
            {
                WorkInfo* work = [profileInfo.workArray objectAtIndex:0];
                lbl.text = [NSString stringWithFormat:@"%@等%d个工作",work.companyName,(int)[profileInfo.workArray count]];
                lbl.textColor = colorWithHex(0x3287E6);
            }
            else
            {
                lbl.text = @"待补充";
                lbl.textColor = [UIColor lightGrayColor];
            }
        }
        else if (indexPath.row == 5)
        {
            cell.textLabel.text = @"学历经历";
            if(profileInfo.educationArray != nil && [profileInfo.educationArray count]>0)
            {
                EducationInfo* education = [profileInfo.educationArray objectAtIndex:0];
                lbl.text = [NSString stringWithFormat:@"%@等%d个经历",
                                             education.school,
                                             (int)[profileInfo.educationArray count]];
                lbl.textColor = colorWithHex(0x3287E6);
            }
            else
            {
                lbl.text = @"待补充";
                lbl.textColor = [UIColor lightGrayColor];
            }
            
            if(isSystemVersionIOS7())
            {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }
    }
    return cell;

}
-(UITableViewCell*)customCell2:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString* Cell = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = cellBackgroundView;
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font =  getFontWith(NO, 13);
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailTextLabel.font = getFontWith(NO, 12);
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.backgroundColor = [UIColor redColor];
    }
    if(isSystemVersionIOS7())
    {
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    cell.textLabel.text = @"";
    cell.imageView.image = nil;
    cell.detailTextLabel.text = @"";
    if(indexPath.section == 0)
    {
        if(indexPath.row == 2)
        {
            cell.textLabel.text = @"姓名";
            nameFiled = [self customTextFiled:cell placeholder:@"必填"];
            [nameFiled setText:profileInfo.userInfo.name];
        }
        else if (indexPath.row == 4)
        {
            cell.textLabel.text = @"公司";
            companyFiled = [self customTextFiled:cell placeholder:@"必填"];
            [companyFiled setText:profileInfo.userInfo.company];
        }
        else if (indexPath.row == 5)
        {
            cell.textLabel.text = @"职位";
            postFiled = [self customTextFiled:cell placeholder:@"必填"];
            [postFiled setText:profileInfo.userInfo.jobCode];
        }
    }
    else if(indexPath.section == 2)
    {
        if (indexPath.row == 2)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow1"]];
            cell.textLabel.text = @"邮箱";
            mailFiled = [self customTextFiled:cell placeholder:@"选填"];
        }
        else if (indexPath.row == 3)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow1"]];
            cell.textLabel.text = @"所在地";
            addressFiled = [self customTextFiled:cell placeholder:@"选填"];
        }
    }
    return cell;
}
-(UITableViewCell*)customCell3:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString* HeadCell = @"HeadCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:HeadCell];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeadCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow1"]];
        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = cellBackgroundView;
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font =  getFontWith(NO, 13);
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = @"形象照";
    headImageView = (EGOImageView*)[cell.contentView viewWithTag:10];
    if(headImageView == nil)
    {
        headImageView = [[EGOImageView alloc]initWithFrame:CGRectMake(80, 10, 50, 50)];
        headImageView.layer.cornerRadius = 25;
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.borderWidth = 0.5;
        headImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        headImageView.placeholderImage = [UIImage imageNamed:@"defaultHead"];
        headImageView.image = [UIImage imageNamed:@"defaultHead"];
        headImageView.tag = 10;
        [cell.contentView addSubview:headImageView];
    }
    if(newHeadImage != nil)
    {
        headImageView.image = newHeadImage;
    }
    else
    {
        [headImageView setImageURL:[NSURL URLWithString:profileInfo.userInfo.avatar]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self clearState];
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        //头像
        [[LogicManager sharedInstance] getImage:self block:^(int event, id object)
        {
            if(object != nil)
            {
                [self setAvatar:object];
            }
        }];
    }
    else if (indexPath.section == 0 && indexPath.row == 6)
    {
        TextViewViewController* view = [[TextViewViewController alloc]initWithNibName:@"TextViewViewController" bundle:nil];
        view.value = profileInfo.userInfo.descriptions;
        [view setEventCallBack:^(int event, id object)
        {
            profileInfo.userInfo.descriptions = (NSString*)object;
            [tableView reloadData];
        }];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        datePiker.baseYear = [NSDate date].year-100;
        datePiker.dateComponent = YearMonthDay;
        NSTimeInterval interval = profileInfo.userInfo.birthday;
        if(interval == 0)
        {
            interval = [[NSDate date] timeIntervalSince1970];
        }
        [datePiker showWithObject:[NSNumber numberWithDouble:interval*1000] block:^(int event, id object)
         {
             NSTimeInterval value = [(NSNumber*)object doubleValue];
             profileInfo.userInfo.birthday = value;
             [tableView reloadData];
         }];
    }
    else if(indexPath.section == 2 && indexPath.row == 4)
    {
        self.hidesBottomBarWhenPushed = YES;
        WorkListViewController* workList = [[WorkListViewController alloc]initWithNibName:@"WorkListViewController" bundle:nil];
        workList.profileInfo = profileInfo;
        [self.navigationController pushViewController:workList animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 5)
    {
        self.hidesBottomBarWhenPushed = YES;
        EducationListViewController* educationList = [[EducationListViewController alloc]initWithNibName:@"EducationListViewController" bundle:nil];
        educationList.profileInfo = profileInfo;
        [self.navigationController pushViewController:educationList animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        [self clearState];
        //行业选择
        pikerView.pickerType = Industry;
        [pikerView showWithObject:profileInfo.userInfo.industryId block:^(int event, id object)
         {
             if(event == 1)
             {
                 IndustryObject *industry = (IndustryObject *)object;
                 profileInfo.userInfo.industryId = industry.code;
                 [tableView reloadData];
             }
         }];
    }
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        //职业标签
        TagViewController *view = [[TagViewController alloc] initWithNibName:@"TagViewController" bundle:nil];
        self.hidesBottomBarWhenPushed = YES;
        view.tagType = 1;
        [self.navigationController pushViewController:view animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 3)
    {
        //技能标签
        TagViewController *view = [[TagViewController alloc] initWithNibName:@"TagViewController" bundle:nil];
        self.hidesBottomBarWhenPushed = YES;
        view.tagType = 2;
        [self.navigationController pushViewController:view animated:YES];
    }
}
-(void)clearState
{
    [self.view endEditing:YES];
    [pikerView hide];
    [datePiker hide];
}
-(UITextField*)customTextFiled:(UITableViewCell*)cell placeholder:(NSString*)placeholder
{
    if(cell == nil || cell.contentView == nil)
    {
        nil;
    }
    UITextField* textField = (UITextField*)[cell.contentView viewWithTag:200];
    if(textField == nil)
    {
        textField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, cell.frame.size.width-100, 40)];
        textField.delegate = self;
        textField.tag = 200;
        [cell.contentView addSubview:textField];
        textField.backgroundColor = [UIColor clearColor];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = getFontWith(NO, 13);
        textField.textColor = colorWithHex(0x3287E6);
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)])
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc]
                                               initWithString:placeholder
                                               attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        }
    }
    return textField;
}
#pragma mark -UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    profileInfo.userInfo.descriptions = textView.text;
}
#pragma mark -UITextFieldDelegate
-(void)textChange:(UITextField*)filed
{
    if(filed == nameFiled)
    {
        profileInfo.userInfo.name = nameFiled.text;
    }
    else if (filed == companyFiled)
    {
        profileInfo.userInfo.company = companyFiled.text;
    }
    else if (filed == addressFiled)
    {
        profileInfo.userInfo.city = addressFiled.text;
    }
    else if (filed == postFiled)
    {
        profileInfo.userInfo.jobCode = postFiled.text;
    }
    else if (filed == mailFiled)
    {
        profileInfo.userInfo.email = mailFiled.text;
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [datePiker hide];
    [pikerView hide];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clearState];
    return YES;
}
#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView animateWithDuration:duration.doubleValue animations:^{
    } completion:^(BOOL finished) {
         table.frame = CGRectMake(0, 0, table.frame.size.width, table.frame.size.height-kbSize.height);
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView animateWithDuration:duration.doubleValue animations:^{
    } completion:^(BOOL finished) {
        table.frame = CGRectMake(0, 0, table.frame.size.width, table.frame.size.height+kbSize.height);
    }];
}

#pragma --mark 选择头像
-(void)setAvatar:(UIImage*)image
{
    headImageView.image = image;
    newHeadImage = image;
    [self saveAvatar:newHeadImage];
}
@end
