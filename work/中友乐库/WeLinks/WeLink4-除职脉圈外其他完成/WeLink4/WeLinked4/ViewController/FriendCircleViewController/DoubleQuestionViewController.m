//
//  DoubleQuestionViewController.m
//  WeLinked4
//
//  Created by floar on 14-5-26.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "DoubleQuestionViewController.h"
#import "VisualRangeViewController.h"
#import "UIPlaceHolderTextView.h"
#import "TagsViewController.h"
#import "NetworkEngine.h"
#import "Tag.h"

#define FontSize 15

@interface DoubleQuestionViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    double lastContentOffset;
    UITextField *textField;
    int allowedFriend;
    
    UILabel *subTitleLabel;
    
    NSMutableArray *ownTagsArray;
    NSMutableArray *ownTagsIdArray;
    NSMutableDictionary *answerDict;
    NSMutableDictionary *pollOptionDict;
}

@property (weak, nonatomic) IBOutlet UITableView *doubleTableView;

@property (nonatomic, strong) UIPlaceHolderTextView *placeHolerText;
@property (nonatomic, strong) UILabel *contentNumLabel;

@end

@implementation DoubleQuestionViewController
@synthesize doubleTableView,placeHolerText,contentNumLabel;

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
    [self.navigationItem setRightBarButtonItem:nil imageSelected:nil title:@"下一步" inset:UIEdgeInsetsZero target:self selector:@selector(nextStep)];
    
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

-(void)selectedAction:(NSNotification *)note
{
    NSString *str = (NSString *)[note object];
    NSLog(@"可见：%@",str);
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

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 1)
    {
        return 1;
    }
    else
    {
        return 2;
    }
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self customAnswerCell:cell index:indexPath];
    }
    if (indexPath.section == 2)
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
    if (indexPath.section == 2)
    {
        VisualRangeViewController *visualCtl = [[VisualRangeViewController alloc] initWithNibName:NSStringFromClass([VisualRangeViewController class]) bundle:nil];
        visualCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:visualCtl animated:YES];
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
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    else
    {
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(void)customAnswerCell:(UITableViewCell *)cell index:(NSIndexPath *)indexPath
{
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:10];
    if (titleLabel == nil)
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
        titleLabel.tag = 10;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = [NSString stringWithFormat:@"答案%d",indexPath.row+1];
        titleLabel.font = getFontWith(NO, FontSize);
        [cell.contentView addSubview:titleLabel];
    }
    
    textField = (UITextField *)[cell.contentView viewWithTag:20+indexPath.row];
    if (textField == nil)
    {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+20, CGRectGetMinY(titleLabel.frame), 200, 20)];
        textField.tag = 20+indexPath.row;
        textField.placeholder = @"必填";
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        if (textField.tag == 20)
        {
            textField.returnKeyType = UIReturnKeyNext;
        }
        else
        {
            textField.returnKeyType = UIReturnKeyDone;
        }
        [cell.contentView addSubview:textField];
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
    
    if (index.section == 2)
    {
        titleLabel.text = @"可见范围";
        subTitleLabel.text = @"3度好友可见";
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITextField *answer1 = (UITextField *)[self.view viewWithTag:20];
    UITextField *answer2 = (UITextField *)[self.view viewWithTag:21];
    if (scrollView.contentOffset.y != lastContentOffset)
    {
        [placeHolerText resignFirstResponder];
        [answer1 resignFirstResponder];
        [answer2 resignFirstResponder];
    }
}

//#pragma mark - UITextFiledDelegate
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if ([textField.text isEqualToString:@""] || textField.text.length == 0 || textField.text == nil)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"输入不能为空"   delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//    }
//    return YES;
//}

#pragma mark - UINavigationBarBtnAction
-(void)gotoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextStep
{
    BOOL next = YES;
    if (placeHolerText.text == nil || placeHolerText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"提问问题不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        next = NO;
    }
    
    UITextField *answer1 = (UITextField *)[self.view viewWithTag:20];
    UITextField *answer2 = (UITextField *)[self.view viewWithTag:21];
    
    if (answer1.text == nil || answer1.text.length == 0 || answer2.text == nil || answer2.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"答案不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
            
            [answerDict removeAllObjects];
            [answerDict setObject:answer1.text forKey:@"1"];
            [answerDict setObject:answer2.text forKey:@"2"];
            
            [pollOptionDict removeAllObjects];
            [pollOptionDict setObject:answerDict forKey:@"pollOptions"];
    
//    [ownTagsArray addObject:@"App"];
//    [ownTagsArray addObject:@"理财"];
//    [ownTagsArray addObject:@"社交"];
//    [ownTagsArray addObject:@"网络"];
//    [ownTagsArray addObject:@"美女"];
//    
//    [ownTagsIdArray addObject:@"1"];
//    [ownTagsIdArray addObject:@"2"];
//    [ownTagsIdArray addObject:@"3"];
//    [ownTagsIdArray addObject:@"4"];
//    [ownTagsIdArray addObject:@"5"];
    
            TagsViewController *tags = [[TagsViewController alloc] initWithNibName:NSStringFromClass([TagsViewController class]) bundle:nil];
                        
            tags.tagsArray = ownTagsArray;
            tags.tagsIDArray = ownTagsIdArray;
            tags.content = placeHolerText.text;
            tags.allowedFriend = allowedFriend;
            tags.pollOptions = pollOptionDict;
            tags.typeId = 22;
            
            [self.navigationController pushViewController:tags animated:YES];
        }];
    }
}

@end
