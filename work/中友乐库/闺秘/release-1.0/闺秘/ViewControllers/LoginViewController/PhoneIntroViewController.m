//
//  PhoneIntroViewController.m
//  闺秘
//
//  Created by floar on 14-7-19.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "PhoneIntroViewController.h"
#import "Package.h"
#import "NetWorkEngine.h"
#import "LogicManager.h"
#import "MainViewController.h"

@interface PhoneIntroViewController ()

@end

@implementation PhoneIntroViewController
{
    
    __weak IBOutlet UIImageView *phoneBGImagView;
    
    __weak IBOutlet UIButton *phoneFriendsBtn;
    
    __weak IBOutlet UIButton *whyBtn;
    
    UIActivityIndicatorView *indicator;
    UILabel *indicatorLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [whyBtn setTitleColor:colorWithHex(0xD0246C) forState:UIControlStateNormal];
    
    
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:UpdatePhoneBookCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
//            [indicator stopAnimating];
            indicatorLabel.alpha = 1;
            if ([pack handleUpdateContractList:pack withErrorCoed:NoCheckErrorCode])
            {
                
                [[LogicManager sharedInstance] setRootViewContrllerWithNavigationBar:[MainViewController sharedInstance]];
            }
        }
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)linkFriendsBtnAcion:(id)sender
{
    phoneBGImagView.image = [UIImage imageNamed:@"img_phone2"];
    
    [phoneFriendsBtn removeFromSuperview];
    [whyBtn removeFromSuperview];
    
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 280, 20, 20)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    indicator.hidesWhenStopped = YES;
    indicator.color = colorWithHex(DeepRedColor);
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(indicator.frame), 180, 40)];
    indicatorLabel.text = @"加载[闺秘]中...";
    indicatorLabel.font = getFontWith(NO, 18);
    indicatorLabel.textAlignment = NSTextAlignmentCenter;
    indicatorLabel.textColor = colorWithHex(DeepRedColor);
    [self.view addSubview:indicatorLabel];
    
    [[LogicManager sharedInstance] getContactFriends:^(int event, id object) {
        if (1 == event && object != nil)
        {
            NSArray *phoneArray = object[@"dic"];
            NSString *json = [[LogicManager sharedInstance] objectToJsonString:phoneArray];
            Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x0c];
            [pack updateContractListWithUserId:[UserInfo myselfInstance].userId userKey:[UserInfo myselfInstance].userKey phoneBookJsonStr:json];
            [[NetWorkEngine shareInstance] sendData:pack UniqueCode:UpdatePhoneBookCode block:^(int event, id object)
             {
                 
             }];
        }
    }];

    
}

- (IBAction)friendWhy:(id)sender
{
    
}



@end
