//
//  DetailSecretViewController.m
//  闺秘
//
//  Created by floar on 14-6-24.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "DetailSecretViewController.h"
#import <XHPathCover.h>
#import <UIImage+Screenshot.h>
#import "Comment.h"
#import "NetWorkEngine.h"
#import "LogicManager.h"
#import "UserInfo.h"
#import "DataBaseManager.h"
#import "ShareBlurView.h"
#import "DetailViewCell.h"

@interface DetailSecretViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    CGPoint pointOffset;
    UIImage *shotImgRect;
    UIImageView *imgView;
    UIButton *sendBtn;

    NSMutableArray *dataArray;
    
    UITextField *commentTextField;
    UIView *inputView;
    CustomButton *backBtn;
    NSString *rightCommentStr;
    UIActivityIndicatorView *indicator;
    
    uint32_t ownCommentNum;
}

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic, strong) XHPathCover *pathCover;

@end

@implementation DetailSecretViewController
@synthesize detailTableView,pathCover;

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
    self.navigationController.delegate = self;
    [self pathCoverHeaderView];
    [self makeTopView];
    dataArray = [[NSMutableArray alloc] init];
    
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, 320, 49)];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    
    detailTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    detailTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 240, 49)];
    commentTextField.placeholder = @"匿名发表评论";
    commentTextField.font = getFontWith(NO, 17);
    commentTextField.delegate = self;
    commentTextField.textAlignment = NSTextAlignmentLeft;
    commentTextField.borderStyle = UITextBorderStyleNone;
    commentTextField.returnKeyType = UIReturnKeySend;
    [inputView addSubview:commentTextField];
    
    sendBtn = [CustomButton buttonWithRect:CGRectMake(CGRectGetMaxX(commentTextField.frame)+20, 0, 49, 49) btnTitle:@"发布" btnImage:nil btnSelectedImage:nil];
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(CGRectGetMaxX(commentTextField.frame)+20, 0, 49, 49);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:colorWithHex(DeepRedColor) forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:sendBtn];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBOardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    DLog(@"%lld",self.signalFeed.feedId);
    
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:FeedDetailCode block:^(int event, id object) {
        if (1 == event)
        {
            //pathCover优先与这部分的网络数据，所以可以直接将pathCover放在这来执行;这个部分很容易出错，之前是讲xpCommentNum、xpLikeNum、isSupportLike写在pathCover本部死活没有数据
            //而对对于本部的数据，因为是直接从上一个页面传递过来，一初始化就有，所有有数据
            Package *pack = (Package *)object;
            
            Feed *feed = [pack handleFeedDetail:pack withErrorCode:NoCheckErrorCode];
            pathCover.xpCommentNum = feed.commentNum;
            ownCommentNum = feed.commentNum;
            pathCover.xpLikeNum = feed.likeNum;
            pathCover.isSupportLike = feed.isOwnZanFeed;
            
            NSString *conditionStr = [NSString stringWithFormat:@" where feedId = '%llu'",self.signalFeed.feedId];
            
            NSArray *feedArray = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class] tableName:nil condition:conditionStr];
            if (feedArray != nil && feedArray.count > 0)
            {
                Feed *changeFeed = [feedArray objectAtIndex:0];
                changeFeed.likeNum = feed.likeNum;
                changeFeed.commentNum = feed.commentNum;
                changeFeed.isOwnZanFeed = feed.isOwnZanFeed;
                [changeFeed synchronize:nil];
            }
            
            [self feedDetailDataFromDB];
            [detailTableView reloadData];
        }
    }];
    
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:CommentFeedCode block:^(int event, id object)
     {
         if (1 == event)
         {
             [commentTextField resignFirstResponder];
//             [detailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(dataArray.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//             [detailTableView reloadData];
             commentTextField.text = @"";
             [indicator stopAnimating];
             sendBtn.alpha = 1;
             Package *pack = (Package *)object;
             if ([pack handleSupportOrComment:pack withErrorCode:NoCheckErrorCode])
             {
                 DLog(@"评论feed成功");
             }
         }
     }];
    
    [self feedDetailDataFromDB];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }

    [self feedDetailDataFromNetWork];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 数据处理函数
