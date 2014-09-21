//
//  MesageSendData.h
//  ChatView
//
//  Created by jonas on 12/16/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//
#import "MessageData.h"

#import <UIKit/UIKit.h>
@interface TextMessageItem : NSObject<MessageAdapterProtocol,UIAlertViewDelegate>
{
    UIActivityIndicatorView* indicatorView;
    UIButton* sendFailedButton;
    EventCallBack call;
}
-(void)setCallBack:(EventCallBack)callback;
@end
