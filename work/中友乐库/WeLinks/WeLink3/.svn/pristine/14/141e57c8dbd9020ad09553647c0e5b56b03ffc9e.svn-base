//
//  SelectFriendViewController.m
//  WeLinked3
//
//  Created by 牟 文斌 on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "SelectFriendViewController.h"
#import "SelectFriendCell.h"
#import "UserInfo.h"
#import "UINavigationBar+Loading.h"
#import "NetworkEngine.h"
#import "AddFriendsViewController.h"
#import "JobDetailViewViewController.h"

@interface SelectFriendViewController ()<SelectFriendCellDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendFriendNum;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic, strong) NSMutableArray *selectFriendList;
@property (nonatomic, strong) NSMutableArray *friendList;
@property (weak, nonatomic) IBOutlet UIView *selectContainView;
@property (strong, nonatomic) IBOutlet UIView *noFriendView;
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;


- (IBAction)confirm:(id)sender;
- (IBAction)selectAll:(id)sender;
- (IBAction)addNewFriend:(id)sender;

@end

@implementation SelectFriendViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back:)];
    [self.navigationController.navigationBar showLoadingIndicator];
    
    self.selectionView.hidden = YES;
    self.footerView.hidden = YES;
    
    self.tableView.hidden = YES;
    self.selectFriendList = [NSMutableArray array];
    self.friendList = [NSMutableArray array];
    if (_type == SelectFriendViewTypePublishJob) {
        [self.navigationItem setTitleViewWithText:@"职位求推荐"];
        [[NetworkEngine sharedInstance] getPublishJobFriendListWithJobID:self.jobInfo.identity Block:^(int event, id object) {
            [self.navigationController.navigationBar hideLoadingIndicator];
            if (1 == event) {
                self.tipsLabel.text = @"职位发布成功!";
                self.tableView.hidden = NO;
                for (NSDictionary *dic in object) {
                    UserInfo *user = [[UserInfo alloc] init];
                    [user setValuesForKeysWithDictionary:dic];
                    [self.friendList addObject:user];
                }
                if (self.friendList.count) {
                    self.selectionView.hidden = NO;
                    self.footerView.hidden = NO;
                    self.selectFriendList = [NSMutableArray arrayWithArray:self.friendList];
                    self.recommendFriendNum.text = [NSString stringWithFormat:@"有%d位朋友可以帮到你。",self.friendList.count];
                }else{
//                    self.recommendFriendNum.text = @"暂时没有朋友可以帮到你哦！";
                    self.tableView.hidden = YES;
                    [self.view addSubview:self.noFriendView];
                }
                [self.tableView reloadData];
            }
            
            DLog(@"发布职位好友列表%@",object);
        }];
    }else{
        [[NetworkEngine sharedInstance] getInternalRecommendFriendListWithRecommend:self.recommendInfo Block:^(int event, id object) {
            [self.navigationItem setTitleViewWithText:@"求内推"];
            
            [self.recommendButton setImage:[UIImage imageNamed:@"btn_internal_recommend_n.png"] forState:UIControlStateNormal];
            [self.recommendButton setImage:[UIImage imageNamed:@"btn_internal_recommend_h.png"] forState:UIControlStateHighlighted];
            [self.navigationController.navigationBar hideLoadingIndicator];
            if (1 == event) {
                self.tableView.hidden = NO;
                self.tipsLabel.text = @"职脉已经筛选出";
                self.tipsLabel.hidden = YES;
                for (NSDictionary *dic in object) {
                    UserInfo *user = [[UserInfo alloc] init];
                    [user setValuesForKeysWithDictionary:dic];
                    [self.friendList addObject:user];
                }
                if (self.friendList.count) {
                    self.selectionView.hidden = NO;
                    self.footerView.hidden = NO;
                    self.selectFriendList = [NSMutableArray arrayWithArray:self.friendList];
                    self.recommendFriendNum.text = @"请选择帮你内推的朋友！";//[NSString stringWithFormat:@"%d位朋友可以帮你内推！",self.friendList.count];
                }else{
                    self.recommendFriendNum.text = @"暂时没有朋友可以帮你内推哦！";
                }
                self.recommendFriendNum.y = self.tipsLabel.y;
                self.recommendFriendNum.height = self.icon.height;
                [self.tableView reloadData];
            }
            DLog(@"内推好友列表%@",object);
            
        }];
    }
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGusture)];
    [self.selectContainView addGestureRecognizer:tapGusture];
    
    _selectAllButton.selected = YES;
}

