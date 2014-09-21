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

#import <AFNetworking.h>


#import "MainViewCell.h"
#import "TipCountView.h"
#import "FriendNumsTableViewCell.h"
#import "QuestionFeedTableViewCell.h"
static NSString *const reuseIdentifyStr = @"mainCell";
static NSString *const questionCellIdentify = @"questionCell";
static NSString *const friendNumIdentify = @"friendNumCell";

#import "Feed.h"
#import "ExtraButton.h"
#import "ShareBlurView.h"
#import <UIImage+Screenshot.h>
#import <UIImage+Blur.h>
#import <MessageUI/MessageUI.h>
#import <SVPullToRefresh.h>

#import "Package.h"
#import "UserInfo.h"
#import "Feed.h"
#import "NetWorkEngine.h"

static const double lastWeek = 60*60*24*7;

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
{
    BOOL isSelected;
    TipCountView *tipView;
    MFMessageComposeViewController *messageCtl;
    UITapGestureRecognizer *tapRefreshData;
}

@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (nonatomic, strong) NSMutableArray *feedDataArray;
@property (nonatomic, strong) NSMutableArray *QuestionFeedsArray;

@end

@implementation MainViewController

@synthesize feedTableView,feedDataArray,QuestionFeedsArray;

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
    
    [self.navigationItem setTitleString:@"闺秘"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navCollection_n"] imageSelected:[[UIImage imageNamed:@"btn_navCollection_h"]imageWithRenderingMode:UIImageRenderingModeAutomatic] title:nil inset:UIEdgeInsetsMake(0, -10, 0, 10) target:self selector:@selector(leftBarBtnAction)];
    [self.navigationItem setRightBarButtonItem:[UIImage imageNamed:@"btn_navWriteSecret_n"] imageSelected:[UIImage imageNamed:@"btn_navWriteSecret_h"] title:nil inset:UIEdgeInsetsMake(0, 10, 0, -10) target:self selector:@selector(rightBarBtnAction)];
    feedTableView.separatorInset = UIEdgeInsetsZero;
    
    feedDataArray = [[NSMutableArray alloc] init];
    QuestionFeedsArray = [[NSMutableArray alloc] init];
    tipView = [[TipCountView alloc] init];
    
    [feedTableView addPullToRefreshWithActionHandler:^{
        [self sendPackForFeedsDataFromNetWork];
    }];
    
    [feedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionFeedTableViewCell class]) bundle:nil] forCellReuseIdentifier:questionCellIdentify];
    [feedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FriendNumsTableViewCell class]) bundle:nil] forCellReuseIdentifier:friendNumIdentify];
    
    //feeds数据处理
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:MainViewSecretContentCode block:^(int event, id object) {
        if (1 == event)
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [feedTableView.pullToRefreshView stopAnimating];
            Package *pack = (Package *)object;
            if ([pack handleFetchFeeds:pack withErrorCode:NoCheckErrorCode])
            {
                [self fetchFeedsDataFromDB];
                [feedTableView reloadData];
            }
        }
    }];
    
    //拉取引导问题
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:FetchGuideQuestionCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            if ([pack handleFetchGuideQuestion:pack withErrorCode:NoCheckErrorCode])
            {
                [self fetchQuestionFeedsFromDB];
                [feedTableView reloadData];
            }
        }
    }];
    
    //页面默认加载数据库数据
    [self fetchFeedsDataFromDB];
    [self fetchQuestionFeedsFromDB];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self sendPackForFeedsDataFromNetWork];
    [self sendPackForGuestQuestionDataFromNetWork];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - 数据库获取数据
-(void)fetchFeedsDataFromDB
{
    [feedDataArray removeAllObjects];
    NSString *conditionStr = [NSString stringWithFormat:@" where DBUid = '%llu'",[UserInfo myselfInstance].userId];
    NSArray *array = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class] tableName:nil condition:conditionStr];
    if (array.count > 0 && array != nil)
    {
        [feedDataArray addObjectsFromArray:array];
    }
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [feedTableView.pullToRefreshView startAnimating];
    int messageId = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:FeedLastMessageId];
    
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x03];
    
    int flag = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"feedsFirstTime"];
    if (0 == flag)
    {
        NSDate *date = [NSDate date];
        NSTimeInterval time = [date timeIntervalSince1970] - lastWeek;
        [pack lastedFeedsWithUserId:userId userKey:userKey lastFentchTime:time messageId:0 limitNum:10];
        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"feedsFirstTime"];
    }
    else
    {
        [pack lastedFeedsWithUserId:userId userKey:userKey lastFentchTime:0 messageId:messageId limitNum:10];
    }
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:MainViewSecretContentCode block:^(int event, id object)
    {
        
    }];
}

