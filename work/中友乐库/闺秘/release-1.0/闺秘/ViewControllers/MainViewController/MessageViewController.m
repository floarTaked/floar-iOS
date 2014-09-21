//
//  MessageViewController.m
//  闺秘
//
//  Created by floar on 14-6-25.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "MessageViewController.h"
#import "SettingViewController.h"
#import "MessageCollectionCell.h"
#import "ShareBlurView.h"
#import "ChangepwViewController.h"
#import "DetailSecretViewController.h"
#import "SuggestViewController.h"
#import <UIImage+Screenshot.h>
#import "Package.h"
#import "NetWorkEngine.h"
#import <MessageUI/MessageUI.h>

@interface MessageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MFMessageComposeViewControllerDelegate>
{
    NSMutableArray *messageDataArray;
    MFMessageComposeViewController *messageViewCtl;
}

@property (weak, nonatomic) IBOutlet UICollectionView *messageCollectView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *messageLayout;


@end

@implementation MessageViewController

@synthesize messageCollectView,messageLayout;

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
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_close_n"] imageSelected:[UIImage imageNamed:@"btn_close_h"] title:nil inset:UIEdgeInsetsMake(0, -10, 0, 10) target:self selector:@selector(messageGoBack)];
    [self.navigationItem setRightBarButtonItem:[UIImage imageNamed:@"btn_navSet_n"] imageSelected:[UIImage imageNamed:@"btn_navSet_h"] title:nil inset:UIEdgeInsetsMake(0, 10, 0, -10) target:self selector:@selector(messageSetting)];
    
    //UICollectionView设置
    [messageLayout setItemSize:CGSizeMake(155, 160)];
    [messageLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //底部、左边、section之间距离
//    messageLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0,0);
    messageLayout.minimumInteritemSpacing = 0;
    messageLayout.minimumLineSpacing = 0;
    
    messageCollectView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    messageCollectView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    messageDataArray = [[NSMutableArray alloc] init];
    
    [messageCollectView registerNib:[UINib nibWithNibName:@"MessageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"messageCell"];
    
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:FetchCollectedFeedsCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            if ([pack handleFetchCollectedFeeds:pack withErrorCode:NoCheckErrorCode])
            {
                [self messageFetchDataFromDB];
                [messageCollectView reloadData];
            }
        }
    }];
//    默认从数据库读取数据
    if (messageDataArray != nil && messageDataArray.count > 0)
    {
        [self showTips];
    }
    [self messageFetchDataFromDB];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self messageFetchDataFromNetWork];
}

-(void)messageFetchDataFromNetWork
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x0e];
    
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    [pack fetchCollectedFeedsUserId:userId userKey:userKey];
    
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:FetchCollectedFeedsCode block:^(int event, id object) {
        
    }];
}

-(void)messageFetchDataFromDB
{
    [messageDataArray removeAllObjects];
    NSString *conditionStr = [NSString stringWithFormat:@" where DBUid = '%llu'",[UserInfo myselfInstance].userId];
    NSArray *arr = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class] tableName:@"FEEDCOLLECT" condition:conditionStr];
    [messageDataArray addObjectsFromArray:arr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (messageDataArray.count == 0 || messageDataArray == nil)
    {
        return 0;
    }
    else if (messageDataArray.count % 2 != 0)
    {
        return messageDataArray.count/2 + 1;
    }
    else
    {
        return messageDataArray.count/2;
    }
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (messageDataArray.count % 2 == 0)
    {
        return 2;
    }
    else
    {
        if (section == messageDataArray.count/2)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *feed = [messageDataArray objectAtIndex:indexPath.section*2+indexPath.row];
    
    MessageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"messageCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MessageCollectionCell class]) owner:self options:nil] lastObject];
    }

    if (indexPath.row == 1)
    {
        cell.frame = CGRectMake(160, 160*indexPath.section, 160, 160);
    }
    else
    {
        cell.frame = CGRectMake(0, 160*indexPath.section, 160, 160);
    }
    cell.cellFeed = feed;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *feed = [messageDataArray objectAtIndex:indexPath.section *2 + indexPath.row];
    DetailSecretViewController *detail = [[DetailSecretViewController alloc] initWithNibName:NSStringFromClass([DetailSecretViewController class]) bundle:nil];
    detail.signalFeed = feed;
    [self.navigationController pushViewController:detail animated:YES];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

#pragma mark - MFMessageDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    if (messageViewCtl != nil)
    {
        [messageViewCtl dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}


#pragma mark - Actions
-(void)messageGoBack
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self showTips];
}

