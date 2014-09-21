//
//  DetailRateViewController.m
//  WeLinked4
//
//  Created by floar on 14-5-28.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "DetailRateViewController.h"
#import "MMPagingScrollView.h"

@interface DetailRateViewController ()<UITableViewDataSource,UITableViewDelegate,MMPagingScrollViewDelegate>
{
    MMPagingScrollView *mmpScrollView;
    
    NSMutableArray* onceCircleArray;
    NSMutableArray* twiceCircleArray;
    NSMutableArray* thirdCircleArray;
    
    int dataType;
}

@property (strong, nonatomic) IBOutlet UITableView *OnceCircleTableView;

@property (strong, nonatomic) IBOutlet UITableView *twiceCircleTableView;

@property (strong, nonatomic) IBOutlet UITableView *thirdCircleTableView;

@property (weak, nonatomic) IBOutlet UIImageView *segmentBackground;

@property (strong, nonatomic) IBOutlet UIView *segmentView;


@end

@implementation DetailRateViewController

@synthesize OnceCircleTableView,thirdCircleTableView,twiceCircleTableView,segmentBackground,segmentView;

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
    [self.navigationItem setTitleString:@"投票详情"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"] imageSelected:[UIImage imageNamed:@"backSelected"] title:nil inset:UIEdgeInsetsMake(0, -20, 0, 0) target:self selector:@selector(gotoBack)];
    
    CGRect frame = segmentView.frame;
    frame.origin.y = 55;
    segmentView.frame = frame;
    dataType = 0;

    
    mmpScrollView = [[MMPagingScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height-44)];
    mmpScrollView.viewList = [NSMutableArray arrayWithObjects:OnceCircleTableView,twiceCircleTableView,thirdCircleTableView, nil];
    mmpScrollView.scrollingDelegate = self;
    mmpScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleHeight;
    mmpScrollView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0f];
    [self.view addSubview:mmpScrollView];
    
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    OnceCircleTableView.tableHeaderView = headerView;
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    twiceCircleTableView.tableHeaderView = headerView;
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    thirdCircleTableView.tableHeaderView = headerView;


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.view addSubview:segmentView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [segmentView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == OnceCircleTableView)
    {
        return 2;
    }
    else if (tableView == twiceCircleTableView)
    {
        return 5;
    }
    else
    {
        return 4;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == OnceCircleTableView)
    {
        if (section == 0)
        {
            return 1;
        }
        else
        {
            return 3;
        }
    }
    else if (tableView == twiceCircleTableView)
    {
        if (section == 0)
        {
            return 1;
        }
        else
        {
            return 3;
        }
    }
    else
    {
        if (section == 0)
        {
            return 1;
        }
        else
        {
            return 3;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma --mark MMPagingScrollViewDelegate
- (void) scrollView:(MMPagingScrollView *)scrollView willShowPageAtIndex:(NSInteger)index
{
    [self switchTableView:(int)index];
}


#pragma mark - Actions

- (IBAction)segmentBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [UIView animateWithDuration:0.3 animations:^{
        [mmpScrollView scrollToIndex:btn.tag-10];
    }];
}

-(void)gotoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)switchTableView:(int)tag
{
    if(tag == 0)
    {
        //一度
        segmentBackground.image = [UIImage imageNamed:@"img_segment1"];
    }
    else if(tag == 1)
    {
        //二度
        segmentBackground.image = [UIImage imageNamed:@"img_segment2"];
    }
    else if(tag == 2)
    {
        //三度
        segmentBackground.image = [UIImage imageNamed:@"img_segment3"];
    }
    dataType = tag;
    [self switchDataSource];
}

-(void)switchDataSource
{
    if(dataType == 0)
    {
        
    }
    else if (dataType == 1)
    {
        
    }
    else if (dataType == 2)
    {
        
    }
}

@end
