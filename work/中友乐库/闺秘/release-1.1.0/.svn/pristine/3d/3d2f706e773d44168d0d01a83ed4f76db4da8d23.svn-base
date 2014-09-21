//
//  MainViewController.m
//  闺秘
//
//  Created by jonas on 6/23/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "MainViewController.h"
#import "DetailSecretViewController.h"
#import "PublishSecretViewController.h"
#import "MessageViewController.h"
#import "LogicManager.h"
#import "DataBaseManager.h"
#import "AppDelegate.h"

#import "MainViewCell.h"
#import "TipCountView.h"
#import "UpdateNumView.h"
#import "FriendNumsTableViewCell.h"
#import "QuestionFeedTableViewCell.h"
#import "PhoneBookTableViewCell.h"

#import "Feed.h"
#import "ExtraButton.h"
#import "ShareBlurView.h"
#import <UIImage+Screenshot.h>
#import <UIImage+Blur.h>
#import <MessageUI/MessageUI.h>
#import <SVPullToRefresh.h>
#import <AFNetworking.h>

#import "Package.h"
#import "UserInfo.h"
#import "Feed.h"
#import "NetWorkEngine.h"
#import "TipCountView.h"
#import "Notice.h"
static const double lastTowDays = 60*60*24*3;
static NSString *const reuseIdentifyStr = @"mainCell";
static NSString *const questionCellIdentify = @"questionCell";
static NSString *const friendNumIdentify = @"friendNumCell";
static NSString *const PhoneBookIdentify = @"phoneBookCell";
static NSString *const experienceFeeds = @"EXPERIENCEFEEDS";

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
{
    BOOL isSelected;
    
    int friendNum;
    
    MFMessageComposeViewController *messageCtl;
    UITapGestureRecognizer *tapRefreshData;
    
    UIImageView *gifImgView;
    UpdateNumView *updateNumView;
}

@property (strong, nonatomic) IBOutlet UITableView *feedTableView;
@property (nonatomic, strong) NSMutableArray *feedDataArray;
@property (nonatomic, strong) NSMutableArray *QuestionFeedsArray;

@end

@implementation MainViewController

@synthesize feedTableView,feedDataArray,QuestionFeedsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)notice:(NSNotification*)noti
{
    NSString* sql = [NSString stringWithFormat:@" where DBUid = %llu",[UserInfo myselfInstance].userId];
    NSArray* array = [[UserDataBaseManager sharedInstance] queryWithClass:[Notice class] tableName:nil condition:sql];
    if(array != nil)
    {
        [tipCountView setTipCount:[array count]];
    }
    else
    {
        [tipCountView setTipCount:0];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"NoticeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainServerSuccess) name:connectServerSuccess object:nil];
    
    [self.navigationItem setTitleString:@"闺秘"];
    
    if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
    {
        [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_close_n"]
                                    imageSelected:[UIImage imageNamed:@"btn_close_h"]
                                            title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15)
                                           target:self
                                         selector:@selector(justExperienctBack)];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navCollection_n"]
                                    imageSelected:[UIImage imageNamed:@"btn_navCollection_h"]
                                            title:nil
                                            inset:UIEdgeInsetsMake(0, -15, 0, 15)
                                           target:self
                                         selector:@selector(leftBarBtnAction)];
        
        [self.navigationItem setRightBarButtonItem:[UIImage imageNamed:@"btn_navWriteSecret_n"]
                                     imageSelected:[UIImage imageNamed:@"btn_navWriteSecret_h"]
                                             title:nil inset:UIEdgeInsetsMake(0, 15, 0, -15)
                                            target:self
                                          selector:@selector(rightBarBtnAction)];
    }
    
    
    tipCountView = [[TipCountView alloc]init];
    tipCountView.frame = CGRectMake(38, 32, tipCountView.frame.size.width, tipCountView.frame.size.height);
    [self.navigationController.view addSubview:tipCountView];
    
    
    feedTableView.separatorInset = UIEdgeInsetsZero;
    
//    feedTableView.decelerationRate = 0.9;
    feedDataArray = [[NSMutableArray alloc] init];
    QuestionFeedsArray = [[NSMutableArray alloc] init];
    
    //下拉刷新
    __weak MainViewController *weakSelf = self;
    __weak UITableView *weakTableView = feedTableView;
    [feedTableView addPullToRefreshWithActionHandler:^{
        if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
        {
            [weakSelf sendPackForFeedsDataFromNetWork];
        }
        else
        {
            [weakSelf sendPackForFeedsDataFromNetWork];
            [weakSelf sendPackForGuestQuestionDataFromNetWork];
            [weakSelf sendPackForFriendNum];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakTableView.pullToRefreshView stopAnimating];
        });
    }];
    
    [feedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionFeedTableViewCell class]) bundle:nil] forCellReuseIdentifier:questionCellIdentify];
    [feedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FriendNumsTableViewCell class]) bundle:nil] forCellReuseIdentifier:friendNumIdentify];
    [feedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PhoneBookTableViewCell class]) bundle:nil] forCellReuseIdentifier:PhoneBookIdentify];
    
    //页面默认加载数据库数据
    [self fetchFeedsDataFromDB];
    [self fetchQuestionFeedsFromDB];
    [self updatePhoneBookByRule];
    
    //上传推送APNs的Token
    [self updateAPNsToken];
    [self linkAPNsToken];
    
    //更新了多少条秘密tips
    updateNumView = [[UpdateNumView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    [self.view addSubview:updateNumView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    //下拉刷新数据加载策略：第一次主动加载网络数据，以后都需要用户下拉刷新才加载网络数据
    uint64_t userID = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID];
    
    if (0 == userID)
    {
        //预览情况：只需要加载feeds内容，不需要加载QuestionFeeds内容，因为预览情况下只显示feeds内容
        int expI = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"expfirstIn"];
        if (0 == expI)
        {
            [self sendPackForFeedsDataFromNetWork];
            
            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"expfirstIn"];
        }
        else
        {
            [self fetchFeedsDataFromDB];
        }
    }
    else
    {
        //非预览，正常情况
        int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"firstInMainView"];
        if (0 == i)
        {
            [self sendPackForFeedsDataFromNetWork];
            [self sendPackForGuestQuestionDataFromNetWork];
            [self sendPackForFriendNum];
            
            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"firstInMainView"];
            
            //记录第一次进入应用时间，用于上传通讯录机制，一个星期上传一次
            NSTimeInterval earlyOneWeek = [[NSDate date] timeIntervalSince1970];
            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithDouble:earlyOneWeek] withKey:UpdatePhoneBookTime];
        }
        {
            [self fetchFeedsDataFromDB];
            [self fetchQuestionFeedsFromDB];
            [self sendPackForFriendNum];
            [self notice:nil];
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    tipCountView.hidden = YES;
}

