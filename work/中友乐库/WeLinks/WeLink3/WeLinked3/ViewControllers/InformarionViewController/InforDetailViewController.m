//
//  InforDetailViewController.m
//  WeLinked3
//
//  Created by Floar on 14-3-4.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "InforDetailViewController.h"

#import "InfoDetailCustomCell.h"
#import "PullRefreshTableView.h"
#import "ArticleBrowserViewController.h"
#import "InfoDetailDataManager.h"

#import "ACTimeScroller.h"
#import <MBProgressHUD.h>

#define StringFont 16


@interface InforDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,InfoDetailDataManagerDelegate,synchornLikeNumber,changeUICommentNum,UIScrollViewDelegate,ACTimeScrollerDelegate>
{
    __weak IBOutlet PullRefreshTableView *infoDetailTableView;
    
    NSInteger currentMaxDisplayedCell;
    NSInteger synchornLikeNumberIndex;
    
    ACTimeScroller *timerScroller;
    NSMutableArray *timeScrollerDateArray;
    
    //传递给ArticleBrowserTopImageView的背景颜色，无图片时候用
    UIColor *pastColor;
}

@property (nonatomic, strong) InfoDetailDataManager *dataManager;

@property (weak, nonatomic) IBOutlet UILabel *infoDetailLabel;

@property (weak, nonatomic) IBOutlet UIView *bottonView;



@end

@implementation InforDetailViewController

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
    
    
    self.wantsFullScreenLayout = YES;
    [self.navigationItem setTitleViewWithText:_infoDetailViewCtlTitle];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back)];
    
    //PullRefreshTableView
    infoDetailTableView.delegate = self;
    infoDetailTableView.dataSource = self;
    infoDetailTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    infoDetailTableView.pullingDelegate = self;
    infoDetailTableView.rowHeight = 160;
    infoDetailTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    infoDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [infoDetailTableView registerNib:[UINib nibWithNibName:@"InfoDetailCustomCell" bundle:nil] forCellReuseIdentifier:@"infoDetailCell"];
    [self.view addSubview:infoDetailTableView];
    
    timeScrollerDateArray = [[NSMutableArray alloc] init];
    
    timerScroller = [[ACTimeScroller alloc] initWithDelegate:self];
    
    //请求网络数据
    self.dataManager = [[InfoDetailDataManager alloc] init];
    self.dataManager.delegate = self;
    self.dataManager.infoDetailSubscribeItem = self.infoDetailSubscribeItem;
//    [self getDateForTimeScroller];
    [self.dataManager loadinfoDetailDataWithSubscribeItem:self.infoDetailSubscribeItem];
 
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#if 0
-(void)getBottonLableSize
{
    CGSize size;
    if (isSystemVersionIOS7()) {
        size = [_infoDetailViewCtlTitle boundingRectWithSize:CGSizeMake(280 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:StringFont],NSFontAttributeName, nil] context:nil].size;
    }else{
        size = [_infoDetailViewCtlTitle sizeWithFont:[UIFont systemFontOfSize:StringFont] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    self.infoDetailLabel.text = _infoDetailViewCtlTitle;
    self.infoDetailLabel.font = getFontWith(NO, StringFont);
    self.infoDetailLabel.frame = CGRectMake(290-size.width, (49-size.height)/2, size.width+20, size.height);
}
#endif

//给动画添加时间数组
-(void)getDateForTimeScroller
{
    for (Article *article in self.dataManager.infoDetailArray)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(article.publishTime)/1000];
        [timeScrollerDateArray addObject:date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日"];
        
//        NSString *timeStr = [dateFormatter stringFromDate:date];
    }
}

-(void)getTimeArray
{
    
}

