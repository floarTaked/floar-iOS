//
//  ShareViewController.m
//  WeLinked4
//
//  Created by floar on 14-5-26.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "ShareViewController.h"
#import "UIPlaceHolderTextView.h"
#import "LogicManager+ImagePiker.h"
#import "NetworkEngine.h"
#import "TagsViewController.h"
#import "VisualRangeViewController.h"
#import "LogicManager.h"

#define FontSize 15


@interface ShareViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    double lastContentOffset;
    UILabel *subTitleLabel;
    int allowedFriend;
    NSString *httpUrl;
    UIAlertView *linkAlert;
}

@property (weak, nonatomic) IBOutlet UITableView *shareTableView;
@property (nonatomic, strong) UIButton *addImageBtn;
@property (nonatomic, strong) UIButton *addHttpBtn;

@property (nonatomic, strong) UIPlaceHolderTextView *placeHolerText;
@property (nonatomic, strong) UILabel *contentNumLabel;
@property (nonatomic, strong) UIImage *postImage;

@end

@implementation ShareViewController

@synthesize shareTableView,placeHolerText,postImage,contentNumLabel,addHttpBtn,addImageBtn;

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
    [self.navigationItem setTitleString:@"分享"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"] imageSelected:[UIImage imageNamed:@"backSelected"] title:nil inset:UIEdgeInsetsMake(0, -20, 0, 0) target:self selector:@selector(gotoBack)];
    [self.navigationItem setRightBarButtonItem:nil imageSelected:nil title:@"发送" inset:UIEdgeInsetsZero target:self selector:@selector(sendShare)];
    
    placeHolerText.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    allowedFriend = 3;
}

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
    return 1;
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
        placeHolerText = (UIPlaceHolderTextView *)[cell.contentView viewWithTag:90];
        if (placeHolerText == nil)
        {
            placeHolerText = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
            placeHolerText.tag = 90;
            placeHolerText.placeholder = @"分享行业资讯或观点...";
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
    else if (indexPath.section == 1)
    {
        addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addImageBtn.frame = CGRectMake(10, 11, 61, 61);
        [addImageBtn addTarget:self action:@selector(AddImageBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [addImageBtn setBackgroundImage:[UIImage imageNamed:@"img_addImage"] forState:UIControlStateNormal];
        [cell.contentView addSubview:addImageBtn];
        
        addHttpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addHttpBtn.frame = CGRectMake(81, 11, 61, 61);
        [addHttpBtn addTarget:self action:@selector(AddHttpBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [addHttpBtn setBackgroundImage:[UIImage imageNamed:@"img_addLink"] forState:UIControlStateNormal];
        [cell.contentView addSubview:addHttpBtn];
    }
    else
    {
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
    else if (indexPath.section == 1)
    {
        return 82;
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
#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length  + text.length> 500)
    {
        return NO;
    }
    else
    {
        NSString* str = [NSString stringWithFormat:@"详细情况描述(选填%d/500)",textView.text.length + text.length];
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:str];
        [string addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:10]
                       range:NSMakeRange(6,[str length] - 6)];
        [contentNumLabel setAttributedText:string];
    }
    return YES;

}

#pragma mark - UIKeyBoardNote

-(void)keyBoardHidden:(NSNotification *)note
{
    
}

-(void)keyBoardShow:(NSNotification *)note
{
    
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
        [placeHolerText resignFirstResponder];
    }
}



#pragma mark - UINavigationBarBtnAction
-(void)gotoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendShare
{
    BOOL send = YES;
    if (placeHolerText.text == nil || placeHolerText.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        send = NO;
    }
    if (self.postImage != nil && httpUrl != nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"不能同时分享图片和网址" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        send = NO;
    }
    
    if (send)
    {
        NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
        [jsonDict setObject:nil forKey:@"tags"];
        [jsonDict setObject:nil forKey:@"tagIds"];
        [jsonDict setObject:placeHolerText.text forKey:@"content"];
        [jsonDict setObject:[NSNumber numberWithInt:allowedFriend] forKey:@"allowedFriend"];
        
        NSString *jsonString = [[LogicManager sharedInstance] objectToJsonString:jsonDict];
        if (self.postImage == nil)
        {
            [[NetworkEngine sharedInstance] sendContent:jsonString image:nil httpUrl:httpUrl block:^(int event, id object) {
                if (1 == event)
                {
                    
                }
                else
                {
                    
                }
            }];
        }
        else if (httpUrl == nil)
        {
            [[NetworkEngine sharedInstance] sendContent:jsonString image:self.postImage httpUrl:nil block:^(int event, id object) {
                if (1 == event)
                {
                    
                }
                else
                {
                    
                }
            }];
        }
    }
}

#pragma mark - Action

-(void)AddImageBtnAction
{
    [[LogicManager sharedInstance] getImage:self block:^(int event, id object)
     {
         if(object != nil)
         {
             self.postImage =  object;
             [self.addImageBtn setImage:object forState:UIControlStateNormal];
             [self.addImageBtn setImage:object forState:UIControlStateHighlighted];
         }
     }];
    
    if (httpUrl != nil)
    {
        httpUrl = nil;
    }
}

-(void)AddHttpBtnAction
{
    NSString *str = nil;
    if (self.postImage != nil)
    {
        str = @"链接地址和图片只能选择其一,分享链接,选择的图片将消失";
    }
    linkAlert = [[UIAlertView alloc] initWithTitle:@"请输入链接地址" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    linkAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [linkAlert show];
    
    if (self.postImage != nil)
    {
        self.postImage = nil;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"确定"] && alertView == linkAlert)
    {
        UITextField *textFiled = [alertView textFieldAtIndex:0];
        httpUrl =textFiled.text;
    }
}

-(void)selectedAction:(NSNotification *)note
{
    NSString *str = (NSString *)[note object];
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
}

@end