#pragma mark - 数据库获取数据
-(void)fetchFeedsDataFromDB
{
    [feedDataArray removeAllObjects];
    
    NSArray *array = nil;
    NSString *conditionStr = nil;
    
    if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
    {
        conditionStr = [NSString stringWithFormat:@" where DBUid = '%llu' order by createTime desc",[UserInfo myselfInstance].DBUid];
        array = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class] tableName:experienceFeeds condition:conditionStr];
    }
    else
    {
        conditionStr = [NSString stringWithFormat:@" where DBUid = '%llu' order by createTime desc",[UserInfo myselfInstance].userId];
        array = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class] tableName:nil condition:conditionStr];
    }
    
    if (array.count > 0 && array != nil)
    {
        [feedDataArray addObjectsFromArray:array];
    }
    
    [feedTableView reloadData];
}

-(void)fetchQuestionFeedsFromDB
{
    [QuestionFeedsArray removeAllObjects];
    NSString *conditionStr = [NSString stringWithFormat:@" where DBUid = '%llu'",[UserInfo myselfInstance].userId];
    NSArray *array = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class] tableName:@"QUESTIONFEED" condition:conditionStr];
    if (array.count > 0 && array != nil)
    {
        [QuestionFeedsArray addObjectsFromArray:array];
    }
}

#pragma mark - 获取网络数据
-(void)sendPackForFeedsDataFromNetWork
{
    uint32_t time = 0;
    uint64_t messageEndId = 0;
    uint32_t fetchNum = 0;
    
    uint64_t changeUserId = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID];
    if (0 == changeUserId)
    {
        //体验
        int flag = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:ExpFirstLogin];
        if (0 == flag)
        {
            NSDate *date = [NSDate date];
            time = [date timeIntervalSince1970] - lastTowDays;
            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:ExpFirstLogin];
            time = 0;
            
        }
        else
        {
            time = 0;
        }
        fetchNum = 30;
    }
    else
    {
        //非体验
        int flag = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:FirstLogin];
        if (0 == flag)
        {
            NSDate *date = [NSDate date];
            time = [date timeIntervalSince1970] - lastTowDays;
            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:FirstLogin];
        }
        else
        {
            time = 0;
        }
        fetchNum = 10;
    }
    messageEndId = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:[NSString stringWithFormat:@"%@%llu",FeedLastMessageId,changeUserId]];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[NetWorkEngine shareInstance] lastedFeedsWith:time messageId:messageEndId limitNum:fetchNum block:^(int event, id object)
    {
        if (1 == event)
        {
            //            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            //增加下拉加载gif动画时间，如果不加动画效果很快消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [feedTableView.pullToRefreshView stopAnimating];
            });
            
            Package *returnPack = (Package *)object;
            uint32_t procotal = [returnPack getProtocalId];
            if (0x03 == procotal)
            {
                [returnPack reset];
                uint32_t result = [returnPack readInt32];
                if (0 == result)
                {
                    uint64_t endMessageId = [returnPack readInt64];
                    
                    //根据不同用户来保存不同的endId，包括预览状态（userId = 0）
                    [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithUnsignedLongLong:endMessageId] withKey:[NSString stringWithFormat:@"%@%llu",FeedLastMessageId,changeUserId]];
                    
                    uint32_t num = [returnPack readInt32];
                    
                    int updateNum = 0;
                    DLog(@"length:%d endMessageId:%llu",num,endMessageId);
                    for (int i = 0;i < num; i++)
                    {
                        Feed *feed = [[Feed alloc] init];
                        feed.feedId = [returnPack readInt64];
                        
                        NSString *conditionStr = [NSString stringWithFormat:@" where feedId = '%llu' and DBUid = %llu",feed.feedId,changeUserId];

                        NSArray *array = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class] tableName:nil condition:conditionStr];
                        if (array.count == 0)
                        {
                            updateNum++;
                        }
                        
                        feed.contentJson = [returnPack readString];
                        feed.likeNum = [returnPack readInt32];
                        feed.isOwnZanFeed = [returnPack readInt32];
                        feed.commentNum = [returnPack readInt32];
                        feed.addressStr = [returnPack readString];
                        feed.createTime = [[NSDate date] timeIntervalSince1970];
                        NSString *contentJson = feed.contentJson;
                        
                        if (contentJson != nil && contentJson.length > 0)
                        {
                            NSDictionary *dict = [[LogicManager sharedInstance] jsonStringToObject:contentJson];
                            feed.contentStr = [dict objectForKey:@"content"];
                            NSString *netImageStr = [dict objectForKey:@"img"];
                            NSRange range = [netImageStr rangeOfString:@"http"];
                            if (range.location == NSNotFound)
                            {
                                NSArray *arr = [netImageStr componentsSeparatedByString:@":"];
                                /*
                                 1,arr肯定是>0，如果不能separate，返回原来字符串，因此不用判断返回的数组是否为空或者>0
                                 2,判断是否和原来的字符串相等
                                 */
                                int imgNum = [[arr lastObject] intValue];
                                if (imgNum >= 12)
                                {
                                    imgNum = arc4random()%12;
                                }
                                feed.imageStr = [NSString stringWithFormat:@"img_secretCell_background_%d",imgNum];
                            }
                            else
                            {
                                feed.imageStr = netImageStr;
                            }
                        }
                        
                        if (0 == changeUserId)
                        {
                            [feed synchronize:experienceFeeds];
                        }
                        else
                        {
                           [feed synchronize:nil];
                        }
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        updateNumView.updateNum = updateNum;
                    });

                    [self fetchFeedsDataFromDB];
                }
                else if (-3 == result)
                {
                    [[LogicManager sharedInstance] makeUserReLoginAuto];
                }
            }
            
        }

    }];
}

