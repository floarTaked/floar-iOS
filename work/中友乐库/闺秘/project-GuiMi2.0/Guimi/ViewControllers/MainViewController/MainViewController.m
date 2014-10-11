//
//  MainViewController.m
//  Guimi
//
//  Created by jonas on 9/11/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "MainViewController.h"
#import "LogicManager.h"
#import "AppDelegate.h"
#import "Feed.h"
#import "NetWorkEngine.h"
#import "MainTableViewCellView.h"
#import "MessageViewController.h"
#import "BlurView.h"
#import "ActionAlertView.h"
#import "PublishSecretViewController.h"
#import "DetailSecretViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize mainTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = colorWithHex(BackgroundColor3);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"NoticeNotification" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainServerSuccess) name:connectServerSuccess object:nil];
    
    [self.navigationItem setTitleString:@"闺秘"];
    
    if (0 == [[LogicManager sharedInstance] getPersistenceIntegerWithKey:USERID])
    {
        [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_close_n"]
                                    imageSelected:[UIImage imageNamed:@"btn_close_h"]
                                            title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15)
                                           target:self
                                         selector:@selector(justExperienctBack)];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navCollection_n"]
                                    imageSelected:[UIImage imageNamed:@"btn_navCollection_h"]
                                            title:nil
                                            inset:UIEdgeInsetsMake(0, -15, 0, 15)
                                           target:self
                                         selector:@selector(leftBarBtnAction)];
        
        [self.navigationItem setRightBarButtonItem:[UIImage imageNamed:@"btn_navWriteSecret_n"]
                                     imageSelected:[UIImage imageNamed:@"btn_navWriteSecret_h"]
                                             title:nil inset:UIEdgeInsetsMake(0, 15, 0, -15)
                                            target:self
                                          selector:@selector(rightBarBtnAction)];
    }
    mainTableView.backgroundView = nil;
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.pullingDelegate = self;
    dataSource = [[NSMutableArray alloc]init];
    viewSource = [[NSMutableArray alloc]init];
    minId = 0;
    maxId = 0;
//    MainTableViewContactCellView* contact = (MainTableViewContactCellView*)[[[NSBundle mainBundle]
//                                                                             loadNibNamed:@"MainTableViewCellView"
//                                                                             owner:self options:nil]
//                                                                            objectAtIndex:1];
//    [viewSource addObject:contact];
//    [dataSource addObject:[NSNull null]];
    
    [self resetDataBaseState];
    [self loadMoreFromDataBase:^(int event, id object)
    {
        [mainTableView reloadData];
    }];
    
    
    [self loadLatestFromNetwork:^(int event, id object)
    {
        [mainTableView reloadData];
    }];
    
    
    [[LogicManager sharedInstance] queryLocation:^(int event, id object)
    {
        NSString* addressJsonStr = @"";
        if (1 == event)
        {
            NSDictionary *dict = (NSDictionary *)object;
            addressJsonStr = [[LogicManager sharedInstance] objectToJsonString:dict];
            [[LogicManager sharedInstance] setPersistenceData:addressJsonStr withKey:LOCATION];
        }
    }];
}
-(UIView*)getCustomCellView:(Class)customClass
{
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil];
    for(id obj in arr)
    {
        if(obj != nil && [obj isKindOfClass:customClass])
        {
            return obj;
        }
    }
    return nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma --mark Custom Function
-(void)loadLatestFromNetwork:(EventCallBack)block
{
    /*
     fetchType:
     0x01:最新到最旧拉取
     0x02:最旧到最新拉取
     feedKind:
     0:不限制
     1:朋友消息
     2:广场消息
     */
    [[NetWorkEngine shareInstance] lastedFeedsWithFetchType:0x02
                                                    startId:maxId
                                                      endId:0
                                           limitFetchAmount:ItemCount
                                                   feedKind:GeneralFeedKind
                                                      block:^(int event, id object)
     {
         if(event == 1)
         {
             [[LogicManager sharedInstance] handlePackage:(Package *)object block:^(int event, id object)
              {
                  [self resetDataBaseState];
                  [self loadMoreFromDataBase:^(int event, id object)
                  {
                      if(block)
                      {
                          block(0,nil);
                      }
                  }];

              }];
         }
         else
         {
             if(block)
             {
                 block(0,nil);
             }
         }
     }];
}
-(void)loadMoreFromNetwork:(EventCallBack)block
{
    /*
     fetchType:
     0x01:最新到最旧拉取
     0x02:最旧到最新拉取
     feedKind:
     0:不限制
     1:朋友消息
     2:广场消息
     */
    [[NetWorkEngine shareInstance] lastedFeedsWithFetchType:0x01
                                                    startId:minId
                                                      endId:0
                                           limitFetchAmount:ItemCount
                                                   feedKind:GeneralFeedKind
                                                      block:^(int event, id object)
     {
         if(event == 1)
         {
             [[LogicManager sharedInstance] handlePackage:(Package *)object block:^(int event, id object)
              {
                  //feedEndId = 13378;
                  //feedStartId = 13081;
                  //feeds =();
                  //packageResult = 0;
                  if(event == 1)
                  {
                      NSNumber* feedStartId = [(NSDictionary*)object objectForKey:@"feedStartId"];
                      if(feedStartId != nil)
                      {
                          minId = [feedStartId longLongValue];
                      }
                      NSArray* array = [(NSDictionary*)object objectForKey:@"feeds"];
                      if(array != nil && [array count]>0)
                      {
                          for(Feed* feed in array)
                          {
                              [dataSource addObject:feed];
                              MainTableViewCustomCellView* cellView = (MainTableViewCustomCellView*)[[[NSBundle mainBundle] loadNibNamed:@"MainTableViewCellView" owner:self options:nil] objectAtIndex:0];
                              cellView.feed = feed;
                              [viewSource addObject:cellView];
                          }
                      }
                      if(block)
                      {
                          block(0,nil);
                      }
                  }
              }];
         }
     }];
}
-(void)resetDataBaseState
{
    NSString* sql = [NSString stringWithFormat:@" where DBUid = %llu order by feedId desc limit 1 offset 0",
                     [UserInfo myselfInstance].userId];
    NSArray* array = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class]
                                                                tableName:nil
                                                                condition:sql];
    if(array != nil && [array count]>0)
    {
        maxId = [[array objectAtIndex:0] feedId];
        minId = maxId+1;
    }
}
-(void)loadMoreFromDataBase:(EventCallBack)block
{
    NSString* sql = [NSString stringWithFormat:@" where DBUid = %llu and feedId < %llu order by feedId desc limit %d offset 0",
                     [UserInfo myselfInstance].userId,minId,ItemCount];
    NSArray* array = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class]
                                                                tableName:nil
                                                                condition:sql];
    if(array != nil && [array count]>0)
    {
        minId = [[array lastObject] feedId];
        for(Feed* feed in array)
        {
            [dataSource addObject:feed];
            MainTableViewCustomCellView* cellView = (MainTableViewCustomCellView*)[[[NSBundle mainBundle] loadNibNamed:@"MainTableViewCellView" owner:self options:nil] objectAtIndex:0];
            cellView.feed = feed;
            [viewSource addObject:cellView];
        }
        if(block)
        {
            block(1,nil);
        }
    }
    else
    {
        if(block)
        {
            block(0,nil);
        }
    }
}
-(void)leftBarBtnAction
{
    [MobClick event:menu_click];
    MessageViewController *message = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    [self.navigationController pushViewController:message animated:YES];
}

