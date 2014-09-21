//
//  MainAgainstView.h
//  闺秘
//
//  Created by floar on 14-7-15.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainAgainstView : UIView

@property (nonatomic, assign) uint64_t feedId;
@property (nonatomic, copy) void (^handleMainCellOtherRemoveBlock)(void);
@property (nonatomic, copy) void (^makeReportReasonViewShowBlock)(void);

@end