- (void)dealloc
{
    self.friendList = nil;
    self.selectFriendList = nil;
    self.jobInfo = nil;
    self.recommendInfo = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.friendList.count) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.friendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectFriendCell";
    SelectFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SelectFriendCell class]) owner:self options:nil] lastObject];
        //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.delegate = self;
    // Configure the cell...
    cell.userInfo = [self.friendList objectAtIndex:indexPath.row];
    if ([self.selectFriendList containsObject:cell.userInfo]) {
        cell.selectFriend = YES;
    }else{
        cell.selectFriend = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
//    UserInfo *user = [self.friendList objectAtIndex:indexPath.row];
//     [[LogicManager sharedInstance] gotoProfile:self userId:user.userId];
    SelectFriendCell *cell = (SelectFriendCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectFriend = !cell.selectFriend;
    [self selectCell:cell];
}
 

- (void)selectCell:(SelectFriendCell *)cell
{
    if (![self.selectFriendList containsObject:cell.userInfo]) {
        [self.selectFriendList addObject:cell.userInfo];
    }else{
        [self.selectFriendList removeObject:cell.userInfo];
        _selectAllButton.selected = NO;
    }
}


- (IBAction)confirm:(id)sender
{
    self.recommendButton.enabled = NO;
    if (_type == SelectFriendViewTypeInternalRecommend) {
        [MobClick event:SOCIAL4];
        if (self.jobInfo) {
            [[NetworkEngine sharedInstance] recommendToFriend:_selectFriendList recommendID:_jobInfo.identity isInternalRecommend:NO FromCompany:YES isFirstRecommend:NO Block:^(int event, id object) {
                DLog(@"公司职位内推 %@",object);
                self.recommendButton.enabled = YES;
                if (1 == event) {
                    MBProgressHUD *progressView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    progressView.mode = MBProgressHUDModeCustomView;
                    progressView.labelText = @"发送成功";
                    progressView.completionBlock = ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    };
                    [progressView hide:YES afterDelay:1];
                }
            }];
        }else{
            [[NetworkEngine sharedInstance] recommendToFriend:_selectFriendList recommendID:_recommendInfo.identity isInternalRecommend:YES FromCompany:NO isFirstRecommend:NO Block:^(int event, id object) {
                DLog(@"内推结果%@",object);
                self.recommendButton.enabled = YES;
                if (1 == event) {
                    MBProgressHUD *progressView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    progressView.mode = MBProgressHUDModeCustomView;
                    progressView.labelText = @"发送成功";
                    progressView.completionBlock = ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    };
                    [progressView hide:YES afterDelay:1];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
        
    }else{
        [MobClick event:SOCIAL3];
        [[NetworkEngine sharedInstance] recommendToFriend:_selectFriendList recommendID:_jobInfo.identity isInternalRecommend:NO FromCompany:NO isFirstRecommend:YES Block:^(int event, id object) {
            DLog(@"职位发布结果 %@",object);
            self.recommendButton.enabled = YES;
            if (1 == event) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"把职位分享到社交网络\n 能增加简历投递" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
//                [alertView show];
                MBProgressHUD *progressView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                progressView.mode = MBProgressHUDModeCustomView;
                progressView.labelText = @"发送成功";
                progressView.completionBlock = ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                };
                [progressView hide:YES afterDelay:1];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

- (IBAction)selectAll:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        [_selectFriendList removeAllObjects];
        [_selectFriendList addObjectsFromArray:_friendList];
        [self.tableView reloadData];
    }else{
        [_selectFriendList removeAllObjects];
        [self.tableView reloadData];
    }
}

- (IBAction)addNewFriend:(id)sender
{
    AddFriendsViewController *addFriendView = [[AddFriendsViewController alloc] init];
    [self.navigationController pushViewController:addFriendView animated:YES];
}

- (void)tapGusture
{
    [self selectAll:_selectAllButton];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
//        分享到微博
        JobDetailViewViewController *jobDetailView = [[JobDetailViewViewController alloc] init];
        jobDetailView.jobIdentity = _jobInfo.identity;
        jobDetailView.needShowShareView = YES;
        [self.navigationController pushViewController:jobDetailView animated:YES];
    }else{
        
    }
}
@end
