//
//  SuggestViewController.m
//  闺秘
//
//  Created by floar on 14-7-15.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "SuggestViewController.h"
#import "NetWorkEngine.h"
#import "Package.h"
#import <MBProgressHUD.h>

@interface SuggestViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    __weak IBOutlet UITextField *suggestField;
    NSString *rightSuggest;
    MBProgressHUD *hud;
}

@end

@implementation SuggestViewController

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
    [self.navigationItem setTitleString:@"意见反馈"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15) target:self selector:@selector(suggestBack)];
    suggestField.delegate = self;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.delegate = self;
    [self.view addSubview:hud];
}

-(void)tapAction
{
    [suggestField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendSuggest:(id)sender
{
    if (suggestField.text != nil && ![suggestField.text isEqual:@""] && suggestField.text.length > 0)
    {
        [MobClick event:feed_back_request];
        rightSuggest = suggestField.text;
        [[NetWorkEngine shareInstance] suggestForUsWith:rightSuggest block:^(int event, id object)
        {
            if (1 == event)
            {
                Package *returnPack = (Package *)object;
                if (0x02 == [returnPack getProtocalId])
                {
                    [returnPack reset];
                    uint32_t result = [returnPack readInt32];
                    if (0 == result)
                    {
                        [hud show:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"反馈成功，我们会尽快处理";
                        [hud hide:YES afterDelay:1.0 complete:^{
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }
                    else if (-3 == result)
                    {
                        [hud show:YES];
                        hud.labelText = @"未授权，请重新登录";
                        [hud hide:YES];
                    }
                    else if (-1 == result)
                    {
                        [hud show:YES];
                        hud.labelText = @"业务异常";
                        [hud hide:YES afterDelay:1.0];
                    }
                }
            }
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendSuggest:nil];
    return YES;
}

-(void)suggestBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
