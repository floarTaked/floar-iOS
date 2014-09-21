//
//  ViewController.m
//  LocalNoticationTest
//
//  Created by floar on 14-8-14.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    
    __weak IBOutlet UILabel *contentLable;
    
    __weak IBOutlet UIImageView *showImg;
    
}

@end

@implementation ViewController

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
    
    [self testLabelLineSpacing];
    [self testLocalNotication];
    [self testImageFromPartView];
    
    
}

-(void)testImageFromPartView
{
    showImg.image = [self getImageFromPartView:self.view frame:CGRectMake(30, 30, 100, 100)];
}

-(UIImage *)getImageFromPartView:(UIView *)view frame:(CGRect)frame
{
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(frame);
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}

-(void)testLabelLineSpacing
{
    contentLable.backgroundColor = [UIColor orangeColor];
    NSString *str = contentLable.text;
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineSpacing:50];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, str.length)];
    [contentLable setAttributedText:attributeStr];
}

-(void)testLocalNotication
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    //    NSDate *date = [NSDate date];
    //    NSTimeInterval time = [date timeIntervalSince1970];
    //    localNotif.fireDate = [NSDate dateWithTimeIntervalSince1970:time+20];
    //    localNotif.timeZone = [NSTimeZone defaultTimeZone];
	
	// Notification details
    localNotif.alertBody = @"open";
	// Set the action button
    localNotif.alertAction = @"View";
	
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
	
	// Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
    localNotif.userInfo = infoDict;
	
	// Schedule the notification
    //    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
