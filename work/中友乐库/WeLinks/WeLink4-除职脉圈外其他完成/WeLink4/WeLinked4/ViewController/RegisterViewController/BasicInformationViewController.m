//
//  BasicInformationViewController.m
//  WeLinked4
//
//  Created by jonas on 5/19/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "BasicInformationViewController.h"
#import "CardPreviewViewController.h"
#import "FillInformationViewController.h"
@interface BasicInformationViewController ()

@end

@implementation BasicInformationViewController

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
                                        inset:UIEdgeInsetsMake(0, -20, 0, 0)
                                       target:self
                                     selector:@selector(back:)];
    [self.navigationItem setTitleString:@"基本资料"];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)fillInfo:(id)sender
{
    FillInformationViewController* fill = [[FillInformationViewController alloc]initWithNibName:@"FillInformationViewController"
                                                                                         bundle:nil];
    [self.navigationController pushViewController:fill animated:YES];
}
-(IBAction)scanInfo:(id)sender
{
    CardPreviewViewController* previewController = [[CardPreviewViewController alloc]initWithNibName:@"CardPreviewViewController" bundle:nil];
    previewController.fillInfo = YES;
    [self presentViewController:previewController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
