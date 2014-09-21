//
//  VisualRangeViewController.m
//  WeLinked4
//
//  Created by floar on 14-5-26.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "VisualRangeViewController.h"

@interface VisualRangeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableViewCell *cell1;
    UITableViewCell *cell2;
    UITableViewCell *cell3;
    
}

@property (weak, nonatomic) IBOutlet UITableView *visualRangeTableView;

@end

@implementation VisualRangeViewController

@synthesize visualRangeTableView;

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
    
    [self.navigationItem setTitleString:@"选择可见范围"];
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d度好友可见",indexPath.row+1];
    if (indexPath.row == 2)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell3 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell == cell1)
    {
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell2.accessoryType = UITableViewCellAccessoryNone;
            cell3.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (selectedCell == cell2)
    {
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell1.accessoryType = UITableViewCellAccessoryNone;
            cell3.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (selectedCell == cell3)
    {
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell1.accessoryType = UITableViewCellAccessoryNone;
            cell2.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - UINavigationBarBtnAction
-(void)gotoBack
{
    if (cell1.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selected" object:@"一度好友可见"];
    }
    else if (cell2.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selected" object:@"二度好友可见"];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selected" object:@"三度好友可见"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
