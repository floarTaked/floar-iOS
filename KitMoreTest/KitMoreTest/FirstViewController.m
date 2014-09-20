//
//  FirstViewController.m
//  KitMoreTest
//
//  Created by floar on 14-6-12.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "FirstViewController.h"
#import <SVPullToRefresh.h>
#import <SWTableViewCell.h>
#import <SVProgressHUD.h>
#import <UINavigationController+SGProgress.h>
#import <Reachability.h>
#import <IQKeyboardManager.h>
#import <MTStatusBarOverlay.h>
#import <RFKeyboardToolbar.h>
#import <RFToolbarButton.h>

#import "TestTwoViewController.h"
#import "InterUIViewController.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *firstTableView;
@property (nonatomic, strong) InterUIViewController *interViewCtl;

@property (weak, nonatomic) IBOutlet UIImageView *bottonImage;


@end

@implementation FirstViewController

@synthesize firstTableView,interViewCtl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBarItem setImage:[UIImage imageNamed:@"cardHolder"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"cardHolderSelected"]];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
        
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    firstTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//    view.backgroundColor = [UIColor clearColor];
    firstTableView.tableHeaderView = self.bottonImage;
//    self.navigationController.delegate = self;
//    [self followScrollView:self.view];
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self showNavBarAnimated:NO];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3+section;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.section *10+indexPath.row+10];
//    [self customCell:cell];
    
    return cell;
}

-(void)customCell:(UITableViewCell *)cell
{
    UITextField *textFiled = (UITextField *)[cell.contentView viewWithTag:10];
    if (textFiled == nil)
    {
        textFiled = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 100, 50)];
        textFiled.tag = 10;
        textFiled.placeholder = @"输入文字";
        textFiled.font = [UIFont systemFontOfSize:14];
        textFiled.keyboardAppearance = UIKeyboardAppearanceDark;
        textFiled.keyboardType = UIKeyboardTypeNumberPad;
        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        textFiled.inputAccessoryView = [RFKeyboardToolbar toolbarViewWithButtons:[self getRFkeyboardBtnArray]];
        [cell.contentView addSubview:textFiled];
    }
    else
    {
        textFiled.text = @"";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (interViewCtl == nil)
//    {
//        interViewCtl = [[InterUIViewController alloc] initWithNibName:NSStringFromClass([InterUIViewController class]) bundle:nil];
//        [self.view addSubview:interViewCtl.view];
//    }
    
//    self.navigationController.view.hidden = YES;
    if (interViewCtl == nil)
    {
        interViewCtl = [[InterUIViewController alloc] initWithNibName:NSStringFromClass([InterUIViewController class]) bundle:nil];
        [self.view addSubview:interViewCtl.view];
    }
    else
    {
        [self.view addSubview:interViewCtl.view];
    }
    
//    TestTwoViewController *two = [[TestTwoViewController alloc] initWithNibName:NSStringFromClass([TestTwoViewController class]) bundle:nil];
//    [self.navigationController pushViewController:two animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor orangeColor];
//    return view;
//}



#pragma mark - Action

-(NSMutableArray *)getRFkeyboardBtnArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    RFToolbarButton *btn1 = [RFToolbarButton buttonWithTitle:@"testBtn1"];
    __weak RFToolbarButton *weakBtn = btn1;
    btn1.tag = 10;
    [btn1 addEventHandler:^{
        NSLog(@"%d",weakBtn.tag);
    } forControlEvents:UIControlEventTouchUpInside];
    
    RFToolbarButton *btn2 = [RFToolbarButton buttonWithTitle:@"testBtn2"];
    [btn2 addEventHandler:^{
        NSLog(@"testBtn2");
    } forControlEvents:UIControlEventTouchUpInside];
    
    [array addObject:btn1];
    [array addObject:btn2];
    
    return array;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
        [navigationController setNavigationBarHidden:YES animated:animated];
    }
    else
    {
        [navigationController setNavigationBarHidden:NO animated:animated];
    }
}

@end
