//
//  FeedsViewController.m
//  WeLinked3
//
//  Created by 牟 文斌 on 2/25/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "FeedsViewController.h"
#import "FeedsTableCell.h"
#import "EditMyProfileViewController.h"
#import "FeedsViewDataManager.h"
#import "UINavigationBar+Loading.h"
#import "NewFeedViewController.h"
#import "PullRefreshTableView.h"
#import "NetworkEngine.h"
#import "Comment.h"
#import "ArticleBrowserViewController.h"
#import "Article.h"
#import "JobDetailViewViewController.h"
#import "CommentListViewController.h"
#import "UserInfo.h"
#import "SystemFeedTableViewCell.h"
#import "UserListViewController.h"

@interface FeedsViewController ()<FeedsTableCellDelegate,FeedsViewDataManagerDelegate,PullRefreshTableViewDelegate,NewFeedViewControllerDelegate,EGOImageViewDelegate>
{
    float _currentTableViewContentOffset;
    int _currentFeedIndex;//当前回复的哪条feeds
}
@property (strong, nonatomic) IBOutlet PullRefreshTableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *commentInputView;
@property (weak, nonatomic) IBOutlet UITextField *commentInputField;
@property (nonatomic, strong) UITapGestureRecognizer *tapGusture;
@property (nonatomic, strong) FeedsViewDataManager *dataManager;
@property (weak, nonatomic) IBOutlet UIImageView *commentBGView;
@property (strong, nonatomic) IBOutlet UIView *noFeedView;
@property (nonatomic, strong) NSMutableDictionary *cellHeightDic;
@property (nonatomic, strong) UIScrollView *preViewScrollView;
@end

@implementation FeedsViewController
{
    CGRect _currentCellRect;
    CGRect _keyboardRect;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tableView = nil;
    self.commentInputView = nil;
    self.commentInputField = nil;
    self.tapGusture = nil;
    self.dataManager = nil;
    self.cellHeightDic = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tabBarItem.image = [UIImage imageNamed:@"activityTab"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"activityTabSelected"];
        self.tabBarItem.title = @"职脉圈";
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
    [self.navigationItem setTitleViewWithText:@"职脉圈"];
    
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleNewPost title:nil target:self selector:@selector(newPost)];
    
    self.tableView.pullingDelegate = self;
    
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGusture:)];
    
    self.dataManager = [[FeedsViewDataManager alloc] init];
    self.dataManager.delegate = self;
    [self.dataManager loadData];
    
    [self.navigationController.navigationBar showLoadingIndicator];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    self.commentBGView.image = [[UIImage imageNamed:@"bg_feeds_comment.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.cellHeightDic = [NSMutableDictionary dictionary];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataManager.feedsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"feedsTableCell";
    Feeds *feed = [self.dataManager.feedsList objectAtIndex:indexPath.row];
    if (feed.feedsType != FeedsSystem) {
        FeedsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FeedsTableCell class]) owner:self options:nil] objectAtIndex:0];
            
        }
        cell.delegate = self;
        cell.feedsController = self;
        cell.feeds = feed;
        cell.indexPath = indexPath;
        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CellIdentifier = @"SystemFeedTableViewCell";
        SystemFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SystemFeedTableViewCell class]) owner:self options:nil] objectAtIndex:0];
            
        }
        cell.feed = feed;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feeds *feed = [self.dataManager.feedsList objectAtIndex:indexPath.row];
    if (feed.feedsType == FeedsUpdateProfile)
    {
        self.hidesBottomBarWhenPushed = YES;
        [[LogicManager sharedInstance] gotoProfile:self userId:feed.userId showBackButton:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else if (feed.feedsType == FeedsSystem)
    {
        NSError* error = nil;
        id data = nil;
        if (feed.targetContent.length) {
            data = [NSJSONSerialization JSONObjectWithData:[feed.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableLeaves error:&error];
        }
        if(error != nil)
        {
            data = nil;
        }
        NSMutableArray *userList = [NSMutableArray array];
        for (int i = 0; i < [(NSArray *)data count] ; i ++) {
            NSDictionary *dic = [data objectAtIndex:i];
            UserInfo *user = [[UserInfo alloc] init];
            [user setValuesForKeysWithDictionary:dic];
            [userList addObject:user];
        }
        
        UserListViewController *userListView = [[UserListViewController alloc] init];
        userListView.userList = userList;
        userListView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userListView animated:YES];
            
        }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = [[self.cellHeightDic objectForKey:[NSString stringWithFormat:@"cellAtIndex%d",indexPath.row]] floatValue];
    if (height < 44) {
        Feeds *feed = [self.dataManager.feedsList objectAtIndex:indexPath.row];
        height = [FeedsTableCell cellHeightWithFeed:feed];
        [self.cellHeightDic setObject:[NSNumber numberWithFloat:height] forKey:[NSString stringWithFormat:@"cellAtIndex%d",indexPath.row]];
    }
//    Feeds *feed = [self.dataManager.feedsList objectAtIndex:indexPath.row];
//    float height = [FeedsTableCell cellHeightWithFeed:feed];
    return height;
}

#pragma mark - Keyboard Notification
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    _keyboardRect = keyboardRect;
    if (_keyboardRect.origin.y < self.view.height) {
        [self moveCommentInputeView:_keyboardRect];
    }
    
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        self.commentInputView.y = self.view.height;
    } completion:^(BOOL finished) {
//        [self.commentInputContainView removeFromSuperview];
    }];
}


