//
//  JobViewController.m
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "JobViewController.h"
#import "JobTableCell.h"
#import "PublishJobViewController.h"
#import "PullRefreshTableView.h"
#import "MMPagingScrollView.h"
#import "JobDetailViewViewController.h"
#import "InternalRecommendViewController.h"
#import "FilterJobViewController.h"
#import "JobViewDataManager.h"
#import "AKSegmentedControl.h"

typedef enum {
    JobSourceTypeFriendList = 0,
    JobSourceTypeCompanyList
}JobSourceType;

@interface JobViewController ()<PullRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,MMPagingScrollViewDelegate,JobViewDataManagerDelegate,AKSegmentedControlDelegate>
{
    int _currentType;
}
@property (nonatomic, strong)  AKSegmentedControl *jobSource;
@property (strong, nonatomic) IBOutlet UIView *toolBar;

@property (nonatomic, strong) PullRefreshTableView *friendJobList;
@property (nonatomic, strong) PullRefreshTableView *companyJobList;
@property (strong, nonatomic) MMPagingScrollView *scrollView;
@property (nonatomic, strong) JobViewDataManager *dataManager;
@property (nonatomic, strong) UILabel *noFriendJobTips;
@property (nonatomic, strong) UILabel *noCompanyJobTips;
@end

@implementation JobViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tabBarItem.image = [UIImage imageNamed:@"job"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"jobSelected"];
        self.tabBarItem.title = @"职业机会";
        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorWithHex(NAVBARCOLOR),
                                                 UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.toolBar = nil;
    self.jobSource = nil;
    self.friendJobList = nil;
    self.companyJobList = nil;
    self.scrollView = nil;
    self.noCompanyJobTips = nil;
    self.noFriendJobTips = nil;
    NSLog(@"job---delloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    [self initSegment];
    [self.navigationItem setTitleViewWithText:@"职业机会"];
    
//    [self.navigationItem setTitleView:self.jobSource];
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleConfirm title:@"发职位" target:self selector:@selector(sendJob)];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleConfirm title:@"筛选" target:self selector:@selector(fliteJob)];
    
    //    添加人脉职位列表
    self.friendJobList = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.toolBar.height)];
    self.friendJobList.delegate = self;
    self.friendJobList.dataSource = self;
    //    self.friendTableView.headerOnly = NO;
    self.friendJobList.pullingDelegate = self;
    self.friendJobList.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleHeight;
    self.friendJobList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.friendJobList.backgroundColor = [UIColor clearColor];
    self.friendJobList.rowHeight = 80;
    [self.friendJobList setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    
    //    添加公司职位列表
    self.companyJobList = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.toolBar.height)];
    self.companyJobList.delegate = self;
    self.companyJobList.dataSource = self;
    self.companyJobList.pullingDelegate = self;
    self.companyJobList.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleHeight;
    //    self.nearbyTableView.headerOnly = NO;
    self.companyJobList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.companyJobList.backgroundColor = [UIColor clearColor];
    self.companyJobList.rowHeight = 80;
    [self.companyJobList setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    
    self.scrollView = [[MMPagingScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), self.view.width, self.view.height - self.toolBar.height)];
    _scrollView.viewList = [NSMutableArray arrayWithObjects:self.friendJobList,self.companyJobList,nil];
    _scrollView.scrollingDelegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleHeight;
    //    _scrollView.scrollEnabled = NO;
    [_scrollView setInitialPageIndex:0];
    self.scrollView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0f];
    [self.view addSubview:_scrollView];
    
    self.dataManager = [[JobViewDataManager alloc] init];
    self.dataManager.delegate = self;
    [self.dataManager loadCompanyJob];
    [self.dataManager loadFriendJob];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishNewJob:) name:kPublishJobSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteJobSuccess:) name:kDeleteJobSuccess object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateJobSuccess:) name:kUpdateJobSuccess object:nil];
    
    self.noFriendJobTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, self.view.width, 200)];
    self.noCompanyJobTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, self.view.width, 200)];
    self.noCompanyJobTips.font = self.noFriendJobTips.font = getFontWith(NO, 14);
    self.noFriendJobTips.textColor = self.noCompanyJobTips.textColor = colorWithHex(0x999999);
    self.noCompanyJobTips.text = self.noFriendJobTips.text = @"暂无数据";
    self.noCompanyJobTips.textAlignment = self.noFriendJobTips.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _toolBar.y = 56;
    [self.navigationController.view addSubview:_toolBar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_toolBar removeFromSuperview];
}
#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_currentType == JobSourceTypeCompanyList) {
        return _dataManager.companyJobList.count;
    }else{
        return _dataManager.friendJobList.count;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JobTableCell";
    JobTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JobTableCell class]) owner:self options:nil] lastObject];
    }
    // Configure the cell...
    JobInfo *job = nil;
    if (_currentType == JobSourceTypeCompanyList) {
        job = [_dataManager.companyJobList objectAtIndex:indexPath.row];
    }else{
        job = [_dataManager.friendJobList objectAtIndex:indexPath.row];
    }
    cell.jobInfo = job;
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobInfo *job = nil;
    JobDetailViewViewController *jobDetail = [[JobDetailViewViewController alloc] init];
    if (_currentType == JobSourceTypeCompanyList)
    {
        job = [_dataManager.companyJobList objectAtIndex:indexPath.row];
        jobDetail.isFriendJob = NO;
    }
    else
    {
        job = [_dataManager.friendJobList objectAtIndex:indexPath.row];
        jobDetail.isFriendJob = YES;
    }
    
    jobDetail.jobIdentity = job.identity;
    jobDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jobDetail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sendJob
{
    PublishJobViewController *publishJobView = [[PublishJobViewController alloc] init];
    publishJobView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishJobView animated:YES];
}

