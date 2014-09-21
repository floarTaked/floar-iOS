//
//  TextViewViewController.m
//  WeLinked4
//
//  Created by jonas on 5/29/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "TextViewViewController.h"
#define  WordCount 500
@interface TextViewViewController ()

@end

@implementation TextViewViewController
@synthesize value;
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
    [self.navigationItem setTitleString:@"输入文本"];
    [self.navigationItem setRightBarButtonItem:nil
                                 imageSelected:nil
                                         title:@"确定"
                                         inset:UIEdgeInsetsMake(0, -30, 0, 0)
                                        target:self
                                      selector:@selector(save:)];
    if(value != nil && [value length]>0)
    {
        [inputView setText:value];
    }
    [inputView setFont:getFontWith(NO, 13)];
    inputView.textColor = colorWithHex(0x3287E6);
    [inputView becomeFirstResponder];
    [wordCountLabel setTextColor:[UIColor darkGrayColor]];
    wordCountLabel.font = getFontWith(NO, 12);
    wordCountLabel.text = [NSString stringWithFormat:@"(0/%d)",WordCount];
}
-(void)setEventCallBack:(EventCallBack)call
{
    callBack = call;
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if(callBack)
    {
        callBack(1,inputView.text);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length  + text.length> WordCount)
    {
        return NO;
    }
    else
    {
        [wordCountLabel setText:[NSString stringWithFormat:@"(%d/%d)",textView.text.length + text.length,WordCount]];
    }
    return YES;
}
@end
