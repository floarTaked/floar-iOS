//
//  CommentListViewController.m
//  WeLinked3
//
//  Created by 牟 文斌 on 3/10/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentsListDataManager.h"
#import "PullRefreshTableView.h"
#import "CommentCell.h"
#import "Common.h"
#import "UserHeadTableCell.h"
#import "MBProgressHUD.h"
#import "LogicManager.h"
#import "SupportListViewController.h"
#import "CommentTitleCell.h"

#define lableWith 130
#define lableHeight 80

@interface CommentListViewController ()<PullRefreshTableViewDelegate,UserHeadTableCellDelegate,CommentsListDataManagerDelegate>
{
    UIAlertView *tipAlertView;
    MBProgressHUD* HUD;
    UITapGestureRecognizer *tap;
    BOOL keyBoradUp;
}
@property (weak, nonatomic) IBOutlet PullRefreshTableView *commentTableView;
@property (strong, nonatomic) IBOutlet UIView *commentInputView;
@property (weak, nonatomic) IBOutlet UITextField *commentInputField;
@property (weak, nonatomic) IBOutlet UIImageView *noCommentImageView;

@property (weak, nonatomic) IBOutlet UIButton *supportBtn;

@property (weak, nonatomic) IBOutlet UIView *supportBtnView;

@property (weak, nonatomic) IBOutlet UIImageView *inputBG;


@property (nonatomic, strong) CommentsListDataManager *dataManager;

@end