-(void)rightBarBtnAction
{
    BlurView* blur = [[BlurView alloc]init];
    UIView* view = [[ActionAlertView sharedInstance] loadPublishActionView:^(int event, id object)
    {
        PublishSecretViewController* pub = [[PublishSecretViewController alloc]initWithNibName:@"PublishSecretViewController" bundle:nil];
        if(event == 1)
        {
            pub.feedType = NormalFeedType;
        }
        else if (event == 2)
        {
            pub.feedType = VoteFeedType;
        }
        [self.navigationController pushViewController:pub animated:YES];
        [blur hide];
    }];
    [blur setActionView:view];
    [blur show];
}

-(void)justExperienctBack
{
    [(AppDelegate *)[UIApplication sharedApplication].delegate login];
}
-(void)notice:(NSNotification*)noti
{
//    NSString* sql = [NSString stringWithFormat:@" where DBUid = %llu",[UserInfo myselfInstance].userId];
//    NSArray* array = [[UserDataBaseManager sharedInstance] queryWithClass:[Notice class] tableName:nil condition:sql];
//    if(array != nil)
//    {
//        [tipCountView setTipCount:[array count]];
//    }
//    else
//    {
//        [tipCountView setTipCount:0];
//    }
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(viewSource != nil)
    {
        return [viewSource count];
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView* v = (UIView*)[viewSource objectAtIndex:indexPath.row];
        v.tag = 100;
        [cell.contentView addSubview:v];
        cell.backgroundView = nil;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.userInteractionEnabled = YES;
        cell.userInteractionEnabled = YES;
    }
    else
    {
        UIView* view = (UIView*)[cell.contentView viewWithTag:100];
        if(view != nil)
        {
            [view removeFromSuperview];
        }
        UIView* v = (UIView*)[viewSource objectAtIndex:indexPath.row];
        v.tag = 100;
        [cell.contentView addSubview:v];
    }
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView* v = (UIView*)[viewSource objectAtIndex:indexPath.row];
    if(v != nil)
    {
        return v.frame.size.height+10;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Feed* feed = [dataSource objectAtIndex:indexPath.row];
    if(feed == nil || (NSNull*)feed == [NSNull null])
    {
        return;
    }
    DetailSecretViewController* detail = [[DetailSecretViewController alloc]initWithNibName:@"DetailSecretViewController"
                                                                                     bundle:nil];
    detail.feed = feed;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark - LoadingTableViewDelegate
- (void)didStartRefreshing:(LoadingTableView *)tableView
{
    [self loadLatestFromNetwork:^(int event, id object)
    {
        [mainTableView tableViewDidFinishedLoading];
    }];
}

- (void)didStartLoading:(LoadingTableView *)tableView
{
    [self loadMoreFromDataBase:^(int event, id object)
    {
        if(event == 0)
        {
            [self loadMoreFromNetwork:^(int event, id object) {
                [mainTableView reloadData];
                [mainTableView tableViewDidFinishedLoading];
            }];
        }
        else if (event == 1)
        {
            [mainTableView reloadData];
            [mainTableView tableViewDidFinishedLoading];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.mainTableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.mainTableView tableViewDidEndDragging:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.mainTableView tableViewDidEndDragging:scrollView];
}
#pragma mark -singleton
+(MainViewController*)sharedInstance
{
    static MainViewController* m_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_instance = [[MainViewController alloc]init];
    });
    return m_instance;
}
@end