- (IBAction)goback:(id)sender
{
    [self back];
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PullRefreshDelegate
//底部下拉刷新的时候调用---无菊花---获取更多的文章列表
-(void)pullingTableViewDidStartLoading:(PullRefreshTableView *)tableView
{
    Article *article = [self.dataManager.infoDetailArray lastObject];
    [self.dataManager loadMoreinfoDetailDataWithSubscribeItem:self.infoDetailSubscribeItem andLastArticleId:article.articleID];
    
//    [self.dataManager loadTimeLineMoreDayDataWithTimeSubscribeItem:self.infoDetailSubscribeItem andTime:[NSString stringWithFormat:@"%0.0f",article.publishTime]];
}

//顶部下拉刷新的时候调用---有菊花---更新文章
-(void)pullingTableViewDidStartRefreshing:(PullRefreshTableView *)tableView
{
    [self.dataManager.infoDetailArray removeAllObjects];
    [self.dataManager loadinfoDetailDataWithSubscribeItem:self.infoDetailSubscribeItem];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [infoDetailTableView tableViewDidScroll:scrollView];
    [timerScroller scrollViewDidScroll];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [infoDetailTableView tableViewDidEndDragging:scrollView];
}

#pragma mark - dataManagerDelegate

-(void)infoDetailDataManagerGetDataSuccess
{
    [infoDetailTableView reloadData];
    [infoDetailTableView tableViewDidFinishedLoading];
}

-(void)infoDetailDataManagerGetDataFailed
{
    [self HUDCustomAction:@"请检查网络状况"];
    [infoDetailTableView tableViewDidFinishedLoading];
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

#pragma mark - UITableViewDelegate

//-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataManager.infoDetailArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *colorArray = @[colorWithHex(0x0578B4),colorWithHex(0xCC9900),colorWithHex(0x0F9664),colorWithHex(0x8C1504),colorWithHex(0x1D3A50),colorWithHex(0x330000)];
    
    InfoDetailCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoDetailCell"];
    
    Article *article = [self.dataManager.infoDetailArray objectAtIndex:indexPath.row];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([InfoDetailCustomCell class]) owner:self options:nil] lastObject];
    }
    cell.article = article;
    pastColor = [colorArray objectAtIndex:indexPath.row % colorArray.count];
    cell.cellColor = pastColor;
    cell.changeCommentNumDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //统计阅读次数
    [MobClick event:ARTICLE2];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleBrowserViewController *browserViewCtl = [[ArticleBrowserViewController alloc] init];
    Article *article = [self.dataManager.infoDetailArray objectAtIndex:indexPath.row];
    synchornLikeNumberIndex = indexPath.row;
    browserViewCtl.synchornLikeNumdelegate = self;
    browserViewCtl.articleColor = pastColor;
    browserViewCtl.article = article;
    browserViewCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browserViewCtl animated:YES];
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
//    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 120, 20)];
//    img.image= [UIImage imageNamed:@"img_time_background"];
//    
//    UILabel *monthAndDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 60, 20)];
//    monthAndDayLabel.font = [UIFont systemFontOfSize:13];
//    monthAndDayLabel.textColor = [UIColor whiteColor];
//    
//    UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(monthAndDayLabel.frame), 5, 60, 20)];
//    weekLabel.textColor = [UIColor whiteColor];
//    weekLabel.font = [UIFont systemFontOfSize:13];
//    monthAndDayLabel.text = @"03月22日";
//    
//    
//    weekLabel.text = @"星期六";
//    
//    
//    [customView addSubview:img];
//    [customView addSubview:monthAndDayLabel];
//    [customView addSubview:weekLabel];
//    
//    return customView;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20;
//}


//添加文章cell第一次查看时候的动画，动画相关的值暂时就写死
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if ((indexPath.section == 0 && currentMaxDisplayedCell == 0) || indexPath.section > currentMaxDisplayedSection){ //first item in a new section, reset the max row count
    if (currentMaxDisplayedCell == 0)
    {
        currentMaxDisplayedCell = -1;
    }
//        currentMaxDisplayedCell = -1; //-1 because the check for currentMaxDisplayedCell has to be > rather than >= (otherwise the last cell is ALWAYS animated), so we need to set this to -1 otherwise the first cell in a section is never animated.
//    }
    
    if (indexPath.row > currentMaxDisplayedCell){ //this check makes cells only animate the first time you view them (as you're scrolling down) and stops them re-animating as you scroll back up, or scroll past them for a second time.
        
        //now make the image view a bit bigger, so we can do a zoomout effect when it becomes visible
//        cell.contentView.alpha = self.cellZoomInitialAlpha.floatValue;
        cell.contentView.alpha = 0.3;
        
//        CGAffineTransform transformScale = CGAffineTransformMakeScale(self.cellZoomXScaleFactor.floatValue, self.cellZoomYScaleFactor.floatValue);
//        CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(self.cellZoomXOffset.floatValue, self.cellZoomYOffset.floatValue);
        CGAffineTransform transformScale = CGAffineTransformMakeScale(1.25, 1.25);
        CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(0, 0);
        
        cell.contentView.transform = CGAffineTransformConcat(transformScale, transformTranslate);
        
        [tableView bringSubviewToFront:cell.contentView];
        [UIView animateWithDuration:0.7 animations:^{
            cell.contentView.alpha = 1;
            //clear the transform
            cell.contentView.transform = CGAffineTransformIdentity;
        } completion:nil];
        
        
        currentMaxDisplayedCell = indexPath.row;
//        currentMaxDisplayedSection = indexPath.section;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - synchornLikeNumberDelegate
-(void)synchornUIWihtLikeNumber:(NSString *)likeNumber
{
//    Article *articel = [self.dataManager.infoDetailArray objectAtIndex:synchornLikeNumberIndex];
//    articel.articleID = likeNumber;
    
    [infoDetailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:synchornLikeNumberIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - CommentListViewCtlChangeOwnViewCommentNumRefreshUI
-(void)changeCommentNum
{
    [infoDetailTableView reloadData];
}

#pragma mark - ACTimeScrollerDelegate Methods

- (UITableView *)tableViewForTimeScroller:(ACTimeScroller *)timeScroller
{
    return infoDetailTableView;
}

- (NSDate *)timeScroller:(ACTimeScroller *)timeScroller dateForCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [infoDetailTableView indexPathForCell:cell];
    [self getDateForTimeScroller];
    return [timeScrollerDateArray objectAtIndex:indexPath.row % timeScrollerDateArray.count];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [timerScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [timerScroller scrollViewDidEndDecelerating];
}



@end