-(void)sendPackForGuestQuestionDataFromNetWork
{
    uint32_t time = 0;
    uint64_t messageEndId = 0;
    uint64_t userId = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID];
    
    int flag = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:QuestionFeedsFirst];
    if (0 == flag)
    {
        NSDate *date = [NSDate date];
        time = [date timeIntervalSince1970] - lastTowDays;
        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:QuestionFeedsFirst];
    }
    else
    {
        time = 0;
    }
    messageEndId = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:[NSString stringWithFormat:@"%@%llu",QuestionFeedLastMessageId,userId]];
    
    [[NetWorkEngine shareInstance] fetchGuideQuestionWithWith:time preMessageId:messageEndId limitsNum:5 block:^(int event, id object)
    {
        if (1 == event)
        {
            [feedTableView.pullToRefreshView stopAnimating];
            Package *returnPack =(Package *)object;
            
            if (0x0f == [returnPack getProtocalId])
            {
                [returnPack reset];
                uint32_t result = [returnPack readInt32];
                if (0 == result)
                {
                    uint64_t preMessageId = [returnPack readInt64];
                    
                    //根据不同用户来保存不同的endId，包括预览状态（userId = 0）
                    [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithUnsignedLongLong:preMessageId] withKey:[NSString stringWithFormat:@"%@%llu",QuestionFeedLastMessageId,userId]];
                    
                    uint32_t num = [returnPack readInt32];
                    for (int i = 0; i < num; i++)
                    {
                        Feed *feed = [[Feed alloc] init];
                        feed.feedId = [returnPack readInt64];
                        NSString *content = [returnPack readString];
                        if (content != nil && content.length > 0)
                        {
                            NSDictionary *dict = [[LogicManager sharedInstance] jsonStringToObject:content];
                            feed.contentStr = [dict objectForKey:@"content"];
                            NSString *netImageStr = [dict objectForKey:@"img"];
                            NSRange range = [netImageStr rangeOfString:@"http"];
                            if (range.location == NSNotFound)
                            {
                                NSArray *arr = [netImageStr componentsSeparatedByString:@":"];
                                int imgNum = [[arr lastObject] intValue];
                                if (imgNum >= 12)
                                {
                                    imgNum = arc4random() % 12;
                                }
                                feed.imageStr = [NSString stringWithFormat:@"img_secretCell_background_%d",imgNum];
                            }
                            else
                            {
                                feed.imageStr = netImageStr;
                            }
                        }
                        
                        [feed synchronize:@"QUESTIONFEED"];
                    }
                }
                else if (-3 == result)
                {
                    [[LogicManager sharedInstance] makeUserReLoginAuto];
                }

            }
        }
    }];
}

