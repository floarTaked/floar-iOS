//
//  SearchFriendViewController.m
//  WeLinked3
//
//  Created by jonas on 2/28/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "PublicObject.h"
#import "LogicManager.h"
@interface SearchFriendViewController ()

@end

@implementation SearchFriendViewController

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
    dataSource = [[NSMutableArray alloc]init];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [m_searchBar becomeFirstResponder];
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
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
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
    UserInfo* info = [dataSource objectAtIndex:indexPath.row];
    
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
        descLabel = [[RCLabel alloc]initWithFrame:CGRectMake(70, 8, 120, 60)];
        [cell.contentView addSubview:descLabel];
        descLabel.tag = 2;
    }
    [imageView setImageURL:[NSURL URLWithString:info.avatar]];
    NSMutableString* str = [[NSMutableString alloc]init];
    JobObject* job = [[LogicManager sharedInstance] getPublicObject:info.jobCode type:Job];
    [str appendFormat:@"<p><font color='#464646' face='FZLTZHK--GBK1-0' size=14>%@</font></p>",info.name==nil?@"":info.name];
    [str appendFormat:@"\n<p lineSpacing=5><font size=11>%@ %@</font></p>",info.company==nil?@"":info.company,job.name==nil?@"":job.name];
    [str appendFormat:@"\n<p lineSpacing=5><font size=11>%@</font></p>",job.parentName==nil?@"":job.parentName];
    [descLabel setText:str];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfo* info =(UserInfo*)[dataSource objectAtIndex:indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [[LogicManager sharedInstance] gotoProfile:self userId:info.userId showBackButton:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* keyWord = searchBar.text;
    [self.navigationController.navigationBar showLoadingIndicator];
    [[NetworkEngine sharedInstance] searchFriends:keyWord block:^(int event, id object)
    {
        [self.navigationController.navigationBar hideLoadingIndicator];
        [dataSource removeAllObjects];
        if(event == 0)
        {
        }
        else if (event == 1)
        {
            [dataSource addObjectsFromArray:object];
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}
@end
