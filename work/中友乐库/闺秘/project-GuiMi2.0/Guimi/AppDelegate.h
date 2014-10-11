//
//  AppDelegate.h
//  闺秘
//
//  Created by jonas on 6/23/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
-(void)login;
@end
