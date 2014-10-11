//
//  DetailSecretViewController.m
//  Guimi
//
//  Created by jonas on 9/15/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "DetailSecretViewController.h"
#import "CommentCellView.h"
@interface DetailSecretViewController ()
@property(nonatomic,strong)IBOutlet UITextView* inputView;
@property(nonatomic,strong)UIButton* switchButton;
@end

@implementation DetailSecretViewController
@synthesize inputView,switchButton;
@synthesize feed;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        viewSource = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = colorWithHex(BackgroundColor3);
    [self.navigationItem setTitleString:@"详情"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_close_n"]
                                imageSelected:[UIImage imageNamed:@"btn_close_h"]
                                        title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15)
                                       target:self
                                     selector:@selector(back:)];
    
    inputView.font = getFontWith(NO, 12);
    inputView.layer.cornerRadius = inputView.frame.size.height/2;
    inputView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.1];
    inputView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    UITapGestureRecognizer* tapGues = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [table addGestureRecognizer:tapGues];
    
    
    emojiView = (EmojiView*)[[[NSBundle mainBundle] loadNibNamed:@"EmojiView" owner:self options:nil] lastObject];
    emojiView.frame = CGRectMake(0, 45,emojiView.frame.size.width, emojiView.frame.size.height);
    [inputBackView addSubview:emojiView];
    
    keybordShow = NO;
    __weak DetailSecretViewController* control = self;
    [emojiView setEventBlock:^(int event, id object)
    {
        if(event == 0)
        {
            //添加表情
            control.inputView.text = [NSString stringWithFormat:@"%@%@",control.inputView.text,(NSString*)object];
        }
        else if (event == 1)
        {
            //删除
            [control.inputView deleteBackward];
        }
        else if (event == 2)
        {
            control.switchButton.selected = !control.switchButton.selected;
            [control.inputView becomeFirstResponder];
        }
    }];
}
-(void)tap:(UITapGestureRecognizer*)gues
{
    [self.view endEditing:YES];
    [self hideKeybord:0.25];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)setFeed:(Feed *)fd
{
    feed = fd;
    headerCellView = (MainTableViewCustomCellView*)[[[NSBundle mainBundle] loadNibNamed:@"MainTableViewCellView"
                                                                            owner:self options:nil] objectAtIndex:0];
    headerCellView.feed = feed;
    CGRect frame = headerCellView.frame;
    frame.size.height += 20;
    headerCellView.frame = frame;
    
    for(int i = 0;i<10;i++)
    {
        Comment* com = [[Comment alloc]init];
        com.comment = @"女神爱屌丝，屌丝爱女汉子，女塑料袋反馈洛杉矶的浪费就死定了开发";
        CommentCellView* cellView = (CommentCellView*)[[[NSBundle mainBundle] loadNibNamed:@"CommentCellView"
                                                                                     owner:self options:nil] objectAtIndex:0];
        cellView.comment = com;
        [viewSource addObject:cellView];
    }
}
#pragma mark - Action Function
-(void)showKeybord:(float)duration
{
    CGRect frame = inputBackView.frame;
    frame.origin.y = self.view.frame.size.height - 216.0 - 45.0;
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:7];
        inputBackView.frame = frame;
        table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, frame.origin.y);
    } completion:^(BOOL finished) {
        keybordShow = YES;
    }];
}
-(void)hideKeybord:(float)duration
{
    CGRect frame = inputBackView.frame;
    frame.origin.y = self.view.frame.size.height - 45.0;
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:7];
        inputBackView.frame = frame;
        table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, frame.origin.y);
    } completion:^(BOOL finished) {
        keybordShow = NO;
    }];
}
-(IBAction)click:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if(btn.tag == 1)
    {
        //表情
        btn.selected = !btn.selected;
        if(switchButton.selected)
        {
            [inputView resignFirstResponder];
        }
        else
        {
            [inputView becomeFirstResponder];
        }
        [self showKeybord:0.25];

    }
    else if (btn.tag == 2)
    {
        //发送
    }
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return [viewSource count];
    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(headerCellView != nil)
        {
            return headerCellView.frame.size.height-20;
        }
    }
    else
    {
        UIView* v = [viewSource objectAtIndex:indexPath.row];
        if(v != nil)
        {
            return v.frame.size.height;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = [NSString stringWithFormat:@"Cell_%d",indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.userInteractionEnabled = YES;
        cell.userInteractionEnabled = YES;
        cell.clipsToBounds = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0)
    {
        MainTableViewCustomCellView* cellView = (MainTableViewCustomCellView*)[cell.contentView viewWithTag:100];
        if(cellView == nil)
        {
            headerCellView.tag = 100;
            [cell.contentView addSubview:headerCellView];
        }
    }
    else
    {
        CommentCellView* cellView = (CommentCellView*)[cell.contentView viewWithTag:100];
        if(cellView == nil)
        {
            cellView = [viewSource objectAtIndex:indexPath.row];
            cellView.tag = 100;
            [cell.contentView addSubview:cellView];
        }
    }
    return cell;
}
#pragma mark - KeyboardShowOrHidden
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    switchButton.selected = NO;
    [self showKeybord:duration.doubleValue];
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if(keybordShow)
    {
        NSDictionary* info = [aNotification userInfo];
        NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        [self hideKeybord:duration.doubleValue];
    }
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length  + text.length> 200)
    {
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    float height = [UILabel calculateHeightWith:textView.text
                                           font:getFontWith(NO, 12)
                                          width:inputView.frame.size.width
                                 lineBreakeMode:NSLineBreakByWordWrapping];
    float diffHeight = 0;
    if(height > 30.0)
    {
        diffHeight = height - inputView.frame.size.height;
    }
    else
    {
        diffHeight = 30.0 - inputView.frame.size.height;
    }
    
    topView.frame = CGRectMake(topView.frame.origin.x, topView.frame.origin.y-diffHeight,
                            topView.frame.size.width, topView.frame.size.height + diffHeight);
    
    topView.backgroundColor = [UIColor whiteColor];
    inputView.frame = CGRectMake(inputView.frame.origin.x, inputView.frame.origin.y,
                               inputView.frame.size.width, inputView.frame.size.height + diffHeight);
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.selectedRange = NSMakeRange(50, 50);
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
}
@end
