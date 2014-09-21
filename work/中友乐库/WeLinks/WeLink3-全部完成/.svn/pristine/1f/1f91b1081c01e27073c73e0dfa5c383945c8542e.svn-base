//
//  InfoDetailSubscriptionViewController.m
//  WeLinked3
//
//  Created by yohunl on 14-3-3.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "InfoDetailSubscriptionViewController.h"

#import "InfoDetailSubscriptionCell.h"
#import "InfoDetailSubscriptionDataManager.h"
#import "InfoDetailCellChange.h"
#import "NetworkEngine.h"

#import "InfoCategorySubscriptionsCell.h"

#import "InforDetailViewController.h"

@interface InfoDetailSubscriptionViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,InfoDetailCellChange,InfoDetailSubscriptionDataManagerDelegate,UISearchBarDelegate>
{
    NSMutableArray *detailSearchDisplayArray;
    NSMutableArray *searchArray;
    
    UISearchBar *detailSubscriptionSearchBar;
    UISearchDisplayController *detailSubScriptionSearchCtl;
    
    __weak IBOutlet UITableView *infodetailSubscriptionTableView;
}

@property (nonatomic, strong) InfoDetailSubscriptionDataManager *dataManger;

@end

@implementation InfoDetailSubscriptionViewController

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
    
    self.wantsFullScreenLayout = YES;
    [self.navigationItem setTitleViewWithText:_ViewCtlTitleString];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back)];
    
    //UISearchBar
#if 0
    detailSubscriptionSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    detailSubscriptionSearchBar.placeholder = @"搜索你感兴趣的东西";
    detailSubScriptionSearchCtl = [[UISearchDisplayController alloc] initWithSearchBar:detailSubscriptionSearchBar contentsController:self];
    detailSubScriptionSearchCtl.searchResultsDataSource = self;
    detailSubScriptionSearchCtl.searchResultsDelegate = self;
    detailSubscriptionSearchBar.delegate = self;
    
    if (detailSearchDisplayArray == nil)
    {
        detailSearchDisplayArray = [[NSMutableArray alloc] init];
    }
    if (searchArray == nil)
    {
        searchArray = [[NSMutableArray alloc] init];
    }
#endif
    
    //UITableView
    infodetailSubscriptionTableView.delegate = self;
    infodetailSubscriptionTableView.dataSource = self;
    infodetailSubscriptionTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    infodetailSubscriptionTableView.tableHeaderView = detailSubscriptionSearchBar;
    
    [self.view addSubview:infodetailSubscriptionTableView];
    
    
    //获取网络信息
    self.dataManger = [[InfoDetailSubscriptionDataManager alloc] init];
    self.dataManger.delegate = self;
    self.dataManger.parentId = self.preViewCellId;
    [self.dataManger loadInfoDetailSubscriptionDataWithPreViewCellId:self.preViewCellId];
}

-(void)HUDCustomAction:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.margin = 10.f;
    hud.yOffset = -30.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self makeCellSelectedStateMis];
    [infodetailSubscriptionTableView deselectRowAtIndexPath:[infodetailSubscriptionTableView indexPathForSelectedRow] animated:YES];
}

- (IBAction)goback:(id)sender
{
    [self back];
}


-(void)makeCellSelectedStateMis
{
    [infodetailSubscriptionTableView deselectRowAtIndexPath:[infodetailSubscriptionTableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - detailSubscriptionTableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == infodetailSubscriptionTableView)
    {
        return self.dataManger.infoDetailSubscriptionArray.count;
    }
    else
    {
        return self.dataManger.infoDetailSearchArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == infodetailSubscriptionTableView)
    {
        InfoDetailSubscriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailcell"];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([InfoDetailSubscriptionCell class]) owner:self options:nil] lastObject];
        }
        
        Column *column = [self.dataManger.infoDetailSubscriptionArray objectAtIndex:indexPath.row];
        cell.column = column;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        cell.detailSubscriptionCellBtn.tag = 50+indexPath.row;
        cell.cellChangeDelegate = self;
        return cell;
    }
    else
    {
        static NSString *cellId = @"searchCell";
        InfoDetailSubscriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([InfoCategorySubscriptionsCell class]) owner:self options:nil] lastObject];
        }
        Column *column = [self.dataManger.infoDetailSearchArray objectAtIndex:indexPath.row];
        cell.column = column;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == infodetailSubscriptionTableView)
    {
        InforDetailViewController *inforDetailCtl = [[InforDetailViewController alloc] init];
        Column *column = [self.dataManger.infoDetailSubscriptionArray objectAtIndex:indexPath.row];
        inforDetailCtl.infoDetailSubscribeItem = column.colunmID;
        inforDetailCtl.infoDetailViewCtlTitle = column.title;
        inforDetailCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inforDetailCtl animated:YES];

    }
    else
    {
        InforDetailViewController *inforDetailCtl = [[InforDetailViewController alloc] initWithNibName:NSStringFromClass([InforDetailViewController class]) bundle:nil];
        Column *column = [self.dataManger.infoDetailSearchArray objectAtIndex:indexPath.row];
        inforDetailCtl.infoDetailSubscribeItem = column.colunmID;
        inforDetailCtl.infoDetailViewCtlTitle = column.title;
        inforDetailCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inforDetailCtl animated:YES];
    }
    [self performSelector:@selector(makeCellSelectedStateMis) withObject:nil afterDelay:1.0];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 61;
    
}

#pragma mark - detailSubscriptionCellDelegate

-(void)changeStateWithCellIndex:(int)index
{
    Column *column = [self.dataManger.infoDetailSubscriptionArray objectAtIndex:index];
    if (0 == [column.isSubscribe intValue])
    {
        column.isSubscribe = @"1";
        [column synchronize:nil];
        [[NetworkEngine sharedInstance] subscribe:column.colunmID block:^(int event, id object)
         {
             if (1 == event)
             {
                 
             }
             if (0 == event)
             {
                 
             }
         }];
    }
    
    else if (1 == [column.isSubscribe intValue])
    {
        column.isSubscribe = @"0";
        [column synchronize:nil];
        [[NetworkEngine sharedInstance] unSubscribe:column.colunmID block:^(int event, id object)
         {
             if (1 == event)
             {
                 
             }
             if (0 == event)
             {
                 NSLog(@"error");
             }
         }];
    }
    
}


#pragma mark - dataManagerDelegate
-(void)InfoDetailSubscriptionDataManagerGetDataSuccess
{
    [infodetailSubscriptionTableView reloadData];
}

-(void)InfoDetailSubscriptionDataManagerGetDataFailed
{
    [infodetailSubscriptionTableView endUpdates];
}

#pragma mark - searchDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (![searchBar.text isEqualToString:@""])
    {
        [self.dataManger loadSearchDataWithKeyword:searchBar.text];
    }
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.dataManger.infoDetailSearchArray removeAllObjects];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.dataManger.infoDetailSearchArray removeAllObjects];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchText isEqualToString:@""])
    {
        [self.dataManger loadSearchDataWithKeyword:searchText];
    }
    
}

//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    NSLog(@"search111---%@",searchString);
//    if (![searchString isEqualToString:@""])
//    {
//        [self.dataManger loadSearchDataWithKeyword:searchString];
//    }
//    return YES;
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
