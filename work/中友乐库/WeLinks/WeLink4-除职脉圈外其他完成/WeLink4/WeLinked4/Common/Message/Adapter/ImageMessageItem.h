//
//  ImageMessageItem.h
//  WeLinked4
//
//  Created by jonas on 5/20/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageData.h"
#import "UserInfo.h"
#import <UIKit/UIKit.h>
@interface ImageMessageItem : NSObject<MessageAdapterProtocol,UIAlertViewDelegate>
{
    UIActivityIndicatorView* indicatorView;
    UIButton* sendFailedButton;
    EventCallBack call;
    EGOImageView* imageView;
}
-(void)setCallBack:(EventCallBack)callback;
@end