-(void)feedDetailDataFromNetWork
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x06];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    [pack feedDetailInfoWithUserId:userId userKey:userKey feedId:self.signalFeed.feedId];
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:FeedDetailCode block:^(int event, id object) {
        
    }];
}

-(void)feedDetailDataFromDB
{
    [dataArray removeAllObjects];
    
    NSString *conditionStr = [NSString stringWithFormat:@" where feedId = '%llu'",self.signalFeed.feedId];
    NSArray *array = [[UserDataBaseManager sharedInstance] queryWithClass:[Comment class] tableName:nil condition:conditionStr];
    if (array.count > 0 && array != nil)
    {
        [dataArray addObjectsFromArray:array];
    }
}

#pragma mark - UITableViewHeaderView函数
//不会消失的topView
-(void)makeTopView
{
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
////    topView.backgroundColor = [UIColor clearColor];
//    topView.userInteractionEnabled = YES;
//    [self.view addSubview:topView];
    
//    最上面小横条图片
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,320,50)];
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    
    backBtn = [CustomButton buttonWithRect: CGRectMake(10, 0, 40, 40) btnTitle:nil btnImage:@"btn_close_n" btnSelectedImage:@"btn_close_h"];
    __weak DetailSecretViewController *weakSelf = self;
    [backBtn addButtionAction:^{
        [weakSelf.navigationController popViewControllerAnimated:NO];
    } buttonControlEvent:UIControlEventTouchUpInside];
    [imgView addSubview:backBtn];
    
}


//底部大图片
-(void)pathCoverHeaderView
{
    pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 300)];
    
    NSRange range = [self.signalFeed.imageStr rangeOfString:@"http"];
    if (range.location != NSNotFound)
    {
        [pathCover.bannerImageView setImageURL:[NSURL URLWithString:self.signalFeed.imageStr]];
    }
    else
    {
        [pathCover.bannerImageView setImage:[UIImage imageNamed:self.signalFeed.imageStr]];
    }
    
    pathCover.isZoomingEffect = YES;
    pathCover.contentStr = self.signalFeed.contentStr;
    pathCover.commitStr = self.signalFeed.addressStr;
    detailTableView.tableHeaderView = self.pathCover;
    
//    shotImgRect = [UIImage imageFromUIView:pathCover];
#if 0
    __weak DetailSecretViewController *weakSelf = self;
    [pathCover setHandleRefreshEvent:^{
        [weakSelf refreshing];
    }];
#endif
    
    
    [pathCover setHandleCommitBtnBlock:^{
        DLog(@"commit");
    }];
    
    /*不需要处理的事件
     [pathCover setHandleTapBackgroundImageEvent:^{
     [weakSelf.pathCover setBackgroundImage:[UIImage imageNamed:@"1"]];
     }];

    [pathCover setHandleCommentBtnBlock:^{
        [weakSelf sendComment];
    }];
     */
    
    [pathCover setHandleOtherBtnBlock:^{
        DLog(@"other");
    }];
    
    [pathCover setHandleLikeBtnBlock:^{
        DLog(@"like");
    }];
    
    [pathCover setHandleShareBtnBlock:^{
        DLog(@"share");
    }];
}

//for mine guess this function maybe did not work,i have customed other's codes-yjf
#if 0
- (void)refreshing {
    // refresh your data sources
    
    __weak DetailSecretViewController *weakSelf = self;
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.pathCover stopRefresh];
    });
}
#endif

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray != nil && dataArray.count > 0)
    {
        return dataArray.count;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [dataArray objectAtIndex:indexPath.row];
    
    static NSString *cellId = @"cellId";
    DetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DetailViewCell class]) owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"masterFloor"];
    if (comment.avatarId == 0 && 0 == i)
    {
        int index = indexPath.row;
        ShareBlurView *master = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [master shareBlurWithImage:[UIImage imageFromUIView:detailTableView] withBlurType:BlurTipsType];
        master.tipsHeight = index*70;
        master.tip.contentStr = @"[大粉钻]这个头像是作者专属的";
        master.tip.standImgStr = @"img_tipsStand_up";
        [master.tip customTipsViewWithPoint:CGPointMake(10, -15) tipType:TipsAvatorType withSubTitle:nil withSubImageStr:@"0" subImageSize:CGSizeMake(32, 32)];
//        __weak ShareBlurView *weakMaster = master;
//        [master.tip setHandleTipsOKBtnActionBlock:^{
//            [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:0] withKey:@"masterFloor"];
//            [weakMaster removeFromSuperview];
//            
//        }];
        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:0] withKey:@"masterFloor"];
        [self.view addSubview:master];
        
        
    }
    
    cell.comment = comment;
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


