//
//  SubSettingViewController.m
//  WeLinked3
//
//  Created by jonas on 3/11/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "SubSettingViewController.h"
#import "CustomCellView.h"
#import "LogicManager.h"
@interface SubSettingViewController ()

@end

@implementation SubSettingViewController

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
    [self.navigationItem setTitleViewWithText:@"手机号隐私设置"];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack
                                                                 title:nil
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
#pragma mark - Table view data source
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CustomCellView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* Identifier = @"Cell";
    CustomMarginCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil)
    {
        cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
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
        cell.textLabel.text = @"隐藏";
        [self customLine:cell];
        
        UIImageView* mark = (UIImageView*)[cell.contentView viewWithTag:10];
        if(mark == nil)
        {
            mark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"didsubscribe"]];
            mark.frame = CGRectMake(cell.contentView.frame.size.width-40, (cell.contentView.frame.size.height-22)/2, 22, 22);
            mark.tag = 10;
            [cell.contentView addSubview:mark];
        }
        //0=好友可见 1=隐藏
        if([UserInfo myselfInstance].phoneStatus == 1)
        {
            mark.hidden = NO;
        }
        else
        {
            mark.hidden = YES;
        }
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"职脉联系人可见";
        [self customLine:cell];
        UIImageView* mark = (UIImageView*)[cell.contentView viewWithTag:10];
        if(mark == nil)
        {
            mark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"didsubscribe"]];
            mark.frame = CGRectMake(cell.contentView.frame.size.width-40, (cell.contentView.frame.size.height-22)/2, 22, 22);
            mark.tag = 10;
            [cell.contentView addSubview:mark];
        }
        //0=好友可见 1=隐藏
        if([UserInfo myselfInstance].phoneStatus == 0)
        {
            mark.hidden = NO;
        }
        else
        {
            mark.hidden = YES;
        }
    }
    return cell;
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
        line = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = colorWithHex(0xCCCCCC);
        line.tag = 2;
        [cell.contentView addSubview:line];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if(indexPath.row == 0)
    {
        [dic setObject:[NSNumber numberWithInt:1] forKey:@"phoneStatus"];
    }
    else if (indexPath.row == 1)
    {
        [dic setObject:[NSNumber numberWithInt:0] forKey:@"phoneStatus"];
    }
    NSString* json = [[LogicManager sharedInstance] objectToJsonString:dic];
    [[NetworkEngine sharedInstance] saveProfileInfo:json block:^(int event, id object)
    {
        if(event == 0)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"修改失败" actionText:@"确定"];
        }
        else if (event == 1)
        {
            [tableView reloadData];
        }
    }];
}
@end
