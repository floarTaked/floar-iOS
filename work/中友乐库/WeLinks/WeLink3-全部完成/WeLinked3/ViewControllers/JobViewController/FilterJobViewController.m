//
//  FilterJobViewController.m
//  WeLinked3
//
//  Created by 牟 文斌 on 3/6/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "FilterJobViewController.h"
#import "CustomPickerView.h"
#import "CustomCellView.h"
#import "JobInfo.h"
#import "LogicManager.h"
#import "PublicObject.h"
#import "FilterJobListViewController.h"

@interface FilterJobViewController ()
{
    CustomPickerView *pickerView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JobInfo *jobInfo;

@end

@implementation FilterJobViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    pickerView = [CustomPickerView sharedInstance];
    [self.navigationController.view addSubview:pickerView];
    self.jobInfo = [[JobInfo alloc] init];
    self.jobInfo.jobCode = @"0151";
    self.jobInfo.locationCode = @"01201";
    
    self.jobInfo.industryId = @"5366";
    self.jobInfo.subIndustryId = @"66";
    self.jobInfo.salaryLevel = 1;
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(backAction)];
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleConfirm title:@"筛选" target:self selector:@selector(confirm)];
    
    [self.navigationItem setTitleViewWithText:@"筛选职位"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        cell.textLabel.text = @"筛选条件";
        cell.textLabel.textColor = colorWithHex(0x666666);
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        return cell;
    }
    else
    {
        static NSString* Identifier = @"Cell";
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
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"";
        cell.imageView.image = nil;
        cell.detailTextLabel.text = @"";
        
        if(indexPath.row == 1)
        {
            cell.textLabel.text = @"职位";
            JobObject *job = [[LogicManager sharedInstance] getPublicObject:self.jobInfo.jobCode type:Job];
            cell.detailTextLabel.text = job.name;
            [self customLine:cell];
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = @"行业";
            IndustryObject *industry = [[LogicManager sharedInstance] getPublicObject:self.jobInfo.industryId type:Industry];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",industry.parentName,industry.name];
            [self customLine:cell];
        }
        else if(indexPath.row == 3)
        {
            cell.textLabel.text = @"工作地点";
            CityObject *city = [[LogicManager sharedInstance] getPublicObject:self.jobInfo.locationCode type:City];
            cell.detailTextLabel.text = city.fullName;
            [self customLine:cell];
        }
        else if(indexPath.row == 4)
        {
            cell.textLabel.text = @"薪酬范围";
            cell.detailTextLabel.text =  [[LogicManager sharedInstance] getSalary:self.jobInfo.salaryLevel];
        }
        return cell;
    }
        
    return nil;
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 30;
    }
    return 55;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return;
    }
    switch (indexPath.row) {
        case 1:
        {
            pickerView.pickerType = Job;
            [pickerView showWithObject:nil block:^(int event, id object)
             {
                 if(event == 1)
                 {
                     JobObject* job = (JobObject*)object;
                     self.jobInfo.jobCode = job.code;
                     //                         [self clearState];
                     [tableView reloadData];
                 }
             }];
        }
            break;
        case 2:
        {
            pickerView.pickerType = Industry;
            [pickerView showWithObject:nil block:^(int event, id object)
             {
                 if(event == 1)
                 {
                     IndustryObject *industry = (IndustryObject *)object;
                     self.jobInfo.industryId = industry.code;
                     self.jobInfo.subIndustryId = industry.parentCode;
                     //                         [self clearState];
                     [tableView reloadData];
                 }
             }];
        }
            break;
        case 3:
        {
            pickerView.pickerType = City;
            [pickerView showWithObject:nil block:^(int event, id object)
             {
                 if(event == 1)
                 {
                     CityObject* city = (CityObject*)object;
                     self.jobInfo.locationCode = city.code;
                     //                         [self clearState];
                     [tableView reloadData];
                 }
             }];
        }
            break;
        case 4:
        {
            pickerView.pickerType = Salary;
            [pickerView showWithObject:nil block:^(int event, id object)
             {
                 if(event == 1)
                 {
                     self.jobInfo.salaryLevel = [object intValue] + 1;
                     //                         [self clearState];
                     [tableView reloadData];
                 }
             }];
        }
            break;
        default:
            break;
    }
}

- (void)backAction
{
    [pickerView hide];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm
{
    [self.navigationController.navigationBar showLoadingIndicator];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[NetworkEngine sharedInstance] selectJobWithJobInfo:_jobInfo Block:^(int event, id object) {
        DLog(@"筛选职位 %@",object);
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.navigationController.navigationBar hideLoadingIndicator];
        if (1 == event) {
            NSMutableArray *jobList = [NSMutableArray array];
            for (NSDictionary *dic in object) {
                JobInfo *jobInfo = [[JobInfo alloc] init];
                [jobInfo setValuesForKeysWithDictionary:dic];
                [jobList addObject:jobInfo];
            }
            FilterJobListViewController *jobListView = [[FilterJobListViewController alloc] init];
            jobListView.jobList = jobList;
            [self.navigationController pushViewController:jobListView animated:YES];
        }
    }];
}

@end
