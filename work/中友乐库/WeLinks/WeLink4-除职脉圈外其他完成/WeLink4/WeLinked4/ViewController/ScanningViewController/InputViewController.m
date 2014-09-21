//
//  InputViewController.m
//  WeLinked4
//
//  Created by jonas on 5/28/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()

@end

@implementation InputViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        edit = NO;
    }
    return self;
}
-(void)setString:(NSString*)title placeholder:(NSString*)place keyboardType:(UIKeyboardType)type
{
    titleString = title;
    placeholder = place;
    keyboardType = type;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(edit)
    {
        [self.navigationItem setLeftBarButtonItem:nil
                                    imageSelected:nil
                                            title:@"删除"
                                            inset:UIEdgeInsetsMake(0, -30, 0, 0)
                                           target:self
                                         selector:@selector(deleteValue:)];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem:nil
                                    imageSelected:nil
                                            title:@"取消"
                                            inset:UIEdgeInsetsMake(0, -30, 0, 0)
                                           target:self
                                         selector:@selector(cancel:)];
    }
    [self.navigationItem setRightBarButtonItem:nil
                                 imageSelected:nil
                                         title:@"完成"
                                         inset:UIEdgeInsetsMake(0, -30, 0, 0)
                                        target:self
                                      selector:@selector(save:)];
    [self.navigationItem setTitleString:titleString];
    [inputFiled setPlaceholder:placeholder];
    inputFiled.keyboardType = keyboardType;
    [inputFiled becomeFirstResponder];
    if(editValue != nil && [editValue length]>0)
    {
        [inputFiled setText:editValue];
    }
}
-(void)deleteValue:(id)sender
{
    if(callBack)
    {
        callBack(1,editValue);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save:(id)sender
{
    if(callBack)
    {
        callBack(2,inputFiled.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)edit:(BOOL)editOrAdd editValue:(NSString*)value block:(EventCallBack)block
{
    edit = editOrAdd;
    callBack = block;
    editValue = value;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
