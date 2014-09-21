//
//  RecommendFriendListViewController.m
//  WeLinked3
//
//  Created by 牟 文斌 on 3/22/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "RecommendFriendListViewController.h"
#import "SelectFriendCell.h"
#import "UINavigationBar+Loading.h"
#import "NetworkEngine.h"

@interface RecommendFriendListViewController ()<SelectFriendCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel1;

@property (weak, nonatomic) IBOutlet UILabel *jobTitle
;
@property (weak, nonatomic) IBOutlet EGOImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *poster;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *recommendFriendNum;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic, strong) NSMutableArray *selectFriendList;
@property (nonatomic, strong) NSMutableArray *friendList;
@property (weak, nonatomic) IBOutlet UIView *selectContainView;

@end

@implementation RecommendFriendListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitleViewWithText:@"职位推荐"];
    
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back:)];
    [self.navigationController.navigationBar showLoadingIndicator];
    
    self.footerView.hidden = YES;
    
    self.tableView.hidden = YES;
    self.selectFriendList = [NSMutableArray array];
    self.friendList = [NSMutableArray array];
    
    [[NetworkEngine sharedInstance] getPublishJobFriendListWithJobID:self.jobID Block:^(int event, id object) {
        [self.navigationController.navigationBar hideLoadingIndicator];
        if (1 == event) {
            self.tableView.hidden = NO;
            self.footerView.hidden = NO;
            for (NSDictionary *dic in object) {
                UserInfo *user = [[UserInfo alloc] init];
                [user setValuesForKeysWithDictionary:dic];
                [self.friendList addObject:user];
            }
            self.selectFriendList = [NSMutableArray arrayWithArray:self.friendList];
            [self.tableView reloadData];
        }
    }];
    
    [[NetworkEngine sharedInstance] getJobDetailWithJobID:self.jobID Block:^(int event, id object)
     {
         //        [self.navigationController.navigationBar hideLoadingIndicator];
         [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
         if(event == 0)
         {
         }
         else if (event == 1)
         {
             JobInfo *jobInfo = [[JobInfo alloc]init];
             [jobInfo setValuesForKeysWithDictionary:object];
             
             JobObject *job = [[LogicManager sharedInstance] getPublicObject:jobInfo.jobCode type:Job];
             
             self.iconImage.imageURL =[NSURL URLWithString: [object objectForKey:@"posterAvatar"] ];
             self.jobTitle.text = job.name;
             self.poster.text = [NSString stringWithFormat:@"发布人%@",[object objectForKey:@"poster"]];
             self.tipsLabel1.text = [NSString stringWithFormat:@"帮%@推荐候选人",[object objectForKey:@"poster"]];
             
         }
     }];
    
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGusture)];
    [self.selectContainView addGestureRecognizer:tapGusture];
    
    _selectAllButton.selected = YES;
}

- (void)dealloc
{
    self.friendList = nil;
    self.selectFriendList = nil;
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
    [[NetworkEngine sharedInstance] recommendToFriend:_selectFriendList recommendID:_jobID isInternalRecommend:NO FromCompany:NO isFirstRecommend:NO Block:^(int event, id object) {
        DLog(@"职位发布结果 %@",object);
        if (1 == event) {
            MBProgressHUD *progressView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            progressView.mode = MBProgressHUDModeCustomView;
            progressView.labelText = @"发送成功";
            progressView.completionBlock = ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            [progressView hide:YES afterDelay:1];
            //                [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
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

- (void)tapGusture
{
    [self selectAll:_selectAllButton];
}

@end
