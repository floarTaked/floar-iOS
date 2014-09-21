//
//  SearchScribesViewController.m
//  WeLinked3
//
//  Created by floar on 14-4-9.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "SearchScribesViewController.h"
#import "UINavigationBar+Loading.h"
#import "InforDetailViewController.h"
#import "searchScribeCell.h"
#import "NetworkEngine.h"

@interface SearchScribesViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *searchArray;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchScribeBar;

@end

@implementation SearchScribesViewController

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
    
    searchArray = [[NSMutableArray alloc] init];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
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
    [self.searchScribeBar becomeFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
        line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 0.5)];
        line.backgroundColor = colorWithHex(0xCCCCCC);
        line.tag = 2;
        [cell.contentView addSubview:line];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    searchScribeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[searchScribeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [self customLine:cell];
    cell.colum = [searchArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Column *column = [searchArray objectAtIndex:indexPath.row];
    InforDetailViewController *infroCtl = [[InforDetailViewController alloc] init];
    infroCtl.infoDetailSubscribeItem = column.colunmID;
    infroCtl.infoDetailViewCtlTitle = column.title;
    infroCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infroCtl animated:YES];
}

#pragma mark - UISearchBarDelegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keyWord = searchBar.text;
    
    [[NetworkEngine sharedInstance] searchArticleByKeyWord:keyWord Block:^(int event, id object)
    {
        [searchArray removeAllObjects];
        if (1 == event)
        {
            for (NSDictionary *dict in object)
            {
                Column *column = [[Column alloc] init];
                [column setValuesForKeysWithDictionary:dict];
                [searchArray addObject:column];
            }
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}

@end