#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
        [navigationController setNavigationBarHidden:YES animated:YES];
        
    }
    else
    {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark- scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [pathCover scrollViewDidScroll:scrollView];
    pointOffset = scrollView.contentOffset;
    if (pointOffset.y >= 240)
    {
        DLog(@"---%f",pointOffset.y);
        UIImage *sdfimg = [self imageFromView:pathCover atFrame:CGRectMake(0, 120, 320, 60)];
        imgView.frame = CGRectMake(0, -100, 320, 250);
        imgView.image = sdfimg;
        imgView.userInteractionEnabled = YES;
        backBtn.frame = CGRectMake(10, 100, 40, 40);
        
//        if (dataArray.count > 0)
//        {
//            int i = []
//            for (Comment *comment in dataArray)
//            {
//                if (comment.avatarId != 0)
//                {
//                    
//                }
//            }
//        }
    }
    else
    {
        
        imgView.image = nil;
    }
}

-(void)tapAction
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [pathCover scrollViewWillBeginDragging:scrollView];
}


#pragma mark - UIStatusBar
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Action
-(void)sendBtnAction:(UIButton *)btn
{
        [self sendComment];
        btn.alpha = 0;
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetMidX(commentTextField.frame)+150, CGRectGetMidY(commentTextField.frame)-10, 20, 20)];
        indicator.hidesWhenStopped = YES;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        indicator.color = colorWithHex(DeepRedColor);
        [indicator startAnimating];
        [inputView addSubview:indicator];
    
    [self feedDetailDataFromNetWork];
}

-(void)sendComment
{
    if (commentTextField.text != nil && [commentTextField.text length] > 0 && ![commentTextField.text isEqualToString:@""])
    {
        ownCommentNum++;
        rightCommentStr = commentTextField.text;
    }
    else
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"评论内容不能为空" actionText:@"确定"];
    }
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x02];
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    [pack supportOrCommentWithUserId:userId userKey:userKey feedId:self.signalFeed.feedId commentId:0 operation:0x04 comment:rightCommentStr];
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:CommentFeedCode block:^(int event, id object) {
        
    }];
    
    //更新数据库commentNum
    NSString *conditionStr = [NSString stringWithFormat:@" where feedId = '%llu'",self.signalFeed.feedId];
    NSArray *feedArray = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class] tableName:nil condition:conditionStr];
    if (feedArray != nil && feedArray.count > 0)
    {
        Feed *changeFeed = [feedArray objectAtIndex:0];
        changeFeed.commentNum = ownCommentNum;
        [changeFeed synchronize:nil];
    }

}

//截图屏幕指定位置图片
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}

#pragma mark - 键盘通知事件
-(void)keyBoardShow:(NSNotification *)note
{
    int keyBoardY = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    int bottonViewY = [UIScreen mainScreen].bounds.size.height-keyBoardY-49;
    
    
    if (dataArray.count > 0)
    {
        NSIndexPath *lastRow = [NSIndexPath indexPathForRow:dataArray.count-1 inSection:0];
        [detailTableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    [UIView animateWithDuration:0.6 animations:^{
        inputView.frame = CGRectMake(0, bottonViewY, 320, 49);
    }];
}

-(void)keyBOardHidden:(NSNotification *)note
{
    [UIView animateWithDuration:0.25 animations:^{
        inputView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, 320, 49);
    }];
}

#pragma mark - textFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendBtnAction:sendBtn];
    return YES;
}


@end
