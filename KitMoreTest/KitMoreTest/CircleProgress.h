//
//  CircleProgress.h
//  KitMoreTest
//
//  Created by floar on 14-6-19.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgress : UIView
{
    CAShapeLayer *trackLayer;
    CAShapeLayer *progressLayer;
    
    UIBezierPath *trackPath;
    UIBezierPath *progressPath;
}

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) float progressWidth;

//-(void)setProgress:(float)progress animated:(BOOL)animated;

@end
