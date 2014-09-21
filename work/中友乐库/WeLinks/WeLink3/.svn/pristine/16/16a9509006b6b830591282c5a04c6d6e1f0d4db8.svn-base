//
//  EditMyProfileViewController.m
//  WeLinked3
//
//  Created by 牟 文斌 on 2/25/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "EditMyProfileViewController.h"
#import "MHTextField.h"
#import "NetworkEngine.h"

@interface EditMyProfileViewController ()
@property (weak, nonatomic) IBOutlet MHTextField *name;
@property (weak, nonatomic) IBOutlet MHTextField *company;
@property (weak, nonatomic) IBOutlet MHTextField *jobTitle;
@property (weak, nonatomic) IBOutlet MHTextField *address;
@property (weak, nonatomic) IBOutlet MHTextField *mobile;
@property (weak, nonatomic) IBOutlet MHTextField *emailAddress;

@end

@implementation EditMyProfileViewController

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
    // Do any additional setup after loading the view from its nib.
    _name.required = YES;
    _company.required = YES;
    _company.required = YES;
    _address.required = YES;
    _mobile.required = YES;
    _emailAddress.required = YES;
    [_emailAddress setEmailField:YES];
    
    [self.navigationItem setTitle:@"基本信息"];
    
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleConfirm title:@"完成" target:self selector:@selector(confirm:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirm:(id)sender
{
    
}

@end
