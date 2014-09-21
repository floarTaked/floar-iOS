//
//  FriendCircleViewController.m
//  WeLinked4
//
//  Created by jonas on 5/14/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "FriendCircleViewController.h"
#import "PublishViewController.h"
#import "CustomTableViewCell.h"
#import "HaveContactorsTableViewCell.h"
#import "shareTableViewCell.h"
#import "AskTableViewCell.h"
#import "CircleMessageListViewController.h"
#import "DetailRateViewController.h"
#import "CellView.h"
#import "PullRefreshTableView.h"
#import "NetworkEngine.h"

#import "Common.h"
@interface FriendCircleViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,PullRefreshTableViewDelegate>
{
    CellView *cellView;
    NSMutableArray *dataArray;
}


@property (weak, nonatomic) IBOutlet PullRefreshTableView *circleTableView;


@end

@implementation FriendCircleViewController

@synthesize circleTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tabBarItem.image = [UIImage imageNamed:@"feeds"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"feedsSelected"];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        self.title = nil;
        
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
    self.view.userInteractionEnabled = YES;
    circleTableView.userInteractionEnabled = YES;
    dataArray = [[NSMutableArray alloc] init];
    cellView = [[CellView alloc] init];
    cellView.friendDelegate = self;
    [dataArray addObject:cellView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoDetailVotePage) name:@"changeView" object:nil];
    
    [self.navigationItem setTitleString:@"职脉圈"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"img_message_circle"] imageSelected:[UIImage imageNamed:@"img_message_circle"] title:nil inset:UIEdgeInsetsMake(0, -20, 0, 0) target:self selector:@selector(messageManager)];
    [self.navigationItem setRightBarButtonItem:[UIImage imageNamed:@"img_edit_n"] imageSelected:[UIImage imageNamed:@"img_edit_h"] title:nil inset:UIEdgeInsetsMake(0, 0, 0, -20) target:self selector:@selector(rightBarBtnAction)];
    
    
    circleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    circleTableView.pullingDelegate = self;
    
    [circleTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"custom"];
    [circleTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HaveContactorsTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"have"];
    [circleTableView registerNib:[UINib nibWithNibName:NSStringFromClass([shareTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"share"];
    [circleTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AskTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"ask"];
    
    circleTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据
-(void)loadFromNetWork
{
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"custom"];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1)
    {
        HaveContactorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"have"];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2)
    {
        shareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"share"];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 3)
    {
        AskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ask"];
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CellView *view = [dataArray objectAtIndex:0];
        view.userInteractionEnabled = YES;
        cell.contentView.userInteractionEnabled = YES;

        [cell.contentView addSubview:view];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 315;
    }
    if (indexPath.section == 1)
    {
        return 330;
    }
    if (indexPath.section == 2)
    {
        return 200;
    }
    if (indexPath.section == 3)
    {
        return 235;
    }
    else
    {
        return cellView.CustomCellViewHeight;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - PullRefreshDelegate
//底部上拉---获取更多feed
-(void)pullingTableViewDidStartLoading:(PullRefreshTableView *)tableView
{
    
}

//顶部下拉---获取最新feed
-(void)pullingTableViewDidStartRefreshing:(PullRefreshTableView *)tableView
{
    [[NetworkEngine sharedInstance] getFeedsWithTime:@"0" limit:10 block:^(int event, id object) {
        NSLog(@"%@",object);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [circleTableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [circleTableView tableViewDidEndDragging:scrollView];
}

#pragma mark - FriendCircledelegate
-(void)gotoDetailVotePage
{
    DetailRateViewController *detail = [[DetailRateViewController alloc] initWithNibName:NSStringFromClass([DetailRateViewController class]) bundle:nil];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)reloadTableView
{
    [circleTableView reloadData];
}

#pragma mark - UINavigatinBarButtonAction
-(void)rightBarBtnAction
{
    PublishViewController *publishCtl = [[PublishViewController alloc] initWithNibName:NSStringFromClass([PublishViewController class]) bundle:nil];
    publishCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishCtl animated:YES];
}

-(void)messageManager
{
    CircleMessageListViewController *messageList = [[CircleMessageListViewController alloc] initWithNibName:NSStringFromClass([CircleMessageListViewController class]) bundle:nil];
    messageList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageList animated:YES];
}
@end