- (void)fliteJob
{
    [MobClick event:JOB3];
    FilterJobViewController *filterView = [[FilterJobViewController alloc] init];
    filterView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:filterView animated:YES];
}


#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullRefreshTableView *)tableView{
    switch (_currentType) {
        case JobSourceTypeFriendList:
            [self.dataManager loadFriendJob];
            break;
        case JobSourceTypeCompanyList:
            [self.dataManager loadCompanyJob];
            break;
            
        default:
            break;
    }
    
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [NSDate date];
}

- (void)pullingTableViewDidStartLoading:(PullRefreshTableView *)tableView{
    switch (_currentType) {
        case JobSourceTypeFriendList:
        {
            [self.dataManager loadFriendJobNextPageData];
//            if (_friendActivitiesLoading) {
//                return;
//            }
//            if (self.manager.friendListHaveNext) {
//                [self.manager getFriendActivityNextPage];
//                
//                _friendActivitiesLoading = YES;
//                [self.friendTableView reloadData];
//            }
        }
            break;
        case JobSourceTypeCompanyList:
        {
            [self.dataManager loadCompanyJobNextPageData];
//            if (_nearbyActivitiesLoading) {
//                return;
//            }
//            if (self.manager.nearbyListHaveNext) {
//                [self.manager getNearbyActivityNextPage];
//                _nearbyActivitiesLoading = YES;
//                [self.nearbyTableView reloadData];
//            }
        }
            break;
        default:
            break;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    switch (_currentType) {
        case JobSourceTypeFriendList:
            [self.friendJobList tableViewDidScroll:scrollView];
            break;
            
        case JobSourceTypeCompanyList:
            [self.companyJobList tableViewDidScroll:scrollView];
            break;
        
            
        default:
            break;
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    switch (_currentType) {
        case JobSourceTypeFriendList:
            [self.friendJobList tableViewDidEndDragging:scrollView];
            break;
        case JobSourceTypeCompanyList:
            [self.companyJobList tableViewDidEndDragging:scrollView];
            break;            
        default:
            break;
    }
    
    self.scrollView.pagingEnabled = YES;
}

- (void) scrollView:(MMPagingScrollView *)scrollView didScrollToIndex:(NSInteger)index
{
    self.jobSource.selectedIndex = index;
}

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    _currentType = self.jobSource.selectedIndex;
    switch (_currentType)
    {
        case JobSourceTypeFriendList:
            [MobClick event:JOB1];
            [self.friendJobList reloadData];
            break;
        case JobSourceTypeCompanyList:
            [MobClick event:JOB2];
            [self.companyJobList reloadData];
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollView scrollToIndex:_currentType];
    }];
}

#pragma mark - dataMangerDelegate

