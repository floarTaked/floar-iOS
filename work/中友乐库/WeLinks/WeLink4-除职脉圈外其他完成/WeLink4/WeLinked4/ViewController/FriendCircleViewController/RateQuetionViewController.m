//
//  RateQuetionViewController.m
//  WeLinked4
//
//  Created by floar on 14-5-26.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "RateQuetionViewController.h"
#import "VisualRangeViewController.h"
#import "UIPlaceHolderTextView.h"
#import "NetworkEngine.h"
#import "TagsViewController.h"
#import "Tag.h"

#define FontSize 14

@interface RateQuetionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int allowedFriend;
    UILabel *subTitleLabel;
    
    NSMutableArray *ownTagsArray;
    NSMutableArray *ownTagsIdArray;
    NSMutableDictionary *answerDict;
    NSMutableDictionary *pollOptionDict;
}

@property (weak, nonatomic) IBOutlet UITableView *rateTableView;

@property (nonatomic, strong) UIPlaceHolderTextView *placeHolerText;
@property (nonatomic, strong) UILabel *contentNumLabel;
@end

@implementation RateQuetionViewController

@synthesize rateTableView,placeHolerText,contentNumLabel;

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
    [self.navigationItem setTitleString:@"提问"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"] imageSelected:[UIImage imageNamed:@"backSelected"] title:nil inset:UIEdgeInsetsMake(0, -20, 0, 0) target:self selector:@selector(gotoBack)];
    [self.navigationItem setRightBarButtonItem:nil imageSelected:nil title:@"下一步" inset:UIEdgeInsetsZero target:self selector:@selector(nextSep)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedAction:) name:@"selected" object:nil];
    
    allowedFriend = 3;
    
    ownTagsArray = [[NSMutableArray alloc] init];
    ownTagsIdArray = [[NSMutableArray alloc] init];
    answerDict = [[NSMutableDictionary alloc] init];
    pollOptionDict = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (indexPath.section == 0)
    {
        placeHolerText = (UIPlaceHolderTextView *)[cell.contentView viewWithTag:90];
        if (placeHolerText == nil)
        {
            placeHolerText = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
            placeHolerText.tag = 90;
            placeHolerText.placeholder = @"写下你的问题...";
            placeHolerText.font = getFontWith(NO, 14);
            
            [cell.contentView addSubview:placeHolerText];
        }
        
        contentNumLabel = (UILabel *)[cell.contentView viewWithTag:100];
        if (contentNumLabel == nil)
        {
            contentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-40, 120-20, 40, 20)];
            contentNumLabel.tag = 100;
            contentNumLabel.textAlignment = NSTextAlignmentCenter;
            contentNumLabel.font = getFontWith(NO, 8);
            contentNumLabel.textColor = colorWithHex(0x999999);
            contentNumLabel.text = @"0/200";
            [cell.contentView addSubview:contentNumLabel];
        }
    }
    
    if (indexPath.section == 1)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self customNormalCell:cell index:indexPath];
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        VisualRangeViewController *visualCtl = [[VisualRangeViewController alloc] initWithNibName:NSStringFromClass([VisualRangeViewController class]) bundle:nil];
        visualCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:visualCtl animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
        titleLabel.text = @"问题将自动添加5星评级选项";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = getFontWith(NO, 11);
        titleLabel.textColor = [UIColor lightGrayColor];
        [view addSubview:titleLabel];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), CGRectGetMinY(titleLabel.frame)+3.5, 69, 12)];
        image.image = [UIImage imageNamed:@"img_rate"];
        [view addSubview:image];
        return view;
    }
    else
    {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 120;
    }
    else
    {
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    else if (section == 1)
    {
        return 30;
    }
    else
    {
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 5;
    }
    else
    {
        return 0.1;
    }
}

-(void)customNormalCell:(UITableViewCell *)cell index:(NSIndexPath *)index
{
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:10];
    if (titleLabel == nil)
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
        titleLabel.tag = 30;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = getFontWith(NO, FontSize);
        [cell.contentView addSubview:titleLabel];
    }
    
    subTitleLabel = (UILabel *)[cell.contentView viewWithTag:10];
    if (subTitleLabel == nil)
    {
        subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, 10, 100, 20)];
        subTitleLabel.tag = 40;
        subTitleLabel.textAlignment = NSTextAlignmentLeft;
        subTitleLabel.font = getFontWith(NO, FontSize);
        subTitleLabel.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:subTitleLabel];
    }
    
    if (index.section == 1)
    {
        titleLabel.text = @"可见范围";
        subTitleLabel.text = @"3度好友可见";
    }
}


#pragma mark - UINavigationBarBtnAction
-(void)gotoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextSep
{
    BOOL next = YES;
    
    if (placeHolerText.text == nil || placeHolerText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"提问的问题不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        next = NO;
    }
    
    if (next)
    {
        [ownTagsArray removeAllObjects];
        [ownTagsIdArray removeAllObjects];
        [[NetworkEngine sharedInstance] getFeedTags:placeHolerText.text block:^(int event, id object)
         {
             
             if (1 == event)
             {
                 NSMutableArray *array = (NSMutableArray *)object;
                 for (Tag *tag in array)
                 {
                     [ownTagsArray addObject:tag.title];
                     [ownTagsIdArray addObject:[NSNumber numberWithDouble:tag.tagId]];
                 }
             }
                          
             TagsViewController *tags = [[TagsViewController alloc] initWithNibName:NSStringFromClass([TagsViewController class]) bundle:nil];
             tags.tagsArray = ownTagsArray;
             tags.tagsIDArray = ownTagsIdArray;
             tags.content = placeHolerText.text;
             tags.allowedFriend = allowedFriend;
             tags.typeId = 23;
             tags.pollOptions = nil;
             
             [self.navigationController pushViewController:tags animated:YES];
         }];
    }
}

#pragma mark - Action
-(void)selectedAction:(NSNotification *)note
{
    NSString *str = (NSString *)[note object];
    subTitleLabel.text = str;
    if ([str isEqualToString:@"一度好友可见"])
    {
        allowedFriend = 1;
    }
    else if ([str isEqualToString:@"二度好友可见"])
    {
        allowedFriend = 2;
    }
    else
    {
        allowedFriend = 3;
    }
    NSLog(@"%@",[NSNumber numberWithInt:allowedFriend]);
}

@end
