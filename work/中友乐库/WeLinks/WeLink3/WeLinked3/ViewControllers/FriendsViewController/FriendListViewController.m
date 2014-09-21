//
//  FriendListViewController.m
//  WeLinked3
//
//  Created by jonas on 3/13/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "FriendListViewController.h"
#import "NetworkEngine.h"
@interface FriendListViewController ()

@end

@implementation FriendListViewController

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
    [self.navigationItem setTitleViewWithText:@""];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack
                                                                 title:nil
                                                                target:self
                                                              selector:@selector(back:)];
    
    dataSource = [[NSMutableArray alloc]init];
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    table.tableHeaderView = headerView;
    if(self.dataType == 0)
    {
        [[NetworkEngine sharedInstance] getUserByCompany:self.name block:^(int event, id object)
        {
            if(event == 0)
            {
            }
            else if (event == 1)
            {
                [dataSource removeAllObjects];
                [dataSource addObjectsFromArray:object];
            }
            [table reloadData];
        }];
    }
    else
    {
        
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitleViewWithText:self.name];
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
#pragma --mark UITableView
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectZero];
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataSource count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* Identifier = @"Cell";
    CustomMarginCellView* cell = (CustomMarginCellView*)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil)
    {
        cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = cellBackgroundView;
    }
    UserInfo* info = (UserInfo*)[dataSource objectAtIndex:indexPath.section];
    
    EGOImageView* imageView = (EGOImageView*)[cell.contentView viewWithTag:1];
    if(imageView == nil)
    {
        imageView = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [cell.contentView addSubview:imageView];
        imageView.tag = 1;
    }
    RCLabel* descLabel = (RCLabel*)[cell.contentView viewWithTag:2];
    if(descLabel == nil)
    {
        descLabel = [[RCLabel alloc]initWithFrame:CGRectMake(70, 8, 220, 60)];
        [cell.contentView addSubview:descLabel];
        descLabel.tag = 2;
    }
    [imageView setImageURL:[NSURL URLWithString:info.avatar]];
    NSMutableString* str = [[NSMutableString alloc]init];
    [str appendFormat:@"<p><font color='#464646' face='FZLTZHK--GBK1-0' size=14>%@</font></p>",info.name];
    [str appendFormat:@"\n<p lineSpacing=5><font size=11>%@ %@</font></p>",info.company,info.job];
    [str appendFormat:@"\n<p lineSpacing=5><font size=11>%@</font></p>",info.descriptions];
    [descLabel setText:str];
    [self customLine:cell height:70];
    return cell;

}
-(void)customLine:(UITableViewCell*)cell height:(float)height
{
    if(cell == nil || cell.contentView == nil)
    {
        return;
    }
    UIView* line = [cell.contentView viewWithTag:4];
    if(line == nil)
    {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, height-0.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = colorWithHex(0xCCCCCC);
        line.tag = 4;
        [cell.contentView addSubview:line];
    }
}
@end
