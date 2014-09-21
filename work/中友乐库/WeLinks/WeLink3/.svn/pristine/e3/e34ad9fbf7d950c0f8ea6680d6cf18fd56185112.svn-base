//
//  FilterJobListViewController.m
//  WeLinked3
//
//  Created by 牟 文斌 on 3/6/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "FilterJobListViewController.h"
#import "JobTableCell.h"
#import "JobDetailViewViewController.h"

@interface FilterJobListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation FilterJobListViewController


- (void)dealloc
{
    self.jobList = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = 80;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [self.navigationItem setTitleViewWithText:@"筛选结果"];
    
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(backAction)];
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleConfirm title:@"关闭" target:self selector:@selector(closeAction)];
    if (self.jobList.count) {
        self.tableView.hidden = NO;
        self.tipsLabel.hidden = YES;
    }else{
        self.tipsLabel.text = @"很抱歉，\n还没有符合你要求的职位";
        self.tipsLabel.textColor = colorWithHex(0x666666);
        self.tipsLabel.font = [UIFont systemFontOfSize:14];
        self.tableView.hidden = YES;
        self.tipsLabel.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    return _jobList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JobTableCell";
    JobTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JobTableCell class]) owner:self options:nil] lastObject];
    }
    // Configure the cell...
    JobInfo *job = [_jobList objectAtIndex:indexPath.row];;
    
    cell.jobInfo = job;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobInfo *job = [_jobList objectAtIndex:indexPath.row];
    JobDetailViewViewController *jobDetail = [[JobDetailViewViewController alloc] init];
    jobDetail.isFriendJob = NO;
    jobDetail.jobIdentity = job.identity;
    jobDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jobDetail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