@implementation CommentListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    self.commentTableView.pullingDelegate = self;
    _commentInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.navigationItem setTitleViewWithText:@"评论"];
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back)];
    
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.dataManager = [[CommentsListDataManager alloc] init];
    self.dataManager.delegate = self;
    
    if (_isFromFeedList == YES)
    {
        NSLog(@"--------%@",_feed);
        if (_feed.feedsType == FeedsArticle)
        {
            self.dataManager.typeId = [[self getCellContent] objectForKey:@"id"];
            [self.dataManager loadData];
        }
        else if (_feed.feedsType == FeedsJob)
        {
            self.dataManager.typeId = _feed.targetId;
            [self.dataManager loadCommentAndSupport:self.dataManager.typeId];
        }
        else
        {
            self.dataManager.typeId = _feed.targetId;
            [self.dataManager loadUserPostCommentAndSupport:self.dataManager.typeId];
        }
    }
    
    if (_isFromFeedList == NO)
    {
        self.dataManager.typeId = self.article.articleID;
        [self.dataManager loadData];
    }
    
    self.supportBtnView.layer.cornerRadius = self.supportBtnView.height / 2;
    self.supportBtnView.layer.borderColor = colorWithHex(0xCCCCCC).CGColor;
    self.supportBtnView.layer.borderWidth = 0.5f;
    self.supportBtnView.clipsToBounds = YES;
    
    self.inputBG.image = [[UIImage imageNamed:@"bg_feeds_comment.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

    if (_isFromFeedList == YES)
    {
        if (_feed.hasZan)
        {
            [self.supportBtn setImage:[UIImage imageNamed:@"btn_feed_support_s"] forState:UIControlStateNormal];
        }
        _isSupport = _feed.hasZan;
    }
    if (_article.hasZan)
    {
        [self.supportBtn setImage:[UIImage imageNamed:@"btn_feed_support_s"] forState:UIControlStateNormal];
    }
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeKeyBoardHidden)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

-(void)tapTitleViewAction
{
    [self back];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(CGSize)getLabelSize:(NSString *)string
             fontSize:(CGFloat)fontSize
{
    CGSize size;
    if (isSystemVersionIOS7())
    {
        size = [string boundingRectWithSize:CGSizeMake(lableWith , lableHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil].size;
    }else{
        size = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(lableWith, lableHeight) lineBreakMode:NSLineBreakByWordWrapping];
    }
    return size;
}

-(void)noCommentBottonImageViewAction
{
    if (self.dataManager.supportList.count != 0 || self.dataManager.commentList.count != 0)
    {
        self.noCommentImageView.hidden = YES;
    }
    else
    {
        self.noCommentImageView.hidden = NO;
        if (self.view.frame.size.height < 500)
        {
            self.noCommentImageView.frame = CGRectMake(0,480-180-64-49, 320, 180);
            self.noCommentImageView.image = [UIImage imageNamed:@"img_comment_3inch"];
        }
        else
        {
            self.noCommentImageView.frame = CGRectMake(0,568-220-64-49, 320, 220);
            self.noCommentImageView.image = [UIImage imageNamed:@"img_comment_4inch"];
        }
    }
}

-(NSDictionary *)getCellContent
{
    id data;
    NSError *error;
    if (_feed.targetContent.length) {
        data = [NSJSONSerialization JSONObjectWithData:[_feed.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                               options:NSJSONReadingMutableLeaves error:&error];
    }
    if (error != nil)
    {
        NSLog(@"---Feeds  error%@",error);
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
    
    return dic;
}

- (void)dealloc
{
    self.dataManager = nil;
}

-(void)makeKeyBoardHidden
{
    [self.view removeGestureRecognizer:tap];
    keyBoradUp = !keyBoradUp;
    [_commentInputField resignFirstResponder];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)customLine:(UITableViewCell*)cell
       withHeight:(CGFloat)height
            withY:(CGFloat)y
        withColor:(int)value
{
    if(cell == nil || cell.contentView == nil)
    {
        return;
    }
    UIView* line = [cell.contentView viewWithTag:2];
    if(line == nil)
    {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, y, cell.frame.size.width, height)];
//        0xCCCCCC
//        0xE5E5E5
        line.backgroundColor = colorWithHex(value);
        line.tag = 2;
        [cell.contentView addSubview:line];
    }
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


- (IBAction)sendCommentAction:(id)sender
{
    if ([_commentInputField.text isEqualToString:@""] || _commentInputField.text == nil)
        
    {
        [self HUDCustomAction:@"请输入评论内容"];
    }
    else
    {
        HUD.labelText = @"评论中...";
        [HUD show:YES];
        
        NSString* text = _commentInputField.text;
        [self performSelector:@selector(makeHUBStateChange) withObject:self afterDelay:1.5];
        [self.noCommentImageView removeFromSuperview];
        [_commentInputField resignFirstResponder];
        
        if (_feed.feedsType == FeedsArticle || _isFromFeedList == NO)
        {
            [self.dataManager addNewComment:text];
        }
        else
        {
            [[NetworkEngine sharedInstance] addNewCommentAtFeed:_feed Comment:text Block:^(int event, id object)
            {
                if(event == 1)
                {
                    _commentInputField.text = @"";
                }
            }];
        }
        
        //统计评论次数
        [MobClick event:@"ARTICLE-4"];
        
        //修改infoDetailView页面的评论数，在infoDetailView页面的每个cell来接受这个通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeInfoViewCommentNum" object:self.article];
        keyBoradUp = !keyBoradUp;
    }
}

- (IBAction)supportAction:(id)sender
{
    
    if (_isFromFeedList == NO)
    {
        if (!_article.hasZan)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.supportBtn setImage:[UIImage imageNamed:@"btn_feed_support_s"] forState:UIControlStateNormal];
                self.supportBtn.transform = CGAffineTransformMakeScale(2.5, 2.5);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.supportBtn.transform = CGAffineTransformIdentity;
                }];
                
            }];
            _article.hasZan = !_article.hasZan;
            [[NetworkEngine sharedInstance] supportArticleWithArticleID:_article.articleID andType:@"1" Block:^(int event, id object)
             {
                 if (1 == event)
                 {
                     
                 }
             }];
            
        }
        else
        {
           [self HUDCustomAction:@"您已经赞"];
        }
        
    }
    else
    {
        if (!_feed.hasZan)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self.supportBtn setImage:[UIImage imageNamed:@"btn_feed_support_s"] forState:UIControlStateNormal];
                self.supportBtn.transform = CGAffineTransformMakeScale(2.5, 2.5);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.supportBtn.transform = CGAffineTransformIdentity;
                }];
                
            }];
            _feed.hasZan = !_feed.hasZan;
            
            [[NetworkEngine sharedInstance] supportFeed:_feed type:1 Block:^(int event, id object)
             {
                 if (1 == event)
                 {
                     
                 }
                 
             }];
        }
        else
        {
            [self HUDCustomAction:@"您已经赞"];
        }
    }
}

