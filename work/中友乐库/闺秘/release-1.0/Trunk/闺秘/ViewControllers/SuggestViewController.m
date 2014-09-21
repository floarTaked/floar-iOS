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

@interface SuggestViewController ()<UITextFieldDelegate>
{
    __weak IBOutlet UITextField *suggestField;
    NSString *rightSuggest;
    
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
    
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_navBack_n"] imageSelected:[UIImage imageNamed:@"btn_navBack_h"] title:nil inset:UIEdgeInsetsMake(0, -10, 0, 10) target:self selector:@selector(suggestBack)];
    suggestField.delegate = self;
    
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:SuggestionsForUsCode block:^(int event, id object) {
        if (1  == event)
        {
            Package *pack = (Package *)object;
            if ([pack handleSuggestForUs:pack withErrorCode:NoCheckErrorCode])
            {
                [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"感谢反馈，我们会尽快处理" actionText:@"确定"];
            }
        }
    }];
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
    if (suggestField.text != nil && [suggestField.text isEqual:@""] && suggestField.text.length > 0)
    {
        rightSuggest = suggestField.text;
        Package *pack = [[Package alloc] initWithSubSystem:FAQSubSys withSubProcotol:0x02];
        
        [pack suggestForUsWithUserId:[UserInfo myselfInstance].userId userKey:[UserInfo myselfInstance].userKey suggestContent:rightSuggest];
        [[NetWorkEngine shareInstance] sendData:pack UniqueCode:SuggestionsForUsCode block:^(int event, id object) {
            
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
