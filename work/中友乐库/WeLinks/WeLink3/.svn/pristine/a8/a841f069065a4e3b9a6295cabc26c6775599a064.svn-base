//
//  AboutViewController.m
//  UnNamed
//
//  Created by jonas on 9/21/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    HUD.labelText = @"Cheking...";
    
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(back:)];
    [self.navigationItem setTitleViewWithText:@"关于职脉"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    iconImageView.layer.cornerRadius = 10;
    iconImageView.layer.masksToBounds = YES;
    [versionLabel setText:[NSString stringWithFormat:@"版本:V%@.0",APPVERSION]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else if(alertView.tag == 2)
    {
        if(buttonIndex == 0)
        {
            //忽略
        }
        else if (buttonIndex == 1)
        {
            //升级
            NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APPID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}
-(IBAction)chackUpdate:(id)sender
{
    HUD.labelText = @"Cheking...";
    [HUD show:YES];
    [[NetworkEngine sharedInstance] checkVersion:APPVERSION block:^(int event, id object)
    {
        if(event == 0)
        {
            [HUD hide:YES];
        }
        else if (event == 1)
        {
            if(object != nil)
            {
//                createTime = 1388123343000;
//                must = 0;
//                platform = ios;
//                url = "";
//                version = "1.2";
//                versionDesc = "xxxxx\\nxx";
//                versionId = 2;
                NSDictionary* dic = (NSDictionary*)object;
                int must = 0;
                if([dic objectForKey:@"must"] != nil)
                {
                    must = [[dic objectForKey:@"must"] intValue];
                }
                NSString* desc = [dic objectForKey:@"versionDesc"];
                if(desc != nil)
                {
                    desc = [desc stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                }
                if(must == 1)
                {
                    //强制更新
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:[dic objectForKey:@"version"]
                                                                   message:desc
                                                                  delegate:self
                                                         cancelButtonTitle:@"立刻升级"
                                                         otherButtonTitles:nil, nil];
                    alert.tag = 1;
                    [alert show];
                    [HUD hide:YES];
                }
                else
                {
                    int version = [APPVERSION intValue];
                    if([dic objectForKey:@"versionId"] != nil)
                    {
                        version = [[dic objectForKey:@"versionId"] intValue];
                    }
                    if(version > [APPVERSION intValue])
                    {
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:[dic objectForKey:@"version"]
                                                                       message:desc
                                                                      delegate:self
                                                             cancelButtonTitle:@"忽略"
                                                             otherButtonTitles:@"立刻升级", nil];
                        alert.tag = 2;
                        [alert show];
                        [HUD hide:YES];
                    }
                    else
                    {
                        HUD.labelText = @"没有更新版本";
                        [HUD hide:YES afterDelay:1];
                    }

                }
            }
            else
            {
                HUD.labelText = @"没有更新版本";
                [HUD hide:YES afterDelay:1];
            }
            
        }
    }];
}
@end
