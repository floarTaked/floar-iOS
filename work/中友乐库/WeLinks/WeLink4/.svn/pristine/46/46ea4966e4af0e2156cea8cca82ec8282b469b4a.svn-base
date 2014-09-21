//
//  ScanningViewController.m
//  WeLinked4
//
//  Created by jonas on 5/14/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "ScanningViewController.h"
#import "SaveCardViewController.h"
#import "Common.h"
@interface ScanningViewController ()

@end

@implementation ScanningViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tabBarItem.image = [UIImage imageNamed:@"scanCard"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"scanCard"];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"scanCard"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"scanCard"]];
        self.title = nil;
        
        NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
        [textAttributes setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorWithHex(NAVBARCOLOR),
                                                 UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)loadCamera
{
    previewController = [[CardPreviewViewController alloc]initWithNibName:@"CardPreviewViewController" bundle:nil];
    [self presentViewController:previewController animated:YES completion:nil];
    
//    SaveCardViewController* save = [[SaveCardViewController alloc]initWithNibName:@"SaveCardViewController" bundle:nil];
//    save.cardInfo = [[Card alloc]init];
//    [self.navigationController pushViewController:save animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