- (void)moveCommentInputeView:(CGRect)keyboardRect
{
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
//    float currentOffset = self.tableView.contentOffset.y;
//    需要移动到的位置
    CGRect targetRect = CGRectMake(0, self.view.height - keyboardRect.size.height - _currentCellRect.size.height + self.tabBarController.tabBar.height, _currentCellRect.size.width, _currentCellRect.size.height);
    
//    NSLog(@"targetY %f keyboardHeight %f inputHeight %f",targetRect.origin.y,_keyboardRect.size.height,self.commentInputView.height);
//    NSLog(@"currentCellRect%@",NSStringFromCGRect(_currentCellRect));
//    tableview内容要滚到合适位置的偏移量
    float shouldMoveOffset = targetRect.origin.y - _currentCellRect.origin.y;
    float offset = _currentTableViewContentOffset - shouldMoveOffset;
    if (offset < 0 ) {
        offset = 0;
    }
    
//    NSLog(@"tableView should offset is %f ",shouldMoveOffset);
//    NSLog(@"tableView before offset is %f ",currentOffset);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentOffset = CGPointMake(0, offset);
        
        self.commentInputView.y = self.view.height - keyboardRect.size.height + self.commentInputView.height - self.tabBarController.tabBar.height;
    }];
}

#pragma mark - FeedsTableCellDelegate
- (void)didSelectCell:(FeedsTableCell *)cell WithRect:(CGRect)rect
{
    if (![self.commentInputView isDescendantOfView:self.view]) {
        [self.view addSubview:self.commentInputView];
        self.commentInputView.y = self.view.height;
    }
    [self.commentInputField becomeFirstResponder];
    _currentCellRect = rect;
    _currentTableViewContentOffset = self.tableView.contentOffset.y;
    [self moveCommentInputeView:_keyboardRect];
    [self.view addGestureRecognizer:self.tapGusture];
}

- (void)didSelectCell:(FeedsTableCell *)cell
{

//    if (![self.commentInputView isDescendantOfView:self.view]) {
//        [self.view addSubview:self.commentInputView];
//        self.commentInputView.y = self.view.height;
//    }
//    [self.commentInputField becomeFirstResponder];
    
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:cell.indexPath];
    CGRect rect = [self.tableView convertRect:rectInTableView toView:self.view];
    _currentCellRect = rect;
    _currentTableViewContentOffset = self.tableView.contentOffset.y;
    [self moveCommentInputeView:_keyboardRect];
    [self.view addGestureRecognizer:self.tapGusture];
    _currentFeedIndex = cell.indexPath.row;
}

