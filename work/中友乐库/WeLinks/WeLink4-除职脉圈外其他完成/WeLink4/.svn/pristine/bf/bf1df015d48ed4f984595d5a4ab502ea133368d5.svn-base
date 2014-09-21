//
//  CardHolderViewController.m
//  WeLinked4
//
//  Created by jonas on 5/14/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "CardHolderViewController.h"
#import "Card.h"
#import "UserInfo.h"
#import "NetworkEngine.h"
#import "DataBaseManager.h"
#import "ChineseToPinyin.h"
#import "EditCardViewController.h"
#import "CardDetailViewController.h"
@interface CardHolderViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
{
    NSMutableArray *cardsArray;
    NSMutableDictionary *cardsDict;
    
    NSMutableArray *keyArray;
    NSMutableArray *searchResultArray;
    
}

@property (weak, nonatomic) IBOutlet UITableView *cardTableView;

@end

@implementation CardHolderViewController

@synthesize cardTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tabBarItem.image = [UIImage imageNamed:@"cardHolder"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"cardHolderSelected"];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        self.title = nil;
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
    
    cardTableView.tableHeaderView = self.searchDisplayController.searchBar;

    [self.navigationItem setTitleString:@"名片夹"];
    [self.navigationItem setRightBarButtonItem:[UIImage imageNamed:@"addCard"]
                                 imageSelected:[UIImage imageNamed:@"addCard"]
                                         title:nil
                                         inset:UIEdgeInsetsMake(0, 0, 0,-30)
                                        target:self
                                      selector:@selector(addCardByUser)];
    cardsArray = [[NSMutableArray alloc] init];
    cardsDict = [[NSMutableDictionary alloc] init];
    keyArray = [[NSMutableArray alloc] init];
    searchResultArray = [[NSMutableArray alloc] init];
    
    UIView* v = [[UIView alloc]init];
    v.backgroundColor = [UIColor clearColor];
    cardTableView.backgroundView = v;
    if ([cardTableView respondsToSelector:@selector(sectionIndexBackgroundColor)])
    {
        cardTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDatafromDB];
    [self loadDateFromNetWork];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 数据处理
-(void)loadDateFromNetWork
{
    [[NetworkEngine sharedInstance] getUserSaveCards:^(int event, id object)
    {
        if (0 == event)
        {
            [self loadDatafromDB];
        }
        else if (1 == event)
        {
            NSMutableArray *array = (NSMutableArray *)object;
            if (array != nil && [array count] > 0)
            {
                [self setData:array];
                [cardTableView reloadData];
            }
        }
    }];
}

-(void)loadDatafromDB
{
    NSArray *array = [[UserDataBaseManager sharedInstance] queryWithClass:[Card class] tableName:nil condition:[NSString stringWithFormat:@" where DBUid=%d",[UserInfo myselfInstance].userId]];
    if (array != nil && array.count > 0)
    {
        [self setData:(NSMutableArray *)array];
        [cardTableView reloadData];
    }
}

-(void)setData:(NSMutableArray *)array
{
    cardsArray = array;
    [cardsDict removeAllObjects];
    
    for (int i = 0; i < ALPHALEN; i++)
    {
        char key = [ALPHA characterAtIndex:i+1];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        [cardsDict setObject:tempArray forKey:[NSString stringWithFormat:@"%c",key]];
    }
    for (Card *card in cardsArray)
    {
        char chr = [ChineseToPinyin sortSectionTitle:card.name];
        NSString *namekey = [NSString stringWithFormat:@"%c",chr];
        NSMutableArray *targetArray = [cardsDict objectForKey:namekey];
        [targetArray addObject:card];
    }
}

