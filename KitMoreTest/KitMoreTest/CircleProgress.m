//
//  CircleProgress.m
//  KitMoreTest
//
//  Created by floar on 14-6-19.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "CircleProgress.h"

@implementation CircleProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        trackLayer = [CAShapeLayer new];
        [self.layer addSublayer:trackLayer];
        trackLayer.fillColor = nil;
        trackLayer.frame = self.bounds;
    
        progressLayer = [CAShapeLayer new];
        [self.layer addSublayer:progressLayer];
        progressLayer.fillColor = nil;
        progressLayer.lineCap = kCALineCapRound;
        progressLayer.frame = self.bounds;
        
        self.progressWidth = 5;
    }
    return self;
}

- (void)setTrack
{
    trackPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    trackLayer.path = trackPath.CGPath;
}

- (void)setProgress
{
    progressPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:- M_PI_2 endAngle:(M_PI * 2) * _progress - M_PI_2 clockwise:YES];
    progressLayer.path = progressPath.CGPath;
}


- (void)setProgressWidth:(float)progressWidth
{
    _progressWidth = progressWidth;
    trackLayer.lineWidth = _progressWidth;
    progressLayer.lineWidth = _progressWidth;
    
    [self setTrack];
    [self setProgress];
}

- (void)setTrackColor:(UIColor *)trackColor
{
    trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    _progress = progress;
    animated = YES;
    
    [self setProgress];
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