-(void)sendPackForFriendNum
{
    [[NetWorkEngine shareInstance] fetchNumberOfFriendsWith:^(int event, id object)
     {
         if (1 == event)
         {
             Package *pack = (Package *)object;
             if (0x0d == [pack getProtocalId])
             {
                 [pack reset];
                 uint32_t result = [pack readInt32];
                 if (0 == result)
                 {
                     friendNum = [pack readInt32];
                     if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"FriendNumFirst"])
                     {
                         if (friendNum != 0)
                         {
                             [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:friendNum] withKey:@"FriendNumFirst"];
                             [feedTableView reloadData];
                         }
                     }
                     [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithUnsignedLongLong:friendNum] withKey:@"friendNum"];
                 }
                 else if (-3 == result)
                 {
                     [[LogicManager sharedInstance] makeUserReLoginAuto];
                 }
             }
             
         }
     }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"memoryWarning:%@",NSStringFromClass([self class]));
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    uint64_t changeUserId = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID];
    if (0 == changeUserId)
    {
        return self.feedDataArray.count;
    }
    else
    {
        int phoneIdentifyNum = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:PhoneBook];
        if (2 == phoneIdentifyNum)
        {
            return feedDataArray.count + 3;
        }
        else
        {
            return feedDataArray.count+2;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    uint64_t changeUserId = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID];
    if (0 == changeUserId)
    {
        Feed *feed = nil;
        feed = [feedDataArray objectAtIndex:indexPath.section];
        MainViewCell *cell = [self feedCell:tableView WithFeed:feed withIndex:indexPath];
        return cell;
    }
    else
    {
        int phoneIdentifyNum = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:PhoneBook];
        if (feedDataArray != nil && feedDataArray.count == 0)
        {
            if (phoneIdentifyNum == 2)
            {
                if (indexPath.section == 0)
                {
                    QuestionFeedTableViewCell *questionCell = [self questionCell:tableView];
                    return questionCell;
                }
                else if (indexPath.section == 1)
                {
                    FriendNumsTableViewCell *friendNumCell = [self friendNumCell:tableView];
                    return friendNumCell;
                }
                else
                {
                    PhoneBookTableViewCell *phoneBookCell = [self phoneBookCell:tableView];
                    return phoneBookCell;
                }
            }
            else
            {
                if (indexPath.section == 0)
                {
                    QuestionFeedTableViewCell *questionCell = [self questionCell:tableView];
                    return questionCell;
                }
                else
                {
                    FriendNumsTableViewCell *friendNumCell = [self friendNumCell:tableView];
                    return friendNumCell;
                }
            }
        }
        else if (self.feedDataArray.count <= 3)
        {
            Feed *feed = nil;
            if (2 == phoneIdentifyNum)
            {
                if (indexPath.section < self.feedDataArray.count)
                {
                    feed = [self.feedDataArray objectAtIndex:indexPath.section];
                    MainViewCell *cell = [self feedCell:tableView WithFeed:feed withIndex:indexPath];
                    return cell;
                }
                else if (indexPath.section == self.feedDataArray.count)
                {
                    QuestionFeedTableViewCell *cell = [self questionCell:tableView];
                    return cell;
                }
                else if (indexPath.section == self.feedDataArray.count+1)
                {
                    FriendNumsTableViewCell *cell = [self friendNumCell:tableView];
                    return cell;
                }
                else
                {
                    PhoneBookTableViewCell *cell = [self phoneBookCell:tableView];
                    return cell;
                }
            }
            else
            {
                if (indexPath.section < self.feedDataArray.count)
                {
                    feed = [self.feedDataArray objectAtIndex:indexPath.section];
                    MainViewCell *cell = [self feedCell:tableView WithFeed:feed withIndex:indexPath];
                    return cell;
                }
                else if (indexPath.section == self.feedDataArray.count)
                {
                    QuestionFeedTableViewCell *cell = [self questionCell:tableView];
                    return cell;
                }
                else
                {
                    FriendNumsTableViewCell *cell = [self friendNumCell:tableView];
                    return cell;
                }
            }
        }
        else if (self.feedDataArray.count > 3 && self.feedDataArray.count <= 6)
        {
            if (phoneIdentifyNum == 2)
            {
                
                if (indexPath.section == 3)
                {
                    QuestionFeedTableViewCell *questionCell = [self questionCell:tableView];
                    return questionCell;
                }
                else if (indexPath.section == self.feedDataArray.count + 1)
                {
                    FriendNumsTableViewCell *friendNumCell = [self friendNumCell:tableView];
                    return friendNumCell;
                }
                else if (indexPath.section == feedDataArray.count+2)
                {
                    PhoneBookTableViewCell *phoneBookCell = [self phoneBookCell:tableView];
                    return phoneBookCell;
                }
                else
                {
                    Feed *feed = nil;
                    if (indexPath.section <= 2)
                    {
                        feed = [self.feedDataArray objectAtIndex:indexPath.section];
                    }
                    else if (indexPath.section > 3 && indexPath.section < self.feedDataArray.count + 1)
                    {
                        feed = [self.feedDataArray objectAtIndex:indexPath.section - 1];
                    }
                    MainViewCell *cell = [self feedCell:tableView WithFeed:feed withIndex:indexPath];
                    if (indexPath.section == 5)
                    {
                        [self showCellShare:cell];
                    }
                    else
                    {
                        ShareBlurView *shareBlurView = (ShareBlurView *)[cell.contentView viewWithTag:10];
                        if (shareBlurView != nil)
                        {
                            [shareBlurView removeFromSuperview];
                        }
                    }
                    return cell;
                }
            
            }
            else
            {
                if (indexPath.section == 3)
                {
                    QuestionFeedTableViewCell *questionCell = [self questionCell:tableView];
                    return questionCell;
                }
                else if (indexPath.section == self.feedDataArray.count + 1)
                {
                    FriendNumsTableViewCell *friendNumCell = [self friendNumCell:tableView];
                    return friendNumCell;
                }
                else
                {
                    Feed *feed = nil;
                    if (indexPath.section <= 2)
                    {
                        feed = [self.feedDataArray objectAtIndex:indexPath.section];
                    }
                    else if (indexPath.section > 3 && indexPath.section < self.feedDataArray.count + 1)
                    {
                        feed = [self.feedDataArray objectAtIndex:indexPath.section - 1];
                    }
                    
                    MainViewCell *cell = [self feedCell:tableView WithFeed:feed withIndex:indexPath];
                    if (indexPath.section == 5)
                    {
                        [self showCellShare:cell];
                    }
                    return cell;
                    
                }
            }
        }
        else
        {
            if (phoneIdentifyNum == 2)
            {
                
                if (indexPath.section == 3)
                {
                    QuestionFeedTableViewCell *questionCell = [self questionCell:tableView];
                    return questionCell;
                }
                else if (indexPath.section == 7)
                {
                    FriendNumsTableViewCell *friendNumCell = [self friendNumCell:tableView];
                    return friendNumCell;
                }
                else if (indexPath.section == feedDataArray.count+2)
                {
                    PhoneBookTableViewCell *phoneBookCell = [self phoneBookCell:tableView];
                    return phoneBookCell;
                }
                else
                {
                    Feed *feed = nil;
                    if (indexPath.section <= 2)
                    {
                        feed = [self.feedDataArray objectAtIndex:indexPath.section];
                    }
                    else if (indexPath.section > 3 && indexPath.section < 7)
                    {
                        feed = [self.feedDataArray objectAtIndex:indexPath.section - 1];
                    }
                    else if (indexPath.section >= 8)
                    {
                        feed = [self.feedDataArray objectAtIndex:indexPath.section - 2];
                    }
                    MainViewCell *cell = [self feedCell:tableView WithFeed:feed withIndex:indexPath];
                    if (indexPath.section == 5)
                    {
                        [self showCellShare:cell];
                    }
                    else
                    {
                        ShareBlurView *shareBlurView = (ShareBlurView *)[cell.contentView viewWithTag:10];
                        if (shareBlurView != nil)
                        {
                            [shareBlurView removeFromSuperview];
                        }
                    }
                    if (indexPath.section == 6)
                    {
                        [self showCellLike:cell];
                    }
                    else
                    {
                        ShareBlurView *shareBlurView = (ShareBlurView *)[cell.contentView viewWithTag:20];
                        if (shareBlurView != nil)
                        {
                            [shareBlurView removeFromSuperview];
                        }
                    }
                    if (self.feedDataArray.count >=7 && self.feedDataArray.count <=8)
                    {
                        if (indexPath.section == 9)
                        {
                            [self showCellCommitAddress:cell withIdentifyStr:feed.addressStr];
                        }
                        else
                        {
                            ShareBlurView *shareBlurView = (ShareBlurView *)[cell.contentView viewWithTag:30];
                            if (shareBlurView != nil)
                            {
                                [shareBlurView removeFromSuperview];
                            }

                        }
                        if (indexPath.section == 10)
                        {
                            [self showCellCommitFriend:cell withIdentifyStr:feed.addressStr];
                        }
                        else
                        {
                            ShareBlurView *shareBlurView = (ShareBlurView *)[cell.contentView viewWithTag:40];
                            if (shareBlurView != nil)
                            {
                                [shareBlurView removeFromSuperview];
                            }

                        }
                    }
                    return cell;
                }
                
            }
            else
            {
                if (indexPath.section == 3)
                {
                    QuestionFeedTableViewCell *questionCell = [self questionCell:tableView];
                    return questionCell;
                }
                else if (indexPath.section == 7)
                {
                    FriendNumsTableViewCell *friendNumCell = [self friendNumCell:tableView];
                    return friendNumCell;
                }
                else
                {
                    Feed *feed = nil;
                    if (indexPath.section <= 2)
                    {
                        feed = [self.feedDataArray objectAtIndex:indexPath.section];
                    }
                    else if (indexPath.section > 3 && indexPath.section < 7)
                    {
                        feed = [self.feedDataArray objectAtIndex:indexPath.section - 1];
                    }
                    else if (indexPath.section >= 8)
                    {
                        feed = [self.feedDataArray objectAtIndex:indexPath.section - 2];
                    }
                    MainViewCell *cell = [self feedCell:tableView WithFeed:feed withIndex:indexPath];
                    if (indexPath.section == 5)
                    {
                        [self showCellShare:cell];
                    }
                    else
                    {
                        ShareBlurView *shareBlurView = (ShareBlurView *)[cell.contentView viewWithTag:10];
                        if (shareBlurView != nil)
                        {
                            [shareBlurView removeFromSuperview];
                        }
                    }
                    if (indexPath.section == 6)
                    {
                        [self showCellLike:cell];
                    }
                    else
                    {
                        ShareBlurView *shareBlurView = (ShareBlurView *)[cell.contentView viewWithTag:20];
                        if (shareBlurView != nil)
                        {
                            [shareBlurView removeFromSuperview];
                        }
                    }
                    if (self.feedDataArray.count >=7 && self.feedDataArray.count <=8)
                    {
                        if (indexPath.section == 9)
                        {
                            [self showCellCommitAddress:cell withIdentifyStr:feed.addressStr];
                        }
                        else
                        {
                            ShareBlurView *shareBlurView = (ShareBlurView *)[cell.contentView viewWithTag:30];
                            if (shareBlurView != nil)
                            {
                                [shareBlurView removeFromSuperview];
                            }
                            
                        }
                        if (indexPath.section == 10)
                        {
                            [self showCellCommitFriend:cell withIdentifyStr:feed.addressStr];
                        }
                        else
                        {
                            ShareBlurView *shareBlurView = (ShareBlurView *)[cell.contentView viewWithTag:40];
                            if (shareBlurView != nil)
                            {
                                [shareBlurView removeFromSuperview];
                            }
                            
                        }
                    }
                    return cell;
                }
                
            }
            
            
            
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   uint64_t changeUserId = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID];
    if (0 == changeUserId)
    {
        [self showJustExperienceBlurView];
    }
    else
    {
        
        int phoneIdentifyNum = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"phoneBook"];
        if (feedDataArray.count > 0)
        {
            if (2 == phoneIdentifyNum)
            {
                [self tableViewDidSelectedIndexForCell:YES withIndex:indexPath];
            }
            else
            {
                [self tableViewDidSelectedIndexForCell:NO withIndex:indexPath];
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    else
    {
        return 10;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

#pragma mark - CustomCell
-(MainViewCell *)feedCell:(UITableView *)tableView WithFeed:(Feed *)feed withIndex:(NSIndexPath *)index
{
    MainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifyStr];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MainViewCell class]) owner:self options:nil] firstObject];
    }
    
    cell.feed = feed;
    
    
    //评论button
    [cell setHandleCommentBtnBlock:^{
        if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
        {
            [self showJustExperienceBlurView];
        }
        else
        {
            [self gotoDetailViewCtl:feed];
        }
    }];
    
    //赞button
    [cell setHandleLikeBtnBlcok:^{
        [self showJustExperienceBlurView];
    }];
    
    //"..."button
    __weak MainViewCell *weakCell = cell;
    [cell setHandleOtherAgainstBtnBlock:^{
        if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
        {
            [self showJustExperienceBlurView];
        }
        else
        {
            ShareBlurView *blurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
            UIImage *shotImg = [UIImage imageFromUIView:weakCell.contentView];
            [blurView shareBlurWithImage:shotImg withBlurType:BlurCommitType];
            blurView.feedId = feed.feedId;
            [blurView.mainAgainst setHandleMainCellOtherRemoveBlock:^{
                [feedDataArray removeObjectAtIndex:index.section];
                [feedTableView deleteSections:[NSIndexSet indexSetWithIndex:index.section] withRowAnimation:UITableViewRowAnimationFade];
                [feedTableView reloadData];
            }];
            
            [blurView.mainAgainst setMakeReportReasonViewShowBlock:^{
                ShareBlurView *reasonBlurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
                [reasonBlurView shareBlurWithImage:[UIImage screenshot] withBlurType:BlurReportReasonType];
                [self.navigationController.view addSubview:reasonBlurView];
            }];
            [weakCell.contentView addSubview:blurView];
        }
    }];
    
    //右上角分享button
    [cell setHandleCellShareViewShow:^{
        
        if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
        {
            [self showJustExperienceBlurView];
        }
        else
        {
            ShareBlurView *blurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
            
            UIImage *shotImg = [UIImage imageFromUIView:weakCell.contentView];
            [blurView shareBlurWithImage:shotImg withBlurType:BlurCellShareType];
            [blurView.cellShare setHandleShareByMessage:^{
              NSString *str = [NSString stringWithFormat:@"%@,快来分享闺秘间的秘密。猛戳下载:%@",feed.contentStr,@"https://itunes.apple.com/us/app/gui-mi/id903777968?l=zh&ls=1&mt=8"];
                [self sendSMS:str];
            }];
            
            [blurView.cellShare setHandleWechat:^{
                [[LogicManager sharedInstance] sendWechatWithTitle:@"来自闺秘的分享" describe:feed.contentStr identify:@"闺秘" image:[UIImage imageNamed:@"58x58"] scene:0 contentCode:1 feedId:feed.feedId];
                [MobClick event:share_weixin];
            }];
            
            [blurView.cellShare setHanldeWechatCircle:^{
                [[LogicManager sharedInstance] sendWechatWithTitle:feed.contentStr describe:@"来自闺秘的分享" identify:@"闺秘" image:[UIImage imageNamed:@"58x58"] scene:1 contentCode:1 feedId:feed.feedId];
                [MobClick event:share_friend_circle];
            }];
            
            [blurView.cellShare setHandleWeibo:^{
                [[LogicManager sharedInstance] sendWeiBoWithTitle:@"来自闺秘的分享" desribe:feed.contentStr image:[UIImage imageNamed:@"58x58"] contentCode:1 feedId:feed.feedId];
                [MobClick event:share_weibo];
            }];
            
            [weakCell.contentView addSubview:blurView];
        }
        
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//朋友数cell
-(FriendNumsTableViewCell *)friendNumCell:(UITableView *)tableView
{
    FriendNumsTableViewCell *friendNumCell = [tableView dequeueReusableCellWithIdentifier:friendNumIdentify];
    
    if (friendNumCell == nil)
    {
        friendNumCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FriendNumsTableViewCell class]) owner:self options:nil] lastObject];
        DLog(@"friendCell---create");
    }
    friendNumCell.selectionStyle = UITableViewCellSelectionStyleNone;
    FriendNumsTableViewCell *weakCell = friendNumCell;
    [friendNumCell setFriendNumHandleInviteFriend:^{
        if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
        {
            [self showJustExperienceBlurView];
        }
        else
        {
            ShareBlurView *blurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
            UIImage *shotImg = [UIImage imageFromUIView:weakCell.contentView];
            [blurView shareBlurWithImage:shotImg withBlurType:BlurInviteFriendsType];
            [weakCell.contentView addSubview:blurView];
        }
    }];
    
    friendNum = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"friendNum"];
    friendNumCell.friendNum = friendNum;
    return friendNumCell;
}