- (void)didClickSupportAtCell:(FeedsTableCell *)cell
{
    if (!cell.feeds.hasZan) {
        switch (cell.feeds.feedsType) {
            case FeedsArticle:
                [MobClick event:CONTACTS1];
                break;
            case FeedsUserPost:
                [MobClick event:CONTACTS5];
                
            default:
                break;
        }
        [self.dataManager supportFeed:cell.feeds Block:^(int event, id object) {
            if (1 == event) {
                cell.feeds.hasZan = YES;
                NSString *zanUser = [NSString stringWithFormat:@"%@、",[UserInfo myselfInstance].name];
                if ([zanUser hasSuffix:@"、"]) {
                    zanUser = [zanUser substringToIndex:zanUser.length - 1];
                }
                cell.feeds.zanUser = zanUser;
                cell.feeds.zanUserNum ++;
                [cell.feeds synchronize:nil];
                [self.cellHeightDic removeAllObjects];
                [self.tableView reloadData];
            }
        }];
    }else
    {
        return;
        [self.dataManager disSupportFeed:cell.feeds Block:^(int event, id object) {
            if (1 == event) {
                cell.feeds.hasZan = NO;
                [cell.feeds.zanUser stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",[UserInfo myselfInstance].name] withString:@""];
                if ([cell.feeds.zanUser hasPrefix:@"、"]) {
                    [cell.feeds.zanUser substringFromIndex:1];
                }
                if ([cell.feeds.zanUser hasSuffix:@"、"]) {
                    [cell.feeds.zanUser substringToIndex:cell.feeds.zanUser.length - 1];
                }

                cell.feeds.zanUserNum --;
                [cell.feeds synchronize:nil];
                [self.tableView reloadData];
            }
        }];
    }
    
}

//点头像
- (void)didClickUserHeadAtCell:(FeedsTableCell *)cell
{
    self.hidesBottomBarWhenPushed = YES;
    [[LogicManager sharedInstance] gotoProfile:self userId:cell.feeds.userId];
    self.hidesBottomBarWhenPushed = NO;
}
//点击原文
- (void)didClickOriginViewAtCell:(FeedsTableCell *)cell
{
    if (cell.feeds.feedsType == FeedsArticle) {
        ArticleBrowserViewController *articleBroswer = [[ArticleBrowserViewController alloc] init];
        NSError *error = nil;
        id data = nil;
        if (cell.feeds.targetContent.length) {
            data = [NSJSONSerialization JSONObjectWithData:[cell.feeds.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableLeaves error:&error];
        }
        if(error != nil)
        {
            data = nil;
        }
        Article *article = [[Article alloc] init];
        
        [article setValuesForKeysWithDictionary:data];
        articleBroswer.article = article;
        articleBroswer.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:articleBroswer animated:YES];
    }
    else if (cell.feeds.feedsType == FeedsJob)
    {
        JobDetailViewViewController *jobDetailView = [[JobDetailViewViewController alloc] init];
        NSError *error = nil;
        id data = nil;
        if (cell.feeds.targetContent.length)
        {
            data = [NSJSONSerialization JSONObjectWithData:[cell.feeds.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableLeaves error:&error];
        }
        if(error != nil)
        {
            data = nil;
        }
//        JobInfo *jobInfo = [[JobInfo alloc] init];
//        [jobInfo setValuesForKeysWithDictionary:data];
        jobDetailView.jobIdentity = [data objectForKey:@"identity"];
        jobDetailView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jobDetailView animated:YES];
    }else if (cell.feeds.feedsType == FeedsUserPost)
    {
        NSError *error = nil;
        id data = nil;
        if (cell.feeds.targetContent.length) {
            data = [NSJSONSerialization JSONObjectWithData:[cell.feeds.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableLeaves error:&error];
        }
        if(error != nil)
        {
            data = nil;
        }
        if ([[data objectForKey:@"image"] length]) {
            UIView *view = [[UIView alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
            self.preViewScrollView = [[UIScrollView alloc] initWithFrame:view.frame];
            _preViewScrollView.backgroundColor = [UIColor clearColor];
            EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:view.bounds];
            imageView.delegate = self;
            imageView.imageURL =[NSURL URLWithString:[data objectForKey:@"image"]] ;
//            imageView.userInteractionEnabled = NO;
            [_preViewScrollView addSubview:imageView];
            view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
            [view addSubview:_preViewScrollView];
            
            UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [view addGestureRecognizer:tapGusture];
            view.alpha = 0;
            [[[UIApplication sharedApplication] keyWindow] addSubview:view];
            [UIView animateWithDuration:0.3 animations:^{
                view.alpha = 1;
            }];
        }
    }
    
}
//点击评论
- (void)didClickCommentViewAtCell:(FeedsTableCell *)cell
{
//    if (cell.feeds.feedsType != FeedsArticle) {
//        return;
//    }
    NSError* error = nil;
    id data = nil;
    if (cell.feeds.targetContent.length) {
        data = [NSJSONSerialization JSONObjectWithData:[cell.feeds.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                               options:NSJSONReadingMutableLeaves error:&error];
    }
    if(error != nil)
    {
        data = nil;
    }
//    if (cell.feeds.feedsType == FeedsUserPost) {
//        [data setObject:cell.feeds.feedsId forKey:@"target_id"];
//    }else{
//        [data setObject:cell.feeds.targetId forKey:@"target_id"];
//    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
    [dic setObject:cell.feeds.feedsId forKey:@"target_id"];
    
    CommentListViewController *commentView = [[CommentListViewController alloc] init];
    commentView.feed = cell.feeds;
    commentView.isFromFeedList = YES;
    commentView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentView animated:YES];
}

- (void)addNewComment:(NSString *)comment Cell:(FeedsTableCell *)cell
{
    Feeds *feed = [self.dataManager.feedsList objectAtIndex:_currentFeedIndex];
    if (comment.length) {
        [MobClick event:CONTACTS2];
        [[NetworkEngine sharedInstance] addNewCommentAtFeed:feed Comment:comment Block:^(int event, id object) {
            DLog(@"feed New comment %@",object);
            if (1 == event) {
                Comment* comment = [[Comment alloc]init];
                [comment setValuesForKeysWithDictionary:object];
                [comment synchronize:nil];
                
                NSError* error = nil;
                id data = nil;
                if (feed.commentString.length) {
                    data = [NSJSONSerialization JSONObjectWithData:[feed.commentString dataUsingEncoding:NSUTF8StringEncoding]
                                                           options:NSJSONReadingMutableLeaves error:&error];
                }
                if(error != nil)
                {
                    data = nil;
                }
                NSMutableArray *mutArray = [NSMutableArray arrayWithArray:data];
                
                [mutArray insertObject:object atIndex:0];
                
                if (mutArray.count > 2) {
                    [mutArray removeLastObject];
                }
                
                NSString *json = [[LogicManager sharedInstance] objectToJsonString:[NSArray arrayWithArray:mutArray]];
                feed.commentString = json;
                feed.commentUserNum ++;
                [self.cellHeightDic removeAllObjects];
                [self.tableView reloadData];
                [cell reloadCommentList];
                [cell clearCommentField];
            }
        }];
    }
}

- (void)beginEdite
{
    [self.commentInputField becomeFirstResponder];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullRefreshTableView *)tableView{
    [self.dataManager loadData];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [NSDate date];
}

- (void)pullingTableViewDidStartLoading:(PullRefreshTableView *)tableView{
    [self.dataManager loadNextPageData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tableView tableViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.commentInputField resignFirstResponder];
}

- (void)tapGusture:(UITapGestureRecognizer *)tapGusture
{
    [self.commentInputField resignFirstResponder];
    [self.view removeGestureRecognizer:self.tapGusture];
}

#pragma mark - DataManagerDelegate
- (void)feedsViewDataManagerDidGetFeedsListSuccess:(FeedsViewDataManager *)manager
{
    [self.tableView tableViewDidFinishedLoading];
    [self.navigationController.navigationBar hideLoadingIndicator];
    [self.cellHeightDic removeAllObjects];
    [self.tableView reloadData];
    if (!manager.feedsList.count) {
        self.tableView.tableHeaderView = self.noFeedView;
//        [self.view addSubview:self.noFeedView];
    }else{
        self.tableView.tableHeaderView = nil;
//        [self.noFeedView removeFromSuperview];
    }
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + 10);
}

- (void)feedsViewDataManagerDidGetFeedsListFailed:(FeedsViewDataManager *)manager
{
    [self.tableView tableViewDidFinishedLoading];
    [self.navigationController.navigationBar hideLoadingIndicator];
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + 10);
}


#pragma mark - 
- (void)newPost
{
    NewFeedViewController *newFeed = [[NewFeedViewController alloc] init];
    newFeed.delegate = self;
    newFeed.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newFeed animated:YES];
}

