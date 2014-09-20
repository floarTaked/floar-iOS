//
//  ViewController.m
//  ShineLabel
//
//  Created by floar on 14-8-2.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "FullScreenViewController.h"

@interface ViewController ()
{
    NSArray *dataArray;
}


@property (weak, nonatomic) IBOutlet UITableView *shareLabelTableView;

@end

@implementation ViewController
@synthesize shareLabelTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self.navigationItem setTitle:@"ShineLabelTest"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataArray = @[@"阿拉斯加的法律是减肥了",@"解放路圣诞节弗兰克的法律是减肥了",@"阿拉斯加的法律发生了地方经理说减肥流口水的减肥了减肥了",@"阿拉斯加的法律是减肥了",@"阿拉斯加的法律是减肥了",@"阿拉斯加的法律是减肥了",@"阿拉斯加的法律是减肥了",@"阿拉斯加alksfdyioiycv.cvnisd法律是减肥了",@"阿拉斯加的时空裂缝上刊登了飞机上来看大夫问发生的房间是减肥了",@"阿拉斯加的法律是谁离开对方就死的幼女留下来韩国了"];
    [self testWantsFullScreenLayout];
    
    NSLog(@"----1");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"---3");
    });
    NSLog(@"----2");
}

-(void)testWantsFullScreenLayout
{
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
    self.extendedLayoutIncludesOpaqueBars = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TableViewCell class]) owner:self options:nil] lastObject];
    }
    cell.cellContentStr = [dataArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FullScreenViewController *fullViewCtl = [[FullScreenViewController alloc] initWithNibName:NSStringFromClass([FullScreenViewController class]) bundle:nil];
    [self.navigationController pushViewController:fullViewCtl animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


@end