//引导问题cell
-(QuestionFeedTableViewCell *)questionCell:(UITableView *)tableView
{
    QuestionFeedTableViewCell *questionCell = [tableView dequeueReusableCellWithIdentifier:questionCellIdentify];
    if (questionCell == nil)
    {
        questionCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QuestionFeedTableViewCell class]) owner:self options:nil] lastObject];
        DLog(@"questionCell---create");
    }
    [questionCell setHandlePublishSecretFromCell:^{
        
        if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
        {
            [self showJustExperienceBlurView];
        }
        else
        {
            [self rightBarBtnAction];
        }
        
    }];
    [questionCell setHandleInviteFriendAnswer:^{
        if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
        {
            [self showJustExperienceBlurView];
        }
        else
        {
            [MobClick event:invite_friends];
            ShareBlurView *inviteFreinds = [ShareBlurView show:self.view type:BlurInviteFriendsType];
            [inviteFreinds.inviteNavSetting setHandleInviteFriendMessageBlock:^{
                NSString *str = [NSString stringWithFormat:@"和我一起玩「闺秘」吧！八卦、爆料、真心话...这里是女生专属秘密交流聚集地，快来分享闺蜜之间的秘密。猛戳下载https://itunes.apple.com/us/app/gui-mi/id903777968?l=zh&ls=1&mt=8"];
                [self sendSMS:str];
            }];
        }
    }];
    
    questionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return questionCell;
}

