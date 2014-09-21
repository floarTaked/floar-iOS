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
#import "FrequentQuestionViewController.h"
#import <UIImage+Screenshot.h>
#import "Package.h"
#import "NetWorkEngine.h"
#import <MessageUI/MessageUI.h>
#import <RQShineLabel.h>

#import <StoreKit/StoreKit.h>

@interface MessageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MFMessageComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>
{
    NSMutableArray *messageDataArray;
    MFMessageComposeViewController *messageViewCtl;
    UILabel *noticeLabel;
}

@property (strong, nonatomic) IBOutlet UICollectionView *messageCollectView;

@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *messageLayout;


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
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_close_n"] imageSelected:[UIImage imageNamed:@"btn_close_h"] title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15) target:self selector:@selector(messageGoBack)];
    [self.navigationItem setRightBarButtonItem:[UIImage imageNamed:@"btn_navSet_n"] imageSelected:[UIImage imageNamed:@"btn_navSet_h"] title:nil inset:UIEdgeInsetsMake(0, 15, 0, -15) target:self selector:@selector(messageSetting)];
    
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
    
//    默认从数据库读取数据
    [self messageFetchDataFromDB];
    
    noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 200, 100, 40)];
    noticeLabel.backgroundColor = [UIColor clearColor];
    noticeLabel.text = @"没有新通知";
    noticeLabel.textColor = colorWithHex(DeepRedColor);
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.font = getFontWith(NO, 17);
    noticeLabel.alpha = 0;
    [self.view addSubview:noticeLabel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [messageCollectView reloadData];
    [self messageFetchDataFromNetWork];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"memoryWarning:%@",NSStringFromClass([self class]));
}

