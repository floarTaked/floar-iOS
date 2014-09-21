//
//  EducationViewController.m
//  WeLinked3
//
//  Created by jonas on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "EducationViewController.h"
#import "CustomCellView.h"
#import "AutoScrollUITextField.h"
#import "UIPlaceHolderTextView.h"
#import "LogicManager.h"
#define  WordCount 500
@interface EducationViewController ()

@end

@implementation EducationViewController
@synthesize educationInfo,editEnable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.editEnable = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitleViewWithText:@"教育经历"];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack
                                                                 title:nil
                                                                target:self
                                                              selector:@selector(back:)];
    if(self.editEnable)
    {
        [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleSave
                                                                      title:@"保存"
                                                                     target:self
                                                                   selector:@selector(save:)];
    }
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [table addGestureRecognizer:tap];
    
    datePiker = [DatePikerView sharedInstance];
    [self.view addSubview:datePiker];
    pikerView = [CustomPickerView sharedInstance];
    [self.navigationController.view addSubview:pikerView];
    
    if(educationInfo==nil)
    {
        newEducation = YES;
        educationInfo = [[EducationInfo alloc]init];
    }
    else
    {
        newEducation = NO;
    }
    
    if(!self.editEnable)
    {
        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        v.backgroundColor = [UIColor clearColor];
        [self.view addSubview:v];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self clearState];
}
-(void)setCallback:(EventCallBack)call
{
    callBack = call;
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            [[NetworkEngine sharedInstance] deleteEducationInfo:educationInfo.identity block:^(int event, id object)
             {
                 if(event == 0)
                 {
                     [[LogicManager sharedInstance] showAlertWithTitle:@"" message:@"删除失败" actionText:@"确定"];
                 }
                 else if (event == 1)
                 {
                     if(callBack)
                     {
                         callBack(0,educationInfo);
                     }
                     [self back:nil];
                 }
             }];
        }
    }
    else if(alertView.tag == 2)
    {
        [self back:nil];
    }
}
-(void)deleteWork:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"确定要删除吗?"
                                                  delegate:self
                                         cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    [alert show];
}
-(void)save:(id)sender
{
    if([schoolTextFiled.text length]<=0 )
    {
        [[LogicManager sharedInstance] showAlertWithTitle:@"提示" message:@"请填写学校信息" actionText:@"确定"];
        return;
    }
    else
    {
        educationInfo.school = schoolTextFiled.text;
    }
    
    
    if([specialTextFiled.text length]<=0 )
    {
        [[LogicManager sharedInstance] showAlertWithTitle:@"提示" message:@"请填写专业信息" actionText:@"确定"];
        return;
    }
    else
    {
        educationInfo.specialty = specialTextFiled.text;
    }
    
    
    if([educationTextFiled.text length]<=0 )
    {
        [[LogicManager sharedInstance] showAlertWithTitle:@"提示" message:@"请填写学历信息" actionText:@"确定"];
        return;
    }
    
    
    if([timeTextFiled.text length]<=0 )
    {
        [[LogicManager sharedInstance] showAlertWithTitle:@"提示" message:@"请选择时间信息" actionText:@"确定"];
        return;
    }
    educationInfo.educationDesc = descTextView.text;
    NSString *json = [[LogicManager sharedInstance] objectToJsonString:educationInfo];
    if(json != nil)
    {
        [[NetworkEngine sharedInstance] saveEducationInfo:json block:^(int event, id object)
         {
             if(event == 0)
             {
                 
             }
             else if (event == 1)
             {
                 educationInfo = [[EducationInfo alloc]init];
                 [educationInfo setValuesForKeysWithDictionary:object];
                 [table reloadData];
                 if(callBack)
                 {
                     callBack(1,educationInfo);
                 }
                 UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@""
                                                                message:@"保存成功"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 alert.tag = 2;
                 [alert show];
             }
         }];
    }
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
-(void)clearState
{
    [self.view endEditing:YES];
    [pikerView hide];
    [datePiker hide];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [pikerView hide];
    [datePiker hide];
    if(educationInfo == nil)
    {
        textField.text = @"";
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text length]<=0)
    {
        textField.text = @"待补充";
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length  + text.length> WordCount)
    {
        return NO;
    }
    else
    {
        [wordCountLabel setText:[NSString stringWithFormat:@"职位描述(%d/%d)",textView.text.length + text.length,WordCount]];
    }
    return YES;
}
#pragma --mark TableviewDatasource
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 20;
    }
    else if(section==2)
    {
        return 40;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 4;
    }
    else if (section == 1)
    {
        return 2;
    }
    else if (section == 2)
    {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            return 30;
        }
        else if (indexPath.row == 1)
        {
            return 100;
        }
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(newEducation)
    {
        return 2;
    }
    else
    {
        if(self.editEnable)
        {
            return 3;
        }
        else
        {
            return 2;
        }
    }
}
- (CustomCellView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
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
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"学校";
            [self customLine:cell height:44];
            schoolTextFiled = [self customTextFiled:cell];
            schoolTextFiled.delegate = self;
            schoolTextFiled.placeholder = @"待补充";
            if(educationInfo.school != nil && [educationInfo.school length]>0)
            {
                [schoolTextFiled setText:educationInfo.school];
            }
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"专业";
            [self customLine:cell height:44];
            specialTextFiled = [self customTextFiled:cell];
            specialTextFiled.delegate = self;
            specialTextFiled.placeholder = @"待补充";
            if(educationInfo.specialty != nil && [educationInfo.specialty length]>0)
            {
                [specialTextFiled setText:educationInfo.specialty];
            }
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = @"学历";
            [self customLine:cell height:44];
            educationTextFiled = [self customTextFiled:cell];
            educationTextFiled.delegate = self;
            educationTextFiled.enabled = NO;
            educationTextFiled.placeholder = @"待补充";
            if(educationInfo.education>0)
            {
                educationTextFiled.text = [NSString stringWithFormat:@"%@",[[LogicManager sharedInstance] getEducation:educationInfo.education]];
            }
        }
        else if(indexPath.row == 3)
        {
            cell.textLabel.text = @"在校时间";
            [self customLine:cell height:44];
            timeTextFiled = [self customTextFiled:cell];
            timeTextFiled.delegate = self;
            timeTextFiled.enabled = NO;
            [timeTextFiled setPlaceholder:@"待补充"];
            int timeBegin = -1;
            int timeEnd = -1;
            if(educationInfo.year != nil && [educationInfo.year length]>0)
            {
                NSArray* arr = [educationInfo.year componentsSeparatedByString:@"-"];
                timeBegin = [[arr objectAtIndex:0] intValue];
                timeEnd = [[arr objectAtIndex:1] intValue];
            }
            
            if(timeBegin != -1 || timeEnd != -1)
            {
                [timeTextFiled setText:[NSString stringWithFormat:@"%d-%d",timeBegin,timeEnd]];
            }
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
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
            cell.textLabel.text = [NSString stringWithFormat:@"职位描述(0/%d)",WordCount];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            wordCountLabel = cell.textLabel;
            return cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString* Identifier = @"SectionInput";
            CustomCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
            }
            
            descTextView = (UIPlaceHolderTextView*)[cell.contentView viewWithTag:100];
            if(descTextView == nil)
            {
                descTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
                descTextView.placeholder = @"谈谈你的校园生活...";
                [cell.contentView addSubview:descTextView];
                descTextView.font = getFontWith(NO, 13);
                descTextView.delegate = self;
                descTextView.tag = 100;
            }
            if(educationInfo.educationDesc != nil && [educationInfo.educationDesc length]>0)
            {
                descTextView.text = educationInfo.educationDesc;
            }
            return cell;
        }
    }
    else
    {
        CustomCellView* cell = [[CustomCellView alloc]init];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *tempView = [[UIView alloc] init];
        cell.backgroundView = tempView;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        
        UIButton* deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 0,290,44)];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"profileDelete"] forState:UIControlStateNormal];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"profileDeleteSelected"] forState:UIControlStateHighlighted];
        [deleteButton.titleLabel setFont:getFontWith(YES, 20)];
        [deleteButton addTarget:self action:@selector(deleteWork:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteButton];
        deleteButton.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if(indexPath.row == 3)
        {
            [self clearState];
            datePiker.baseYear = 2000;
            datePiker.dateComponent = YearYear;
            int timeEnd = [NSDate date].year;
            int timeBegin = timeEnd -1;
            if(educationInfo.year != nil && [educationInfo.year length]>0)
            {
                NSArray* arr = [educationInfo.year componentsSeparatedByString:@"-"];
                timeBegin = [[arr objectAtIndex:0] intValue];
                timeEnd = [[arr objectAtIndex:1] intValue];
            }
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:timeBegin],@"begin",
                                 [NSNumber numberWithInt:timeEnd],@"end",nil];
            [datePiker showWithObject:dic block:^(int event, id object)
             {
                 int beginYear = [[(NSDictionary*)object objectForKey:@"begin"] intValue];
                 int endYear = [[(NSDictionary*)object objectForKey:@"end"] intValue];
                 NSDate* b = [NSDate dateWithYear:beginYear month:1 day:1];
                 NSDate* e = [NSDate dateWithYear:endYear month:1 day:1];
                 educationInfo.year = [NSString stringWithFormat:@"%d-%d",b.year,e.year];
                 [table reloadData];
             }];
        }
        else if (indexPath.row == 2)
        {
            [self clearState];
            pikerView.pickerType = Education;
            [pikerView showWithObject:[NSNumber numberWithInt:educationInfo.education-1] block:^(int event, id object)
             {
                 if(event == 1)
                 {
                     educationInfo.education = [(NSNumber*)object intValue]+1;
                     [tableView reloadData];
                 }
             }];
        }
    }
}
-(void)customLine:(UITableViewCell*)cell height:(float)height
{
    if(cell == nil || cell.contentView == nil)
    {
        return;
    }
    UIView* line = [cell.contentView viewWithTag:2];
    if(line == nil)
    {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, height-0.5, cell.frame.size.width, 0.5)];
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
        textField = [[AutoScrollUITextField alloc]initWithFrame:CGRectMake(80, 0, cell.frame.size.width-130, 44)];
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