//通讯录cell
-(PhoneBookTableViewCell *)phoneBookCell:(UITableView *)tableView
{
    PhoneBookTableViewCell *phoneBookCell = [tableView dequeueReusableCellWithIdentifier:PhoneBookIdentify];
    if (phoneBookCell == nil)
    {
        phoneBookCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PhoneBookTableViewCell class]) owner:self options:nil] lastObject];
    }
    phoneBookCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [phoneBookCell setHandlePhoneBookAccessBlock:^{
        ShareBlurView *visitPhoneBookBlur = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [visitPhoneBookBlur shareBlurWithImage:[UIImage screenshot] withBlurType:BlurPhoneBookAlertType];
        [self.navigationController.view addSubview:visitPhoneBookBlur];
    }];
    phoneBookCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return phoneBookCell;
}

-(void)tableViewDidSelectedIndexForCell:(BOOL)phoneBook withIndex:(NSIndexPath *)index
{
    Feed *feed = nil;
    if (phoneBook)
    {
        if (index.section < 3)
        {
            feed = [self.feedDataArray objectAtIndex:index.section];
            [self gotoDetailViewCtl:feed];
        }
        else if (index.section > 3 && index.section < 7)
        {
            feed = [self.feedDataArray objectAtIndex:index.section - 1];
            [self gotoDetailViewCtl:feed];
        }
        else if (index.section >= 8 && index.section != self.feedDataArray.count + 2)
        {
            feed = [self.feedDataArray objectAtIndex:index.section - 2];
            [self gotoDetailViewCtl:feed];
        }
    }
    else
    {
        if (index.section < 3)
        {
            feed = [self.feedDataArray objectAtIndex:index.section];
            [self gotoDetailViewCtl:feed];
        }
        else if (index.section > 3 && index.section < 7)
        {
            feed = [self.feedDataArray objectAtIndex:index.section - 1];
            [self gotoDetailViewCtl:feed];
        }
        else if (index.section >= 8)
        {
            feed = [self.feedDataArray objectAtIndex:index.section -2];
            [self gotoDetailViewCtl:feed];
        }
    }
    
}