#pragma mark - NewFeedViewCtrlDelegate
- (void)newFeedViewController:(NewFeedViewController *)viewController AddNewFeedsSuccess:(Feeds *)feed
{
    [self.cellHeightDic removeAllObjects];
    [self.dataManager.feedsList insertObject:feed atIndex:0];
    if (!self.dataManager.feedsList.count) {
//        [self.view addSubview:self.noFeedView];
        self.tableView.tableHeaderView = self.noFeedView;
    }else{
        self.tableView.tableHeaderView = nil;
//        [self.noFeedView removeFromSuperview];
    }
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)tapImageView:(UITapGestureRecognizer *)tapGusture
{
    [tapGusture.view removeFromSuperview];
    self.preViewScrollView = nil;
}

#pragma mark - EGOImageViewDelegate
- (void)imageViewLoadedImage:(EGOImageView*)imageView
{
//    imageView.width = imageView.image.size.width;
    float ratio = imageView.image.size.width / imageView.width;
    imageView.height = imageView.image.size.height / ratio;
    self.preViewScrollView.contentSize = CGSizeMake(imageView.width, imageView.image.size.height * (imageView.width / imageView.image.size.width));
    if (imageView.height < [[[UIApplication sharedApplication] keyWindow] bounds].size.height) {
        imageView.center = [[[UIApplication sharedApplication] keyWindow] center];
    }else{
        imageView.y = 0;
    }
    
}

@end