-(void)makeHUBStateChange
{
    self.article.commentNum++;
    [self.dataManager.commentList removeAllObjects];
    [self.dataManager loadData];
    HUD.labelText = @"评论成功";

    [HUD hide:YES afterDelay:1.0];
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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        if (_dataManager.supportList.count == 0)
        {
            if (_dataManager.commentList.count == 0)
            {
                return 1;
            }
            else
            {
                return 2;
            }
        }
        else
        {
            return 3;
        }
    }
    if (1 == section)
    {
        return _dataManager.commentList.count;
    }
    else
    {
        return 0;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            //图片
            static NSString *cellId = @"titleCell";
            CommentTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil)
            {
                cell = [[CommentTitleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dateDic = [self getCellContent];
            
            if (_isFromFeedList == YES)
            {
                if (_feed.feedsType == FeedsJob)
                {
                    [cell jobArticleCell];
                }
                else if (_feed.feedsType == FeedsArticle || _isFromFeedList == NO)
                {
                    cell.isFromFeedList = YES;
                    [cell articleTitleViewCell];
                }
                else
                {
                    [cell userPostCell];
                }
            }
        
            if (_isFromFeedList == NO)
            {
                [cell articleFromArticel:self.article];
            }
            
            return cell;
            
        }
        else if (indexPath.row == 1)
        {
            //赞和评论
            static NSString* Identifier = @"SectionHeader";
            CustomCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[CustomCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
            }
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
            
            UIImageView *supportImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
            supportImageView.image = [UIImage imageNamed:@"btn_feed_support_n"];
            
            UILabel *supportLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(supportImageView.frame)+5, 10, 50, 20)];
            supportLabel.font = [UIFont systemFontOfSize:14];
            supportLabel.textColor = colorWithHex(0x999999);
            supportLabel.text = [NSString stringWithFormat:@"赞(%d)",self.dataManager.supportList.count];
            [view addSubview:supportLabel];
            [view addSubview:supportImageView];
            
            UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(supportLabel.frame), 10, 20, 20)];
            commentImageView.image = [UIImage imageNamed:@"img_comment_n"];
            
            UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentImageView.frame), 10, 70, 20)];
            commentLabel.font = [UIFont systemFontOfSize:14];
            commentLabel.textColor = colorWithHex(0x999999);
            commentLabel.text = [NSString stringWithFormat:@"评论(%d)",self.dataManager.commentList.count];
            [view addSubview:commentImageView];
            [view addSubview:commentLabel];
            [cell.contentView addSubview:view];
            return cell;
            
        }
        else
        {
            //赞头像列表
            static NSString* Identifier = @"IconCell";
            UserHeadTableCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if(cell == nil)
            {
                cell = [[UserHeadTableCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
                
            }
            cell.delegate = self;
            cell.userInteractionEnabled = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.friendList = _dataManager.supportList;
            return cell;
        }
    }
    else
    {
        //评论列表
        static NSString* Identifier = @"commentCell";
        CommentCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if(cell == nil)
        {
            cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        }
        cell.comment = [_dataManager.commentList objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self customLine:cell withHeight:0.5 withY:0 withColor:0xCCCCCC];
        return cell;
    }
}

- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section
{
        static NSString *IndenterId = @"IndenterId";
        UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:IndenterId];
        if (view == nil)
        {
            view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, 280, 20)];
        }
        view.contentView.backgroundColor = [UIColor redColor];
        return view;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            if (_feed.feedsType == FeedsUserPost)
            {
                return 135;
            }
            else
            {
                return 110;
            }
            return 110;
        }
        else if (1 == indexPath.row)
        {
            return 40;
        }
        else
        {
            return 55;
        }
    }
    else
    {
        return 80;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectZero];
    return v;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2)
    {
        SupportListViewController *support = [[SupportListViewController alloc] initWithNibName:NSStringFromClass([SupportListViewController class]) bundle:nil];
        support.supportArray = self.dataManager.supportDetailArray;
        [self.navigationController pushViewController:support animated:YES];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [self back];
    }
}

