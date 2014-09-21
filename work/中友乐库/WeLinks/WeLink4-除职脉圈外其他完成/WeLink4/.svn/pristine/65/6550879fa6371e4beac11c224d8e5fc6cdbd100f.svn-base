//
//  JobOrEduListViewController.m
//  WeLinked4
//
//  Created by floar on 14-5-23.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "JobOrEduListViewController.h"
#import "DetailInfoViewController.h"
#import "ProfileInfo.h"
#import "EducationInfo.h"
#import "WorkInfo.h"

@interface JobOrEduListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isEdit;
}


@property (weak, nonatomic) IBOutlet UITableView *infoListTableView;

@end

@implementation JobOrEduListViewController

@synthesize isJob,infoListTableView,profileInfo;

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
    
    if (isJob)
    {
        [self.navigationItem setTitleString:@"工作经历"];
    }
    else
    {
        [self.navigationItem setTitleString:@"教育经历"];
    }
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"] imageSelected:[UIImage imageNamed:@"backSelected"] title:nil inset:UIEdgeInsetsMake(0, -20, 0, 0) target:self selector:@selector(gotoBack)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isEdit == YES)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (isJob == YES)
        {
            return profileInfo.workArray.count;
        }
        else
        {
            return profileInfo.educationArray.count;
        }
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [profileInfo.workArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailInfoViewController *detail = [[DetailInfoViewController alloc] initWithNibName:NSStringFromClass([DetailInfoViewController class]) bundle:nil];
    
    if (indexPath.section == 0)
    {
        detail.isAdd = NO;
    }
    else
    {
        detail.isAdd = YES;
    }
    
    [self.navigationController pushViewController:detail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)customNormalCell:(UITableViewCell *)cell
        WithProfileInfo:(id )jobOrEdu
{
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:10];
    if (nameLabel == nil)
    {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 25)];
        nameLabel.tag = 10;
        nameLabel.font = getFontWith(YES, 14);
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:nameLabel];
    }
    
    UILabel *positionLabel = (UILabel *)[cell.contentView viewWithTag:20];
    if (positionLabel == nil)
    {
        positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame), 100, 20)];
        positionLabel.tag = 20;
        positionLabel.font = getFontWith(NO, 12);
        positionLabel.textAlignment = NSTextAlignmentLeft;
        positionLabel.textColor = colorWithHex(0xAAAAAA);
        [cell.contentView addSubview:positionLabel];
    }
    
    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:30];
    if (dateLabel == nil)
    {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 20, 100, 20)];
        dateLabel.tag = 30;
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.textColor = [UIColor blueColor];
        [cell.contentView addSubview:dateLabel];
    }
    
    if (jobOrEdu != nil )
    {
        if ([jobOrEdu isKindOfClass:[WorkInfo class]])
        {
            WorkInfo *job = (WorkInfo *)jobOrEdu;
            nameLabel.text = job.companyName;
            positionLabel.text = job.jobCode;
            dateLabel.text = job.year;
        }
        else if ([jobOrEdu isKindOfClass:[EducationInfo class]])
        {
            EducationInfo *edu = (EducationInfo *)jobOrEdu;
            nameLabel.text = edu.school;
            positionLabel.text = edu.department;
            dateLabel.text = edu.year;
        }
    }
}

#pragma mark - UINavigationBarBtnAction
-(void)gotoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
