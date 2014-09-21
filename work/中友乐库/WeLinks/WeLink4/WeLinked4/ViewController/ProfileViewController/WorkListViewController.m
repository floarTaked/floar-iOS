//
//  WorkListViewController.m
//  WeLinked3
//
//  Created by jonas on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "WorkListViewController.h"
#import "CustomCellView.h"
#import "WorkInfo.h"
#import "WorkViewController.h"
@interface WorkListViewController ()

@end

@implementation WorkListViewController
@synthesize profileInfo,editEnable;
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
    [self.navigationItem setTitleString:@"工作经历"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
                                imageSelected:[UIImage imageNamed:@"backSelected"]
                                        title:nil
                                        inset:UIEdgeInsetsMake(0, 0, 0, 0)
                                       target:self
                                     selector:@selector(back:)];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(section==1)
    {
        return 40;
    }
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(profileInfo.workArray != nil)
        {
            return [profileInfo.workArray count];
        }
        else
        {
            return 0;
        }
    }
    else if (section == 1)
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
    if(self.editEnable)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}
- (CustomMarginCellView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString* Identifier = @"Cell";
        CustomMarginCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cellBackgroundView.backgroundColor = [UIColor whiteColor];
            cell.backgroundView = cellBackgroundView;
            
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.font = getFontWith(YES, 14);
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.font = getFontWith(NO, 12);
            cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        }
        UILabel* lbl = (UILabel*)[cell.contentView viewWithTag:3];
        if(lbl == nil)
        {
            lbl = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-120, 2, 100, 50)];
            lbl.tag = 3;
            lbl.font = getFontWith(NO, 12);
            lbl.textColor = colorWithHex(0x3287E6);
            [cell.contentView addSubview:lbl];
        }
        WorkInfo* work = [profileInfo.workArray objectAtIndex:indexPath.row];
        cell.textLabel.text = work.companyName;
        cell.detailTextLabel.text = work.jobDesc;
        
        lbl.text = [NSString stringWithFormat:@"%d-%d",2013,2014];
        [self customLine:cell height:55];
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
        
        
        UIButton* addButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 0,290,44)];
        [addButton setBackgroundImage:[UIImage imageNamed:@"addWork"] forState:UIControlStateNormal];
        [addButton setBackgroundImage:[UIImage imageNamed:@"addWorkSelected"] forState:UIControlStateHighlighted];
        [addButton.titleLabel setFont:getFontWith(YES, 20)];
        [addButton addTarget:self action:@selector(addWork:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addButton];
        addButton.backgroundColor = [UIColor clearColor];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        WorkViewController* work = [[WorkViewController alloc]initWithNibName:@"WorkViewController" bundle:nil];
        WorkInfo* info = [profileInfo.workArray objectAtIndex:indexPath.row];
        work.workInfo = info;
        work.editEnable = self.editEnable;
        [work setCallback:^(int event, id object)
        {
            if(event == 0 && object != nil)
            {
                //删除成功
                if([profileInfo.workArray containsObject:object])
                {
                    [profileInfo.workArray removeObject:object];
                    [table reloadData];
                }
            }
        }];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:work animated:YES];
    }
}
-(void)addWork:(id)sender
{
    WorkViewController* work = [[WorkViewController alloc]initWithNibName:@"WorkViewController" bundle:nil];
    work.workInfo = nil;
    [work setCallback:^(int event, id object)
     {
         if(event == 1 && object != nil)
         {
             //添加成功
             if(![profileInfo.workArray containsObject:object])
             {
                 [profileInfo.workArray addObject:object];
                 [table reloadData];
             }
         }
     }];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:work animated:YES];
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
@end