#pragma mark - UINaigationItem-RightBarButton
-(void)addCardByUser
{
    EditCardViewController* edit = [[EditCardViewController alloc]initWithNibName:@"EditCardViewController" bundle:nil];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:edit animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == cardTableView)
    {
        [keyArray removeAllObjects];
        for (int i = 0; i < ALPHALEN; i++)
        {
            char key = [ALPHA characterAtIndex:i+1];
            NSMutableArray *array = [cardsDict objectForKey:[NSString stringWithFormat:@"%c",key]];
            if (array.count > 0)
            {
                [keyArray addObject:[NSString stringWithFormat:@"%c",key]];
            }
        }
        return keyArray.count;
    }
    else
    {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == cardTableView)
    {
        NSString *key = [keyArray objectAtIndex:section];
        NSArray *array = [cardsDict objectForKey:key];
        if (array != nil)
        {
            return array.count + 1;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return searchResultArray.count+1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        static NSString *cellId = @"HeaderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cellBackgroundView.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1.0];
            cell.backgroundView = cellBackgroundView;
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //header
        NSString* keyChar = [keyArray objectAtIndex:indexPath.section];
        UILabel* headerLabel = [[UILabel alloc] init];
        
        
        headerLabel.backgroundColor = [UIColor clearColor];
        [headerLabel setFont:[UIFont boldSystemFontOfSize:13]];
        headerLabel.tag = 200;
        headerLabel.textColor = [UIColor blackColor];
        
        headerLabel.frame = CGRectMake(15, 2, 20, 20);
        [headerLabel setText:keyChar];
        [cell.contentView addSubview:headerLabel];
        return cell;
    }
    else
    {
        static NSString *cellId = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cellBackgroundView.backgroundColor = [UIColor whiteColor];
            cell.backgroundView = cellBackgroundView;
            cell.backgroundColor = [UIColor clearColor];
        }
        Card* info = nil;
        if(tableView == cardTableView)
        {
            NSString* keyChar = [keyArray objectAtIndex:indexPath.section];
            NSArray* arr = [cardsDict objectForKey:keyChar];
            if(arr != nil)
            {
                info = [arr objectAtIndex:indexPath.row-1];
            }
        }
        else if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            info = [searchResultArray objectAtIndex:indexPath.row-1];
        }
        [self customNormalCell:cell withCard:info];
        return cell;
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (int i = 1; i<=27; i++)
    {
        [array addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
    }
    return array;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch)
    {
        [tableView scrollRectToVisible:CGRectMake(0, 0, 320, 44) animated:YES];
        return -1;
    }
    return [ALPHA rangeOfString:title].location-2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == self.cardTableView)
    {
        NSString *chr = [keyArray objectAtIndex:indexPath.section];
        NSMutableArray *arr = [cardsDict objectForKey:chr];
        Card *card = [arr objectAtIndex:indexPath.row - 1];
        CardDetailViewController* detail = [[CardDetailViewController alloc]initWithNibName:@"CardDetailViewController" bundle:nil];
        detail.cardInfo = card;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        Card *card = [searchResultArray objectAtIndex:indexPath.row - 1];
        CardDetailViewController* detail = [[CardDetailViewController alloc]initWithNibName:@"CardDetailViewController" bundle:nil];
        detail.cardInfo = card;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 25;
    }
    else
    {
        return 70;
    }
    
}

-(void)customNormalCell:(UITableViewCell *)cell withCard:(Card *)card
{
    EGOImageView *image = (EGOImageView *)[cell.contentView viewWithTag:10];
    if (image == nil)
    {
        image = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 50)];
        image.tag = 10;
        image.placeholderImage = [UIImage imageNamed:@"defaultHead"];
        [cell.contentView addSubview:image];
    }
    RCLabel* lbl = (RCLabel*)[cell.contentView viewWithTag:20];
    if(lbl == nil)
    {
        lbl = [[RCLabel alloc]initWithFrame:CGRectMake(110, 10, 200, 50)];
        lbl.tag = 20;
        lbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lbl];
    }
    if (card != nil)
    {
        image.imageURL = [NSURL URLWithString:card.avatar];
        
        NSMutableString* str = [[NSMutableString alloc]init];
        [str appendFormat:@"<p ><font color='#000000' size=14>%@</font></p>",
         card.name==nil?@"":[card.name cleanup:[NSArray arrayWithObjects:@"\n",@"\t", nil]]];
        
        [str appendFormat:@"\n<p ><font color='#CCCCCC' size=12>%@</font></p>",
         card.job==nil?@"":[card.job cleanup:[NSArray arrayWithObjects:@"\n",@"\t", nil]]];
        
        [str appendFormat:@"\n<p ><font color='#CCCCCC' size=12>%@</font></p>",
         card.company==nil?@"":[card.company cleanup:[NSArray arrayWithObjects:@"\n",@"\t", nil]]];
        [lbl setText:str];
    }
}
#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText != nil && searchText.length > 0)
    {
        [searchResultArray removeAllObjects];
        NSString *searchBarString = [ChineseToPinyin pinyinFromChiniseString:searchText];
        BOOL exist = NO;
        for (Card *card in cardsArray)
        {
            NSString *cardNameString = [ChineseToPinyin pinyinFromChiniseString:card.name];
            if ([cardNameString rangeOfString:searchBarString].location !=NSNotFound)
            {
                exist = YES;
            }
            else
            {
                for (int i = 0; i < searchBarString.length; i++)
                {
                    NSString *key = [NSString stringWithFormat:@"%c",[searchBarString characterAtIndex:i]];
                    if ([cardNameString rangeOfString:key].location != NSNotFound)
                    {
                        exist = YES;
                        break;
                    }
                }
            }
            if (exist)
            {
                [searchResultArray addObject:card];
            }
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}
@end