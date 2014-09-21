//
//  ThirdViewController.m
//  KitMoreTest
//
//  Created by floar on 14-6-12.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "ThirdViewController.h"
#import <SVPullToRefresh.h>
#import <SRRefreshView.h>

@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>

@property (weak, nonatomic) IBOutlet UITableView *thirdTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SRRefreshView *slimeRefresh;

@end

@implementation ThirdViewController

@synthesize thirdTableView,dataArray,slimeRefresh;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBarItem setImage:[[UIImage imageNamed:@"scanCard"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"scanCardSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    
    [self loadData];
    self.view.frame = [UIScreen mainScreen].bounds;
    
//    [self initSRlimeView];
    [self addSVPullHeader];
    [self addSVPullFooter];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [thirdTableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDate *date = [dataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];

//    UIView* separatorLineView = [cell.contentView viewWithTag:10];
//    if (separatorLineView == nil)
//    {
//        separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0,69, 320, 1)];
//        separatorLineView.tag = 10;
//        separatorLineView.backgroundColor = [UIColor grayColor];
//        [cell.contentView addSubview:separatorLineView];
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - slimeRefreshDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [slimeRefresh scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [slimeRefresh scrollViewDidEndDraging];
}

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [dataArray insertObject:[NSDate date] atIndex:0];
        [thirdTableView reloadData];
        [slimeRefresh endRefresh];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
}

#pragma mark - Actions
-(void)initSRlimeView
{
    slimeRefresh = [[SRRefreshView alloc] init];
    slimeRefresh.delegate = self;
    slimeRefresh.upInset = 0;
    slimeRefresh.slimeMissWhenGoingBack = YES;
    slimeRefresh.slime.bodyColor = [UIColor blackColor];
    slimeRefresh.slime.skinColor = [UIColor whiteColor];
    slimeRefresh.slime.lineWith = 1;
    slimeRefresh.slime.shadowBlur = 4;
    //    slimeRefresh.showSuccessLable = YES;
    slimeRefresh.slime.shadowColor = [UIColor blackColor];
    [thirdTableView addSubview:slimeRefresh];
}

-(void)addSVPullHeader
{
    [thirdTableView addPullToRefreshWithActionHandler:^{
        [self refreshTopPullData];
    }];
    
}

-(void)addSVPullFooter
{
    [thirdTableView addInfiniteScrollingWithActionHandler:^{
        [self refreshBottomPullData];
    }];
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    label.text = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    label.text = @"Loading...";
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    
    [thirdTableView.infiniteScrollingView setCustomView:label forState:SVInfiniteScrollingStateLoading];
}

-(void)loadData
{
    for (int i = 0; i < 2; i++)
    {
        [dataArray addObject:[NSDate dateWithTimeIntervalSinceNow:-i*60]];
    }
}

-(void)refreshTopPullData
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [dataArray insertObject:[NSDate date] atIndex:0];
        [thirdTableView reloadData];
        [thirdTableView.pullToRefreshView stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
}

-(void)refreshBottomPullData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [dataArray addObject:[NSDate date]];
        [thirdTableView reloadData];
        [thirdTableView.infiniteScrollingView stopAnimating];
    });
}


@end
