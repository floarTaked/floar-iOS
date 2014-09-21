//
//  EditCardViewController.h
//  WeLinked4
//
//  Created by jonas on 5/16/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "EditCardViewController.h"
#import "Common.h"
#import "NetworkEngine.h"
#import "LogicManager.h"
#import "InputViewController.h"
#import "MainViewController.h"
#import "LogicManager+ImagePiker.h"
@implementation EditCardViewController
@synthesize cardCheckImage,cardInfo;
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
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
                                 imageSelected:[UIImage imageNamed:@"backSelected"]
                                         title:nil
                                         inset:UIEdgeInsetsMake(0, -20, 0, 0)
                                        target:self
                                      selector:@selector(back:)];
    [self.navigationItem setRightBarButtonItem:nil
                                 imageSelected:nil
                                         title:@"保存"
                                         inset:UIEdgeInsetsMake(0, -30, 0, 0)
                                        target:self
                                      selector:@selector(save:)];
    [self.navigationItem setTitleString:@"编辑个人资料"];
    cardView.userInteractionEnabled = YES;
    cardView.multipleTouchEnabled  = YES;
    cardView.clipsToBounds = YES;
    cardImage.userInteractionEnabled = YES;
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(pinchImage:)];
    [cardImage addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(panImage:)];
    [cardImage addGestureRecognizer:panGestureRecognizer];
    if(cardCheckImage == nil)
    {
        [cardImage setImageURL:[NSURL URLWithString:cardInfo.cardImageUrl]];
    }
    else
    {
        cardImage.image = cardCheckImage;
    }
    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit:)];
