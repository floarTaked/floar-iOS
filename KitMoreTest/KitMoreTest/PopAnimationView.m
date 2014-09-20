//
//  PopAnimationView.m
//  KitMoreTest
//
//  Created by floar on 14-6-27.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "PopAnimationView.h"
#import <POP.h>

@implementation PopAnimationView
{
    UILabel *label;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.backgroundColor = [UIColor brownColor];
        [self addSubview:label];
    }
    return self;
}

-(void)setAnimationCenter:(CGPoint)animationCenter
{
    _animationCenter = animationCenter;
    label.text = [NSString stringWithFormat:@"pop animation %@",self.numLabel];
    label.textColor = [UIColor orangeColor];
    
    POPSpringAnimation *amin = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    amin.toValue = [NSValue valueWithCGPoint:animationCenter];
    amin.dynamicsMass = 2;
    [self pop_addAnimation:amin forKey:@"center"];
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
