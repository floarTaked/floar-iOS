//
//  WhoSeeMeViewController.m
//  WeLinked4
//
//  Created by floar on 14-5-16.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "WhoSeeMeViewController.h"
#import "UINavigationItemCustom.h"
#import "NetworkEngine.h"
#import "UserInfo.h"
#import "LogicManager.h"

@interface WhoSeeMeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *careArray;
}

@property (weak, nonatomic) IBOutlet UITableView *careTableView;

@end

@implementation WhoSeeMeViewController

@synthesize careTableView;

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
    [self.navigationItem setTitleString:@"谁看过我"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"] imageSelected:[UIImage imageNamed:@"backSelected"] title:nil inset:UIEdgeInsetsMake(0, -20, 0, 0) target:self selector:@selector(goToBack)];
    careTableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    
    if (careArray == nil)
    {
        careArray = [[NSMutableArray alloc] init];
    }
    
    [self loadDataFromDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据处理
-(void)loadDataFromNetWork
{
    [[NetworkEngine sharedInstance] getVisitorInfo:@"1" limit:@"6" block:^(int event, id object)
    {
        if (0 == event)
        {
            [self loadDataFromDB];
        }
        else if (1 == event)
        {
            careArray = object;
            [careTableView reloadData];
        }
    }];
}

-(void)loadDataFromDB
{
    NSArray *dbArray = [[UserDataBaseManager sharedInstance] queryWithClass:[UserInfo class]
                                               tableName:VisitorFriends
                                               condition:[NSString stringWithFormat:@" where DBUid = %d",[UserInfo myselfInstance].userId]];
    if (dbArray != nil && dbArray.count > 0)
    {
        careArray = (NSMutableArray *)dbArray;
    }
    [self loadDataFromNetWork];
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
//    UserInfo *userInfo = [careArray objectAtIndex:indexPath.row];
//    if(userInfo != nil)
//    {
//        self.hidesBottomBarWhenPushed = YES;
//        [[LogicManager sharedInstance] gotoProfile:self userId:userInfo.userId];
//    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)customNormalCell:(UITableViewCell *)cell withUserInfo:(UserInfo *)visitor
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
    
    
    
    EGOImageView *avatorImage = (EGOImageView *)[cell.contentView viewWithTag:30];
    if (avatorImage == nil)
    {
        avatorImage = [[EGOImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeImage.frame)+20, 10, 50, 50)];
        avatorImage.tag = 20;
        avatorImage.placeholderImage = [UIImage imageNamed:@"defaultHead"];
        [cell.contentView addSubview:avatorImage];
    }
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:40];
    if (nameLabel == nil)
    {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatorImage.frame)+10, CGRectGetMinY(avatorImage.frame)+2, 200, 15)];
        nameLabel.tag = 40;
        nameLabel.font = getFontWith(NO, 15);
        [cell.contentView addSubview:nameLabel];
    }
    
    UILabel *jobLabel = (UILabel *)[cell.contentView viewWithTag:50];
    if (jobLabel == nil)
    {
        jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatorImage.frame)+10, CGRectGetMaxY(nameLabel.frame)+2, 200, 15)];
        jobLabel.tag = 50;
        jobLabel.font = getFontWith(NO, 12);
        jobLabel.textColor =  colorWithHex(0xAAAAAA);
        [cell.contentView addSubview:jobLabel];
    }
    
    UILabel *companyLable = (UILabel *)[cell.contentView viewWithTag:60];
    if (companyLable == nil)
    {
        companyLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatorImage.frame)+10, CGRectGetMaxY(jobLabel.frame)+2, 200, 15)];
        companyLable.tag = 40;
        companyLable.font = getFontWith(NO, 12);
        companyLable.textColor =  colorWithHex(0xAAAAAA);
        [cell.contentView addSubview:companyLable];
    }
    
    if (visitor != nil)
    {
        avatorImage.imageURL = [NSURL URLWithString:visitor.avatar];
        timeLable.text = [self getTime:visitor.createTime];
        nameLabel.text = visitor.name;
        jobLabel.text = visitor.jobCode;
        companyLable.text = visitor.company;
    }
    else
    {
        timeLable.text = @"12月31";
        avatorImage.imageURL = [NSURL URLWithString:visitor.avatar];
//        timeLable.text = @"23:59";
        nameLabel.text = @"你妹妹";
        jobLabel.text = @"你妹妹工作";
        companyLable.text = @"你妹妹.com.baidu.com";
    }
}


#pragma mark - 其他
-(void)goToBack
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
