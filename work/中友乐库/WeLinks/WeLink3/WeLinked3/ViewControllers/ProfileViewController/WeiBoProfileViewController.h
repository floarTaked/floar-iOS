//
//  WeiBoProfileViewController.h
//  WeLinked3
//
//  Created by jonas on 3/18/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiBoProfileViewController : UIViewController
{
    IBOutlet UIWebView* web;
}
@property(nonatomic,strong)NSString* weiboId;
@property(nonatomic,strong)NSString* titleString;
@end