#pragma mark - 数据处理
-(void)messageFetchDataFromNetWork
{
    [[NetWorkEngine shareInstance] fetchCollectedFeeds:^(int event, id object)
    {
        if (1 == event)
        {
            Package *returnPack = (Package *)object;
            if (0x0e == [returnPack getProtocalId])
            {
                [returnPack reset];
                uint32_t result = [returnPack readInt32];
                if (0 == result)
                {
                    uint32_t count = [returnPack readInt32];
                    if (0 == count)
                    {
                        [UIView animateWithDuration:1.0 animations:^{
                            noticeLabel.alpha = 1.0;
                        }];
                    }
                    else
                    {
                        noticeLabel.alpha = 0;
                    }
                    for (int i = 0; i < count; i++)
                    {
                        Feed *feed = [[Feed alloc] init];
                        feed.feedId = [returnPack readInt64];
                        feed.contentJson = [returnPack readString];
                        
                        NSString *contentStr = feed.contentJson;
                        if (contentStr != nil && contentStr.length > 0)
                        {
                            NSDictionary *dict = [[LogicManager sharedInstance] jsonStringToObject:contentStr];
                            feed.contentStr = [dict objectForKey:@"content"];
                            NSString *netImageStr = [dict objectForKey:@"img"];
                            
                            NSRange range = [netImageStr rangeOfString:@"http"];
                            if (range.location == NSNotFound)
                            {
                                NSArray *arr = [netImageStr componentsSeparatedByString:@":"];
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
                        feed.likeNum = [returnPack readInt32];
                        feed.isOwnZanFeed = [returnPack readInt32];
                        feed.commentNum = [returnPack readInt32];
                        feed.addressStr = [returnPack readString];
                        [feed synchronize:@"FEEDCOLLECT"];
                    }
                    [self messageFetchDataFromDB];
                    [messageCollectView reloadData];
                }
                else if (-3 == result)
                {
                    [[LogicManager sharedInstance] makeUserReLoginAuto];
                }
            }
        }
    }];
}

-(void)messageFetchDataFromDB
{
    [messageDataArray removeAllObjects];
    NSString *conditionStr = [NSString stringWithFormat:@" where DBUid = '%llu'",[UserInfo myselfInstance].userId];
    NSArray *arr = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class] tableName:@"FEEDCOLLECT" condition:conditionStr];
    [messageDataArray addObjectsFromArray:arr];
    
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
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCollectionCell" owner:self options:nil] lastObject];
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
    DetailSecretViewController *detail = [[DetailSecretViewController alloc] initWithNibName:@"DetailSecretViewController" bundle:nil];
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
    if (controller != nil)
    {
        [controller dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - SKStoreDelegate
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    if (viewController != nil)
    {
        [viewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}


#pragma mark - Actions
-(void)messageGoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showTips
{
    int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"feedCollected"];
    if (0 == i)
    {
        
        ShareBlurView *tip = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
//        UIImage *shotImg = [UIImage screenshot];
        UIImage *shotImg = [UIImage imageFromUIView:self.view];
        [tip shareBlurWithImage:shotImg withBlurType:BlurTipsType];
        tip.tipsHeight = 235;
        [tip.tip customTipsViewWithPoint:CGPointMake(0, -15) tipType:TipsFeedCollectedType withSubTitle:nil withSubImageStr:nil subImageSize:CGSizeZero];
        tip.tip.contentStr = @"你收到的新的评论和「赞」将会在这里出现，快来看看吧!";
        __weak ShareBlurView *weakTip = tip;
        [tip.tip setHandleTipsOKBtnActionBlock:^{
//            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"feedCollected"];
            [UIView animateWithDuration:1.0 animations:^{
                weakTip.tip.alpha = 0;
                weakTip.alpha = 0;
            } completion:^(BOOL finished) {
                [weakTip removeFromSuperview];
            }];
        }];
        [self.navigationController.view addSubview:tip];
    }
}


-(void)messageSetting
{
    [MobClick event:app_setting];
//    void(^handleInviteBtnBlock)(void)
//    void(^handleFrequentQuestionsBlock)(void);
//    void(^handleSuggestForUsBlock)
//    void(^handleChangePWBlock)(void);
//    void(^handleRateMeBlock)(void);
//    void(^handleLogoutBlcok)(void);
//    void(^handleClearMarkBlock)(void)

    ShareBlurView *blurView = [ShareBlurView show:[UIImage screenshot] type:BlurSettingType];
//    ShareBlurView *blurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight([UIScreen mainScreen].bounds))];
//    [blurView shareBlurWithImage:[UIImage screenshot] withBlurType:BlurSettingType];
    
    __weak ShareBlurView *weakBlurView = blurView;
    [blurView.navSettingAppear setHandleInviteBtnBlock:^{
        
        ShareBlurView *inviteFreinds = [ShareBlurView show:[UIImage screenshot] type:BlurInviteFriendsType];
        
//        ShareBlurView *inviteFreinds = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight([UIScreen mainScreen].bounds))];
        //[inviteFreinds shareBlurWithImage:[UIImage screenshot] withBlurType:BlurInviteFriendsType];
        [inviteFreinds.inviteNavSetting setHandleInviteFriendMessageBlock:^{
            messageViewCtl = [[MFMessageComposeViewController alloc] init];
            messageViewCtl.view.backgroundColor = [UIColor whiteColor];
            messageViewCtl.navigationBarHidden = NO;
            messageViewCtl.body = [NSString stringWithFormat:@"和我一起玩「闺秘」吧！八卦、爆料、真心话...这里是女生专属秘密交流聚集地，快来分享闺蜜之间的秘密。猛戳下载https://itunes.apple.com/us/app/gui-mi/id903777968?l=zh&ls=1&mt=8"];
            messageViewCtl.recipients = [NSArray arrayWithObjects:nil, nil];
            messageViewCtl.messageComposeDelegate = self;
            [self presentViewController:messageViewCtl animated:YES completion:^{
                
            }];
            
        }];
        
//        [weakBlurView addSubview:inviteFreinds];
    }];

    [blurView.navSettingAppear setHandleChangePWBlock:^{
        [MobClick event:change_password];
        ChangepwViewController *changePWCtl = [[ChangepwViewController alloc] initWithNibName:NSStringFromClass([ChangepwViewController class]) bundle:nil];
        [self.navigationController pushViewController:changePWCtl animated:YES];
    }];
    
    [blurView.navSettingAppear setHandleFrequentQuestionsBlock:^{
        FrequentQuestionViewController *frequent = [[FrequentQuestionViewController alloc] initWithNibName:NSStringFromClass([FrequentQuestionViewController class]) bundle:nil];
        [self.navigationController pushViewController:frequent animated:YES];
    }];
    
    [blurView.navSettingAppear setHandleRateMeBlock:^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APPID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
        }
        else
        {
            SKStoreProductViewController *storeCtl = [[SKStoreProductViewController alloc] init];
            storeCtl.delegate = self;
            [storeCtl loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: APPID} completionBlock:^(BOOL result, NSError *error) {
                if (error != nil)
                {
                    DLog(@"error:%@ withUserInfo:%@",error,[error userInfo]);
                }
                else
                {
                    [self presentViewController:storeCtl animated:YES completion:^{
                        
                    }];
                }
            }];
        }
    }];

    [blurView.navSettingAppear setHandleLogoutBlcok:^{
        ShareBlurView *logoutView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight([UIScreen mainScreen].bounds))];
        [logoutView shareBlurWithImage:[UIImage screenshot] withBlurType:BLurLogoutType];
        [weakBlurView addSubview:logoutView];
    }];

    [blurView.navSettingAppear setHandleClearMarkBlock:^{
        [MobClick event:clear_traces];
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
