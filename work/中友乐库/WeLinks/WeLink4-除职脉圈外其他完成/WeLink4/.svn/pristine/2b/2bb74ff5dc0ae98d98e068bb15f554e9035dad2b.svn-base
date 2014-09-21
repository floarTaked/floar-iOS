//
//  InputViewController.h
//  WeLinked4
//
//  Created by jonas on 5/28/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
@interface InputViewController : UIViewController
{
    IBOutlet UITextField* inputFiled;
    NSString* titleString;
    NSString* placeholder;
    BOOL edit;
    NSString* editValue;
    EventCallBack callBack;
    UIKeyboardType keyboardType;
}
-(void)edit:(BOOL)editOrAdd editValue:(NSString*)value block:(EventCallBack)block;
-(void)setString:(NSString*)title placeholder:(NSString*)place keyboardType:(UIKeyboardType)type;
@end
