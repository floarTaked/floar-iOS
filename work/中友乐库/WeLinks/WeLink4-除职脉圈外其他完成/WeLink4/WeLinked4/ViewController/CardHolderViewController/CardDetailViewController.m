//
//  CardDetailViewController.m
//  WeLinked4
//
//  Created by jonas on 5/26/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "CardDetailViewController.h"
#import "OtherProfileViewController.h"
#import "LogicManager.h"
#import "EditCardViewController.h"
#import "NetworkEngine.h"
@interface CardDetailViewController ()

@end

@implementation CardDetailViewController
@synthesize cardInfo;
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
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"back"]
                                imageSelected:[UIImage imageNamed:@"backSelected"]
                                        title:nil
                                        inset:UIEdgeInsetsMake(0, -10, 0, 0)
                                       target:self
                                     selector:@selector(back:)];
    [self.navigationItem setRightBarButtonItem:[UIImage imageNamed:@"more"]
                                 imageSelected:[UIImage imageNamed:@"more"]
                                         title:nil
                                         inset:UIEdgeInsetsMake(0, 0, 0, -20)
                                        target:self
                                      selector:@selector(more:)];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoProfile:)];
    tap.numberOfTapsRequired = 1;
    [headImageView addGestureRecognizer:tap];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 45;
    headImageView.layer.borderWidth = 2;
    headImageView.layer.borderColor = [colorWithHex(0x99D5EC) CGColor];
    
    
    detailView.center = CGPointMake(backImageView.frame.size.width/2,
                                    backImageView.frame.size.height/2+detailView.frame.size.height/2-10);
    
    cardView.center = CGPointMake(backImageView.frame.size.width/2,
                                    backImageView.frame.size.height/2+cardView.frame.size.height/2-10);
    
    markView.center = CGPointMake(backImageView.frame.size.width/2,
                                    backImageView.frame.size.height/2+markView.frame.size.height/2-10);
    
    [backImageView addSubview:detailView];
    [backImageView addSubview:cardView];
    [backImageView addSubview:markView];

    [self fillData];
    
}
-(void)fillData
{
    [self.navigationItem setTitleString:cardInfo.name];
    NSMutableString* str = [[NSMutableString alloc]init];
    
    [str appendFormat:@"<p align=center ><font color='#FFFFFF' face='FZLTZHK--GBK1-0' size=25>%@</font></p>",
     cardInfo.name==nil?@"":[cardInfo.name cleanup:[NSArray arrayWithObjects:@"\n",@"\t", nil]]];
    [str appendFormat:@"\n<p align=center  lineSpacing=3><font color='#FFFFFF' size=13>%@</font></p>",
     cardInfo.job==nil?@"":[cardInfo.job cleanup:[NSArray arrayWithObjects:@"\n",@"\t", nil]]];
    [str appendFormat:@"\n<p align=center ><font color='#FFFFFF' size=12>%@</font></p>",
     cardInfo.company==nil?@"":[cardInfo.company cleanup:[NSArray arrayWithObjects:@"\n",@"\t", nil]]];
    [detailInfo setText:str];
    
    
    
    detailImageView.highlighted = YES;
    [headImageView setImageURL:[NSURL URLWithString:cardInfo.avatar]];
    [cardImage setImageURL:[NSURL URLWithString:cardInfo.cardImageUrl]];
    
    NSString* phoneString = @"";
    if([cardInfo.phoneArray count]>=2)
    {
        phoneString = [NSString stringWithFormat:@"%@\n%@",[cardInfo.phoneArray objectAtIndex:0],[cardInfo.phoneArray objectAtIndex:1]];
    }
    else if ([cardInfo.phoneArray count]==1)
    {
        phoneString = [NSString stringWithFormat:@"\n%@",[cardInfo.phoneArray objectAtIndex:0]];
    }
    
    NSString* mailString = @"";
    if([cardInfo.emailArray count]>=2)
    {
        mailString = [NSString stringWithFormat:@"%@\n%@",[cardInfo.emailArray objectAtIndex:0],[cardInfo.emailArray objectAtIndex:1]];
    }
    else if ([cardInfo.emailArray count]==1)
    {
        mailString = [NSString stringWithFormat:@"\n%@",[cardInfo.emailArray objectAtIndex:0]];
    }
    
    [phoneLabel setText:[NSString stringWithFormat:@"<p><font color='#5B9FEB' size=14>%@</font></p>\nMobile Phone",phoneString]];
    
    [mailLabel setText:[NSString stringWithFormat:@"<p><font color='#5B9FEB' size=14>%@</font></p>\nEmail Address",mailString]];
    
    [imLabel setText:[NSString stringWithFormat:@"\n<p><font color='#5B9FEB' size=14>%@</font></p>\nWeiXin/QQ Number",
                      [cardInfo.account cleanup:[NSArray arrayWithObjects:@"\n",@"\t", nil]]]];
    
    
    recentLabel.textColor = colorWithHex(0x5B9FEB);
    recentLabel.font = [UIFont systemFontOfSize:12];
    [recentLabel setText:[NSString stringWithFormat:@"最近见到%@是在",cardInfo.name]];
    
    lacationView.layer.borderWidth = 0.6;
    lacationView.layer.borderColor = [colorWithHex(0xCCCCCC) CGColor];
    descView.layer.borderWidth = 0.6;
    descView.layer.borderColor = [colorWithHex(0xCCCCCC) CGColor];
    
    [locationLabel setText:cardInfo.cardPosition];
    [timeLabel setText:@"2014年5月25号 下午18:00"];
    [descView setText:cardInfo.descriptions];
}
-(void)gotoProfile:(id)sender
{
    OtherProfileViewController* profile = [[OtherProfileViewController alloc]initWithNibName:@"OtherProfileViewController" bundle:nil];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
}
-(void)more:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"编辑名片",@"分享名片",@"删除名片",@"保存到通讯录", nil];
    [sheet showInView:self.navigationController.view];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)gotoMap:(UIGestureRecognizer*)gues
{
    [UIView animateWithDuration:0.2 animations:^{
        lacationView.backgroundColor = colorWithHex(0xEEEEEE);
    } completion:^(BOOL finished) {
        lacationView.backgroundColor = [UIColor clearColor];
    }];
}
-(IBAction)switchTab:(UIGestureRecognizer*)gues
{
    if(gues.view == detailImageView)
    {
        detailImageView.highlighted = YES;
        cardImageView.highlighted = NO;
        markImageView.highlighted = NO;
        
        
        detailView.hidden = NO;
        cardView.hidden = YES;
        markView.hidden = YES;
    }
    else if (gues.view == cardImageView)
    {
        detailImageView.highlighted = NO;
        cardImageView.highlighted = YES;
        markImageView.highlighted = NO;
        
        
        detailView.hidden = YES;
        cardView.hidden = NO;
        markView.hidden = YES;
    }
    else if (gues.view == markImageView)
    {
        detailImageView.highlighted = NO;
        cardImageView.highlighted = NO;
        markImageView.highlighted = YES;
        
        
        
        detailView.hidden = YES;
        cardView.hidden = YES;
        markView.hidden = NO;
    }
}
-(IBAction)clickButton:(id)sender
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma --mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            //编辑名片
            EditCardViewController* edit = [[EditCardViewController alloc]initWithNibName:@"EditCardViewController" bundle:nil];
            edit.cardInfo = cardInfo;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:edit animated:YES];
        }
            break;
        case 1:
        {
            //分享名片
        }
            break;
        case 2:
        {
            //删除名片
            [[NetworkEngine sharedInstance] deleteCard:cardInfo.cardId block:^(int event, id object)
            {
                if(event == 0)
                {
                    [[LogicManager sharedInstance] showAlertWithTitle:nil message:(NSString*)object actionText:@"确定"];
                }
                else if (event == 1)
                {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil
                                                                   message:@"删除成功"
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }
            break;
        case 3:
        {
            //保存到通讯录
            [self saveToContact];
        }
            break;
        default:
            break;
    }
}
#pragma --mark--
-(void)saveAction:(ABAddressBookRef)iPhoneAddressBook
{
    ABRecordRef newPerson = ABPersonCreate();
    
    CFErrorRef error = NULL;
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)([cardInfo.name substringToIndex:1]), &error);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)([cardInfo.name substringFromIndex:1]), &error);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, (__bridge CFTypeRef)(cardInfo.company), &error);
    ABRecordSetValue(newPerson, kABPersonJobTitleProperty, (__bridge CFTypeRef)(cardInfo.job), &error);
    
    //phone number
    if(cardInfo.phoneArray != nil && [cardInfo.phoneArray count]>0)
    {
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for(int i = 0;i<[cardInfo.phoneArray count];i++)
        {
            NSString* phone = [cardInfo.phoneArray objectAtIndex:i];
            if(i == 0)
            {
                ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(phone), kABPersonPhoneMainLabel, NULL);
            }
            else if (i == 1)
            {
                ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(phone), kABPersonPhoneMobileLabel, NULL);
            }
            else
            {
                ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(phone), kABOtherLabel, NULL);
            }
        }
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,&error);
        CFRelease(multiPhone);
    }
    
    
    //email
    if(cardInfo.emailArray != nil && [cardInfo.emailArray count]>0)
    {
        for (NSString* mail in cardInfo.emailArray)
        {
            ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(mail), kABWorkLabel, NULL);
            ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
            CFRelease(multiEmail);
        }
    }
    //address
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:cardInfo.companyAddress forKey:(NSString *) kABPersonAddressStreetKey];
    //    [addressDictionary setObject:@"Chicago" forKey:(NSString *)kABPersonAddressCityKey];
    //    [addressDictionary setObject:@"IL" forKey:(NSString *)kABPersonAddressStateKey];
    //    [addressDictionary setObject:@"60654" forKey:(NSString *)kABPersonAddressZIPKey];
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress,&error);
    CFRelease(multiAddress);
    
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);
    if (error != NULL)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"保存失败,请确认已获取访问通讯录权限" actionText:@"确定"];
    }
    else
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"保存成功" actionText:@"确定"];
    }
}
-(void)saveToContact
{
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(iPhoneAddressBook, ^(bool granted, CFErrorRef error)
        {
            //第一次的时候系统就会弹出一个提示框告诉用户是否允许该应用访问通讯录
            if(granted && error == nil)
            {
                [self saveAction:iPhoneAddressBook];
            }
            else
            {
                [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"禁止访问通讯录讲导致保存不成功" actionText:@"确定"];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        //说明可以访问
        [self saveAction:iPhoneAddressBook];
    }
    else
    {
        //可能是用户关闭了访问通讯的权限。
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"还未获得访问通讯录权限" actionText:@"确定"];
    }
}
@end
