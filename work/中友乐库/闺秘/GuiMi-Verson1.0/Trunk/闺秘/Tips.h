//
//  Tips.h
//  闺秘
//
//  Created by floar on 14-7-23.
//  Copyright (c) 2014年 jonas. All rights reserved.


typedef enum
{
    TipsSupportType = 0,
    TipsAvatorType,
    TipsFriendType,
    TipsAddressType,
    TipsFeedCollectedType,
    TipsCellShareType
}TipsType;

#import <UIKit/UIKit.h>

@interface Tips : UIView

@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *standImgStr;
@property (nonatomic, copy) void (^handleTipsOKBtnActionBlock)(void);

-(void)customTipsViewWithPoint:(CGPoint)point
                       tipType:(TipsType)type
                  withSubTitle:(NSString *)title
               withSubImageStr:(NSString *)imageStr
                  subImageSize:(CGSize)subImageSize;

@end
