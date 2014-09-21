//
//  CircleMessageListViewController.m
//  WeLinked4
//
//  Created by floar on 14-5-28.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "CircleMessageListViewController.h"
#import "Feed.h"

@interface CircleMessageListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *messageListArray;
}

@property (weak, nonatomic) IBOutlet UITableView *messageListTableView;

@end

@implementation CircleMessageListViewController

@synthesize messageListTableView;

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
    [self.navigationItem setTitleString:@"消息管理"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"] imageSelected:[UIImage imageNamed:@"backSelected"] title:nil inset:UIEdgeInsetsMake(0, -20, 0, 0) target:self selector:@selector(gotoBack)];
    [self.navigationItem setRightBarButtonItem:nil imageSelected:nil title:@"清空" inset:UIEdgeInsetsZero target:self selector:@selector(makeMessageListEmpty)];
    
    messageListTableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    
    if (messageListArray == nil)
    {
        messageListArray = [[NSMutableArray alloc] init];
    }
    
    [self loadDataFromDB];

}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
    //    return careArray;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    [self customNormalCell:cell withUserInfo:nil];
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

-(void)customNormalCell:(UITableViewCell *)cell withUserInfo:(Feed *)feed
{
    
    UIImageView *lineImage = (UIImageView *)[cell.contentView viewWithTag:20];
    if (lineImage == nil)
    {
        lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 1, 70)];
        lineImage.tag = 20;
        lineImage.image = [UIImage imageNamed:@"img_line"];
        [cell.contentView addSubview:lineImage];
    }
    
    UIImageView *timeImage = (UIImageView *)[cell.contentView viewWithTag:10];
    if (timeImage == nil)
    {
        timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
        timeImage.tag = 10;
        timeImage.image = [UIImage imageNamed:@"img_time"];
        [cell.contentView addSubview:timeImage];
    }
    
    UILabel *timeLable = (UILabel *)[cell.contentView viewWithTag:70];
    if (timeLable == nil)
    {
        timeLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 40, 20)];
        timeLable.tag = 70;
        timeLable.textColor = [UIColor whiteColor];
        timeLable.textAlignment = NSTextAlignmentCenter;
        timeLable.font = getFontWith(NO, 10);
        [timeImage addSubview:timeLable];
    }
    
    timeLable.text = @"12月31";
}


#pragma mark - 数据处理
-(void)loadDataFromNetWork
{
    
}

-(void)loadDataFromDB
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
-(void)makeMessageListEmpty
{
    
}

-(void)gotoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)getTime:(NSTimeInterval)timeInterval
{
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *todayString = [formatter stringFromDate:todayDate];
    
    NSDate *networkDate = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    NSString *networkString = [formatter stringFromDate:networkDate];
    
    if ([todayString isEqualToString:networkString])
    {
        [formatter setDateFormat:@"HH:mm"];
        todayString = [formatter stringFromDate:todayDate];
        return todayString;
    }
    else
    {
        NSString *resultDateString = [self changeTimeFormatter:networkString];
        return resultDateString;
    }
}

-(NSString *)changeTimeFormatter:(NSString *)timeString
{
    NSMutableString *tempStr = [NSMutableString stringWithString:timeString];
    NSRange range = [tempStr rangeOfString:@"月"];
    if (range.location != NSNotFound)
    {
        if ([tempStr characterAtIndex:range.location+1] == '0')
        {
            [tempStr deleteCharactersInRange:NSMakeRange(range.location+1, range.length)];
        }
        if ([tempStr characterAtIndex:range.location-2] == '0')
        {
            [tempStr deleteCharactersInRange:NSMakeRange(range.location-2, range.length)];
        }
    }
    return tempStr;
}


@end
