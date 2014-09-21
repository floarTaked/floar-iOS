//
//  DrawFace.m
//  KitMoreTest
//
//  Created by floar on 14-6-19.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "DrawFace.h"

@implementation DrawFace

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawHead {
    
    //使用 bezierPathWithOvalInRect 方法在一個設定的矩形方塊中畫出圓形，也就是笑臉的頭部
    UIBezierPath *pathHead = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(40, 120, 240, 240)];
    
    //設定畫出線條的寬度
    [pathHead setLineWidth:5];
    
    //畫出線條
    [pathHead stroke];
}

- (void)drawEyes {
    
    //此設定的 path 為畫出眼睛
    UIBezierPath *pathEyes = [UIBezierPath bezierPath];
    
    //畫出左眼
    [pathEyes addArcWithCenter:CGPointMake(115, 190) radius:10 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    //畫出右眼
    [pathEyes moveToPoint:CGPointMake(215, 190)];
    [pathEyes addArcWithCenter:CGPointMake(205, 190) radius:10 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [pathEyes setLineWidth:5];
    [pathEyes stroke];
}

- (void)drawSmile {
    
    //此設定的 path 為畫出嘴巴
    UIBezierPath *pathSmile = [UIBezierPath bezierPath];
    
    //移動至座標點
    [pathSmile moveToPoint:CGPointMake(100, 280)];
    
    //此方法為利用貝茲曲線的方法畫出微笑的嘴巴
    [pathSmile addCurveToPoint:CGPointMake(220, 280) controlPoint1:CGPointMake(130, 330) controlPoint2:CGPointMake(190, 330)];
    
    //同樣設定線條寬度以及畫出線條
    [pathSmile setLineWidth:5];
    [pathSmile stroke];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //設定所畫出的 Path 顏色
    [[UIColor blueColor] set];
    
    [self drawHead];
    [self drawEyes];
    [self drawSmile];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
