//
//  LoginViewController.h
//  WeLinked3
//
//  Created by jonas on 2/21/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
@interface LoginViewController : UIViewController<UIAlertViewDelegate>
{
    IBOutlet UIButton* loginButton;
    IBOutlet UIImageView* background;
    IBOutlet UILabel* agreementLabel;
    IBOutlet UIButton* agreementButton;
    BOOL agree;
    MBProgressHUD* HUD;
}
@end
