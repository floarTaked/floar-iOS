//
//  PhoneViewController.h
//  WeLinked4
//
//  Created by jonas on 5/19/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneViewController : UIViewController
{
    IBOutlet UILabel* descLabel;
    IBOutlet UITextField* inputPhone;
    IBOutlet UIButton* sendButton;
    IBOutlet UILabel* countLabel;
    IBOutlet UITextField* codeTextField;
    
    
    NSString* checkedNumber;
    NSTimer* timer;
    int timeTick;
}
@end