-(void)sendPackForGuestQuestionDataFromNetWork
{
    int messageId = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:QuestionFeedLastMessageId];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x0f];
    
    int flag = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"questionFirstTime"];
    if (0 == flag)
    {
        NSDate *date = [NSDate date];
        NSTimeInterval time = [date timeIntervalSince1970] - lastWeek;
        [pack fetchGuideQuestionWithWithUserId:userId userKey:userKey fetchTime:time preMessageId:0 limitsNum:5];
        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"questionFirstTime"];
    }
    else
    {
        [pack fetchGuideQuestionWithWithUserId:userId userKey:userKey fetchTime:0 preMessageId:messageId limitsNum:5];
    }
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:FetchGuideQuestionCode block:^(int event, id object) {
        
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (feedDataArray != nil)
    {
        return feedDataArray.count + 2;
    }
    else
    {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (feedDataArray != nil)
    {
        if (indexPath.section == 0)
        {
            QuestionFeedTableViewCell *questionCell = [tableView dequeueReusableCellWithIdentifier:questionCellIdentify forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if (questionCell == nil)
            {
                questionCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QuestionFeedTableViewCell class]) owner:self options:nil] lastObject];
            }
            [questionCell setHandlePublishSecretFromCell:^{
                
                PublishSecretViewController *publishCtl = [[PublishSecretViewController alloc] initWithNibName:NSStringFromClass([PublishSecretViewController class]) bundle:nil];
                [self.navigationController pushViewController:publishCtl animated:YES];
            }];
            [questionCell setHandleInviteFriendAnswer:^{
//                NSLog(@"----Ask friend to Answer");
                DLog(@"----Ask friend to Answer");
            }];
            
            questionCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return questionCell;
        }
        else if (indexPath.section == 1)
        {
            FriendNumsTableViewCell *friendNumCell = [tableView dequeueReusableCellWithIdentifier:friendNumIdentify];
            
            if (friendNumCell == nil)
            {
                friendNumCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FriendNumsTableViewCell class]) owner:self options:nil] lastObject];
            }
            friendNumCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return friendNumCell;
        }
        else
        {
            Feed *feed = [self.feedDataArray objectAtIndex:indexPath.section-2];
            
            MainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifyStr];
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MainViewCell class]) owner:self options:nil] firstObject];
            }
            
            cell.feed = feed;
            
            int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"cellShare"];
            if (indexPath.section == 6 && 0 == i)
            {
                ShareBlurView *cellShareTipsBlur = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, cell.width, cell.height)];
                [cellShareTipsBlur shareBlurWithImage:[UIImage imageFromUIView:cell.contentView] withBlurType:BlurTipsType];
                [cellShareTipsBlur.tip customTipsViewWithPoint:CGPointMake(280, -15) tipType:TipsCellShareType withSubTitle:nil withSubImageStr:@"btn_cellShare_n" subImageSize:CGSizeMake(44, 44)];
                cellShareTipsBlur.tip.contentStr = @"你可以通过微信、微博、短信分享你喜欢的秘密";
                cellShareTipsBlur.tipsHeight = 60;
