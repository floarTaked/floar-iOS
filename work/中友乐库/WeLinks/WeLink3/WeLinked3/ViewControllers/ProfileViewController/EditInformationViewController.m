//
//  EditInformationViewController.m
//  WeLinked3
//
//  Created by jonas on 2/25/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "EditInformationViewController.h"
#import "CustomCellView.h"
#import "AutoScrollUITextField.h"
#import "UserInfo.h"
#import "LogicManager.h"
#import "NetworkEngine.h"
@interface EditInformationViewController ()

@end

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitleViewWithText:@"基本信息"];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack
                                                                 title:nil
                                                                target:self
                                                              selector:@selector(back:)];
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleSave
                                                                  title:@"保存"
                                                                 target:self
                                                               selector:@selector(save:)];
    
    UIView* head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, 30)];
    head.backgroundColor = [UIColor clearColor];
    table.tableHeaderView = head;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [table addGestureRecognizer:tap];
    pikerView = [CustomPickerView sharedInstance];
    [self.navigationController.view addSubview:pikerView];
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
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clearState
{
    [self.view endEditing:YES];
    profileInfo.userInfo.name = nameTextFiled.text;
    profileInfo.userInfo.company = companyTextFiled.text;
    
    profileInfo.userInfo.phone = phoneTextFiled.text;
    profileInfo.userInfo.email = emailTextFiled.text;
    [pikerView hide];
}
-(void)save:(id)sender
{
    [self clearState];
    
    if([[LogicManager sharedInstance] isMobileNumber:phoneTextFiled.text])
    {
        profileInfo.userInfo.phone = phoneTextFiled.text;
    }
    else
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"手机号码格式不正确，请重新输入" actionText:@"确定"];
        return;
    }
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:profileInfo.userInfo.name==nil?@"":profileInfo.userInfo.name forKey:@"name"];
    [dic setObject:profileInfo.userInfo.company==nil?@"":profileInfo.userInfo.company forKey:@"company"];
    [dic setObject:profileInfo.userInfo.jobCode==nil?@"":profileInfo.userInfo.jobCode forKey:@"jobCode"];
    [dic setObject:profileInfo.userInfo.city==nil?@"":profileInfo.userInfo.city forKey:@"city"];
    [dic setObject:profileInfo.userInfo.phone==nil?@"":profileInfo.userInfo.phone forKey:@"phone"];
    [dic setObject:profileInfo.userInfo.email==nil?@"":profileInfo.userInfo.email forKey:@"email"];
    NSString* json = [[LogicManager sharedInstance] objectToJsonString:dic];
    [[NetworkEngine sharedInstance] saveProfileInfo:json block:^(int event, id object)
    {
        if(event == 0)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:@"" message:@"保存失败" actionText:@"确定"];
        }
        else if (event == 1)
        {
            if(object != nil)
            {
                [profileInfo.userInfo setValuesForKeysWithDictionary:object];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                               message:@"保存成功"
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
            }
        }
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        [self back:nil];
    }
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
    switch (section)
    {
        case 0:
            return 4;
            break;
        case 1:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        return 30;
    }
    return 55;
}
- (CustomCellView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.section == 1 || indexPath.section == 2) && indexPath.row == 0)
    {
        static NSString* Identifier = @"SectionHeader";
        CustomCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        if(indexPath.section == 1)
        {
            cell.textLabel.text = @"联系方式";
        }
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        return cell;
    }
    else
    {
        static NSString* Identifier = @"Cell";
        CustomCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
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
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                cell.textLabel.text = @"真实姓名";
                [self customLine:cell];
                nameTextFiled = [self customTextFiled:cell];
                [nameTextFiled setPlaceholder:@"待补充"];
                [nameTextFiled setText:profileInfo.userInfo.name];
            }
            else if(indexPath.row == 1)
            {
                cell.textLabel.text = @"公司";
                [self customLine:cell];
                companyTextFiled = [self customTextFiled:cell];
                [companyTextFiled setPlaceholder:@"待补充"];
                [companyTextFiled setText:profileInfo.userInfo.company];
            }
            else if(indexPath.row == 2)
            {
                cell.textLabel.text = @"职位";
                [self customLine:cell];
//                cell.detailTextLabel.text = profileInfo.post;
                UITextField* textFiled = [self customTextFiled:cell];
                [textFiled setPlaceholder:@"待补充"];
                textFiled.enabled = NO;
                [textFiled setText:profileInfo.userInfo.job];
            }
            else if(indexPath.row == 3)
            {
                cell.textLabel.text = @"所在地";
                CityObject* city = [[LogicManager sharedInstance] getPublicObject:profileInfo.userInfo.city type:City];
                cell.detailTextLabel.text = city.name;
            }
        }
        else if (indexPath.section == 1)
        {
            if(indexPath.row == 1)
            {
                cell.textLabel.text = @"手机";
                [self customLine:cell];
//                cell.detailTextLabel.text = profileInfo.phone;
                phoneTextFiled = [self customTextFiled:cell];
                [phoneTextFiled setText:profileInfo.userInfo.phone];
            }
            else if(indexPath.row == 2)
            {
                cell.textLabel.text = @"邮箱";
                [self customLine:cell];
//                cell.detailTextLabel.text = profileInfo.email;
                emailTextFiled = [self customTextFiled:cell];
                [emailTextFiled setText:profileInfo.userInfo.email];
            }
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && indexPath.row == 2)
    {
        //行业选择
        pikerView.pickerType = Job;
        [pikerView showWithObject:profileInfo.userInfo.jobCode block:^(int event, id object)
         {
             if(event == 1)
             {
                 JobObject* job = (JobObject*)object;
                 profileInfo.userInfo.jobCode = job.code;
                 [self clearState];
                 [tableView reloadData];
             }
         }];
    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        //城市选择
        pikerView.pickerType = City;
        [pikerView showWithObject:profileInfo.userInfo.city block:^(int event, id object)
         {
             if(event == 1)
             {
                 CityObject* ct = (CityObject*)object;
                 profileInfo.userInfo.city = ct.code;
                 [self clearState];
                 [tableView reloadData];
             }
         }];
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
-(UITextField*)customTextFiled:(UITableViewCell*)cell
{
    if(cell == nil || cell.contentView == nil)
    {
        nil;
    }
    AutoScrollUITextField* textField = (AutoScrollUITextField*)[cell.contentView viewWithTag:200];
    if(textField == nil)
    {
        textField = [[AutoScrollUITextField alloc]initWithFrame:CGRectMake(100, 5, cell.frame.size.width-150, 50)];
        textField.table = table;
        textField.tag = 200;
        [cell.contentView addSubview:textField];
        textField.backgroundColor = [UIColor clearColor];
        textField.textAlignment = NSTextAlignmentRight;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = getFontWith(NO, 12);
        textField.textColor = colorWithHex(0x3287E6);
        if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)])
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"待补充"
                                                                              attributes:@{NSForegroundColorAttributeName:colorWithHex(0x3287E6)}];
        }
    }
    return textField;
}
@end
