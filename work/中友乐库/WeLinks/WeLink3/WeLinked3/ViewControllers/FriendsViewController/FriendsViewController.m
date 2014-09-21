//
//  FriendsViewController.m
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "FriendsViewController.h"
#import "SearchFriendViewController.h"
#import "InternalRecommendViewController.h"
#import "AddFriendsViewController.h"
#import "FriendListViewController.h"
#import "PublishJobViewController.h"
@interface FriendsViewController ()
{
}
@end

@implementation FriendsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tabBarItem.image = [UIImage imageNamed:@"myFriends"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"myFriendsSelected"];
        self.tabBarItem.title = @"职脉";
        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorWithHex(NAVBARCOLOR),
                                                 UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"Loading...";
    
    self.wantsFullScreenLayout = YES;
    [self.navigationItem setTitleViewWithText:self.tabBarItem.title];
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleSearch
                                                                  title:@"添加"
                                                                 target:self
                                                               selector:@selector(addFriend:)];
    
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleSearch
                                                                 title:@"搜索"
                                                                target:self
                                                              selector:@selector(search:)];
//    CGRect frame = segmentNav.frame;
//    frame.origin.y = 54;
//    segmentNav.frame = frame;
    if(_refreshFooterView == nil)
    {
        _refreshFooterView = [[EGORefreshTableFooterView alloc]initWithFrame:CGRectMake(0,friendList.frame.size.height-REFRESH_REGION_HEIGHT,
                                                                                        friendList.frame.size.width, REFRESH_REGION_HEIGHT)];
        _refreshFooterView.delegate = self;
        _refreshFooterView.backgroundColor = [UIColor clearColor];
        [friendList addSubview:_refreshFooterView];
        if (_refreshFooterView)
        {
            [_refreshFooterView refreshLastUpdatedDate];
        }
        _refreshFooterView.loading = NO;
    }
    [self reloadData];
    pageNumber = 0;
    unKnowDataSource = [[NSMutableArray alloc]init];
//    companyDataSource = [[NSMutableArray alloc]init];
//    postDataSource = [[NSMutableArray alloc]init];
    
    scrollView = [[MMPagingScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    scrollView.viewList = [NSMutableArray arrayWithObjects:friendList,nil];
    scrollView.scrollingDelegate = self;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0f];
    [self.view addSubview:scrollView];
    
//    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
//    headerView.backgroundColor = [UIColor clearColor];
//    companyList.tableHeaderView = headerView;
//    
//    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
//    headerView.backgroundColor = [UIColor clearColor];
//    postList.tableHeaderView = headerView;
    
//    [[NetworkEngine sharedInstance] groupByCompany:^(int event, id object)
//    {
//        if(event == 0)
//        {
//            
//        }
//        else if (event == 1)
//        {
//            [companyDataSource addObjectsFromArray:object];
//        }
//        [companyList reloadData];
//    }];
//    [[NetworkEngine sharedInstance] groupByJob:^(int event, id object)
//    {
//        if(event == 0)
//        {
//            
//        }
//        else if (event == 1)
//        {
//            [postDataSource addObjectsFromArray:object];
//        }
//        [postList reloadData];
//    }];
    
    NSArray* arr = [[UserDataBaseManager sharedInstance]
                    queryWithClass:[UserInfo class]
                    tableName:AllFriendsTable
                    condition:[NSString stringWithFormat:@" where DBUid = '%@' order by friendType",[UserInfo myselfInstance].userId]];
    
    if(arr != nil && [arr count]>0)
    {
        [unKnowDataSource addObjectsFromArray:arr];
        [self reloadData];
    }
    [HUD show:YES];
    [self loadMoreData];
}
-(void)setFooterView
{
    CGFloat height = MAX(friendList.contentSize.height, friendList.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        _refreshFooterView.frame = CGRectMake(0.0f,height,friendList.frame.size.width,REFRESH_REGION_HEIGHT);
    }
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}
-(void)reloadData
{
    [friendList reloadData];
    if (_refreshFooterView)
    {
        [self setFooterView];
    }
}
-(void)loadMoreData
{
    [[NetworkEngine sharedInstance] getAllFriends:[NSString stringWithFormat:@"%d",pageNumber] block:^(int event, id object)
     {
         [HUD hide:YES];
         if(event == 0)
         {
             [self loadMoreTableViewDataFinished];
         }
         else if (event == 1)
         {
             if(object != nil && [object count]>0)
             {
                 [unKnowDataSource removeAllObjects];
                 pageNumber++;
                 NSArray* arr = [[UserDataBaseManager sharedInstance]
                                 queryWithClass:[UserInfo class]
                                 tableName:AllFriendsTable
                                 condition:[NSString stringWithFormat:@" where DBUid = '%@' order by friendType",[UserInfo myselfInstance].userId]];
                 [unKnowDataSource addObjectsFromArray:arr];
             }
             [self loadMoreTableViewDataFinished];
         }
     }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:SOCIAL1];
//    [self.navigationController.view addSubview:segmentNav];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [segmentNav removeFromSuperview];
}
-(void)addFriend:(id)sender
{
    AddFriendsViewController* add = [[AddFriendsViewController alloc]initWithNibName:@"AddFriendsViewController" bundle:nil];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)search:(id)sender
{
    SearchFriendViewController* search = [[SearchFriendViewController alloc]initWithNibName:@"SearchFriendViewController" bundle:nil];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)switchTableView:(int)tag
{
    if(tag == 1)
    {
        //全部
//        segementBackground.image = [UIImage imageNamed:@"friendTab1"];
//        dataType = 0;
        [self reloadData];
    }
//    else if(tag == 2)
//    {
//        //公司
//        segementBackground.image = [UIImage imageNamed:@"friendTab2"];
//        dataType = 1;
//        [companyList reloadData];
//    }
//    else if(tag == 3)
//    {
//        //职位
//        segementBackground.image = [UIImage imageNamed:@"friendTab3"];
//        dataType = 2;
//        [postList reloadData];
//    }
}
-(IBAction)switchButton:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    [UIView animateWithDuration:0.3 animations:^
    {
        [scrollView scrollToIndex:btn.tag-1];
    }];
}
-(IBAction)publishAction:(id)sender
{
    int tag = (int)[(UIButton*)sender tag];
    if(tag == 10)
    {
        //招聘人才
        PublishJobViewController *publishJobView = [[PublishJobViewController alloc] init];
        publishJobView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:publishJobView animated:YES];
    }
    else if (tag == 20)
    {
        //求内推
        InternalRecommendViewController *internalRecommend = [[InternalRecommendViewController alloc] init];
        internalRecommend.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:internalRecommend animated:YES];
    }
}
#pragma --mark MMPagingScrollViewDelegate
- (void) scrollView:(MMPagingScrollView *)scrollView willShowPageAtIndex:(NSInteger)index
{
    [self switchTableView:(int)index+1];
}
#pragma --mark UITableView
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectZero];
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == friendList)
    {
        if(section == 0)
        {
            return 0;
        }
        else if (section == 1)
        {
            return 0;
        }
        else if (section == 2)
        {
            return 10;
        }
        else
        {
            return 10;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == friendList)
    {
        if(indexPath.section == 1)
        {
            return 20;
        }
        return 70;
    }
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == friendList)
    {
        return [unKnowDataSource count]+2;
    }