//                __weak ShareBlurView *weakCellShareTip = cellShareTipsBlur;
//                [cellShareTipsBlur.tip setHandleTipsOKBtnActionBlock:^{
//                    [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"cellShare"];
//                    [weakCellShareTip removeFromSuperview];
//                }];
                
                [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"cellShare"];
                
                [cell.contentView addSubview:cellShareTipsBlur];
            }
            
            [cell setHandleCommentBtnBlock:^{
                DetailSecretViewController *detail = [[DetailSecretViewController alloc] initWithNibName:NSStringFromClass([DetailSecretViewController class]) bundle:nil];
                detail.signalFeed = feed;
                [self.navigationController pushViewController:detail animated:YES];
            }];
            
            __weak MainViewCell *weakCell = cell;
            [cell setHandleOtherAgainstBtnBlock:^{
                ShareBlurView *blurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
                UIImage *shotImg = [UIImage imageFromUIView:weakCell.contentView];
                [blurView shareBlurWithImage:shotImg withBlurType:BlurCommitType];
                blurView.feedId = feed.feedId;
                [blurView.mainAgainst setHandleMainCellOtherRemoveBlock:^{
                    //            [Feed deleteWith:<#(NSString *)#> condition:<#(NSString *)#>];
                    [feedDataArray removeObjectAtIndex:indexPath.section];
                    [feedTableView reloadData];
                }];
                
                [blurView.mainAgainst setMakeReportReasonViewShowBlock:^{
                    ShareBlurView *reasonBlurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
                    [reasonBlurView shareBlurWithImage:[UIImage screenshot] withBlurType:BlurReportReasonType];
                    [self.navigationController.view addSubview:reasonBlurView];
                }];
                [weakCell.contentView addSubview:blurView];
            }];
            
            [cell setHandleCellShareViewShow:^{
                ShareBlurView *blurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
                
                UIImage *shotImg = [UIImage imageFromUIView:weakCell.contentView];
                [blurView shareBlurWithImage:shotImg withBlurType:BlurCellShareType];
                [blurView.cellShare setHandleShareByMessage:^{
                    if ([MFMessageComposeViewController canSendText])
                    {
                        messageCtl = [[MFMessageComposeViewController alloc] init];
                        messageCtl.view.backgroundColor = [UIColor whiteColor];
                        messageCtl.navigationBarHidden = NO;
                        messageCtl.body = [NSString stringWithFormat:@"%@,快来分享闺秘间的秘密。猛戳下载:%@",feed.contentStr,@"https://itunes.apple.com/us/app/gui-mi/id903777968?l=zh&ls=1&mt=8"];
                        messageCtl.recipients = [NSArray arrayWithObjects:nil, nil];
                        messageCtl.messageComposeDelegate = self;
                        [self presentViewController:messageCtl animated:YES completion:^{
                            
                        }];
                    }
                    
                }];
                
                [blurView.cellShare setHandleWechat:^{
                    [[LogicManager sharedInstance] sendWechatWithTitle:@"来自闺秘的分享" describe:feed.contentStr identify:@"闺秘" image:[UIImage imageNamed:@"58x58"] scene:0];
                }];
                [blurView.cellShare setHanldeWechatCircle:^{
                    [[LogicManager sharedInstance] sendWechatWithTitle:feed.contentStr describe:@"来自闺秘的分享" identify:@"闺秘" image:[UIImage imageNamed:@"58x58"] scene:1];
                }];
                [blurView.cellShare setHandleWeibo:^{
                    [[LogicManager sharedInstance] sendWeiBoWithTitle:@"来自闺秘的分享" desribe:feed.contentStr image:[UIImage imageNamed:@"58x58"]];
                }];
                [weakCell.contentView addSubview:blurView];
            }];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section > 1)
    {
        Feed *feed = [self.feedDataArray objectAtIndex:indexPath.section-2];
        
        DetailSecretViewController *detail = [[DetailSecretViewController alloc] initWithNibName:NSStringFromClass([DetailSecretViewController class]) bundle:nil];
        detail.signalFeed = feed;
        [self.navigationController pushViewController:detail animated:YES];
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *btn = (UIButton *)[cell.contentView viewWithTag:100];
    if (btn.alpha == 0)
    {
        [UIView animateWithDuration:3.5 animations:^{
            btn.alpha = 1.0;
        }];
    }
    else if (btn.alpha == 1)
    {
        [UIView animateWithDuration:3.5 animations:^{
            btn.alpha = 0;
        }];
    }
}

#pragma mark - MFMessageDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
//            NSLog(@"cancle");
            DLog(@"cancle");
            break;
            case MessageComposeResultFailed:
//            NSLog(@"error");
            DLog(@"error");
            break;
            case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    if (messageCtl != nil)
    {
        [messageCtl dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - Actions
-(void)leftBarBtnAction
{
    MessageViewController *message = [[MessageViewController alloc] initWithNibName:NSStringFromClass([MessageViewController class]) bundle:nil];
    [self.navigationController pushViewController:message animated:YES];
}

-(void)rightBarBtnAction
{
    PublishSecretViewController *pubCtl = [[PublishSecretViewController alloc] initWithNibName:NSStringFromClass([PublishSecretViewController class]) bundle:nil];
    [self.navigationController pushViewController:pubCtl animated:YES];
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
