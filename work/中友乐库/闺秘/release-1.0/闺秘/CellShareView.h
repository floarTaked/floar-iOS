//
//  CellShareView.h
//  闺秘
//
//  Created by floar on 14-7-16.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellShareView : UIView

@property (nonatomic, copy) void (^handleShareByMessage)(void);
@property (nonatomic, copy) void (^handleWechat)(void);
@property (nonatomic, copy) void (^hanldeWechatCircle)(void);
@property (nonatomic, copy) void (^handleWeibo)(void);

@end