-(void)showTips
{
    int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"feedCollected"];
    if (0 == i)
    {
        
        ShareBlurView *tip = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        UIImage *shotImg = [UIImage screenshot];
        [tip shareBlurWithImage:shotImg withBlurType:BlurTipsType];
        tip.tipsHeight = 235;
        [tip.tip customTipsViewWithPoint:CGPointMake(0, -15) tipType:TipsFeedCollectedType withSubTitle:nil withSubImageStr:nil subImageSize:CGSizeZero];
        tip.tip.contentStr = @"你收到的新的评论和[赞]将会在这里出现，快来看看吧!";
//        __weak ShareBlurView *weakTip = tip;
//        [tip.tip setHandleTipsOKBtnActionBlock:^{
//            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"feedCollected"];
//            [weakTip removeFromSuperview];
//        }];
        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"feedCollected"];
        [self.navigationController.view addSubview:tip];
        
        
    }
}


-(void)messageSetting
{
    
//    void(^handleInviteBtnBlock)(void)
//    void(^handleFrequentQuestionsBlock)(void);
//    void(^handleSuggestForUsBlock)
//    void(^handleChangePWBlock)(void);
//    void(^handleRateMeBlock)(void);
//    void(^handleLogoutBlcok)(void);
//    void(^handleClearMarkBlock)(void)

    ShareBlurView *blurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight([UIScreen mainScreen].bounds))];
    [blurView shareBlurWithImage:[UIImage screenshot] withBlurType:BlurSettingType];
    
    __weak ShareBlurView *weakBlurView = blurView;
    [blurView.navSettingAppear setHandleInviteBtnBlock:^{
        ShareBlurView *inviteFreinds = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight([UIScreen mainScreen].bounds))];
        [inviteFreinds shareBlurWithImage:[UIImage screenshot] withBlurType:BlurInviteFriendsType];
        [inviteFreinds.inviteNavSetting setHandleInviteFriendMessageBlock:^{
            messageViewCtl = [[MFMessageComposeViewController alloc] init];
            messageViewCtl.view.backgroundColor = [UIColor whiteColor];
            messageViewCtl.navigationBarHidden = NO;
            messageViewCtl.body = [NSString stringWithFormat:@"和我一起玩[闺秘]吧！八卦、爆料、真心话...这里是女生专属秘密交流聚集地，快来分享闺蜜之间的秘密。猛戳下载https://itunes.apple.com/us/app/gui-mi/id903777968?l=zh&ls=1&mt=8"];
            messageViewCtl.recipients = [NSArray arrayWithObjects:nil, nil];
            messageViewCtl.messageComposeDelegate = self;
            [self presentViewController:messageViewCtl animated:YES completion:^{
                
            }];
            
        }];
        
        [weakBlurView addSubview:inviteFreinds];
    }];

    [blurView.navSettingAppear setHandleChangePWBlock:^{
        ChangepwViewController *changePWCtl = [[ChangepwViewController alloc] initWithNibName:NSStringFromClass([ChangepwViewController class]) bundle:nil];
        [self.navigationController pushViewController:changePWCtl animated:YES];
    }];

    [blurView.navSettingAppear setHandleLogoutBlcok:^{
        ShareBlurView *logoutView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight([UIScreen mainScreen].bounds))];
        [logoutView shareBlurWithImage:[UIImage screenshot] withBlurType:BLurLogoutType];
        [weakBlurView addSubview:logoutView];
    }];

    [blurView.navSettingAppear setHandleClearMarkBlock:^{
        ShareBlurView *clearMarkView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight([UIScreen mainScreen].bounds))];
        [clearMarkView shareBlurWithImage:[UIImage screenshot] withBlurType:BlurClearMarkType];
        [weakBlurView addSubview:clearMarkView];
        
    }];
    
    [blurView.navSettingAppear setHandleSuggestForUsBlock:^{
        SuggestViewController *suggest = [[SuggestViewController alloc] initWithNibName:NSStringFromClass([SuggestViewController class]) bundle:nil];
        [self.navigationController pushViewController:suggest animated:YES];
    }];
    
    [self.navigationController.view addSubview:blurView];
}

@end
