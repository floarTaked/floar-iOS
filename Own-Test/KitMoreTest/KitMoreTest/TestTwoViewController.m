//
//  TestTwoViewController.m
//  KitMoreTest
//
//  Created by floar on 14-6-12.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "TestTwoViewController.h"
#import <SVProgressHUD.h>

#import "Feed.h"
#import "Comment.h"

#define chatCellHeight 80
#define ContentCellHeight 100


@interface TestTwoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;


@end

@implementation TestTwoViewController

@synthesize chatTableView;

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
    dataArray = [[NSMutableArray alloc] init];
    
    [self loadDate];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Feed *feed = [dataArray objectAtIndex:section];
    return feed.commentArray.count+2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *feed = [dataArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0)
    {
        static NSString *contentInden = @"content";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentInden];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentInden];
        }
        [self customContentCell:cell feed:feed];
        return cell;
    }
    else if (indexPath.row == feed.commentArray.count+1)
    {
        static NSString *chatCell = @"chat";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCell];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatCell];
        }
        [self customChatActionCell:cell];
        return cell;
    }
    else
    {
        static NSString *commentCell = @"comment";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCell];
        }
        Comment *comment = [feed.commentArray objectAtIndex:indexPath.row-1];
        [self customCommentCell:cell comment:comment];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *feed = [dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0)
    {
        return ContentCellHeight;
    }
    else if (indexPath.row == feed.commentArray.count + 1)
    {
        return chatCellHeight;
    }
    else
    {
        Comment *comment = [feed.commentArray objectAtIndex:indexPath.row - 1];
        CGSize size = [comment.commentString boundingRectWithSize:CGSizeMake(290, 2000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil].size;
        return size.height+10;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    return view;
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

-(void)customChatActionCell:(UITableViewCell *)cell
{
    for (int i = 0; i < 2; i++)
    {
        UIButton *btn = (UIButton *)[cell.contentView viewWithTag:100+i];
        if (btn == nil)
        {
            btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(15+(140+10)*i, 10, 140, 60);
            btn.tag = 100 + i;
            btn.backgroundColor = [UIColor redColor];
            [btn addTarget:self action:@selector(chatViewAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
    }
}

-(void)customCommentCell:(UITableViewCell *)cell comment:(Comment *)comment
{
    UILabel *commentLabel = (UILabel *)[cell.contentView viewWithTag:90];
    
    CGSize commentSize = [comment.commentString boundingRectWithSize:CGSizeMake(290, 2000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil].size;
    
    if (commentLabel == nil)
    {
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 290, commentSize.height)];
        commentLabel.font = [UIFont systemFontOfSize:14];
        commentLabel.tag = 90;
        commentLabel.numberOfLines = 0;
        [cell.contentView addSubview:commentLabel];
    }
    else
    {
        commentLabel.frame = CGRectMake(15, 0, 290, commentSize.height+10);
    }
    
    if (comment != nil)
    {
        commentLabel.text = comment.commentString;
    }
    else
    {
        commentLabel.text = @"空";
    }
    
    
}

-(void)customContentCell:(UITableViewCell *)cell feed:(Feed *)feed
{
    UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:80];
    
    if (contentLabel == nil)
    {
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 290, 90)];
        contentLabel.tag = 80;
        [cell.contentView addSubview:contentLabel];
    }
    if (feed != nil)
    {
        contentLabel.text = feed.contentString;
    }
    
}


#pragma mark - Actions

-(void)loadDate
{
    
    NSArray *tit = @[@"的交付老师的减肥了地方军绿色的交付老师的减肥",@"sdlfsldfjlsjdfkls的交付老师的减肥了地方军绿色的交付老师的减肥",@"分手典礼福建省老地方军绿色的减肥了开始到家里附近的开发的交付老师的减肥了地方军绿色的交付老师的减肥",@"分开老师的减肥了开始的减肥了的交付老师的减肥了地方军绿色的交付老师的减肥",@"方军绿色的交付老师的减肥",@"减肥了地方军绿色的交付老师的减肥",@"的积分时间段飞洛杉矶的分离式的减肥了涉及到开了家连锁店加福禄寿的交付老师就分开的交付老师的减肥了地方军绿色的交付老师的减肥"];
    for (int i = 0; i < 10; i++)
    {
        Feed *feed = [[Feed alloc] init];
        feed.contentString = [NSString stringWithFormat:@"feed内容%d",i];
        for (int j = 0; j < arc4random() %6+1; j++)
        {
            Comment *comment = [[Comment alloc] init];
            comment.commentString = [tit objectAtIndex:(arc4random() % tit.count)%10];
            [feed.commentArray addObject:comment];
        }
        [dataArray addObject:feed];
    }
}

-(void)chatViewAction:(UIButton *)btn
{
    if (btn.tag == 100)
    {
        [SVProgressHUD showWithStatus:@"get it"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }
    else if (btn.tag == 101)
    {
        
    }
}

@end
