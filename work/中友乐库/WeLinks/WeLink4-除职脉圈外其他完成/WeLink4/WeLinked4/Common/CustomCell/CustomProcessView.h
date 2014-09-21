//
//  customProcessView.h
//  WeLinked4
//
//  Created by floar on 14-5-27.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendProtocol.h"

//title在下
@interface CustomProcessView : UIView
@property (nonatomic, assign) double foreLongth;
@property (nonatomic, strong) UIColor *foreColor;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, weak) id<FriendProtocol> delegate;

@end