//    else if (tableView == companyList)
//    {
//        return [companyDataSource count];
//    }
//    else if (tableView == postList)
//    {
//        return [postDataSource count];
//    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == friendList)
    {
        return [self buildCell1:tableView cellForRowAtIndexPath:indexPath];
    }
//    else if (tableView == companyList)
//    {
//        return [self buildCell2:tableView cellForRowAtIndexPath:indexPath];
//    }
//    else if (tableView == postList)
//    {
//        return [self buildCell3:tableView cellForRowAtIndexPath:indexPath];
//    }
    return nil;
}
-(UITableViewCell*)buildCell1:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString* Identifier = @"Header";
        CustomCellView* cell = (CustomCellView*)[tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        UIView* headView = (UIImageView*)[cell viewWithTag:100];
        if(headView == nil)
        {
            tableHeaderView.tag = 100;
            [cell.contentView addSubview:tableHeaderView];
        }
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString* Identifier = @"Section";
        CustomCellView* cell = (CustomCellView*)[tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        UIImageView* imageView = (UIImageView*)[cell viewWithTag:200];
        if(imageView == nil)
        {
            //可能认识的人.png
            imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mybeKnow"]];
            imageView.frame = CGRectMake(0, 0, 110, 20);
            [cell.contentView addSubview:imageView];
            imageView.tag = 200;
        }
        return cell;
    }
    else
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
        UserInfo* info = (UserInfo*)[unKnowDataSource objectAtIndex:indexPath.section-2];
        
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
        NSString* name = info.name;
        if(name != nil && [name length]>12)
        {
            name = [name substringToIndex:12];
            name = [NSString stringWithFormat:@"%@...",name];
        }
        [str appendFormat:@"<p><font color='#464646' face='FZLTZHK--GBK1-0' size=14>%@</font></p>",name];
        [str appendFormat:@"\n<p lineSpacing=5><font color='#999999' size=11>%@ %@</font></p>",info.company,info.job];
        [str appendFormat:@"\n<p lineSpacing=5><font color='#999999' size=11>%@</font></p>",info.descriptions];
        [descLabel setText:str];
        
        
        UILabel* degreeLabel = (UILabel*)[cell.contentView viewWithTag:3];
        float width = [UILabel calculateWidthWith:name
                                             font:getFontWith(YES, 14)
                                           height:25
                                   lineBreakeMode:NSLineBreakByCharWrapping];
        if(degreeLabel == nil)
        {
            degreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width + 80, 7, 36, 18)];
            degreeLabel.textColor = colorWithHex(0xAAAAAA);
            degreeLabel.layer.cornerRadius = 4;
            degreeLabel.layer.masksToBounds = YES;
            degreeLabel.font = [UIFont boldSystemFontOfSize:13];
            degreeLabel.textAlignment = NSTextAlignmentCenter;
            degreeLabel.backgroundColor = colorWithHex(0xE5E5E5);
            degreeLabel.shadowColor = [UIColor whiteColor];
            degreeLabel.shadowOffset = CGSizeMake(0, 1);
            [cell.contentView addSubview:degreeLabel];
            degreeLabel.tag = 3;
        }
        degreeLabel.frame = CGRectMake(width + 80, 7, 36, 18);
        [degreeLabel setText:[NSString stringWithFormat:@"%d度",info.friendType]];
        return cell;
    }
}
//-(UITableViewCell*)buildCell2:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString* Identifier = @"Cell2";
//    CustomMarginCellView* cell = (CustomMarginCellView*)[tableView dequeueReusableCellWithIdentifier:Identifier];
//    if(cell == nil)
//    {
//        cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
//        cellBackgroundView.backgroundColor = [UIColor whiteColor];
//        cell.backgroundView = cellBackgroundView;
//        
//        cell.textLabel.font = getFontWith(YES, 14);
//        cell.textLabel.textColor = [UIColor blackColor];
//        cell.detailTextLabel.font = getFontWith(NO, 13);
//    }
//    NSDictionary* dic = [companyDataSource objectAtIndex:indexPath.section];
//    cell.textLabel.text = [dic objectForKey:@"title"];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@人",[dic objectForKey:@"count"]];
//    [self customLine:cell height:44];
//    return cell;
//}
//-(UITableViewCell*)buildCell3:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString* Identifier = @"Cell3";
//    CustomMarginCellView* cell = (CustomMarginCellView*)[tableView dequeueReusableCellWithIdentifier:Identifier];
//    if(cell == nil)
//    {
//        cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
//        cellBackgroundView.backgroundColor = [UIColor whiteColor];
//        cell.backgroundView = cellBackgroundView;
//        
//        cell.textLabel.font = getFontWith(YES, 14);
//        cell.textLabel.textColor = [UIColor blackColor];
//        cell.detailTextLabel.font = getFontWith(NO, 13);
//    }
//    NSDictionary* dic = [postDataSource objectAtIndex:indexPath.section];
//    cell.textLabel.text = [dic objectForKey:@"title"];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@人",[dic objectForKey:@"count"]];
//    [self customLine:cell height:44];
//    return cell;
//}
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
    if(tableView == friendList)
    {
        if(indexPath.section == 0)
        {
            return;
        }
        UserInfo*info = (UserInfo*)[unKnowDataSource objectAtIndex:indexPath.section-2];
        self.hidesBottomBarWhenPushed = YES;
        [[LogicManager sharedInstance] gotoProfile:self userId:info.userId showBackButton:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
//    else if (tableView == companyList)
//    {
//        NSDictionary* dic = [companyDataSource objectAtIndex:indexPath.section];
//        FriendListViewController* list = [[FriendListViewController alloc]initWithNibName:@"FriendListViewController" bundle:nil];
//        list.dataType = 0;
//        list.name = [dic objectForKey:@"title"];
//        [self.navigationController pushViewController:list animated:YES];
//    }
//    else if (tableView == postList)
//    {
//        NSDictionary* dic = [postDataSource objectAtIndex:indexPath.section];
//        FriendListViewController* list = [[FriendListViewController alloc]initWithNibName:@"FriendListViewController" bundle:nil];
//        list.dataType = 1;
//        list.name = [dic objectForKey:@"title"];
//        [self.navigationController pushViewController:list animated:YES];
//    }
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scroll
{
	if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scroll];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scroll willDecelerate:(BOOL)decelerate
{
    if (_refreshFooterView && !_refreshFooterView.loading)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scroll];
    }
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if(_refreshFooterView)
    {
        [self loadMoreData];
    }
}
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
	if(_refreshFooterView != nil)
    {
        return _refreshFooterView.loading;
    }
	return NO;
}
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	return [NSDate date];
}
#pragma mark -
#pragma mark 刷新及加载数据
-(void)loadMoreTableViewDataFinished
{
    if(_refreshFooterView)
    {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (_refreshFooterView)
            {
                [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:friendList];
                _refreshFooterView.loading = NO;
            }
            [self reloadData];
        });
    }
}
@end
