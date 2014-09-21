
//
//  InfoCategoryOfSubscriptionsViewController.m
//  WeLinked3
//
//  Created by yohunl on 14-3-3.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "InfoCategoryOfSubscriptionsViewController.h"

#import "InfoDetailSubscriptionViewController.h"
#import "InfoCategorySubscriptionsCell.h"
#import "CategorySubscriptionsDataManager.h"
#import "SearchScribesViewController.h"

#import "AKSegmentedControl.h"
#import "PullRefreshTableView.h"
#import "MMPagingScrollView.h"
#import <MBProgressHUD.h>


typedef enum
{
//    SubscribesTypeIndustryChoiceType = 0,
//    SubscribesTypeGoodChoiceTpye
    
    SubscribesTypeGoodChoiceTpye = 0,
    SubscribesTypeIndustryChoiceType
}SubscribesType;

@interface InfoCategoryOfSubscriptionsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,CategorySubscriptionsDataManagerDelegate,UISearchBarDelegate,PullRefreshTableViewDelegate,MMPagingScrollViewDelegate,AKSegmentedControlDelegate>
{
    NSMutableArray *subscriptionsDisplaySearchArray;
    NSMutableArray *searchArray;
    
    UISearchBar *subSriptionsIndtorySearchBar;
    UISearchDisplayController *subSriptionsIndtoryDisCtl;
    
    UISearchBar *subSriptionsGoodSearchBar;
    UISearchDisplayController *subSriptionsGoodDisCtl;
    
    int currentType;
    
}

@property (nonatomic, strong) CategorySubscriptionsDataManager *dataManager;
@property (nonatomic, strong) PullRefreshTableView *IndustryChoiceList;
@property (nonatomic, strong) PullRefreshTableView *GoodChoiceList;
@property (nonatomic, strong) MMPagingScrollView *subscriptionsMMpageScrollView;
@property (nonatomic, strong) AKSegmentedControl *AKSubscribesSegmentCtl;

@property (strong, nonatomic) IBOutlet UIImageView *AKToolBarView;

@end

@implementation InfoCategoryOfSubscriptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = NO;
    self.AKToolBarView.y = 63;
    self.wantsFullScreenLayout = YES;
    //定制UINavigationItem
    [self.navigationItem setTitleViewWithText:@"订阅类别"];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back)];
    
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleSearch title:nil target:self selector:@selector(searchAction:)];
    
    [self initAKSegment];
    
    //添加行业订阅列表
    self.IndustryChoiceList = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.AKToolBarView.frame), self.view.width, self.view.height - self.AKToolBarView.height)];
    self.IndustryChoiceList.delegate = self;
    self.IndustryChoiceList.dataSource = self;
    //    self.friendTableView.headerOnly = NO;
    self.IndustryChoiceList.pullingDelegate = self;
    self.IndustryChoiceList.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleHeight;
    self.IndustryChoiceList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.IndustryChoiceList.backgroundColor = [UIColor clearColor];
    self.IndustryChoiceList.rowHeight = 80;
    [self.IndustryChoiceList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //添加精选订阅列表
    self.GoodChoiceList = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.AKToolBarView.frame), self.view.width, self.view.height - self.AKToolBarView.height)];
    self.GoodChoiceList.delegate = self;
    self.GoodChoiceList.dataSource = self;
    self.GoodChoiceList.pullingDelegate = self;
    self.GoodChoiceList.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleHeight;
    //    self.nearbyTableView.headerOnly = NO;
    self.GoodChoiceList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.GoodChoiceList.backgroundColor = [UIColor clearColor];
    self.GoodChoiceList.rowHeight = 80;
    [self.GoodChoiceList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    if (self.view.frame.size.height < 500)
    {
        self.subscriptionsMMpageScrollView = [[MMPagingScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height - self.AKToolBarView.height)];
    }
    else
    {
        //4inch-ok
        self.subscriptionsMMpageScrollView = [[MMPagingScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height - self.AKToolBarView.height)];
    }
    
    self.subscriptionsMMpageScrollView.viewList = [NSMutableArray arrayWithObjects:self.GoodChoiceList,self.IndustryChoiceList,nil];
    self.subscriptionsMMpageScrollView.scrollingDelegate = self;
    self.subscriptionsMMpageScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleHeight;
//    _scrollView.scrollEnabled = NO;
    [self.subscriptionsMMpageScrollView setInitialPageIndex:0];
    self.subscriptionsMMpageScrollView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0f];
    [self.view addSubview:self.subscriptionsMMpageScrollView];
    
    self.IndustryChoiceList.showFooter = NO;
    self.GoodChoiceList.showFooter = NO;
    

    if (subscriptionsDisplaySearchArray == nil)
    {
        subscriptionsDisplaySearchArray = [[NSMutableArray alloc] init];
    }
    if (searchArray == nil)
    {
        searchArray = [[NSMutableArray alloc] init];
    }
    
    self.dataManager = [[CategorySubscriptionsDataManager alloc] init];
    _dataManager.delegate = self;
    [self.dataManager subscriptionsLoadIndustryChoiceData];
    [self.dataManager subscriptionsLoadGoodChoiceData];

    
}

