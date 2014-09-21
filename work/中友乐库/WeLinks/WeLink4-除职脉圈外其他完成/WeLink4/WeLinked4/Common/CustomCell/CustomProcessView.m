//
//  customProcessView.m
//  WeLinked4
//
//  Created by floar on 14-5-27.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "CustomProcessView.h"

@implementation CustomProcessView
{
    UIView *foreView;
    CGRect rect;
    CGSize titleSize;
    
    UILabel *titleLabel;
    UILabel *longthLable;
    
    UITapGestureRecognizer *tapProcess;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        rect = frame;
        
        
        tapProcess = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapProcess];
        self.userInteractionEnabled = YES;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        longthLable = [[UILabel alloc] initWithFrame:CGRectZero];
        
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
    
    titleLabel.frame = CGRectMake(rect.size.width-200, 0, titleSize.width, rect.size.height);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = title;
    [self addSubview:titleLabel];
}

-(void)setForeLongth:(double)foreLongth
{
    
    if (foreLongth > 0)
    {
        if (foreView == nil)
        {
            foreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290*foreLongth, rect.size.height)];
            [self addSubview:foreView];
        }
        
        longthLable.frame = CGRectMake(rect.size.width-50, 0, 50, rect.size.height);
        longthLable.text = [NSString stringWithFormat:@"%d%%",(int)(foreLongth*100)];
        [self addSubview:longthLable];
        
        [self bringSubviewToFront:titleLabel];
        [self removeGestureRecognizer:tapProcess];
    }
    else if (foreLongth == 0)
    {
        longthLable.text = nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height-1, rect.size.width, 1)];
    view.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:view];
}

-(void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"%d",tap.view.tag);
    [self.delegate makeVoteViewChange];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
    
    
//    [self.delegate makeChatViewShow];
}

@end