//    tap.numberOfTapsRequired = 1;
//    tap.delegate = self;
//    [mainView addGestureRecognizer:tap];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
//    {
//        [self.view endEditing:YES];
//        return NO;
//    }
//    return  YES;
//}
-(void)endEdit:(UITapGestureRecognizer*)gues
{
    [self.view endEditing:YES];
}
-(void)save:(id)sender
{
    if(![self checkValue])
    {
        return;
    }
    NSData* headData = UIImageJPEGRepresentation(newHeadImage, 0.1);
//    NSData* cardImageData = UIImageJPEGRepresentation(cardImage.image, 0.1);
    HUD.labelText = @"Uploading...";
    [HUD show:YES];
    [[NetworkEngine sharedInstance] updateCard:headData card:cardInfo block:^(int event, id object)
    {
        if(event == 0)
        {
            //失败
            HUD.labelText = @"上传失败";
            [HUD hide:YES afterDelay:1];
        }
        else if (event == 1)
        {
            //成功
            HUD.labelText = @"上传成功";
            [HUD hide:YES afterDelay:1 complete:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}
-(BOOL)checkValue
{
    if(cardImage.image == nil)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"名片图片不能为空"
                                               actionText:@"确定"];
        return NO;
    }
    if(newHeadImage == nil)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"头像不能为空"
                                               actionText:@"确定"];
        return NO;
    }
    if(cardInfo.name == nil || [cardInfo.name length]<=0)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"姓名不能为空"
                                               actionText:@"确定"];
        return NO;
    }
    return YES;
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
// 处理缩放手势
- (void) pinchImage:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panImage:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}
#pragma --mark 选择头像
-(void)setAvatar:(UIImage*)image
{
    headImageView.image = image;
    newHeadImage = image;
}
#pragma --mark TableView
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 5;
    }
    else if (section == 1)
    {
        return 6 + [cardInfo.phoneArray count] + [cardInfo.emailArray count];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 30;
    }
    else
    {
        if (indexPath.section == 0)
        {
            if(indexPath.row == 1)
            {
                return 70;
            }
        }
    }
    return 45;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackgroundView.backgroundColor = colorWithHex(0xF1F1F1);
        cell.backgroundView = cellBackgroundView;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"";
        cell.imageView.image = nil;
        cell.detailTextLabel.text = @"";
        if(indexPath.row == 0)
        {
            if(indexPath.section == 0)
            {
                cell.imageView.image = [UIImage imageNamed:@"basicInfo"];
            }
            else if(indexPath.section == 1)
            {
                cell.imageView.image = [UIImage imageNamed:@"detailInfo"];
            }
        }
        return cell;
    }
    else
    {
        if(indexPath.section == 0 && indexPath.row == 1)
        {
            UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cellBackgroundView.backgroundColor = [UIColor whiteColor];
            cell.backgroundView = cellBackgroundView;
            
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.font = getFontWith(NO, 13);
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.font = getFontWith(NO, 12);
            cell.detailTextLabel.textColor = colorWithHex(0x3287E6);
            
            cell.textLabel.text = @"形象照";
            cell.imageView.image = nil;
            cell.detailTextLabel.text = @"";
            headImageView = (EGOImageView*)[cell.contentView viewWithTag:10];
            if(headImageView == nil)
            {
                headImageView = [[EGOImageView alloc]initWithFrame:CGRectMake(70, 10, 50, 50)];
                headImageView.layer.cornerRadius = 25;
                headImageView.layer.masksToBounds = YES;
                headImageView.layer.borderWidth = 0.5;
                headImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                headImageView.placeholderImage = [UIImage imageNamed:@"defaultHead"];
                headImageView.image = [UIImage imageNamed:@"defaultHead"];
                headImageView.tag = 10;
                [cell.contentView addSubview:headImageView];
            }
            if(newHeadImage != nil)
            {
                headImageView.image = newHeadImage;
            }
            else
            {
                [headImageView setImageURL:[NSURL URLWithString:cardInfo.avatar]];
            }
            return cell;
        }
        else
        {
            UITableViewCell* cell = nil;
            if(indexPath.section == 0)
            {
                cell = [self customCell1:tableView indexPath:indexPath];
            }
            else if (indexPath.section == 1)
            {
                if (indexPath.row == [cardInfo.phoneArray count]+1 ||
                    indexPath.row == [cardInfo.phoneArray count]+ [cardInfo.emailArray count] + 2)
                {
                    cell = [self customCell2:tableView indexPath:indexPath];
                }
                else
                {
                    cell = [self customCell1:tableView indexPath:indexPath];
                }
            }
            return cell;
        }
    }
}
-(UITableViewCell*)customCell1:(UITableView*)tableView indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cellBackgroundView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = cellBackgroundView;
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = getFontWith(NO, 14);
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.detailTextLabel.font = getFontWith(NO, 12);
    cell.detailTextLabel.textColor = colorWithHex(0x3287E6);
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;

    cell.textLabel.text = @"";
    cell.imageView.image = nil;
    cell.detailTextLabel.text = @"";
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 2)
        {
            cell.textLabel.text = @"姓名";
            nameFiled = [self customTextFiled:cell placeholder:@""];
            [nameFiled setText:cardInfo.name];
        }
        else if(indexPath.row == 3)
        {
            cell.textLabel.text = @"公司";
            compFiled = [self customTextFiled:cell placeholder:@""];
            [compFiled setText:cardInfo.company];
        }
        else if(indexPath.row == 4)
        {
            cell.textLabel.text = @"职位";
            jobFiled = [self customTextFiled:cell placeholder:@""];
            [jobFiled setText:cardInfo.job];
        }
    }
    else if(indexPath.row <= [cardInfo.phoneArray count])
    {
        cell.textLabel.text = @"手机";
        UILabel* lbl = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, cell.frame.size.width-100, 45)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = colorWithHex(0x3287E6);
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.font = getFontWith(NO, 13);
        [lbl setText:[cardInfo.phoneArray objectAtIndex:indexPath.row-1]];
        [cell.contentView addSubview:lbl];
    }
    else if (indexPath.row >[cardInfo.phoneArray count]+1 &&
             indexPath.row < [cardInfo.phoneArray count]+ [cardInfo.emailArray count] + 2)
    {
        cell.textLabel.text = @"邮件";
        UILabel* lbl = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, cell.frame.size.width-100, 45)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = colorWithHex(0x3287E6);
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.font = getFontWith(NO, 13);
        [lbl setText:[cardInfo.emailArray objectAtIndex:indexPath.row- [cardInfo.phoneArray count]-2]];
        [cell.contentView addSubview:lbl];
    }
    else if (indexPath.row == [cardInfo.phoneArray count]+ [cardInfo.emailArray count] + 3)
    {
        cell.textLabel.text = @"公司地址";
        addressFiled = [self customTextFiled:cell placeholder:@""];
        [addressFiled setText:cardInfo.companyAddress];
    }
    else if (indexPath.row == [cardInfo.phoneArray count]+ [cardInfo.emailArray count] + 4)
    {
        cell.textLabel.text = @"通讯帐号";
        IMFiled = [self customTextFiled:cell placeholder:@""];
        [IMFiled setText:cardInfo.account];
    }
    else if (indexPath.row == [cardInfo.phoneArray count]+ [cardInfo.emailArray count] + 5)
    {
        cell.textLabel.text = @"名片位置";
        posFiled = [self customTextFiled:cell placeholder:@""];
        [posFiled setText:cardInfo.cardPosition];
    }
    return cell;
}
-(UITableViewCell*)customCell2:(UITableView*)tableView indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cellBackgroundView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = cellBackgroundView;
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = getFontWith(NO, 14);
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.detailTextLabel.font = getFontWith(NO, 12);
    cell.detailTextLabel.textColor = colorWithHex(0x3287E6);
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.textLabel.text = @"";
    cell.imageView.image = nil;
    cell.detailTextLabel.text = @"";
    if (indexPath.row == [cardInfo.phoneArray count]+1)
    {
        cell.textLabel.text = @"添加手机";
    }
    else if (indexPath.row == [cardInfo.phoneArray count]+ [cardInfo.emailArray count] + 2)
    {
        cell.textLabel.text = @"添加邮件";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        [[LogicManager sharedInstance] getImage:self block:^(int event, id object) {
            if(object != nil)
            {
                [self setAvatar:object];
            }
        }];
    }
    else if (indexPath.section == 1 && indexPath.row >0 && indexPath.row < [cardInfo.phoneArray count]+1)
    {
        //修改手机
        InputViewController* input = [[InputViewController alloc]initWithNibName:@"InputViewController" bundle:nil];
        [input setString:@"输入手机号码" placeholder:@"输入手机号码" keyboardType:UIKeyboardTypePhonePad];
        NSString* val = [cardInfo.phoneArray objectAtIndex:indexPath.row-1];
        [input edit:YES editValue:val block:^(int event, id object)
         {
             if(event == 1)
             {
                 //删除
                 cardInfo.phone = [cardInfo.phone stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",val]
                                                                            withString:@""];
                 cardInfo.phone = [cardInfo.phone stringByReplacingOccurrencesOfString:val withString:@""];
             }
             else if (event == 2)
             {
                 //修改
                 if(object != nil && [(NSString*)object length]>0)
                 {
                     cardInfo.phone = [cardInfo.phone stringByReplacingOccurrencesOfString:val withString:(NSString*)object];
                 }
                 else
                 {
                     cardInfo.phone = [cardInfo.phone stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",val]
                                                                                withString:@""];
                 }
             }
             [cardInfo.phoneArray removeAllObjects];
             [table reloadData];
         }];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:input animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == [cardInfo.phoneArray count]+1)
    {
        //添加手机
        InputViewController* input = [[InputViewController alloc]initWithNibName:@"InputViewController" bundle:nil];
        [input setString:@"输入手机号码" placeholder:@"输入手机号码" keyboardType:UIKeyboardTypePhonePad];
        [input edit:NO editValue:nil block:^(int event, id object)
        {
            if(object != nil && [(NSString*)object length]>0)
            {
                if(cardInfo.phone != nil && [cardInfo.phone length]>0)
                {
                    cardInfo.phone = [cardInfo.phone stringByReplacingOccurrencesOfString:@",," withString:@","];
                    cardInfo.phone = [cardInfo.phone stringByReplacingOccurrencesOfString:@", ," withString:@","];
                    cardInfo.phone = [NSString stringWithFormat:@"%@,%@",cardInfo.phone,(NSString*)object];
                }
                else
                {
                    cardInfo.phone = [NSString stringWithFormat:@"%@",(NSString*)object];
                }
            }
            [cardInfo.phoneArray removeAllObjects];
            [table reloadData];
        }];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:input animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row > [cardInfo.phoneArray count]+1
             && indexPath.row < [cardInfo.phoneArray count]+ [cardInfo.emailArray count] + 2)
    {
        //修改邮箱
        InputViewController* input = [[InputViewController alloc]initWithNibName:@"InputViewController" bundle:nil];
        [input setString:@"输入邮箱" placeholder:@"输入邮箱" keyboardType:UIKeyboardTypeEmailAddress];
        NSString* val = [cardInfo.emailArray objectAtIndex:indexPath.row-[cardInfo.phoneArray count]-2];
        [input edit:YES editValue:val block:^(int event, id object)
         {
             if(event == 1)
             {
                 //删除
                 cardInfo.email = [cardInfo.email stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",val]
                                                                            withString:@""];
                 cardInfo.email = [cardInfo.email stringByReplacingOccurrencesOfString:val withString:@""];
             }
             else if (event == 2)
             {
                 //修改
                 if(object != nil && [(NSString*)object length]>0)
                 {
                     cardInfo.email = [cardInfo.email stringByReplacingOccurrencesOfString:val withString:(NSString*)object];
                 }
                 else
                 {
                     cardInfo.email = [cardInfo.email stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",val]
                                                                                withString:@""];
                 }
             }
             [cardInfo.emailArray removeAllObjects];
             [table reloadData];
         }];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:input animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == [cardInfo.phoneArray count]+ [cardInfo.emailArray count] + 2)
    {
        //添加邮箱
        InputViewController* input = [[InputViewController alloc]initWithNibName:@"InputViewController" bundle:nil];
        [input setString:@"输入邮箱" placeholder:@"输入邮箱" keyboardType:UIKeyboardTypeEmailAddress];
        [input edit:NO editValue:nil block:^(int event, id object)
         {
             if(object != nil && [(NSString*)object length]>0)
             {
                 if(cardInfo.email != nil && [cardInfo.email length]>0)
                 {
                     cardInfo.email = [cardInfo.email stringByReplacingOccurrencesOfString:@",," withString:@","];
                     cardInfo.email = [cardInfo.email stringByReplacingOccurrencesOfString:@", ," withString:@","];
                     cardInfo.email = [NSString stringWithFormat:@"%@,%@",cardInfo.email,(NSString*)object];
                 }
                 else
                 {
                     cardInfo.email = [NSString stringWithFormat:@"%@",(NSString*)object];
                 }
             }
             [cardInfo.emailArray removeAllObjects];
             [table reloadData];
         }];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:input animated:YES];
    }
}
-(UITextField*)customTextFiled:(UITableViewCell*)cell placeholder:(NSString*)placeholder
{
    if(cell == nil || cell.contentView == nil)
    {
        nil;
    }
    UITextField* textField = (UITextField*)[cell.contentView viewWithTag:200];
    [textField setText:@""];
    if(textField == nil)
    {
        textField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, cell.frame.size.width-100, 45)];
        textField.tag = 200;
        [cell.contentView addSubview:textField];
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = colorWithHex(0x3287E6);
        textField.textAlignment = NSTextAlignmentLeft;
        textField.font = getFontWith(NO, 13);
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)])
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc]
                                               initWithString:placeholder
                                               attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        }
    }
    return textField;
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
-(void)textChange:(UITextField*)filed
{
    if(filed == nameFiled)
    {
        cardInfo.name = nameFiled.text;
    }
    else if (filed == compFiled)
    {
        cardInfo.company = compFiled.text;
    }
    else if (filed == jobFiled)
    {
        cardInfo.job = jobFiled.text;
    }
    else if (filed == addressFiled)
    {
        cardInfo.companyAddress = addressFiled.text;
    }
    else if (filed == IMFiled)
    {
        cardInfo.account = IMFiled.text;
    }
    else if (filed == posFiled)
    {
        cardInfo.cardPosition = posFiled.text;
    }
    
}
#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect frame = table.frame;
    frame.size.height = self.view.frame.size.height - kbSize.height;
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView animateWithDuration:duration.doubleValue animations:^{
        mainView.frame = CGRectMake(0, -205, self.view.frame.size.width, self.view.frame.size.height);
        table.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect frame = table.frame;
    frame.size.height = self.view.frame.size.height - 205;
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView animateWithDuration:duration.doubleValue animations:^{
        mainView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        table.frame = frame;
    } completion:^(BOOL finished) {
    }];
}
@end
