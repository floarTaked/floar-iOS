//
//  ContactsViewController.m
//  WeLinked3
//
//  Created by jonas on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "ContactsViewController.h"
#import "AddFriendsViewController.h"
#import "NewFriendsViewController.h"
#import "ProfileInfo.h"
#import "LogicManager.h"
@interface ContactsViewController ()

@end

@implementation ContactsViewController

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
    table.tableHeaderView = self.searchDisplayController.searchBar;
    
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back:)];
    [self.navigationItem setTitleViewWithText:@"联系人"];
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleIndex
                                                                  title:@"添加"
                                                                 target:self
                                                               selector:@selector(addFriend:)];
    dataSource = [[NSMutableArray alloc]init];
    friendsData = [[NSMutableDictionary alloc]init];
    keyArray = [[NSMutableArray alloc]init];
    searchResult = [[NSMutableArray alloc]init];
    tipCountView = [[TipCountView alloc]init];
    if ([table respondsToSelector:@selector(sectionIndexBackgroundColor)])
    {
        [table setSectionIndexBackgroundColor:[UIColor clearColor]];
    }
    [[HeartBeatManager sharedInstane] registerInvokeMethod:@"newfriend" callback:^(int event, id object)
     {
         if(event == 1)
         {
             if(tipCountView != nil)
             {
                 [tipCountView setTipCount:[(NSString*)object intValue]];
             }
         }
     }];
    [self loadFromDataBase];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTip:) name:NewFriendsNotification object:nil];
}
-(void)resetTip:(NSNotification*)notification
{
    if(tipCountView != nil)
    {
        [tipCountView setTipCount:0];
    }
}
//-(UIView*)getSearchView
//{
//    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    v.backgroundColor = colorWithHex(0xF5F5F5);
//    
//    UIImageView* inputView = [[UIImageView alloc]init];
//    inputView.image = [[UIImage imageNamed:@"bg_textInput_filed"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
//    inputView.frame = CGRectMake(10, 6, 275, 32);
//    [v addSubview:inputView];
//    
//    
//    UIImageView* searchView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchIcon"]];
//    searchView.frame = CGRectMake(10, 8, searchView.frame.size.width, searchView.frame.size.height);
//    
//    [inputView addSubview:searchView];
//    
//    
//    UITextField* inputText = [[UITextField alloc]initWithFrame:CGRectMake(30, 3, 240, 26)];
//    [inputText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    inputText.font = [UIFont systemFontOfSize:14];
//    inputText.placeholder = @"搜索联系人";
//    inputText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
//    inputText.backgroundColor = [UIColor clearColor];
//    [inputView addSubview:inputText];
//    
//    inputView.userInteractionEnabled = YES;
//    v.userInteractionEnabled = YES;
//    
//    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, v.frame.size.height-1, v.frame.size.width, 1)];
//    line.backgroundColor = colorWithHex(0xE0E0E0);
//    [v addSubview:line];
//    return v;
//}
-(void)loadFromNetwok
{
    [[NetworkEngine sharedInstance] getMyFriends:^(int event, id object)
    {
        if(event == 0)
        {
            [self loadFromDataBase];
        }
        else if (event == 1)
        {
             NSMutableArray* arr = (NSMutableArray*)object;
             if(arr != nil && [arr count]>0)
             {
                 [self setData:arr];
                 [table reloadData];
                 noFriendView.hidden = YES;
             }
            else
            {
                noFriendView.hidden = NO;
                [self.view bringSubviewToFront:noFriendView];
            }
        }
    }];
}
-(void)loadFromDataBase
{
    NSArray* arr = [[UserDataBaseManager sharedInstance] queryWithClass:[UserInfo class]
                                                              tableName:MyFriendsTable
                                                              condition:[NSString stringWithFormat:@" where DBUid='%@'",[UserInfo myselfInstance].userId]];
    
    if(arr != nil && [arr count]>0)
    {
        [self setData:(NSMutableArray*)arr];
        [table reloadData];
        noFriendView.hidden = YES;
    }
    else
    {
        noFriendView.hidden = NO;
        [self.view bringSubviewToFront:noFriendView];
    }
    [self loadFromNetwok];
}
-(void)setData:(NSMutableArray*)arr
{
    dataSource = arr;
    [friendsData removeAllObjects];
    for (int i=0; i<ALPHALEN; i++)
    {
        char key = [ALPHA characterAtIndex:(i+1)];
        NSMutableArray* array = [[NSMutableArray alloc] init];
        [friendsData setObject:array forKey:[NSString stringWithFormat:@"%c",key]];
    }
    for(UserInfo* info in dataSource)
    {
        char c = [ChineseToPinyin sortSectionTitle:info.name];
        NSString* key = [NSString stringWithFormat:@"%c", c];
        NSMutableArray* array = [friendsData objectForKey:key];
        [array addObject:info];
    }
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addFriend:(id)sender
{
    AddFriendsViewController* add = [[AddFriendsViewController alloc]initWithNibName:@"AddFriendsViewController" bundle:nil];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == table)
    {
        [keyArray removeAllObjects];
        for (int i=0; i<ALPHALEN; i++)
        {
            char key = [ALPHA characterAtIndex:(i+1)];
            NSMutableArray* array = [friendsData objectForKey:[NSString stringWithFormat:@"%c",key]];
            if([array count] > 0)
            {
                [keyArray addObject:[NSString stringWithFormat:@"%c",key]];
            }
        }
        return [keyArray count]+1;
    }
    else
    {
        //搜索
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == table)
    {
        if(section == 0)
        {
            return 1;
        }
        else if(section >0 && section < ALPHALEN+1)
        {
            NSString* key = [keyArray objectAtIndex:section-1];
            NSArray* arr = [friendsData objectForKey:key];
            if(arr != nil)
            {
                return [arr count]+1;
            }
            else
            {
                return 0;
            }
        }
        return 0;
    }
    else
    {
        return [searchResult count];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section > 0 && indexPath.row==0)
    {
        return 20;
    }
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == table)
    {
        //正常
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            static NSString* CellIdentifier = @"newFriendCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
                cellBackgroundView.backgroundColor = [UIColor whiteColor];
                cell.backgroundView = cellBackgroundView;
                
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.font = getFontWith(YES, 13);
                cell.textLabel.textColor = [UIColor blackColor];
            }
            cell.textLabel.text = @"新的联系人";
            cell.imageView.image = [UIImage imageNamed:@"newFriendIcon"];
            tipCountView.center = CGPointMake(150,28);
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            TipCountView* tip = (TipCountView*)[cell.contentView viewWithTag:100];
            if(tip == nil)
            {
                [cell.contentView addSubview:tipCountView];
                tipCountView.tag = 100;
            }
            return cell;
        }
        else
        {
            CustomCellView* cell = [[CustomCellView alloc] init];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            [cell setSelectedPosition:CustomCellBackgroundViewPositionMiddle];
            if(indexPath.row == 0)
            {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //header
                NSString* keyChar = [keyArray objectAtIndex:indexPath.section-1];
                UIView* view = [[UIView alloc] init];
                UILabel* headerLabel = [[UILabel alloc] init];
                
                view.frame = CGRectMake(0, 0, cell.contentView.frame.size.width, 20);
                view.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1.0];
                
                headerLabel.backgroundColor = [UIColor clearColor];
                [headerLabel setFont:[UIFont systemFontOfSize:13]];
                headerLabel.tag = 200;
                headerLabel.textColor = [UIColor grayColor];
                
                headerLabel.frame = CGRectMake(15, 2, 20, 15);
                
                [view addSubview:headerLabel];
                
                [headerLabel setText:keyChar];
                [cell.contentView addSubview:view];
            }
            else
            {
                NSString* keyChar = [keyArray objectAtIndex:indexPath.section-1];
                NSArray* arr = [friendsData objectForKey:keyChar];
                if(arr != nil)
                {
                    UserInfo* info = [arr objectAtIndex:indexPath.row-1];
                    [self customCell:cell info:info];
                    [self customLine:cell height:60];
                }
            }
            return cell;
        }
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        //搜索
        CustomCellView* cell = [[CustomCellView alloc] init];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell setSelectedPosition:CustomCellBackgroundViewPositionMiddle];
        UserInfo* info = [searchResult objectAtIndex:indexPath.row];
        [self customCell:cell info:info];
        [self customLine:cell height:60];
        return cell;
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (int i = 1; i <= 27; i++)
    {
        [indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
    }
    return indices;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch)
	{
		[tableView scrollRectToVisible:CGRectMake(0, 0, 320, 44) animated:YES];
		return -1;
	}
    return  [ALPHA rangeOfString:title].location-2;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == table)
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                NewFriendsViewController* newFriend = [[NewFriendsViewController alloc]initWithNibName:@"NewFriendsViewController" bundle:nil];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:newFriend animated:YES];
            }
        }
        else
        {
            if(indexPath.row > 0)
            {
                NSString* keyChar = [keyArray objectAtIndex:indexPath.section-1];
                NSArray* arr = [friendsData objectForKey:keyChar];
                if(arr != nil)
                {
                    UserInfo* info = [arr objectAtIndex:indexPath.row-1];
                    if(info != nil)
                    {
                        self.hidesBottomBarWhenPushed = YES;
                        [[LogicManager sharedInstance] gotoProfile:self userId:info.userId];
                    }
                }
            }
        }
    }
    else if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        UserInfo* info = [searchResult objectAtIndex:indexPath.row];
        if(info != nil)
        {
            self.hidesBottomBarWhenPushed = YES;
            [[LogicManager sharedInstance] gotoProfile:self userId:info.userId];
        }
    }
    
}
-(void)customLine:(UITableViewCell*)cell height:(float)height
{
    if(cell == nil || cell.contentView == nil)
    {
        return;
    }
    UIView* line = [cell.contentView viewWithTag:4];
    if(line == nil)
    {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, height-0.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = colorWithHex(0xCCCCCC);
        line.tag = 4;
        [cell.contentView addSubview:line];
    }
}
-(void)customCell:(UITableViewCell*)cell info:(UserInfo*)info
{
    EGOImageView* image = (EGOImageView*)[cell.contentView viewWithTag:1];
    if(image == nil)
    {
        image = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        image.tag = 1;
        image.placeholderImage = [UIImage imageNamed:@"defaultHead"];
        [cell.contentView addSubview:image];
    }
    
    UILabel* name = (UILabel*)[cell.contentView viewWithTag:2];
    if(name == nil)
    {
        name = [[UILabel alloc]initWithFrame:CGRectMake(60, 12, cell.contentView.frame.size.width-100, 21)];
        name.backgroundColor = [UIColor clearColor];
        [name setFont:[UIFont systemFontOfSize:14]];
        name.tag = 2;
        [cell.contentView addSubview:name];
    }
    
    RCLabel* lbl = (RCLabel*)[cell.contentView viewWithTag:3];
    if(lbl == nil)
    {
        lbl = [[RCLabel alloc]initWithFrame:CGRectMake(60, 33, cell.contentView.frame.size.width-100, 20)];
        [cell.contentView addSubview:lbl];
        lbl.tag = 3;
    }
    if(info != nil)
    {
        [name setText:info.name];
        [image setImageURL:[NSURL URLWithString:info.avatar]];
        [lbl setText:[NSString stringWithFormat:@"<font size=12 color='#999999'>%@  %@</font>",info.company,info.job]];
    }
}
#pragma --mark UiSearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText != nil && [searchText length]>0)
    {
        [searchResult removeAllObjects];
        NSString* keyPinyin = [ChineseToPinyin pinyinFromChiniseString:searchText];
        for (UserInfo* friendInfo in dataSource)
        {
            BOOL exist = NO;
            NSString* pinyin = [ChineseToPinyin pinyinFromChiniseString:friendInfo.name];
            if ([pinyin rangeOfString:keyPinyin].length > 0)
            {
                exist = YES;
            }
            else
            {
                for(int i=0;i<[keyPinyin length];i++)
                {
                    NSString* key = [NSString stringWithFormat:@"%c",[keyPinyin characterAtIndex:i]];
                    if ([pinyin rangeOfString:key].length > 0)
                    {
                        exist = YES;
                        break;
                    }
                }
            }
            if(exist)
            {
                [searchResult addObject:friendInfo];
            }
        }
        [table reloadData];
    }
    else
    {
        [table reloadData];
    }
}
@end
