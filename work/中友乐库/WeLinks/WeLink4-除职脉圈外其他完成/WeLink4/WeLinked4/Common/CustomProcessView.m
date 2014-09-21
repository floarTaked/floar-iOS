//
//  customProcessView.m
//  WeLinked4
//
//  Created by floar on 14-5-27.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "customProcessView.h"

@implementation customProcessView
{
    UIView *foreView;
    CGRect rect;
    CGSize titleSize;
    
    UILabel *titleLabel;
    UILabel *longthLable;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        rect = frame;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        longthLable = [[UILabel alloc] initWithFrame:CGRectZero];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)setForeColor:(UIColor *)foreColor
{
    foreView.backgroundColor = foreColor;
}

-(void)setTitle:(NSString *)title
{
    titleSize = [title boundingRectWithSize:CGSizeMake(2000, rect.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:nil].size;
    
    titleLabel.frame = CGRectMake(rect.size.width-300, 0, titleSize.width, rect.size.height);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = title;
    [self addSubview:titleLabel];
}

-(void)setForeLongth:(double)foreLongth
{
    foreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width*foreLongth, rect.size.height)];
    
    longthLable.frame = CGRectMake(rect.size.width-50, 0, 50, rect.size.height);
    longthLable.text = [NSString stringWithFormat:@"%d%%",(int)(foreLongth*100)];
    
    [self addSubview:foreView];
    [self addSubview:longthLable];
}

-(void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"%d",tap.view.tag);
}

@end
