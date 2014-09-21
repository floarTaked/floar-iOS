//
//  TagsViewController.m
//  WeLinked4
//
//  Created by floar on 14-6-3.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "TagsViewController.h"
#import "NetworkEngine.h"
#import "LogicManager.h"

@interface TagsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITextField *textFiled;
    NSMutableArray *jsonArray;
    
    double lastContentOffset;
}

@property (weak, nonatomic) IBOutlet UITableView *tagsTableView;

@end

@implementation TagsViewController

@synthesize tagsTableView,tagsArray,tagsIDArray,pollOptions,allowedFriend,typeId,content;

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
    [self.navigationItem setTitleString:@"设置标签"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"] imageSelected:[UIImage imageNamed:@"backSelected"] title:nil inset:UIEdgeInsetsMake(0, -20, 0, 0) target:self selector:@selector(gotoBack)];
    [self.navigationItem setRightBarButtonItem:nil imageSelected:nil title:@"确定" inset:UIEdgeInsetsZero target:self selector:@selector(sendQuestion)];
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
    if (section == 0)
    {
        return tagsArray.count;
    }
    else
    {
        return 1;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0)
    {
        [self customNormalCell:cell withIndex:indexPath];
    }
    else
    {
        textFiled = (UITextField *)[cell.contentView viewWithTag:10];
        if (textFiled == nil)
        {
            textFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 300, 30)];
            textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
            textFiled.placeholder = @"添加标签";
            textFiled.delegate = self;
            textFiled.font = getFontWith(NO, 14);
            textFiled.returnKeyType = UIReturnKeyDone;
            [cell.contentView addSubview:textFiled];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    else
    {
        return 5;
    }
}

-(void)customNormalCell:(UITableViewCell *)cell
              withIndex:(NSIndexPath *)index
{
    cell.textLabel.text = [tagsArray objectAtIndex:index.row];
    cell.textLabel.font = getFontWith(NO, 14);
    UIButton *btn = (UIButton *)[cell.contentView viewWithTag:100+index.row];
    if (btn == nil)
    {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(283, 13, 17, 17);
        btn.tag = 100+index.row;
        [btn setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
}

#pragma mark - UITextFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (tagsArray.count < 5 && textField.text.length <6 && textField.text > 0 && textField.text != nil && ![textField.text  isEqual: @""])
    {
        [tagsArray addObject:textField.text];
        [tagsIDArray addObject:@"6"];
        [tagsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        textField.text = @"";
    }
    else if(tagsArray.count == 5)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"标签数不超过5个" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    if (textField.text.length > 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"字数不超过6个" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    if ([textField.text isEqualToString:@""] || textField.text.length == 0 || textField.text == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"输入不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    NSLog(@"%@---%@",tagsArray,tagsIDArray);
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y != lastContentOffset)
    {
        [textFiled resignFirstResponder];
    }
}


#pragma mark - UINavigationBarBtnAction
-(void)gotoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendQuestion
{
    NSString *tagsString = [tagsArray componentsJoinedByString:@","];
    NSString *tagsIdString = [tagsIDArray componentsJoinedByString:@","];
    
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setObject:tagsString forKey:@"tags"];
    [jsonDict setObject:tagsIdString forKey:@"tagIds"];
    [jsonDict setObject:content forKey:@"content"];
    [jsonDict setObject:[NSNumber numberWithInt:allowedFriend] forKey:@"allowedFriend"];
    [jsonDict setObject:[NSNumber numberWithInt:typeId] forKey:@"typeId"];
    
    if (typeId == 23)
    {
        [jsonDict setObject:[NSNull null] forKey:@"pollOptions"];
    }
    else if (typeId == 22)
    {
        [jsonDict setObject:pollOptions forKey:@"pollOptions"];
    }
    
    NSString *jsonString = [[LogicManager sharedInstance] objectToJsonString:jsonDict];
    
    [[NetworkEngine sharedInstance] postQuestion:jsonString block:^(int event, id object) {
        if (1 == event)
        {
            
        }
        else
        {
            
        }
    }];
}

#pragma mark - Action
-(void)deleteAction:(UIButton *)btn
{
    if (tagsArray.count > 0)
    {
        [tagsArray removeObjectAtIndex:btn.tag - 100];
        [tagsIDArray removeObjectAtIndex:btn.tag - 100];
        [tagsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:btn.tag-100 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [tagsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