- (void)jobViewDataManagerGetFriendJobListSuccess
{
    [self.friendJobList reloadData];
    if (self.dataManager.friendJobList.count) {
//        self.friendJobList.hidden = NO;
//        [self.noFriendJobTips removeFromSuperview];
        self.friendJobList.tableHeaderView = nil;
    }else{
//        self.friendJobList.hidden = YES;
//        [self.scrollView addSubview:self.noFriendJobTips];
        self.friendJobList.tableHeaderView = self.noFriendJobTips;
//        self.noFriendJobTips.center = CGPointMake(self.friendJobList.center.x, 90);
    }
    [self.friendJobList tableViewDidFinishedLoading];
}

- (void)jobViewDataManagerGetFriendJobListFailed
{
    if (self.dataManager.friendJobList.count) {
//        self.friendJobList.hidden = NO;
//        [self.noFriendJobTips removeFromSuperview];
        self.friendJobList.tableHeaderView = nil;
    }else{
        self.friendJobList.tableHeaderView = self.noFriendJobTips;
//        self.friendJobList.hidden = YES;
//        [self.scrollView addSubview:self.noFriendJobTips];
//        self.noFriendJobTips.center = CGPointMake(self.friendJobList.center.x, 90);
    }
    [self.friendJobList tableViewDidFinishedLoading];
}

- (void)jobViewDataManagerGetCompanyJobListSuccess
{
    [self.companyJobList reloadData];
    if (self.dataManager.companyJobList.count) {
//        self.companyJobList.hidden = NO;
//        [self.noCompanyJobTips removeFromSuperview];
        self.companyJobList.tableHeaderView = nil;
    }else{
        self.companyJobList.tableHeaderView = self.noCompanyJobTips;
//        self.companyJobList.hidden = YES;
//        [self.scrollView addSubview:self.noCompanyJobTips];
//        self.noCompanyJobTips.center = CGPointMake(self.companyJobList.center.x, 90);
    }
    [self.companyJobList tableViewDidFinishedLoading];
}
- (void)jobViewDataManagerGetCompanyJobListFailed
{
    if (self.dataManager.companyJobList.count) {
//        self.companyJobList.hidden = NO;
//        [self.noCompanyJobTips removeFromSuperview];
        self.companyJobList.tableHeaderView = nil;
    }else{
        self.companyJobList.tableHeaderView = self.noCompanyJobTips;
//        self.companyJobList.hidden = YES;
//        [self.scrollView addSubview:self.noCompanyJobTips];
//        self.noCompanyJobTips.center = CGPointMake(self.companyJobList.center.x, 90);
    }
    [self.companyJobList tableViewDidFinishedLoading];
}
#pragma mark - initSegment
- (void)initSegment
{
    self.jobSource = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(40, 5, 240, 30)];
//    [self.jobSource setBackgroundImage:[[UIImage imageNamed:@"segmented-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 7.5, 12, 7.5)]];
    self.jobSource.backgroundColor = [UIColor clearColor];
    self.jobSource.delegate = self;
    self.jobSource.layer.cornerRadius = 5;
    self.jobSource.layer.borderColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0f].CGColor;
    self.jobSource.layer.borderWidth = 1.0f;
    self.jobSource.clipsToBounds = YES;
    
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"segmented-bg-pressed-center.png"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"segmented-bg-pressed-center.png"]
                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"人脉职位" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    leftButton.frame = CGRectMake(0, 0, 120, 30);
    
    [leftButton setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [leftButton setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [leftButton setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(120, 0, 120, 30);
    [rightButton setTitle:@"公司职位" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    [rightButton setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [rightButton setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [buttonArray addObject:leftButton];
    [buttonArray addObject:rightButton];
    
    _jobSource.buttonsArray = buttonArray;
    [_toolBar addSubview:_jobSource];
}

#pragma mark - Noti
- (void)publishNewJob:(NSNotification *)notification
{
    JobInfo *job = [notification object];
    [self.dataManager.friendJobList insertObject:job atIndex:0];
    if (self.dataManager.friendJobList.count) {
        self.friendJobList.tableHeaderView = nil;
    }else{
        self.friendJobList.tableHeaderView = self.noFriendJobTips;
    }
    [self.friendJobList reloadData];
}

- (void)upDateJobSuccess:(NSNotification *)notification
{
    [self.dataManager loadFriendJob];
}

- (void)deleteJobSuccess:(NSNotification *)notification
{
    JobInfo *job = [notification object];
    [self.dataManager.friendJobList removeObject:job];
    if (self.dataManager.friendJobList.count) {
        self.friendJobList.tableHeaderView = nil;
    }else{
        self.friendJobList.tableHeaderView = self.noFriendJobTips;
    }
    [self.friendJobList reloadData];
}

@end