#pragma mark - Tips Show
-(void)showCellShare:(UITableViewCell *)cell
{
    int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"cellShare"];
    if (0 == i)
    {
        ShareBlurView *cellShareTipsBlur = (ShareBlurView *)[cell.contentView viewWithTag:10];
        if (cellShareTipsBlur == nil)
        {
            cellShareTipsBlur = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
            [cellShareTipsBlur shareBlurWithImage:[UIImage imageFromUIView:cell.contentView] withBlurType:BlurTipsType];
            [cellShareTipsBlur.tip customTipsViewWithPoint:CGPointMake(280, -15) tipType:TipsCellShareType withSubTitle:nil withSubImageStr:@"btn_cellShare_n" subImageSize:CGSizeMake(44, 44)];
            cellShareTipsBlur.tag = 10;
            cellShareTipsBlur.tip.contentStr = @"你可以通过微信、微博、短信分享你喜欢的秘密";
            cellShareTipsBlur.tipsHeight = 60;
            __weak ShareBlurView *weakCellshare = cellShareTipsBlur;
            [cellShareTipsBlur.tip setHandleTipsOKBtnActionBlock:^{
                [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"cellShare"];
                [UIView animateWithDuration:1.0 animations:^{
                    weakCellshare.tip.alpha = 0;
                    weakCellshare.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakCellshare removeFromSuperview];
                }];
            }];
            
            [cell.contentView addSubview:cellShareTipsBlur];
        }
    }

}

-(void)showCellLike:(UITableViewCell *)cell
{
    int zanI = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"zanFlag"];
    if (0 == zanI)
    {
        if (0 == zanI)
        {
            ShareBlurView *tip = (ShareBlurView *)[cell.contentView viewWithTag:20];
            if (tip == nil)
            {
                tip = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width,cell.contentView.height)];
                [tip shareBlurWithImage:[UIImage imageFromUIView:cell.contentView] withBlurType:BlurTipsType];
                tip.tipsHeight = 195;
                tip.tag = 20;
                [tip.tip customTipsViewWithPoint:CGPointMake(270, 65) tipType:TipsSupportType withSubTitle:nil withSubImageStr:@"btn_support_yes" subImageSize:CGSizeMake(20, 20)];
                __weak ShareBlurView *weakTip = tip;
                [tip.tip setHandleTipsOKBtnActionBlock:^{
                    [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"zanFlag"];
                    [UIView animateWithDuration:1.0 animations:^{
                        weakTip.tip.alpha = 0;
                        weakTip.alpha = 0;
                    } completion:^(BOOL finished) {
                        [weakTip removeFromSuperview];
                    }];
                }];
                [cell.contentView addSubview:tip];
            }
        }
    }

}

-(void)showCellCommitAddress:(UITableViewCell *)cell withIdentifyStr:(NSString *)identifyStr
{
    int addressI = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"addressType"];
    if (0 == addressI)
    {
        NSRange addressRange = [identifyStr rangeOfString:@"朋友"];
        if (addressRange.location == NSNotFound)
        {
            if (0 == addressI)
            {
                ShareBlurView *tip = (ShareBlurView *)[cell.contentView viewWithTag:30];
                if (tip == nil)
                {
                    tip = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height)];
                    [tip shareBlurWithImage:[UIImage imageFromUIView:cell.contentView] withBlurType:BlurTipsType];
                    tip.tipsHeight = 195;
                    tip.tip.contentStr = @"这条秘密来自朋友圈外,这是一条热门秘密,或者你朋友赞过";
                    tip.tag = 30;
                    
                    [tip.tip customTipsViewWithPoint:CGPointMake(15, 65) tipType:TipsAddressType withSubTitle:identifyStr withSubImageStr:nil subImageSize:CGSizeZero];
                    __weak ShareBlurView *weakTip = tip;
                    [tip.tip setHandleTipsOKBtnActionBlock:^{
                        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"addressType"];
                        [UIView animateWithDuration:1.0 animations:^{
                            weakTip.tip.alpha = 0;
                            weakTip.alpha = 0;
                        } completion:^(BOOL finished) {
                            [weakTip removeFromSuperview];
                        }];
                    }];
                    [cell.contentView addSubview:tip];
                }
            }
            
        }
    }

}

-(void)showCellCommitFriend:(UITableViewCell *)cell withIdentifyStr:(NSString *)identifyStr
{
    int friendI = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"friendType"];
    if (0 == friendI)
    {
        NSRange addressRange = [identifyStr rangeOfString:@"朋友圈"];
        if (addressRange.location != NSNotFound)
        {
            if (0 == friendI)
            {
                
                ShareBlurView *tip = (ShareBlurView *)[cell.contentView viewWithTag:40];
                if (tip == nil)
                {
                    tip = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height)];
                    [tip shareBlurWithImage:[UIImage imageFromUIView:cell.contentView] withBlurType:BlurTipsType];
                    tip.tipsHeight = 195;
                    tip.tag = 40;
                    tip.tip.contentStr = @"这个秘密来自你的朋友圈,表示是你的朋友或者朋友的朋友发的";
                    [tip.tip customTipsViewWithPoint:CGPointMake(10, 65) tipType:TipsFriendType withSubTitle:@"朋友圈" withSubImageStr:nil subImageSize:CGSizeZero];
                    __weak ShareBlurView *weakTip = tip;
                    [tip.tip setHandleTipsOKBtnActionBlock:^{
                        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"friendType"];
                        [UIView animateWithDuration:1.0 animations:^{
                            weakTip.tip.alpha = 0;
                            weakTip.alpha = 0;
                        } completion:^(BOOL finished) {
                            [weakTip removeFromSuperview];
                        }];
                    }];
                    [cell.contentView addSubview:tip];
                }
            }
        }
    }


}

