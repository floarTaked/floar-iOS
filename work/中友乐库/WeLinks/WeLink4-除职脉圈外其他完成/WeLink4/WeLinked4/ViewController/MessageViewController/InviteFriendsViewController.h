//
//  InviteFriendsViewController.h
//  WeLinked4
//
//  Created by floar on 14-5-16.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface InviteFriendsViewController : UIViewController<MFMessageComposeViewControllerDelegate>
{
    MFMessageComposeViewController *messageController;
}
@end