//返回页面时候，cell自动取消选中状态
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.GoodChoiceList deselectRowAtIndexPath:[self.GoodChoiceList indexPathForSelectedRow] animated:YES];
    [self.IndustryChoiceList deselectRowAtIndexPath:[self.IndustryChoiceList indexPathForSelectedRow] animated:YES];
    
    [self.navigationController.view.window addSubview:self.AKToolBarView];
    [self.navigationController.view bringSubviewToFront:self.AKToolBarView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.AKToolBarView removeFromSuperview];
    [super viewWillDisappear:animated];
}

//点击cell后，过段时间cell自动取消选中状态
//-(void)makeCellSelectedStateMis
//{
//    [subscriptionsTableView deselectRowAtIndexPath:[subscriptionsTableView indexPathForSelectedRow] animated:YES];
//}

- (IBAction)goback:(id)sender
{
    [self back];
}

- (IBAction)searchAction:(id)sender
{
    SearchScribesViewController *seachCtl = [[SearchScribesViewController alloc] init];
    [self.navigationController pushViewController:seachCtl animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    self.GoodChoiceList = nil;
    self.IndustryChoiceList = nil;
    self.AKSubscribesSegmentCtl = nil;
    self.subscriptionsMMpageScrollView = nil;
    self.AKToolBarView = nil;
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

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == subscriptionsTableView)
//    {
        if (tableView == self.IndustryChoiceList)
        {
            return self.dataManager.IndustryChoiceListArray.count;
        }
        else
        {
            return self.dataManager.GoodChoiceListArray.count;
        }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        InfoCategorySubscriptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subscriptions"];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([InfoCategorySubscriptionsCell class]) owner:self options:nil] lastObject];
        }
    
        Column *column = nil;
        if (tableView == self.IndustryChoiceList)
        {
            column = [self.dataManager.IndustryChoiceListArray objectAtIndex:indexPath.row];
        }else{
            column = [self.dataManager.GoodChoiceListArray objectAtIndex:indexPath.row];
        }
    
        cell.column = column;
        [self customLine:cell];
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (currentType == SubscribesTypeIndustryChoiceType)
    {
        InfoDetailSubscriptionViewController *detailSubscriptionViewCtl = [[InfoDetailSubscriptionViewController alloc] init];
        Column *column = [self.dataManager.IndustryChoiceListArray objectAtIndex:indexPath.row];
        detailSubscriptionViewCtl.preViewCellId = column.colunmID;
        detailSubscriptionViewCtl.ViewCtlTitleString = column.title;
        [self.navigationController pushViewController:detailSubscriptionViewCtl animated:YES];
    }
    else
    {
        InfoDetailSubscriptionViewController *detailSubscriptionViewCtl = [[InfoDetailSubscriptionViewController alloc] init];
        Column *column = [self.dataManager.GoodChoiceListArray objectAtIndex:indexPath.row];
        detailSubscriptionViewCtl.preViewCellId = column.colunmID;
        detailSubscriptionViewCtl.ViewCtlTitleString = column.title;
        [self.navigationController pushViewController:detailSubscriptionViewCtl animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

#pragma mark - dataMangerDelegate
- (void)subscriptionsDataManagerGetIndustryChoiceListSuccess
{
    [self.IndustryChoiceList reloadData];
    [self.IndustryChoiceList tableViewDidFinishedLoading];
}

- (void)subscriptionsDataManagerGetIndustryChoiceListFailed
{
    [self HUDCustomAction:@"请检查网络状况"];
        [self.IndustryChoiceList tableViewDidFinishedLoading];
}

- (void)subscriptionsDataManagerGetGoodChoiceListSuccess
{
    [self.GoodChoiceList reloadData];
    [self.GoodChoiceList tableViewDidFinishedLoading];
}
- (void)subscriptionsDataManagerGetGoodChoiceListFailed
{
    [self HUDCustomAction:@"请检查网络状况"];
    [self.GoodChoiceList tableViewDidFinishedLoading];
}

#pragma mark - UISearchDelegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchArray removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullRefreshTableView *)tableView
{
    switch (currentType)
    {
        case SubscribesTypeIndustryChoiceType:
            [self.dataManager.IndustryChoiceListArray removeAllObjects];
            [self.dataManager subscriptionsLoadIndustryChoiceData];
            break;
        case SubscribesTypeGoodChoiceTpye:
            [self.dataManager.GoodChoiceListArray removeAllObjects];
            [self.dataManager subscriptionsLoadGoodChoiceData];
            break;
            
        default:
            break;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    switch (currentType)
    {
        case SubscribesTypeGoodChoiceTpye:
            [self.GoodChoiceList tableViewDidScroll:scrollView];
            break;
            
        case SubscribesTypeIndustryChoiceType:
            [self.IndustryChoiceList tableViewDidScroll:scrollView];
            break;
            
            
        default:
            break;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    switch (currentType)
    {
        case SubscribesTypeIndustryChoiceType:
            [self.IndustryChoiceList tableViewDidEndDragging:scrollView];
            break;
        case SubscribesTypeGoodChoiceTpye:
            [self.GoodChoiceList tableViewDidEndDragging:scrollView];
            break;
        default:
            break;
    }
    
    self.subscriptionsMMpageScrollView.pagingEnabled = YES;
}

- (void) scrollView:(MMPagingScrollView *)scrollView didScrollToIndex:(NSInteger)index
{
    self.AKSubscribesSegmentCtl.selectedIndex = index;
}

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    currentType = self.AKSubscribesSegmentCtl.selectedIndex;
    switch (currentType)
    {
        case SubscribesTypeIndustryChoiceType:
//            [self.dataManager.IndustryChoiceListArray removeAllObjects];
            [self.dataManager subscriptionsLoadIndustryChoiceData];
            [self.IndustryChoiceList reloadData];
            break;
        case SubscribesTypeGoodChoiceTpye:
//            [self.dataManager.GoodChoiceListArray removeAllObjects];
//            [self.dataManager subscriptionsLoadGoodChoiceDataFromDB];
            
            [self.dataManager subscriptionsLoadGoodChoiceData];
//            DLog(@"goodchoiceTpye %d",self.dataManager.GoodChoiceListArray.count);
            [self.GoodChoiceList reloadData];
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.subscriptionsMMpageScrollView scrollToIndex:currentType];
    }];
}


#pragma mark - initSegment
- (void)initAKSegment
{
    self.AKSubscribesSegmentCtl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(40, 5, 240, 30)];
//    [self.jobSource setBackgroundImage:[[UIImage imageNamed:@"segmented-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 7.5, 12, 7.5)]];
    self.AKSubscribesSegmentCtl.backgroundColor = [UIColor clearColor];
    self.AKSubscribesSegmentCtl.delegate = self;
    self.AKSubscribesSegmentCtl.layer.cornerRadius = 5;
    self.AKSubscribesSegmentCtl.layer.borderColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0f].CGColor;
    self.AKSubscribesSegmentCtl.layer.borderWidth = 1.0f;
    self.AKSubscribesSegmentCtl.clipsToBounds = YES;
    
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"segmented-bg-pressed-center.png"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"segmented-bg-pressed-center.png"]
                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"精选" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    leftButton.frame = CGRectMake(0, 0, 120, 30);
    
    [leftButton setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [leftButton setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [leftButton setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(120, 0, 120, 30);
    [rightButton setTitle:@"行业" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    [rightButton setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [rightButton setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [buttonArray addObject:leftButton];
    [buttonArray addObject:rightButton];
    
    self.AKSubscribesSegmentCtl.buttonsArray = buttonArray;
    [self.AKToolBarView addSubview:self.AKSubscribesSegmentCtl];
}

#pragma mark - 画出cell分割线
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


@end
