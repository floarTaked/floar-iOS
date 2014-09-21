//
//  InformarionViewController.m
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "InformarionViewController.h"

#import "InfoCategoryOfSubscriptionsViewController.h"
#import "InforCollectionCell.h"
#import "InforDetailViewController.h"
#import "InformarionDataManager.h"

#import "DataBaseManager.h"
#import "UserInfo.h"
#import <MBProgressHUD.h>


@interface InformarionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,InformarionDataManagerDelegate>
{
    __weak IBOutlet UICollectionView *inforCollectionView;
    __weak IBOutlet UICollectionViewFlowLayout *inforLayout;
}

@property (nonatomic, strong) InformarionDataManager *dataManager;

@end

@implementation InformarionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tabBarItem.image = [UIImage imageNamed:@"info"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"infoSelected"];
        self.tabBarItem.title = @"资讯";
        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorWithHex(NAVBARCOLOR),
                                                 UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    
    [self.navigationItem setTitleViewWithText:self.tabBarItem.title];
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleCategory title:nil target:self selector:@selector(changeViewCtl)];
    
    NSLog(@"%@",NSHomeDirectory());
    
    self.dataManager = [[InformarionDataManager alloc] init];
    self.dataManager.delegate = self;
    
    //UICollectionView设置
    [inforLayout setItemSize:CGSizeMake(145, 130)];
    [inforLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //底部、左边、section之间距离
    inforLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    
    inforCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    inforCollectionView.delegate = self;
    inforCollectionView.dataSource = self;
    inforCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    [inforCollectionView registerNib:[UINib nibWithNibName:@"InforCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"inforCollectionCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    [self.dataManager.informarionArray removeAllObjects];
    [self.dataManager loadInformarionDataFromDB];
    [inforCollectionView reloadData];
    [self.dataManager loadInformarionDataFromNetWork];
    
}

- (IBAction)goToSubscribes:(id)sender
{
    [self changeViewCtl];
}


-(void)changeViewCtl
{
    InfoCategoryOfSubscriptionsViewController *catgorySubscriptionsViewCtl = [[InfoCategoryOfSubscriptionsViewController alloc] init];
    catgorySubscriptionsViewCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:catgorySubscriptionsViewCtl animated:YES];
}

-(void)HUDCustomAction:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.margin = 10.f;
    hud.yOffset = -30.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

#pragma mark - UICollectionDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.dataManager.informarionArray.count == 0 || self.dataManager.informarionArray == nil)
    {
        return 0;
    }
    else if (self.dataManager.informarionArray.count % 2 != 0)
    {
        return self.dataManager.informarionArray.count/2 + 1;
    }
    else
    {
        return self.dataManager.informarionArray.count/2;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataManager.informarionArray.count % 2 == 0)
    {
        return 2;
    }
    else
    {
        if (section == self.dataManager.informarionArray.count/2)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *colorArray = @[colorWithHex(0x0578B4),colorWithHex(0xCC9900),colorWithHex(0x0F9664),colorWithHex(0x8C1504),colorWithHex(0x1D3A50),colorWithHex(0x330000)];
    
    InforCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"inforCollectionCell" forIndexPath:indexPath];
    Column *column = [self.dataManager.informarionArray objectAtIndex:indexPath.section*2+indexPath.row];
    cell.cellColor = [colorArray objectAtIndex:(indexPath.section*2+indexPath.row)%colorArray.count];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([InforCollectionCell class]) owner:self options:nil] lastObject];
        
    }
    
    cell.column = column;
    
    //定制最后一个cell
    if (indexPath.section*2+indexPath.row == self.dataManager.informarionArray.count - 1)
    {
        [cell lastCell];
//        [cell transOrNot:NO];
    }
    else
    {
//        [cell animationCell:column];
//        [cell transOrNot:YES];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section*2+indexPath.row == self.dataManager.informarionArray.count - 1)
    {
        [self changeViewCtl];
    }
    else
    {
        InforDetailViewController *inforDetailCtl = [[InforDetailViewController alloc] initWithNibName:NSStringFromClass([InforDetailViewController class]) bundle:nil];
        Column *column = [self.dataManager.informarionArray objectAtIndex:indexPath.section*2+indexPath.row];
        inforDetailCtl.infoDetailSubscribeItem = column.colunmID;
        inforDetailCtl.infoDetailViewCtlTitle = column.title;
        inforDetailCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:inforDetailCtl animated:YES]; 
    }
    
}

#pragma mark - dataManagerDelegate

-(void)informarionDataMangerGetDataSuccess
{
    [inforCollectionView reloadData];
}

-(void)informarionDataMangerGetDataFailed
{

    [self HUDCustomAction:@"请检查网络状况"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