#pragma mark - CellBlurView
-(void)showJustExperienceBlurView
{
    ShareBlurView *experienceBlur = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [experienceBlur shareBlurWithImage:[UIImage screenshot] withBlurType:BlurJustExperienceType];
    [self.navigationController.view addSubview:experienceBlur];
}

-(void)showCellRightTopShareBlur:(MainViewCell *)cell
{
    
}

-(void)showCellCommentActionBlur:(MainViewCell *)cell
{
    
}

-(void)showCellCommitActionBlur:(MainViewCell *)cell
{
    
}

#pragma mark - MFMessageDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            DLog(@"cancle");
            break;
            case MessageComposeResultFailed:
            DLog(@"error");
            break;
            case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    if (controller != nil)
    {
        [controller dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RQShineLabelStart" object:nil userInfo:nil];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RQShineLabelPause" object:nil userInfo:nil];
}


#pragma mark - Actions
-(void)leftBarBtnAction
{
    [MobClick event:menu_click];
    MessageViewController *message = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    [self.navigationController pushViewController:message animated:YES];
}

-(void)rightBarBtnAction
{
    PublishSecretViewController *pubCtl = [[PublishSecretViewController alloc] initWithNibName:@"PublishSecretViewController"
                                                                                        bundle:nil];
    [self.navigationController pushViewController:pubCtl animated:YES];
}

-(void)justExperienctBack
{
    [(AppDelegate *)[UIApplication sharedApplication].delegate login];
}

//截图屏幕指定位置图片
- (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(frame);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}

-(void)gotoDetailViewCtl:(Feed *)feed
{
    DetailSecretViewController *detail = [[DetailSecretViewController alloc] initWithNibName:@"DetailSecretViewController" bundle:nil];
    detail.signalFeed = feed;
    [self.navigationController pushViewController:detail animated:NO];
}

-(void)sendSMS:(NSString *)str
{
    if ([MFMessageComposeViewController canSendText])
    {
        [MobClick event:share_message];
        messageCtl = [[MFMessageComposeViewController alloc] init];
        messageCtl.view.backgroundColor = [UIColor whiteColor];
        messageCtl.navigationBarHidden = NO;
        messageCtl.body = str;
        messageCtl.recipients = [NSArray arrayWithObjects:nil, nil];
        messageCtl.messageComposeDelegate = self;
        [self presentViewController:messageCtl animated:YES completion:^{
            
        }];
    }
}

-(void)linkAPNsToken
{
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    NSString *apnsToken = [[LogicManager sharedInstance] getPersistenceStringWithKey:APNSTOKEN];
    if (apnsToken != nil && apnsToken.length > 0)
    {
        if (userId != 0 && userKey!= nil && userKey.length > 0)
        {
            UserInfo *user = [UserInfo myselfInstance];
            user.userId = userId;
            user.userKey = userKey;
            user.userAPNsToken = apnsToken;
            [user synchronize:nil];
        }
    }
}

-(void)updateAPNsToken
{
    NSString *APNsToken = [[LogicManager sharedInstance] getPersistenceStringWithKey:APNSTOKEN];
    if (APNsToken != nil && APNsToken.length > 0)
    {
        int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"updateAPNsToken"];
        if (0 == i)
        {
            [[NetWorkEngine shareInstance] registDeviceToken:APNsToken block:^(int event, id object)
            {
                if (1 == event)
                {
                    Package *returnPack = (Package *)object;
                    if (0x01 == [returnPack getProtocalId])
                    {
                        [returnPack reset];
                        uint32_t result = [returnPack readInt32];
                        if (0 == result)
                        {
                            DLog(@"上传APNs Token成功");
                            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"updateAPNsToken"];
                        }
                        else if (-3 == result)
                        {
                            [[LogicManager sharedInstance] makeUserReLoginAuto];
                        }
                    }
                }
                else
                {
                    DLog(@"上传APNsToken失败");
                }
            }];
        }
    }
}

-(void)updatePhoneBookByRule
{
    int phoneBookIdentify = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:PhoneBook];
    
    if (2 == phoneBookIdentify)
    {
        [self updatePhoneBook];
    }
    else
    {
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval earlyTime = [[LogicManager sharedInstance] getPersistenceDoubleWithKey:UpdatePhoneBookTime];
        if (0 != earlyTime)
        {
            NSTimeInterval dropTime = nowTime - earlyTime;
            double day = dropTime/(24*60*60);
            if (day >= 7)
            {
                
                [self updatePhoneBook];
                [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithDouble:nowTime] withKey:UpdatePhoneBookTime];
            }
        }
    }
    
}

-(void)updatePhoneBook
{
    runOnAsynQueue(^{
        [[LogicManager sharedInstance] getContactFriends:^(int event, id object) {
            if (1 == event)
            {
                NSArray *phoneArray = object[@"dic"];
                NSString *json = [[LogicManager sharedInstance] objectToJsonString:phoneArray];
                
                runOnMainQueueWithoutDeadlocking(^{
                    [[NetWorkEngine shareInstance] updateContractListWith:json block:^(int event, id object)
                     {
                         if (1 == event)
                         {
                             Package *returnPack = (Package *)object;
                             if (0x0c == [returnPack getProtocalId])
                             {
                                 [returnPack reset];
                                 uint32_t result = [returnPack readInt32];
                                 if (0 == result)
                                 {
                                     DLog(@"上传通讯录成功");
                                     [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:4] withKey:PhoneBook];
                                 }
                                 else if (-3 == result)
                                 {
                                     [[LogicManager sharedInstance] makeUserReLoginAuto];
                                 }
                             }
                             
                         }
                         else if (0 == event)
                         {
                             DLog(@"上传通讯录失败");
                         }
                         
                     }];
                });
            }
            else if (-1 == event)
            {
                [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:PhoneBook];
            }
        }];
    });
}

-(void)mainServerSuccess
{
    DLog(@"connectServerSuccess");
}

+(MainViewController*)sharedInstance
{
    static MainViewController* m_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_instance = [[MainViewController alloc]init];
    });
    return m_instance;
}

@end
