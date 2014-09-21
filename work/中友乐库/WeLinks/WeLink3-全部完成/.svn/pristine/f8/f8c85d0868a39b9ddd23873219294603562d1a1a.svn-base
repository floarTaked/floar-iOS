//
//  TagViewController.m
//  WeLinked3
//
//  Created by jonas on 4/8/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "TagViewController.h"
#import "UserInfo.h"
#import "Common.h"
#import "NetworkEngine.h"
@implementation StateButton
@synthesize selectedState,data;
-(id)init
{
    self = [super init];
    if(self)
    {
        selectedStateView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selectedState"]];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        selectedStateView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selectedState"]];
    }
    return self;
}
-(void)setSelectedState:(BOOL)selected
{
    selectedState = selected;
    if(selectedState)
    {
        CGRect frame = selectedStateView.frame;
        frame.origin.x = self.frame.size.width - frame.size.width;
        frame.origin.y = 0;
        selectedStateView.frame = frame;
        [self addSubview:selectedStateView];
    }
    else
    {
        [selectedStateView removeFromSuperview];
    }
}
@end

@interface TagViewController ()

@end

@implementation TagViewController
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
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack
                                                                 title:nil
                                                                target:self
                                                              selector:@selector(back:)];
    [self.navigationItem setTitleViewWithText:@"职脉标签"];
    
    dataSource = [NSMutableArray array];
    updateSource = [NSMutableArray array];
    NSString* tags = [UserInfo myselfInstance].tags;
    if(tags != nil && [tags length]>0)
    {
        NSArray* arr = [tags componentsSeparatedByString:@","];
        for(NSString* s in arr)
        {
            if(s != nil && [s length]>0)
            {
                [dataSource addObject:s];
                [updateSource addObject:s];
            }
        }
    }
    [dataSource addObject:@"NIIIIIIIIIIL"];
    [self updateListView];
}
-(void)updateListView
{
    if(listView != nil)
    {
        [listView removeFromSuperview];
    }
    listView = [self getTagList:nil];
    listView.frame = CGRectMake(10, 40, 300, listView.frame.size.height);
    [self.view addSubview:listView];
    
    CGRect frame = confirmButton.frame;
    frame.origin.y = listView.frame.origin.y + listView.frame.size.height + 20;
    confirmButton.frame = frame;
}
-(IBAction)save:(id)sender
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:updateSource];
    NSMutableString* str = [NSMutableString string];
    for (NSString* s in arr)
    {
        [str appendString:s];
        [str appendString:@","];
    }
    if([str length]>0)
    {
        //删除最后一个逗号
        [str deleteCharactersInRange:NSMakeRange([str length]-1, 1)];
    }
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:str==nil?@"":str forKey:@"tags"];
    NSString* json = [[LogicManager sharedInstance] objectToJsonString:dic];
    [self.navigationController.navigationBar showLoadingIndicator];
    [[NetworkEngine sharedInstance] saveProfileInfo:json block:^(int event, id object)
     {
         [self.navigationController.navigationBar hideLoadingIndicator];
         if(event == 0)
         {
             [[LogicManager sharedInstance] showAlertWithTitle:@"" message:@"保存失败" actionText:@"确定"];
         }
         else if (event == 1)
         {
             if(object != nil)
             {
                 [[UserInfo myselfInstance] setValuesForKeysWithDictionary:object];
                 UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                                message:@"保存成功"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                 alert.tag = 1;
                 [alert show];
             }
         }
     }];
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UITextField* txt = [alertView textFieldAtIndex:0];
        if(txt != nil && [txt.text length]>0 && [txt.text length]<11)
        {
            [dataSource insertObject:txt.text atIndex:[dataSource count]-1];
            [updateSource addObject:txt.text];
            [self updateListView];
        }
    }
}
-(void)clickedButton:(id)sender
{
    StateButton* btn = (StateButton*)sender;
    if(btn.tag != 1000)
    {
        btn.selectedState = !btn.selectedState;
        if(btn.selectedState)
        {
            //添加
            if(![updateSource containsObject:btn.data])
            {
                [updateSource addObject:btn.data];
            }
        }
        else
        {
            //删除
            if([updateSource containsObject:btn.data])
            {
                int idx = [updateSource indexOfObject:btn.data];
                [updateSource removeObjectAtIndex:idx];
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写标签名称 最长10个字"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        UITextField* txt = [alert textFieldAtIndex:0];
        if(txt != nil)
        {
            txt.delegate = self;
        }
        [alert show];
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.text.length > 10)
    {
        textField.text = [textField.text substringToIndex:10];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 10)
    {
        return NO;
    }
    return YES;
}
-(UIView*)getTagList:(UserInfo*)userInfo
{
    float HEIGHT = 23;
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, HEIGHT)];
    v.backgroundColor = [UIColor whiteColor];
    v.userInteractionEnabled = YES;
    float width = 10;
    float height = 16;
    CGRect frame = v.frame;
    for(NSString* s in dataSource)
    {
        StateButton* button = [[StateButton alloc]initWithFrame:CGRectMake(0, 0, 0, HEIGHT)];
        button.data = s;
        [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        CGRect buttonFrame = button.frame;
        if([s isEqualToString:@"NIIIIIIIIIIL"])
        {
            if([dataSource count]>=51)
            {
                continue;
            }
            button.tag = 1000;
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.text = @"";
            [button setBackgroundImage:[UIImage imageNamed:@"addTag"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"addTagSelected"] forState:UIControlStateHighlighted];
            buttonFrame.size.width = 66;
            buttonFrame.size.height = 24;
            button.frame = buttonFrame;
        }
        else
        {
            [button setTitle:s forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = getFontWith(NO, 13);
            button.backgroundColor = colorWithHex(0x2485ED);
            button.titleLabel.textColor = [UIColor whiteColor];

            float labelWidth = [UILabel calculateWidthWith:s
                                                      font:button.titleLabel.font
                                                    height:HEIGHT
                                            lineBreakeMode:NSLineBreakByWordWrapping];
            buttonFrame.size.width += labelWidth + 10;
            buttonFrame.size.height = HEIGHT;
            button.frame = buttonFrame;
            if([updateSource containsObject:s])
            {
                button.selectedState = YES;
            }
            else
            {
                button.selectedState = NO;
            }
        }
        
        if(width + buttonFrame.size.width > frame.size.width-10)
        {
            frame.size.height += HEIGHT+5;
            width = 10 + buttonFrame.size.width/2;
            height += HEIGHT+5;
            button.center = CGPointMake(width, height);
            width += buttonFrame.size.width/2+10;
        }
        else
        {
            width += buttonFrame.size.width/2;
            button.center = CGPointMake(width, height);
            width += buttonFrame.size.width/2 + 10;
        }
        [v addSubview:button];
    }
    frame.size.height += 10;
    
    if(dataSource == nil || [dataSource count]<=1)
    {
        frame.size.height = 156;
        frame.size.width = 300;
    }
    v.frame = frame;
    return v;
}
@end
