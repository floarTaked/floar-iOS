//
//  SettingViewController.m
//  Guimi
//
//  Created by jonas on 9/12/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "SettingViewController.h"
#import "ChangepwViewController.h"
#import "FrequentQuestionViewController.h"
#import "SuggestViewController.h"
#import "BlurView.h"
#import "ActionAlertView.h"
#import "LogicManager.h"
#import "AppDelegate.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SettingViewController

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
    self.view.backgroundColor = colorWithHex(BackgroundColor3);
    [self.navigationItem setTitleString:@"设置"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_close_n"]
                                imageSelected:[UIImage imageNamed:@"btn_close_h"]
                                        title:nil
                                        inset:UIEdgeInsetsMake(0, -15, 0, 15)
                                       target:self
                                     selector:@selector(back:)];
    UIView* v = [[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    table.backgroundView = v;
    table.backgroundColor = [UIColor clearColor];
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
#pragma --mark TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    return v;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* Identifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil)
    {
        if(isSystemVersionIOS7())
        {
            cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        
        if(isSystemVersionIOS7())
        {
            UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cellBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3f];
            cell.backgroundView = cellBackgroundView;
            cell.backgroundColor = [UIColor clearColor];
            [(CustomMarginCellView*)cell setFillColor:[UIColor lightGrayColor]];
        }
        else
        {
            cell.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:71.0/255.0 blue:77.0/255.0 alpha:0.9];
        }
        
        cell.textLabel.font =  getFontWith(YES, 15);
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    else
    {
        UIView* line = [cell.contentView viewWithTag:100];
        if(line != nil)
        {
            [line removeFromSuperview];
        }
    }
    if(indexPath.row != 4)
    {
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 54,table.frame.size.width-20, 1)];
        line.tag = 100;
        line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1f];
        [cell.contentView addSubview:line];
    }
    
    cell.textLabel.text = @"";
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.imageView.image = nil;
    if(indexPath.row == 0)
    {
        if(isSystemVersionIOS7())
        {
            [(CustomMarginCellView*)cell setSelectedPosition:CustomCellBackgroundViewPositionTop];
            [(CustomMarginCellView*)cell setCornerRadius:5.0];
        }
        cell.textLabel.text = @"新手指引";
        cell.imageView.image = [UIImage imageNamed:@"setting1"];
    }
    else if(indexPath.row == 1)
    {
        if(isSystemVersionIOS7())
        {
            [(CustomMarginCellView*)cell setSelectedPosition:CustomCellBackgroundViewPositionMiddle];
        }
        cell.textLabel.text = @"意见反馈";
        cell.imageView.image = [UIImage imageNamed:@"setting2"];
    }
    else if(indexPath.row == 2)
    {
        if(isSystemVersionIOS7())
        {
            [(CustomMarginCellView*)cell setSelectedPosition:CustomCellBackgroundViewPositionMiddle];
        }
        cell.textLabel.text = @"修改密码";
        cell.imageView.image = [UIImage imageNamed:@"setting3"];
    }
    else if(indexPath.row == 3)
    {
        if(isSystemVersionIOS7())
        {
            [(CustomMarginCellView*)cell setSelectedPosition:CustomCellBackgroundViewPositionMiddle];
        }
        cell.textLabel.text = @"给我评分";
        cell.imageView.image = [UIImage imageNamed:@"setting4"];
    }
    else if(indexPath.row == 4)
    {
        if(isSystemVersionIOS7())
        {
            [(CustomMarginCellView*)cell setSelectedPosition:CustomCellBackgroundViewPositionBottom];
            [(CustomMarginCellView*)cell setCornerRadius:5.0];
        }
        cell.textLabel.text = @"注销";
        cell.imageView.image = [UIImage imageNamed:@"setting5"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            FrequentQuestionViewController *frequent = [[FrequentQuestionViewController alloc] initWithNibName:NSStringFromClass([FrequentQuestionViewController class]) bundle:nil];
            [self.navigationController pushViewController:frequent animated:YES];
        }
            break;
        case 1:
        {
            SuggestViewController *suggest = [[SuggestViewController alloc] initWithNibName:NSStringFromClass([SuggestViewController class]) bundle:nil];
            [self.navigationController pushViewController:suggest animated:YES];
        }
            break;
        case 2:
        {
            [MobClick event:change_password];
            ChangepwViewController *changePWCtl = [[ChangepwViewController alloc] initWithNibName:NSStringFromClass([ChangepwViewController class]) bundle:nil];
            [self.navigationController pushViewController:changePWCtl animated:YES];
        }
            break;
        case 3:
        {
            NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APPID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
        }
            break;
        case 4:
        {
            BlurView* blur = [[BlurView alloc]init];
            UIView* view = [[ActionAlertView sharedInstance] loadLogoutActionView:^(int event, id object)
            {
                if(event == 1)
                {
                    [blur hide];
                }
                else if (event == 2)
                {
                    //退出登录
                    [[LogicManager sharedInstance] setPersistenceData:nil withKey:USERID];
                    AppDelegate* del = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    [del login];
                }
            }];
            [blur setActionView:view];
            [blur show];
        }
            break;
        case 5:
            break;
        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)])
    {
        CGFloat cornerRadius = 3.f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
        {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        }
        else if (indexPath.row == 0)
        {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
        }
        else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
        {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        }
        else
        {
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        layer.fillColor =  [UIColor colorWithRed:70.0/255.0 green:71.0/255.0 blue:77.0/255.0 alpha:0.9].CGColor;
        if (addLine == YES)
        {
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}
@end
