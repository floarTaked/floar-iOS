//
//  InternalRecommendViewController.m
//  WeLinked3
//
//  Created by 牟 文斌 on 2/24/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "InternalRecommendViewController.h"
#import "CustomCellView.h"
#import "ProfileInfo.h"
#import "SelectFriendViewController.h"
#import "PublicObject.h"
#import "LogicManager.h"
#import "CustomPickerView.h"
#import "NetworkEngine.h"
#import "AutoScrollUITextField.h"
#import "UIPlaceHolderTextView.h"
@interface InternalRecommendViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    CGRect _keyboardRect;
    CGRect _currentCellRect;
    int _currentIndex;
    float _currentTableViewContentOffset;
    CustomPickerView *pickerView;
    UIPlaceHolderTextView* jobDescription;
    BOOL descEditing;
}
@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UITextField* companyField1;
@property(nonatomic,strong)UITextField* companyField2;
@property(nonatomic,strong)UITextField* companyField3;
@property(nonatomic,strong)UITextField* currentcompanyField;
@end
@implementation InternalRecommendViewController
@synthesize recommendInfo,recommendID;
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
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back:)];

    if(self.recommendInfo == nil)
    {
        if(recommendID == nil || [recommendID length]<=0)
        {
            //发布内推
            mask = NO;
            accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self.navigationItem setTitleViewWithText:@"求内推"];
            [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleConfirm title:@"发布" target:self selector:@selector(confirm)];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
            
            pickerView = [CustomPickerView sharedInstance];
            [self.navigationController.view addSubview:pickerView];
            
            recommendInfo = [[RecommendInfo alloc] init];
            self.recommendInfo.industryId = [UserInfo myselfInstance].industryId;
            self.recommendInfo.currentCompany = [UserInfo myselfInstance].company;
            self.recommendInfo.currentJob = [UserInfo myselfInstance].jobCode;
            self.recommendInfo.locationCode = [UserInfo myselfInstance].city;
            [self.tableView reloadData];
        }
        else
        {
            //查看内推
            [[NetworkEngine sharedInstance] getRecommendedInfo:self.recommendID block:^(int event, id object)
             {
                 if(event == 1)
                 {
                     self.recommendInfo = (RecommendInfo*)object;
                     [self.navigationItem setTitleViewWithText:self.recommendInfo.company1];
                     [self.tableView reloadData];
                 }
                 else
                 {
                     [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"网络错误" actionText:@"确定"];
                 }
             }];
        }
    }
    else
    {
        //查看内推
        mask = YES;
        accessoryType = UITableViewCellAccessoryNone;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.recommendInfo = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)back:(id)sender
{
    [pickerView hide];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm
{
    [self saveTempValue];
    if (!self.recommendInfo.company1 && !self.recommendInfo.company2 && !self.recommendInfo.company3) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:@"请输入一个公司" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.recommendInfo.industryId) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:@"请选择行业" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.recommendInfo.jobCode) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:@"请选择一个职位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.recommendInfo.locationCode) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:@"请选择工作地点" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.recommendInfo.currentCompany) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:@"请输入目前公司" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.recommendInfo.currentJob) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:@"请选择目前职位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.recommendInfo.currentLevel) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:@"请选择级别" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.recommendInfo.howLong) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:@"请选择工作年限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (!self.recommendInfo.education) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:@"请选择学历" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [self.navigationController.navigationBar showLoadingIndicator];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[NetworkEngine sharedInstance] requestInternalRecommend:self.recommendInfo Block:^(int event, id object)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.navigationController.navigationBar hideLoadingIndicator];
        if (1 == event && object != nil)
        {
            [MobClick event:SOCIAL4];
            SelectFriendViewController *selectFriend = [[SelectFriendViewController alloc] init];
            selectFriend.type = SelectFriendViewTypeInternalRecommend;
            selectFriend.recommendInfo = (RecommendInfo*)object;
            [self.navigationController pushViewController:selectFriend animated:YES];
        }
        else
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"网络错误" actionText:@"确定"];
        }
    }];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ( 0 == section) {
        return 4;
    }else if (1== section)
    {
        return 4;
    }else if (2 == section){
        return 6;
    }else if (3 == section)
    {
        return 2;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3) && indexPath.row == 0)
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
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        if(indexPath.section == 0)
        {
            if(mask)
            {
                cell.textLabel.text = @"意向公司";
            }
            else
            {
                NSString* str = @"意向公司(可以选择3个)";
                NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:str];
                [string addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:10]
                               range:NSMakeRange(4,[str length] - 4)];
                [cell.textLabel setAttributedText:string];
            }
        }
        else if(indexPath.section == 1)
        {
            cell.textLabel.text = @"意向职位";
        }
        else if(indexPath.section == 2)
        {
            cell.textLabel.text = @"我的职位情况";
        }
        else if (3 == indexPath.section)
        {
            if(mask)
            {
                cell.textLabel.text = @"详细情况描述";
            }
            else
            {
                countLabel = cell.textLabel;
                
                NSString* str = [NSString stringWithFormat:@"详细情况描述(选填%d/500)",[self.recommendInfo.descriptions length]];
                NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:str];
                [string addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:10]
                               range:NSMakeRange(6,[str length] - 6)];
                [countLabel setAttributedText:string];
            }
        }
        
        return cell;
    }
    else if (indexPath.section == 0)
    {
        static NSString* Identifier = @"CompanyCell";
        CustomMarginCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
            cell.accessoryType = accessoryType;
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
        if(indexPath.row == 1)
        {
            cell.textLabel.text = @"公司1";
            cell.imageView.image = nil;
            self.companyField1 = [self customTextFiled:cell];
            [self.companyField1 setText:self.recommendInfo.company1];
            [self customLine:cell];
            self.companyField1.enabled = !mask;
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = @"公司2";
            cell.imageView.image = nil;
            self.companyField2 = [self customTextFiled:cell];
            [self.companyField2 setText:self.recommendInfo.company2];
            [self customLine:cell];
            self.companyField2.enabled = !mask;
        }
        else if(indexPath.row == 3)
        {
            cell.textLabel.text = @"公司3";
            cell.imageView.image = nil;
            self.companyField3 = [self customTextFiled:cell];
            [self.companyField3 setText:self.recommendInfo.company3];
            [self customLine:cell];
            self.companyField3.enabled = !mask;
        }
        cell.accessoryType = accessoryType;
        return cell;
    }
    else if(indexPath.section < 3)
    {
        if (indexPath.section == 2 && indexPath.row == 1)
        {
            
            static NSString* Identifier = @"currentCompanyCell";
            CustomMarginCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
                cell.accessoryType = accessoryType;
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
            cell.textLabel.text = @"目前公司";
            cell.imageView.image = nil;
            self.currentcompanyField = [self customTextFiled:cell];
            [self.currentcompanyField setText:self.recommendInfo.currentCompany];
            [self customLine:cell];
            self.currentcompanyField.enabled = !mask;
            cell.accessoryType = accessoryType;
            return cell;
        }
        else
        {
            static NSString* Identifier = @"CustomCell";
            CustomMarginCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
                
                
                UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
                cellBackgroundView.backgroundColor = [UIColor whiteColor];
                cell.backgroundView = cellBackgroundView;
                
                
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.font = getFontWith(YES, 13);
                cell.textLabel.textColor = [UIColor blackColor];
                cell.detailTextLabel.font = getFontWith(NO, 12);
                cell.detailTextLabel.textColor = colorWithHex(0x3287E6);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"";
            cell.imageView.image = nil;
            cell.detailTextLabel.text = @"";
            if (indexPath.section == 1)
            {
                if (indexPath.row == 1)
                {
                    cell.textLabel.text = @"行业";
                    IndustryObject *industry = [[LogicManager sharedInstance] getPublicObject:self.recommendInfo.industryId type:Industry];
                    if (industry)
                    {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",industry.parentName,industry.name];
                    }
                    else
                    {
                        cell.detailTextLabel.text = @"必选";
                    }
                    
                    [self customLine:cell];
                }
                else if (indexPath.row == 2)
                {
                    cell.textLabel.text = @"职位";
                    JobObject *job = [[LogicManager sharedInstance] getPublicObject:self.recommendInfo.jobCode type:Job];
                    if (job)
                    {
                        cell.detailTextLabel.text = job.name;
                    }
                    else
                    {
                        cell.detailTextLabel.text = @"必选";
                    }
                    
                    [self customLine:cell];
                }
                else if (indexPath.row == 3)
                {
                    cell.textLabel.text = @"地点";
                    CityObject *city = [[LogicManager sharedInstance] getPublicObject:self.recommendInfo.locationCode type:City];
                    if (city)
                    {
                        cell.detailTextLabel.text = city.fullName;
                    }
                    else
                    {
                        if ([UserInfo myselfInstance].city.length)
                        {
                            cell.detailTextLabel.text = [UserInfo myselfInstance].city;
                        }
                        else
                        {
                            cell.detailTextLabel.text = @"必选";
                        }
                        
                    }
                    
                    [self customLine:cell];
                }
            }
            else
            {
                if (indexPath.row == 2)
                {
                    cell.textLabel.text = @"目前职位";
                    [self customLine:cell];
                    JobObject* job = [[LogicManager sharedInstance] getPublicObject:self.recommendInfo.currentJob type:Job];
                    if (job)
                    {
                        cell.detailTextLabel.text = job.name;
                    }
                    else
                    {
                        cell.detailTextLabel.text = @"必选";
                    }
                    
                }
                else if (indexPath.row == 3)
                {
                    cell.textLabel.text = @"级别";
                    if ([[LogicManager sharedInstance] getJobLevel:self.recommendInfo.currentLevel].length)
                    {
                        cell.detailTextLabel.text = [[LogicManager sharedInstance] getJobLevel:self.recommendInfo.currentLevel];
                    }
                    else
                    {
                        cell.detailTextLabel.text = @"必选";
                    }
                    [self customLine:cell];
                }
                else if (indexPath.row == 4)
                {
                    cell.textLabel.text = @"工作年限";
                    if ([[LogicManager sharedInstance] getJobYear:self.recommendInfo.howLong].length)
                    {
                        cell.detailTextLabel.text = [[LogicManager sharedInstance] getJobYear:self.recommendInfo.howLong];
                    }
                    else
                    {
                        cell.detailTextLabel.text = @"必选";
                    }
                    [self customLine:cell];
                }
                else if (indexPath.row == 5)
                {
                    cell.textLabel.text = @"学历";
                    if ([[LogicManager sharedInstance] getEducation:self.recommendInfo.education].length)
                    {
                        cell.detailTextLabel.text = [[LogicManager sharedInstance] getEducation:self.recommendInfo.education];
                    }
                    else
                    {
                        cell.detailTextLabel.text = @"必选";
                    }
                }
            }
            cell.accessoryType = accessoryType;
            return cell;
        }
        
    }
    else if (indexPath.section == 3)
    {
        static NSString* Identifier = @"SectionInput";
        CustomMarginCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        jobDescription = (UIPlaceHolderTextView*)[cell.contentView viewWithTag:100];
        if(jobDescription == nil)
        {
            jobDescription = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, 100)];
            jobDescription.placeholder = @"填写你的详细情况,或对内推职位的要求...";
            [cell.contentView addSubview:jobDescription];
            jobDescription.font = getFontWith(NO, 13);
            jobDescription.delegate = self;
            jobDescription.tag = 100;
        }
        [jobDescription setText:self.recommendInfo.descriptions];
        if(mask)
        {
            jobDescription.editable = NO;
        }
        return cell;
    }
    return nil;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3) && indexPath.row == 0) {
        return 30;
    }
    else if (indexPath.section == 3 && indexPath.row == 1)
    {
        return 100;
    }
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(mask)
    {
        return;
    }
