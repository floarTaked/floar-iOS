//
//  FourthViewController.m
//  KitMoreTest
//
//  Created by floar on 14-6-12.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "FourthViewController.h"

@interface FourthViewController ()
{
    NSArray *dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *fourthTableView;


@end

@implementation FourthViewController

@synthesize fourthTableView;

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
    dataArray = @[[UIColor orangeColor],[UIColor blueColor],[UIColor brownColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count %2 !=0)
    {
        return dataArray.count/2+1;
    }
    else
    {
        return dataArray.count/2;
    }
//    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
//    [self customCell:cell withImage1Color:<#(UIColor *)#> imageColor2:<#(UIColor *)#>]
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(void)customCell:(UITableViewCell *)cell withImage1Color:(UIColor *)img1Color imageColor2:(UIColor *)im2Color
{
//    UITextField *textFiled = (UITextField *)[cell.contentView viewWithTag:10];
//    if (textFiled == nil)
//    {
//        textFiled = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 100, 50)];
//        textFiled.tag = 10;
//        textFiled.placeholder = @"输入文字";
//        textFiled.font = [UIFont systemFontOfSize:14];
//        textFiled.keyboardAppearance = UIKeyboardAppearanceDark;
//        textFiled.keyboardType = UIKeyboardTypeNumberPad;
//        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [cell.contentView addSubview:textFiled];
//    }
    
    UIImageView *img1 = (UIImageView *)[cell.contentView viewWithTag:10];
    if (img1 == nil)
    {
        img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        img1.tag = 10;
        img1.backgroundColor = img1Color;
        [cell.contentView addSubview:img1];
    }
    
    UIImageView *img2 = (UIImageView *)[cell.contentView viewWithTag:20];
    if (img2 == nil)
    {
        img2 = [[UIImageView alloc] initWithFrame:CGRectMake(160, 0, 160, 160)];
        img2.tag = 20;
        img2.backgroundColor = im2Color;
        [cell.contentView addSubview:img2];
    }
}



@end