#pragma mark - 
#pragma mark - PullingRefreshTableViewDelegate
//顶部下拉
#if 1
- (void)pullingTableViewDidStartRefreshing:(PullRefreshTableView *)tableView{
    [self.dataManager.commentList removeAllObjects];
    [self.dataManager.supportList removeAllObjects];
    [self.dataManager loadData];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [NSDate date];
}

- (void)pullingTableViewDidStartLoading:(PullRefreshTableView *)tableView{
//    [self.dataManager loadData];
    
}
#endif

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.commentTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.commentTableView tableViewDidEndDragging:scrollView];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

- (UIView *)configHeaderCellAtSection:(int)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    
    [view addSubview:icon];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = colorWithHex(0x999999);
    [view addSubview:label];
    
    UIImageView *icon2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [view addSubview:icon2];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = colorWithHex(0x999999);
    [view addSubview:line];
    
    if (section == 0) {
//        label.text = [NSString stringWithFormat:@"赞%d",self.article.likeNum];
        label.text = [NSString stringWithFormat:@"赞(%d)",self.dataManager.supportList.count];
        CGSize size = CGSizeZero;
        if (isSystemVersionIOS7()) {
            size = [label.text boundingRectWithSize:CGSizeMake(280 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil].size;
        }else{
            size = [label.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        }
        label.width = size.width;
        icon.image = [UIImage imageNamed:@"btn_feed_support_n"];
        icon2.image = [UIImage imageNamed:@"img_support.png"];
        icon2.width = 20;
        icon2.x = 300 - 20;
        icon2.height = 20;
        icon2.y = 10;
        line.width = 300 - CGRectGetMaxX(label.frame) - 22;
        line.height = 1;
        line.y = 20;
        line.x = CGRectGetMaxX(label.frame);
        
    }else{
//        label.text = [NSString stringWithFormat:@"评论%d",self.article.commentNum];
        label.text = [NSString stringWithFormat:@"评论(%d)",self.dataManager.commentList.count];
        CGSize size = CGSizeZero;
        if (isSystemVersionIOS7()) {
            size = [label.text boundingRectWithSize:CGSizeMake(280 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil].size;
        }else{
            size = [label.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        }
        label.width = size.width;
        icon.image = [UIImage imageNamed:@"icon_comment.png"];
        icon2.image = [UIImage imageNamed:@"img_comment.png"];
        icon2.width = 40;
        icon2.x = 280 - 20;
        icon2.height = 20;
        icon2.y = 10;
        line.width = 297 - CGRectGetMaxX(label.frame) - 40;
        line.height = 1;
        line.y = 20;
        line.x = CGRectGetMaxX(label.frame);
    }
    
    return view;
}
#if 1
#pragma mark - DataManagerDelegate
- (void)getCommentListSuccess:(CommentsListDataManager *)dataManager
{
    [self noCommentBottonImageViewAction];
    [self.commentTableView reloadData];
    [self.commentTableView tableViewDidFinishedLoading];
}

- (void)getCommentListFailed:(CommentsListDataManager *)dataManager
{
    [self.commentTableView tableViewDidFinishedLoading];
}

- (void)addNewCommentSuccess:(CommentsListDataManager *)dataManager
{
    _commentInputField.text = @"";
    [self.commentTableView reloadData];
    [self.commentTableView tableViewDidFinishedLoading];
}

- (void)addNewCommentFailed:(CommentsListDataManager *)dataManager
{
    [self.commentTableView tableViewDidFinishedLoading];
}
#endif

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
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.commentInputView.y = self.view.height - keyboardRect.size.height - self.commentInputView.height;
    }];
    
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
        self.commentInputView.y = self.view.height-self.commentInputView.height;
    } completion:^(BOOL finished) {
        //        [self.commentInputContainView removeFromSuperview];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendCommentAction:nil];
    keyBoradUp = !keyBoradUp;
    return YES;
}

-(void)makeAlertViewHidden
{
//    UIAlertView *alert = (UIAlertView *)[self.view viewWithTag:TIPALERTVIEWTAG];
    [tipAlertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