//    第一个section只能输入
    if (indexPath.section == 0)
    {
        return;
    }
//    点击到sectionHeader
    if ((indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3) && indexPath.row == 0)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView setContentOffset:offsetPoint animated:YES];
        }];
        [self clearState];
        return;
    }
    
    offsetPoint = tableView.contentOffset;
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [tableView convertRect:rectInTableView toView:self.view];
    //    需要移动的位置
    float targetY = self.view.height - pickerView.height - rect.size.height;
    float offSet = rect.origin.y - targetY;
    float currentContentOffset = tableView.contentOffset.y;
    
    if (currentContentOffset + offSet > 0)
    {
        [tableView setContentOffset:CGPointMake(0, currentContentOffset + offSet) animated:YES];
    }
    
    if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 1:
            {
                [self saveTempValue];
                pickerView.pickerType = Industry;
                [pickerView showWithObject:nil block:^(int event, id object)
                 {
                     if(event == 1)
                     {
                         IndustryObject *industry = (IndustryObject *)object;
                         self.recommendInfo.industryId = industry.code;
                         self.recommendInfo.subIndustryId = industry.parentCode;
                         //                         [self clearState];
                         [tableView reloadData];
                     }
                     [tableView setContentOffset:offsetPoint animated:YES];
                 }];
            }
                break;
            case 2:
            {
                [self saveTempValue];
                pickerView.pickerType = Job;
                [pickerView showWithObject:nil block:^(int event, id object)
                 {
                     if(event == 1)
                     {
                         JobObject* job = (JobObject*)object;
                         self.recommendInfo.jobCode = job.code;
                         //                         [self clearState];
                         [tableView reloadData];
                     }
                     [tableView setContentOffset:offsetPoint animated:YES];
                 }];
            }
                break;
            case 3:
            {
                [self saveTempValue];
                pickerView.pickerType = City;
                [pickerView showWithObject:nil block:^(int event, id object)
                 {
                     if(event == 1)
                     {
                         CityObject* city = (CityObject*)object;
                         self.recommendInfo.locationCode = city.code;
                         //                         [self clearState];
                         [tableView reloadData];
                     }
                     [tableView setContentOffset:offsetPoint animated:YES];
                 }];
            }
                break;
            default:
                break;
        }
    }
    else if (2 == indexPath.section)
    {
        switch (indexPath.row)
        {
            case 2:
            {
                [self saveTempValue];
                pickerView.pickerType = Job;
                [pickerView showWithObject:nil block:^(int event, id object)
                 {
                     if(event == 1)
                     {
                         JobObject* job = (JobObject*)object;
                         self.recommendInfo.currentJob = job.code;
                         //                         [self clearState];
                         [tableView reloadData];
                     }
                     [tableView setContentOffset:offsetPoint animated:YES];
                 }];
            }
                break;
            case 3:
            {
                [self saveTempValue];
                pickerView.pickerType = JobLevel;
                [pickerView showWithObject:nil block:^(int event, id object)
                 {
                     if(event == 1)
                     {
                         self.recommendInfo.currentLevel = [object intValue] + 1;
                         //                         [self clearState];
                         [tableView reloadData];
                     }
                     [tableView setContentOffset:offsetPoint animated:YES];
                 }];
            }
                break;
            case 4:
            {
                [self saveTempValue];
                pickerView.pickerType = JobYear;
                [pickerView showWithObject:nil block:^(int event, id object)
                 {
                     if(event == 1)
                     {
                         self.recommendInfo.howLong = [object intValue] + 1;
                         //                         [self clearState];
                         [tableView reloadData];
                     }
                     [tableView setContentOffset:offsetPoint animated:YES];
                 }];
            }
                break;
            case 5:
            {
                [self saveTempValue];
                pickerView.pickerType = Education;
                [pickerView showWithObject:nil block:^(int event, id object)
                 {
                     if(event == 1)
                     {
                         self.recommendInfo.education = [object intValue] + 1;
                         //                         [self clearState];
                         [tableView reloadData];
                     }
                     [tableView setContentOffset:offsetPoint animated:YES];
                 }];
            }
                break;
            default:
                break;
        }
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
    
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void)clearState
{
    [self.view endEditing:YES];
    [pickerView hide];
}
-(void)saveTempValue
{
    [self.view endEditing:YES];
    self.recommendInfo.company1 = self.companyField1.text;
    self.recommendInfo.company2 = self.companyField2.text;
    self.recommendInfo.company3 = self.companyField3.text;
    self.recommendInfo.currentCompany = self.currentcompanyField.text;
    self.recommendInfo.descriptions = jobDescription.text;
}
#pragma --mark UITextFiledDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [pickerView hide];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.recommendInfo.company1 = self.companyField1.text;
    self.recommendInfo.company2 = self.companyField2.text;
    self.recommendInfo.company3 = self.companyField3.text;
    self.recommendInfo.currentCompany = self.currentcompanyField.text;
    self.recommendInfo.descriptions = jobDescription.text;
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.companyField1)
    {
        self.recommendInfo.company1 = textField.text;
    }
    else if (textField == self.companyField2)
    {
        self.recommendInfo.company2 = textField.text;
    }
    else if (textField == self.companyField3)
    {
        self.recommendInfo.company3 = textField.text;
    }
    else if (textField == self.currentcompanyField)
    {
        self.recommendInfo.currentCompany = textField.text;
    }
    return YES;
}
#pragma --mark UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    descEditing = YES;
    offsetPoint = self.tableView.contentOffset;
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
    CGRect rect = [self.tableView convertRect:rectInTableView toView:self.view];
    _currentTableViewContentOffset = self.tableView.contentOffset.y;
    _currentCellRect = rect;
    [UIView animateWithDuration:0.3 animations:^{
        [pickerView hide];
    }];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length  + text.length> 500)
    {
        return NO;
    }
    else
    {
        NSString* str = [NSString stringWithFormat:@"详细情况描述(选填%d/500)",textView.text.length + text.length];
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:str];
        [string addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:10]
                       range:NSMakeRange(6,[str length] - 6)];
        [countLabel setAttributedText:string];
    }
    self.recommendInfo.descriptions = textView.text;
    return YES;
}
#pragma mark - Keyboard Notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    if(!descEditing)
    {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    _keyboardRect = keyboardRect;
    if (_keyboardRect.origin.y < self.view.height)
    {
        [self moveCommentInputeView:_keyboardRect];
    }
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    descEditing = NO;
}

- (void)moveCommentInputeView:(CGRect)keyboardRect
{
    //需要移动到的位置
    CGRect targetRect = CGRectMake(0, self.view.height - keyboardRect.size.height  - _currentCellRect.size.height, _currentCellRect.size.width, _currentCellRect.size.height);
    //tableview内容要滚到合适位置的偏移量
    float shouldMoveOffset = targetRect.origin.y - _currentCellRect.origin.y;
    float offset = _currentTableViewContentOffset - shouldMoveOffset;
    if (offset < 0 )
    {
        offset = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentOffset = CGPointMake(0, offset);
        
    }];
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
        textField = [[AutoScrollUITextField alloc]initWithFrame:CGRectMake(80, 5, cell.frame.size.width-115, 44)];
        textField.table = self.tableView;
        textField.delegate = self;
        textField.tag = 200;
        [cell.contentView addSubview:textField];
        textField.backgroundColor = [UIColor clearColor];
        textField.textAlignment = NSTextAlignmentRight;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = getFontWith(NO, 12);
        textField.textColor = colorWithHex(0x3287E6);
        if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)])
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"必填"
                                                                              attributes:@{NSForegroundColorAttributeName:colorWithHex(0x3287E6)}];
        }
    }
    return textField;
}
@end
