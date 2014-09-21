//
//  MessageSendPostIntroduceItem.h
//  WeLinked3
//
//  Created by jonas on 2/28/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageData.h"
//求内推
@interface PostRecommendedMessageItem : NSObject<MessageAdapterProtocol,UIAlertViewDelegate>
{
    UIActivityIndicatorView* indicatorView;
    UIButton* sendFailedButton;
    EventCallBack call;
}
-(void)setCallBack:(EventCallBack)callback;
@end
